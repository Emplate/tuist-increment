import ProjectDescription

public extension SettingsDictionary {
    /// The Info.plist will be preprocessed with a header file
    func preprocessInfoPlistWithVersions(_ headerPath: String) -> SettingsDictionary {
        merging([
            "INFOPLIST_PREPROCESS": true,
            "INFOPLIST_PREFIX_HEADER": .string(headerPath),
        ])
    }

    var preprocessInfoPlistWithVersions: SettingsDictionary {
        preprocessInfoPlistWithVersions("$(PROJECT_DIR)/../Versions.h")
    }
}

public extension Dictionary where Key == String, Value == ProjectDescription.Plist.Value {
    var withVersionPlaceholders: [String: ProjectDescription.Plist.Value] {
        merging([
            "CFBundleShortVersionString": "APP_VERSION",
            "CFBundleVersion": "APP_BUILD",
        ], uniquingKeysWith: { $1 })
    }
}
