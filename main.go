package main

import (
	_ "embed"
	"fmt"
	"log"
	"os"

	"github.com/armon/go-socks5"

	"github.com/ismdeep/socks5-server/conf"
)

//go:embed banner.txt
var banner string

func main() {

	fmt.Println(banner)

	cfg := &socks5.Config{}

	if conf.ROOT.Username != "" {
		log.Println("authentication enabled")
		cfg.Credentials = socks5.StaticCredentials{
			conf.ROOT.Username: conf.ROOT.Password,
		}
	} else {
		log.Println("WARN!!! authentication disabled")
	}

	server, err := socks5.New(cfg)
	if err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "failed to create server: %v\n", err)
		os.Exit(1)
	}

	log.Printf("socks5 server started, bind: %v\n", conf.ROOT.Bind)
	if err := server.ListenAndServe("tcp", conf.ROOT.Bind); err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "failed to start server: %v\n", err)
		os.Exit(1)
	}
}
