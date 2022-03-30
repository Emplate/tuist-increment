import ArgumentParser

extension MainCommand {
    struct IncrementBuild: ParsableCommand {
        static var configuration = CommandConfiguration(
            commandName: "build",
            abstract: "Increments the build number"
        )

        func run() throws {
            print("Incrementing the build number")
        }
    }
}
