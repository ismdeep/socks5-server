package main

import (
	"fmt"
	"github.com/armon/go-socks5"
	"github.com/ismdeep/ismdeep-go-utils/args_util"
	"log"
)

func ShowHelpMsg() {
	fmt.Println("Usage: socks5-server    -l <BIND-ADDRESS:PORT>")
}

func main() {
	if args_util.Exists("--help") {
		ShowHelpMsg()
		return
	}

	if !args_util.Exists("-l") {
		ShowHelpMsg()
		return
	}

	bindAddressPort := args_util.GetValue("-l")

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
