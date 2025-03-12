mod add_view;
mod sub_view;

use leptos::prelude::*;
use thaw::*;
use crate::add_view::AddView;
use crate::sub_view::SubView;

#[component]
pub fn WasmCalculator() -> impl IntoView {
    let v1 = RwSignal::new(String::from(""));
    let v2 = RwSignal::new(String::from(""));

    view! {
        <div class="max-w-md mx-auto mt-10 mt-3 p-5 bg-white rounded-lg shadow-lg">
        <p>"WASM Calculator:"</p>
        <div>"Value 1:  "<Input value=v1/></div>
        <div>"Value 2:  "<Input value=v2/></div>
        <AddView v1=v1 v2=v2></AddView>
        <SubView v1=v1 v2=v2></SubView>
        </div>
    }
}

fn main() {
    console_log::init_with_level(log::Level::Debug).expect("Failed to initialize logging");
    mount_to_body(|| view! {
        <ConfigProvider>
            <WasmCalculator/>
        </ConfigProvider>
    })
}