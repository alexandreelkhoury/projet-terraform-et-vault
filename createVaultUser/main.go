package main

import (
	"fmt"
	"os"

	vault "github.com/hashicorp/vault/api"
)

func main() {

	vaultAddress := "http://localhost:8200"
	adminToken := "myroot"
	username := "user1"
	password := "azerty"

	// Créez une nouvelle configuration Vault avec l'adresse de Vault
	config := &vault.Config{Address: vaultAddress}

	// Initialisez un nouveau client Vault avec le token administrateur
	client, err := vault.NewClient(config)
	if err != nil {
		fmt.Println("Error creating Vault client:", err)
		os.Exit(1)
	}
	client.SetToken(adminToken)

	// Créer un nouvel utilisateur avec userpass
	userData := map[string]interface{}{
		"password": password,
		"policies": "alex-policy",
		// "policies": "default",
	}

	_, err = client.Logical().Write("auth/userpass/users/"+username, userData)
	if err != nil {
		fmt.Println("Error creating Vault user:", err)
		os.Exit(1)
	}

	fmt.Println("User created successfully!")
}
