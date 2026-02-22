import AppKit
import Foundation

extension NSImage {
    func toPNGData() -> Data? {
        guard
            let tiffData = tiffRepresentation,
            let bitmapRep = NSBitmapImageRep(data: tiffData)
        else {
            return nil
        }

        return bitmapRep.representation(using: .png, properties: [:])
    }
}
