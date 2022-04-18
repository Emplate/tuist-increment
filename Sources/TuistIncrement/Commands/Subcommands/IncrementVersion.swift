import ArgumentParser
import Foundation

struct IncrementVersion: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "version",
        abstract: "Increments the version number"
    )

    func run() throws {
        let file = File(path: "EmplateConsumer/InfoPlist.h")

        var version = try file.readVersion()

        let currentYear = Calendar.current.component(.year, from: Date())

        if version.year == currentYear {
            // Increment the number if the year hasn't changed
            version.number += 1
        } else {
            // Reset to current year and version 1 if the year has changed
            version.year = currentYear
            version.number = 1
        }

        try file.updateVersion(version)
    }
}
