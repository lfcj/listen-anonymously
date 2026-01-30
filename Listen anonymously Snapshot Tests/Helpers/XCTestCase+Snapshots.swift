import XCTest

public extension XCTestCase {

    /// Creates a PNG image out of the given `snapshot` and saves it in the file directory using the given `name`
    /// - Parameters:
    ///   - snapshot: `UIImage` that will be saved to the file system as a PNG
    ///   - name: Name the snapshot will have inside of the `snapshots` folder
    ///   - file: File path from which the method is called
    ///   - line: Line from which the method is called
    /// - Returns: The `Data` of the snapshot as a PNG image.
    func record(
        snapshot: UIImage,
        named name: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let snapshotData = makeSnapshotData(snapshot: snapshot, file: file, line: line)
        let snapshotURL = makeSnapshotURL(name: name, file: file)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try snapshotData?.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to save image \(name). Error: \(error))", file: file, line: line)
        }
    }

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

}
