import ArgumentParser

struct IncrementBuild: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "build",
        abstract: "Increments the build number"
    )

    func run() throws {
        let file = File(path: "EmplateConsumer/InfoPlist.h")

        let buildNumber = try file.readBuild()

        try file.updateBuild(buildNumber + 1)
    }
}
