package greeter

import "fmt"

// BuildGreeting возвращает приветствие для ученика.
func BuildGreeting(name string) string {
	return fmt.Sprintf("Привет, %s! Добро пожаловать в Go.", name)
}
