import Foundation

class File {
    private let path: String

    init(path: String) {
        self.path = path
    }

    enum FileKey: String {
        case version = "APP_VERSION"
        case build = "APP_BUILD"
    }

    enum FileError: Error {
        case couldNotReadContent(URL)
        case couldNotFindValueForKey(FileKey)
    }

    public func readValue(from key: FileKey) throws -> String {
        guard let line = try lines().first(where: { $0.starts(with: "#define \(key.rawValue)") }),
              let value = line.split(separator: " ").last
        else {
            throw FileError.couldNotFindValueForKey(key)
        }

        return String(value)
    }

    public func updateValue(key: FileKey, value: String) throws {
        let content = try lines()
            .map { line -> String in
                // Skip unrelated lines
                guard line.starts(with: "#define \(key.rawValue)") else {
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
}
