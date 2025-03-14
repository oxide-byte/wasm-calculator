plugins {
    kotlin("multiplatform") version "1.8.20"
}

repositories {
    mavenCentral()
}

kotlin {
    wasm {
        binaries.executable()
        browser {
            // Configure WebAssembly target
        }
    }

    sourceSets {
        val wasmMain by getting {
            dependencies {
                implementation(kotlin("stdlib"))
            }
        }
    }
}