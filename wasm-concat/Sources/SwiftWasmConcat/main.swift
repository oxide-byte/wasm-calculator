// Sources/SwiftWasmConcat/main.swift

import Foundation

@_cdecl("concatIntegers")
public func concatIntegers(_ a: Int32, _ b: Int32) -> Int32 {
    // Convert integers to strings
    let aString = String(a)
    let bString = String(b)

    // Concatenate the strings
    let concatenated = aString + bString

    // Parse back to integer
    if let result = Int32(concatenated) {
        return result
    } else {
        // Return a default value if parsing fails
        // (e.g., if the result is too large for Int32)
        return 0
    }
}

// This is needed for the WASM module to have a main function
@main
struct SwiftWasmConcatMain {
    static func main() {
        // This won't be executed in WASM context, but is needed for compilation
    }
}