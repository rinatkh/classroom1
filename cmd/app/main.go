package main

import (
	"fmt"

	"github.com/rinat-course/classroom1/internal/greeter"
)

func main() {
	message := greeter.BuildGreeting("Анна")
	fmt.Println(message)
}
