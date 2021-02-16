package main

import (
	"fmt"
	"github.com/armon/go-socks5"
	"log"
	"os"
)

func ShowHelpMsg() {
	fmt.Println("Usage: socks5-server    <BIND-ADDRESS:PORT>")
}

func main() {
	if len(os.Args) <= 1 {
		ShowHelpMsg()
		return
	}
	conf := &socks5.Config{}
	server, err := socks5.New(conf)
	if err != nil {
		panic(err)
	}

	bindAddressPort := os.Args[1]

	log.Printf("BIND: %v\n", bindAddressPort)

	if err := server.ListenAndServe("tcp", bindAddressPort); err != nil {
		panic(err)
	}
}
