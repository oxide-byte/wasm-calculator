use leptos::prelude::*;
use leptos::task::spawn_local;
use log::{error, info};
use wasm_bindgen::{JsCast, JsValue};
use wasm_bindgen::prelude::wasm_bindgen;
const WASM_BYTES: &[u8] = include_bytes!("../../../modules/sub.wasm");

#[wasm_bindgen]
pub struct WasmSubModule {
    instance: js_sys::WebAssembly::Instance,
}

#[wasm_bindgen]
impl WasmSubModule {
    #[wasm_bindgen(constructor)]
    pub fn new() -> leptos::error::Result<WasmSubModule, JsValue> {
        // Create module from bytes
        info!("WASM [sub] construct...");
        let wasm_module = js_sys::WebAssembly::Module::new(&js_sys::Uint8Array::from(WASM_BYTES))?;
        let imports = js_sys::Object::new();
        let instance = js_sys::WebAssembly::Instance::new(&wasm_module, &imports)?;
        info!("WASM [sub] instance created");
        Ok(WasmSubModule { instance })
    }

    pub fn sub(&self, a: i32, b: i32) -> leptos::error::Result<i32, JsValue> {
        info!("CALL [sub] for {} {}", a, b);
        let exports = self.instance.exports();

        // Debug: Log all available exports
        let keys = js_sys::Object::keys(&exports);
        let length = keys.length();
        info!("Available exports ({}): ", length);
        for i in 0..length {
            let key = keys.get(i);
            info!("  Export {}: {:?}", i, key);
        }

        // Try to get the sub function
        let sub_fn = match js_sys::Reflect::get(&exports, &JsValue::from_str("sub")) {
            Ok(func) => {
                info!("Found sub function: {:?}", func);
                match func.dyn_into::<js_sys::Function>() {
                    Ok(f) => f,
                    Err(e) => {
                        error!("Failed to convert to Function: {:?}", e);
                        return Err(JsValue::from_str("sub is not a function"));
                    }
                }
            },
            Err(e) => {
                error!("Failed to get sub function: {:?}", e);
                return Err(e);
            }
        };

        // Call the function with better error handling
        match sub_fn.call2(&JsValue::NULL, &JsValue::from(a), &JsValue::from(b)) {
            Ok(result) => {
                match result.as_f64() {
                    Some(num) => {
                        Ok(num as i32)
                    },
                    None => {
                        error!("Invalid return value type");
                        Err(JsValue::from_str("Invalid return value type"))
                    }
                }
            },
            Err(e) => {
                error!("Error calling sub function: {:?}", e);
                Err(e)
            }
        }
    }
}

#[component]
pub fn SubView(v1: RwSignal<String>, v2: RwSignal<String>) -> impl IntoView {

    let result = RwSignal::new(None::<i32>);
    let error = RwSignal::new(None::<String>);

    Effect::new(move |_| {
        // This will properly track v1 and v2
        let n1_str = v1.get();
        let n2_str = v2.get();

        // Only proceed if we have valid numbers
        match (n1_str.parse::<i32>(), n2_str.parse::<i32>()) {
            (Ok(n1), Ok(n2)) => {

                // Use spawn_local for the async WASM operation
                spawn_local(async move {
                    match WasmSubModule::new() {
                        Ok(wasm_module) => {
                            match wasm_module.sub(n1, n2) {
                                Ok(sum) => {
                                    result.set(Some(sum));
                                    error.set(None);
                                },
                                Err(e) => {
                                    error.set(Some(format!("Error calculating: {:?}", e)));
                                    result.set(None);
                                }
                            }
                        }
                        Err(e) => {
                            error.set(Some(format!("Error loading WASM module: {:?}", e)));
                            result.set(None);
                        }
                    }
                });
            },
            _ => {
                // Handle invalid input (non-numeric values)
                if !n1_str.is_empty() && !n2_str.is_empty() {
                    error.set(Some("Please enter valid numbers".to_string()));
                }
                result.set(None);
            }
        }
    });

    view! {
        <div class="max-w-md mx-auto mt-10 mt-3 p-5 bg-white rounded-lg shadow-lg">
            <p class="mb-5"> SUBSTACTION calculated with a WAT WASM module </p>
            <p>"Result: " {move || result.get().map(|n| n.to_string()).unwrap_or_else(|| "No result".to_string())}</p>
        </div>
    }
}