import ArgumentParser
import Foundation

extension MainCommand {
    struct IncrementBuild: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Increments the build number"
        )

        func run() throws {
            let file = File(path: "EmplateConsumer/InfoPlist.h")

            let buildNumber = try Int(file.readValue(from: .build))

            guard let buildNumber = buildNumber else {
                fatalError("Could not unwrap the build number as an integer")
            }

            try file.updateValue(key: .build, value: "\(buildNumber + 1)")
        }
    }
}
