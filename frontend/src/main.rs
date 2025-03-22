mod modules;

use leptos::prelude::*;
use thaw::*;

use crate::modules::*;

#[component]
pub fn WasmCalculator() -> impl IntoView {
    let v1 = RwSignal::new(String::from(""));
    let v2 = RwSignal::new(String::from(""));

    view! {
        <div class="mx-auto ml-40 mr-40 mt-5 p-5 bg-white rounded-lg shadow-lg">
        <p>"WASM Calculator:"</p>
        <div>"Value 1:  "<Input value=v1/></div>
        <div>"Value 2:  "<Input value=v2/></div>
        <table>
            <tr>
                <td><AddView v1=v1 v2=v2></AddView></td>
                <td><SubView v1=v1 v2=v2></SubView></td>
                <td><MinView v1=v1 v2=v2></MinView></td>
            </tr>
            <tr>
                <td><MulView v1=v1 v2=v2></MulView></td>
                <td><DivView v1=v1 v2=v2></DivView></td>
                <td><MaxView v1=v1 v2=v2></MaxView></td>
            </tr>
            <tr>
                <td><PowerView v1=v1 v2=v2></PowerView></td>
                <td><ModulusView v1=v1 v2=v2></ModulusView></td>
                <td><ConcatView v1=v1 v2=v2></ConcatView></td>
            </tr>
        </table>
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