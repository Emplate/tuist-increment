import ArgumentParser

/// The entry point of the plugin. Main command that must be invoked in `main.swift` file.
@main
struct MainCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "plugin-increment",
        abstract: "A plugin that increments the build and version numbers",
        subcommands: [
            IncrementBuild.self,
            IncrementVersion.self,
        ],
        defaultSubcommand: IncrementBuild.self
    )
}
