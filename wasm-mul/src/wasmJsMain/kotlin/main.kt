import kotlin.wasm.*

@WasmExport
fun mul(a: Int, b: Int): Int {
    return a * b
}