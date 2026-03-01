import XCTest

public extension XCTestCase {

    /// Generates PNG data from given `snapshot`.
    /// - Parameters:
    ///   - snapshot: `UIImage` that will be converted to PNG data
    ///   - file: File path from which the method is called
    ///   - line: Line from which the method is called
    /// - Returns: The `Data` of the snapshot as a PNG image.
    func makeSnapshotData(
        snapshot: UIImage,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Data? {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to get PNG image from \(name).", file: file, line: line)
            return nil
        }

        return snapshotData
    }

    /// Saves a snapshot to `fastlane/screenshots/<locale>/` for frameit, using the `XX_screenshot` naming convention.
    /// - Parameters:
    ///   - snapshot: `UIImage` that will be saved to the file system as a PNG
    ///   - name: Screenshot name using frameit convention (e.g. "01_screenshot")
    ///   - locale: Locale folder name matching fastlane convention (e.g. "en-US")
    ///   - file: File path from which the method is called
    ///   - line: Line from which the method is called
    func record(
        snapshot: UIImage,
        named name: String,
        locale: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let snapshotData = makeSnapshotData(snapshot: snapshot, file: file, line: line)
        let snapshotURL = makeFrameitURL(name: name, locale: locale, file: file)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to save image \(name) for locale \(locale). Error: \(error))", file: file, line: line)
        }
    }

    /// Creates a URL inside of the `snapshots` folder, which is parallel to the calling file.
    /// - Parameters:
    ///   - name: The name the file the URL points to should have
    ///   - file: The file next to which the `snapshots` folder will be created
    ///     the accessibility value is unchanged.
    /// - Returns: The URL where a snapshot can be saved with `name`
    /// Example:
    ///
    /// if one calls this method from within `/Some/Path/To/File.swift`, the output URL is
    /// `/Some/Path/To/snapshots/<name>.png`
    func makeSnapshotURL(name: String, file: StaticString) -> URL {
        URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png", isDirectory: false)
    }

    /// Creates a URL inside `fastlane/screenshots/<locale>/` for frameit.
    func makeFrameitURL(name: String, locale: String, file: StaticString) -> URL {
        projectRootURL(file: file)
            .appendingPathComponent("fastlane/screenshots/\(locale)")
            .appendingPathComponent("\(name).png", isDirectory: false)
    }

    /// Finds the project root by walking up from the test file until we find the `fastlane` directory.
    private func projectRootURL(file: StaticString) -> URL {
        var url = URL(fileURLWithPath: String(describing: file))
        while url.path != "/" {
            url = url.deletingLastPathComponent()
            if FileManager.default.fileExists(atPath: url.appendingPathComponent("fastlane").path) {
                return url
            }
        }
        fatalError("Could not find project root containing 'fastlane' directory")
    }

}
