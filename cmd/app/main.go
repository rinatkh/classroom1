package main

import (
	"fmt"

	"github.com/rinat-course/classroom1/internal/greeter"
)

func main() {
	message := greeter.BuildGreeting("Мария")
	fmt.Println(message)
}
