
```toml
[package]
name = "my-leptos-app"
version = "0.1.0"
edition = "2021"

[dependencies]
leptos = { version = "0.5", features = ["csr"] }
wasm-bindgen = "0.2"
wasm-bindgen-futures = "0.4"
web-sys = { version = "0.3", features = ["Window"] }
js-sys = "0.3"
```

```rust
use leptos::*;
use wasm_bindgen::prelude::*;
use web_sys::Window;

// Define the external WASM function interface
#[wasm_bindgen]
extern "C" {
    type WasmModule;

    #[wasm_bindgen(constructor)]
    fn new() -> WasmModule;

    #[wasm_bindgen(method)]
    fn add(this: &WasmModule, a: i32, b: i32) -> i32;
}

// Store the WASM module in a static variable
static WASM_MODULE: std::sync::OnceLock<WasmModule> = std::sync::OnceLock::new();

async fn init_wasm() -> Result<(), JsValue> {
    let wasm_module = wasm_bindgen_futures::JsFuture::from(
        web_sys::WebAssembly::instantiate_streaming(
            &web_sys::window()
                .unwrap()
                .fetch_with_str("/path/to/your/module.wasm"),
            &JsValue::NULL,
        ),
    )
    .await?;

    let module = WasmModule::new();
    WASM_MODULE.set(module).expect("WASM module already initialized");
    Ok(())
}

// Calculator component that uses the WASM function
#[component]
fn WasmCalculator() -> impl IntoView {
    let (result, set_result) = create_signal(0);
    let (a, set_a) = create_signal(0);
    let (b, set_b) = create_signal(0);
    let (loading, set_loading) = create_signal(true);
    let (error, set_error) = create_signal::<Option<String>>(None);

    // Initialize WASM when the component mounts
    create_effect(move |_| {
        spawn_local(async move {
            match init_wasm().await {
                Ok(_) => set_loading.set(false),
                Err(e) => {
                    set_error.set(Some(e.as_string().unwrap_or("Failed to load WASM".into())));
                    set_loading.set(false);
                }
            }
        });
    });

    let calculate = move |_| {
        if let Some(wasm_module) = WASM_MODULE.get() {
            let sum = wasm_module.add(a.get(), b.get());
            set_result.set(sum);
        }
    };

    view! {
        <div>
            {move || {
                if loading.get() {
                    view! { <div>"Loading WASM module..."</div> }
                } else if let Some(err) = error.get() {
                    view! { <div class="error">{err}</div> }
                } else {
                    view! {
                        <div>
                            <input
                                type="number"
                                on:input=move |ev| {
                                    set_a.set(event_target_value(&ev).parse::<i32>().unwrap_or(0))
                                }
                            />
                            <input
                                type="number"
                                on:input=move |ev| {
                                    set_b.set(event_target_value(&ev).parse::<i32>().unwrap_or(0))
                                }
                            />
                            <button on:click=calculate>"Calculate"</button>
                            <p>"Result: " {result}</p>
                        </div>
                    }
                }
            }}
        </div>
    }
}

#[component]
fn App() -> impl IntoView {
    view! {
        <main>
            <h1>"WASM Calculator"</h1>
            <WasmCalculator/>
        </main>
    }
}

fn main() {
    mount_to_body(App);
}
```

```rust
// Add retry logic for WASM loading
async fn load_wasm_with_retry(retries: u32) -> Result<(), JsValue> {
    let mut attempts = 0;
    while attempts < retries {
        match init_wasm().await {
            Ok(_) => return Ok(()),
            Err(e) => {
                attempts += 1;
                if attempts == retries {
                    return Err(e);
                }
                gloo_timers::future::TimeoutFuture::new(1000).await;
            }
        }
    }
    Err(JsValue::from_str("Failed to load WASM after retries"))
}
```

```rust
create_effect(move |_| {
    spawn_local(async move {
        match load_wasm_with_retry(3).await {
            Ok(_) => set_loading.set(false),
            Err(e) => {
                set_error.set(Some(e.as_string().unwrap_or("Failed to load WASM".into())));
                set_loading.set(false);
            }
        }
    });
});
```