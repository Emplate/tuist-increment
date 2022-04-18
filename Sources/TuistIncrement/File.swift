import Foundation

final class File {
    private let path: String

    public init(path: String) {
        self.path = path
    }

    public enum FileError: Error {
        case couldNotReadContent(URL)
        case couldNotFindValueForKey(String)
        case couldNotReadBuildNumber
        case couldNotReadVersion
    }

    public struct Version {
        var year: Int
        var number: Int

        var name: String {
            "\(year).\(number)"
        }
    }

    public func readBuild() throws -> Int {
        guard let buildNumber = try Int(readValue(from: .build)) else {
            throw FileError.couldNotReadBuildNumber
        }
        return buildNumber
    }

    public func readVersion() throws -> Version {
        let values = try readValue(from: .version).split(separator: ".")

        guard let year = Int(values[0]), let number = Int(values[1]) else {
            throw FileError.couldNotReadVersion
        }

        return Version(year: year, number: number)
    }

    public func updateBuild(_ build: Int) throws {
        try updateValue(key: .build, value: String(build))
    }

    public func updateVersion(_ version: Version) throws {
        try updateValue(key: .version, value: version.name)
    }

    private func readValue(from key: Key) throws -> String {
        guard let line = try lines().first(where: { $0.starts(with: key.linePrefix) }),
              let value = line.split(separator: " ").last
        else {
            throw FileError.couldNotFindValueForKey(key.rawValue)
        }

        return String(value)
    }

    private func updateValue(key: Key, value: String) throws {
        let content = try lines()
            .map { line -> String in
                // Skip unrelated lines
                guard line.starts(with: key.linePrefix) else {
                    return String(line)
                }

                // Split the line by spaces and update the last part with the new value
                return line
                    .split(separator: " ")
                    .enumerated()
                    .map { entry in
                        guard entry.offset == 2 else {
                            return String(entry.element)
                        }
                        return value
                    }
                    .joined(separator: " ")
            }
            .joined(separator: "\n") + "\n"

        try content.write(
            toFile: path,
            atomically: true,
            encoding: .utf8
        )
    }

    private func lines() throws -> [String] {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)

        guard let content = String(data: data, encoding: .utf8) else {
            throw FileError.couldNotReadContent(url)
        }

        return content
            .split(separator: "\n")
            .map { String($0) }
    }

    private enum Key: String {
        case version = "APP_VERSION"
        case build = "APP_BUILD"

        var linePrefix: String {
            "#define \(rawValue)"
        }
    }
}
