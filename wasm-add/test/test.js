// Test file to load and use the WASM module
const wasmCode = await Deno.readFile("./dist/adder.wasm");
const wasmModule = new WebAssembly.Module(wasmCode);
const wasmInstance = new WebAssembly.Instance(wasmModule, {});

// Get the exported function
const exports = wasmInstance.exports;
const add = exports.add as (a: number, b: number) => number;

// Test the function
console.log("Testing WASM adder:");
console.log(`2 + 3 = ${add(2, 3)}`);
console.log(`-5 + 10 = ${add(-5, 10)}`);
console.log(`100 + 200 = ${add(100, 200)}`);