package cmd

import (
	"testing"
)

func TestSomething(t *testing.T) {
	if versionCmd.Use != "version" {
		t.Errorf("Version incorrect. Expeted %s, got %s", "version", versionCmd.Use)
	}

}
