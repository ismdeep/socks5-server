package main

import (
	"log"

	"github.com/armon/go-socks5"

	"github.com/ismdeep/socks5-server/conf"
)

func main() {
	cfg := &socks5.Config{}

	if conf.ROOT.Username != "" {
		cfg.Credentials = socks5.StaticCredentials{
			conf.ROOT.Username: conf.ROOT.Password,
		}
	}

	server, err := socks5.New(cfg)
	if err != nil {
		panic(err)
	}

	log.Printf("BIND: %v\n", conf.ROOT.Bind)
	if err := server.ListenAndServe("tcp", conf.ROOT.Bind); err != nil {
		panic(err)
	}
}
