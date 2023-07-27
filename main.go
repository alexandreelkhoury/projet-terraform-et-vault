package main

import (
	"fmt"
	"os"

	vault "github.com/hashicorp/vault/api"
)

func main() {

	vaultAddress := "http://localhost:8200"
	vaultUsername := "user1"
	vaultPassword := "azerty"

	// Créez une nouvelle configuration Vault avec l'adresse de Vault
	config := &vault.Config{Address: vaultAddress}

	// Initialisez un nouveau client Vault
	client, err := vault.NewClient(config)
	if err != nil {
		fmt.Println("Error creating Vault client:", err)
		os.Exit(1)
	}

	// Authentification avec userpass
	loginData := map[string]interface{}{
		"password": vaultPassword,
	}
	secret, err := client.Logical().Write("auth/userpass/login/"+vaultUsername, loginData)
	if err != nil {
		fmt.Println("Error authenticating with Vault:", err)
		os.Exit(1)
	}

	if secret == nil || secret.Auth.ClientToken == "" {
		fmt.Println("Authentication failed. Check your username and password.")
		os.Exit(1)
	}

	// Définir le token d'authentification pour le client Vault
	client.SetToken(secret.Auth.ClientToken)

	//Preparing the data to write
	inputData := map[string]interface{}{
		"data": map[string]interface{}{
			"hello": "world!",
		},
	}

	//Writing the data
	_, err = client.Logical().Write("secret/data/hello", inputData)
	if err != nil {
		panic(err)
	}

	//reading the data
	data, err := client.Logical().Read("secret/data/bonjour")
	if err != nil {
		panic(err)
	}
	fmt.Println(data.Data["data"])
}
