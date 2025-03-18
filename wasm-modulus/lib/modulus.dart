// lib/modulus.dart

int modulus(int a, int b) {
  if (b == 0) {
    return 0; // Handle division by zero safely in WASM context
  }
  return a % b;
}

void main() {
  // Required empty main function
}