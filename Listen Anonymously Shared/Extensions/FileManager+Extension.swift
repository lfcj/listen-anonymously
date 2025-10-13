import Foundation

extension FileManager {
    static func createTemporaryFileURL(fileExtension: String) -> URL {
        let temporaryDirectory = NSTemporaryDirectory()
        let fileName = UUID().uuidString + ".\(fileExtension)"
        let temporaryFileURL = URL(fileURLWithPath: temporaryDirectory).appendingPathComponent(fileName)
        return temporaryFileURL
    }
}
