// src/wasmMain/kotlin/Multiplier.kt

@file:JsExport

package multiplier

import kotlin.js.JsExport

class Multiplier {
    fun multiply(a: Int, b: Int): Int {
        return a * b
    }
}

// Standalone function for direct usage
fun multiply(a: Int, b: Int): Int {
    return a * b
}