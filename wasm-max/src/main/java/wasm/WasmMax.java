package wasm;

import org.teavm.interop.Export;

public class WasmMax {
    /**
     * Calculates the maximum of two integers
     *
     * @param a first integer
     * @param b second integer
     * @return the maximum value between a and b
     */
    @Export(name = "max")
    public static int max(int a, int b) {
        if (a > b) {
            return a;
        } else {
            return b;
        }
    }

    // Main method required for TeaVM compilation
    public static void main(String[] args) {
        // Empty main method
    }
}