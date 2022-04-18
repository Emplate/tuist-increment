import ArgumentParser
import Foundation

extension MainCommand {
    struct IncrementVersion: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "version",
            abstract: "Increments the version number"
        )

        func run() throws {
            let key = "APP_VERSION"
            let values = readValue(from: key).split(separator: ".")

            guard let versionYear = Int(values[0]),
                  var versionNumber = Int(values[1])
            else {
                fatalError("Could not unwrap the version numbers as integers")
            }

            let currentYear = Calendar.current.component(.year, from: Date())

            if versionYear == currentYear {
                // Increment the number if the year hasn't changed
                versionNumber += 1
            } else {
                // Reset to version 1 if the year has changed
                versionNumber = 1
            }

            updateValue(key: key, value: "\(currentYear).\(versionNumber)")
        }
    }
}