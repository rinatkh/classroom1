package greeter

import "testing"

func TestBuildGreeting(t *testing.T) {
	got := BuildGreeting("Мария")
	want := "Привет, Мария! Добро пожаловать в Go."

	if got != want {
		t.Fatalf("BuildGreeting() = %q, want %q", got, want)
	}
}
