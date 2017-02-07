package app

import (
	"net/http"

	paArtTmp "github.com/firefirestyle/engine-v01/article/template"
	paUsrTmp "github.com/firefirestyle/engine-v01/user/template"
)

/*
config.go
var indexUrlConfig []string = []string{"users", "me", "user", "post"}
var usrConfig = paUsrTmp.UserTemplateConfig{
	TwitterConsumerKey:       "zr",
	TwitterConsumerSecret:    "e7",
	TwitterAccessToken:       "51",
	TwitterAccessTokenSecret: "Z5",
	KindBaseName:             "fu",
	AllowInvalidSSL:          true,
}
*/

var usrTemplate = paUsrTmp.NewUserTemplate(usrConfig)
var artTemplate *paArtTmp.ArtTemplate = paArtTmp.NewArtTemplate(
	paArtTmp.ArtTemplateConfig{
		KindBaseName: "fa",
	}, usrTemplate.GetUserHundlerObj)

func init() {
	usrTemplate.InitUserApi()
	artTemplate.InitArtApi()
	for _, v := range indexUrlConfig {
		w := http.FileServer(http.Dir("web"))
		var a string = ("/" + v)
		http.Handle(a, http.StripPrefix(a, w))
	}
	http.Handle("/", http.FileServer(http.Dir("web")))
}
