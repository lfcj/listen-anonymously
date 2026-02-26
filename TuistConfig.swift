import ProjectDescription

let config = Config(
    compatibleXcodeVersions: ["26.3"],
    swiftVersion: "6.0",
    generationOptions: .options(
        resolveDependenciesWithSystemScm: false,
        disablePackageVersionLocking: false
    )
)
