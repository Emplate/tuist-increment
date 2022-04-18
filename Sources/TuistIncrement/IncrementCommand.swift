import ArgumentParser
import Foundation

@main
struct IncrementCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Increments the build or version number"
    )

    @Argument(help: "Specify what to increment (`build` | `version` | `both`)")
    var mode = Mode.both

    @Option
    var path: String = "Versions.h"

    func run() throws {
        let file = File(path: path)

        switch mode {
        case .build:
            try buildNumber(file)

        case .version:
            try versionNumber(file)

        case .both:
            try buildNumber(file)
            try versionNumber(file)
        }
    }

    private func buildNumber(_ file: File) throws {
        let buildNumber = try file.readBuild()
        try file.updateBuild(buildNumber + 1)
    }

    private func versionNumber(_ file: File) throws {
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

    enum Mode: String, ExpressibleByArgument {
        case build, version, both
    }
}
