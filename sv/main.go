package app

import (
	"net/http"

	"regexp"

	paArtTmp "github.com/firefirestyle/engine-v01/article/template"
	paUsrTmp "github.com/firefirestyle/engine-v01/user/template"
	//	"google.golang.org/appengine"
	//	"google.golang.org/appengine/log"
)

/*
config.go
var indexUrlConfig []string = []string{"/users", "/me", "/user", "/post"}
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
	//
	//router path
	pat1, _ := regexp.Compile("[A-Z2-7]+")
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		//
		for _, v := range indexUrlConfig {
			if v == r.URL.Path {
				http.ServeFile(w, r, "web/index.html")
				return
			}
		}
		//
		if pat1.MatchString(r.URL.Path) {
			http.ServeFile(w, r, "web/index.html")
			return
		} else {
			http.ServeFile(w, r, "web"+r.URL.Path)
			return
		}
	})
}
