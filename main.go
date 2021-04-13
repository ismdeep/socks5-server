package main

import (
	"fmt"
	"github.com/armon/go-socks5"
	"github.com/ismdeep/args"
	"log"
)

func ShowHelpMsg() {
	fmt.Println("Usage: socks5-server    -l <BIND-ADDRESS:PORT>")
}

func main() {
	if args.Exists("--help") {
		ShowHelpMsg()
		return
	}

	if !args.Exists("-l") {
		ShowHelpMsg()
		return
	}

	bindAddressPort := args.GetValue("-l")

	conf := &socks5.Config{}
	server, err := socks5.New(conf)
	if err != nil {
		panic(err)
	}

	log.Printf("BIND: %v\n", bindAddressPort)

	if err := server.ListenAndServe("tcp", bindAddressPort); err != nil {
		panic(err)
	}
}
