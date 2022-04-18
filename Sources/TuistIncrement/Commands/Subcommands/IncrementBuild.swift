import ArgumentParser
import Foundation

extension MainCommand {
    struct IncrementBuild: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Increments the build number"
        )

        func run() throws {
            let key = "APP_BUILD"
            guard let buildNumber = Int(readValue(from: key)) else {
                fatalError("Could not unwrap the build number as an integer")
            }

            updateValue(key: key, value: "\(buildNumber + 1)")
        }
    }
}

let fileName = "EmplateConsumer/InfoPlist.h"

// MARK: Shared code with the `IncrementVersion` task (should be kept in sync until Tuist provides a way to share code between tasks)

func updateValue(key: String, value: String) {
    let content = lines
        .map { line -> String in
            // Skip unrelated lines
            guard line.starts(with: "#define \(key)") else {
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

    do {
        try content.write(
            toFile: fileName,
            atomically: true,
            encoding: .utf8
        )
    } catch {
        fatalError("Could not update the value for the key: \(key)")
    }
}

func readValue(from key: String) -> String {
    guard let line = lines.first(where: { $0.starts(with: "#define \(key)") }),
          let value = line.split(separator: " ").last
    else {
        fatalError("Could not read the value for the key: \(key)")
    }

    return String(value)
}

var lines: [String] {
    let url = URL(fileURLWithPath: fileName)

    guard let data = try? Data(contentsOf: url),
          let content = String(data: data, encoding: .utf8)
    else {
        fatalError("Could not read content of file")
    }

    return content
        .split(separator: "\n")
        .map { String($0) }
}
