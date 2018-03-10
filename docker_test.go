package gerrit_test

import (
	"os"
	"testing"

	"github.com/andygrunwald/go-gerrit"
)

func TestDockerHttpGerritAvailable(t *testing.T) {
	instance := os.Getenv("GERRIT_URL")
	if instance == "" {
		instance = "http://localhost:8080/"
	}

	client, err := gerrit.NewClient(instance, nil)
	if err != nil {
		t.Fatal(err)
	}

	username := "admin1"
	password := "password"
	client.Authentication.SetBasicAuth(username, password)

	_, _, err = client.Accounts.GetAccount("self")
	if err != nil {
		t.Fatal(err)
	}
}
