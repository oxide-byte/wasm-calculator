use leptos::prelude::*;
use thaw::*;
use wasm_bindgen::prelude::wasm_bindgen;

#[wasm_bindgen(module = "wasm-moodules/adder.wasm")]
extern "C" {
    #[wasm_bindgen()]
    fn adder(arg1: i32, arg2: i32) -> i32;
}

fn main() {
    mount_to_body(|| view! {
        <ConfigProvider>
            <p>test: {adder(1,2)}</p>
        </ConfigProvider>
    })
}