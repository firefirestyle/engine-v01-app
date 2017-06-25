package app

import (
	"net/http"

	"regexp"
	"strings"

	paArtTmp "github.com/firefirestyle/engine-v01/article/template"
	paUsrTmp "github.com/firefirestyle/engine-v01/user/template"
	//	"google.golang.org/appengine"
	//	"google.golang.org/appengine/log"
	"os"
	//	"strings"
	"time"

	"io/ioutil"

	//	"google.golang.org/appengine/log"

	"encoding/base32"

	"google.golang.org/appengine"
)

/*
config.go
var indexUrlConfig []string = []string{"/index.html","/", "/users", "/me", "/user", "/post"}
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
		if strings.Contains(r.URL.Host, "firefirestyle.net") {
			http.Redirect(w, r, "https://firefirestyle.appspot.com", 302)
			return
		}
		//
		for _, v := range indexUrlConfig {
			if v == r.URL.Path {
				//				http.ServeFile(w, r, "web/index.html")
				serveIndexHtml(w, r, "web")
				return
			}
		}
		//
		if pat1.MatchString(r.URL.Path) {
			http.ServeFile(w, r, "web/index.html")
			return
		} else {
			serveFile(w, r, "web")
			//			http.ServeFile(w, r, "web"+r.URL.Path)
			return
		}
	})
}

func serveIndexHtml(w http.ResponseWriter, r *http.Request, dir string) {
	pat2, _ := regexp.Compile("main\\.dart\\.js")
	path := dir + "/index.html"

	f, e := os.Open(path)
	if e != nil {
		w.WriteHeader(404)
		return
	}
	cont, _ := ioutil.ReadAll(f)
	version := appengine.VersionID(appengine.NewContext(r))
	versionHash := base32.StdEncoding.EncodeToString([]byte(version))
	v := "main.dart.js?version=" + versionHash
	cont = pat2.ReplaceAll(cont, []byte(v))
	f.Close()

	w.Write([]byte(cont))
}

func serveFile(w http.ResponseWriter, r *http.Request, dir string) {
	pat1, _ := regexp.Compile(".*/")
	path := dir + r.URL.Path
	filename := pat1.ReplaceAllString(path, "")

	f, e := os.Open(path)
	if e != nil {
		w.WriteHeader(404)
		return
	}

	if r.URL.Query().Get("version") != "" {
		w.Header().Set("Cache-Control", "public, max-age=2592000")
	}

	http.ServeContent(w, r, filename, time.Time{}, f)
}
