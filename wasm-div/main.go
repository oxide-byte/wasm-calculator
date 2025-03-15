package main

//export div
func div(a, b int) int {
	if b == 0 {
		return 0 // Handle division by zero
	}
	return a / b
}

func main() {
    println("div two numbers:", div(2, 3))
}