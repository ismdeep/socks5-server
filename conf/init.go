package conf

import (
	"context"

	"github.com/sethvargo/go-envconfig"
)

type cfg struct {
	Bind     string `env:"SOCKS5_SERVER_BIND,default=0.0.0.0:3080"`
	Username string `env:"SOCKS5_USERNAME"`
	Password string `env:"SOCKS5_PASSWORD"`
}

// ROOT instance
var ROOT cfg

func init() {
	if err := envconfig.Process(context.Background(), &ROOT); err != nil {
		panic(err)
	}
}
