package main

import (
	"embed"
	"fmt"
	"html/template"
	"net/http"
	"os"
	"time"
)

type Welcome struct {
	Name string
	Time string
	Pod  string
}

func getPort() string {
	p := os.Getenv("APP_PORT")
	if p != "" {
		return ":" + p
	}
	return ":8080"
}

func main() {
	welcome := Welcome{"GITOPS", time.Now().Format(time.Stamp), os.Getenv("HOSTNAME")}

	templates := template.Must(template.ParseFS(tmpFS,"templates/welcome-template.html"))

	http.Handle("/static/",
		http.StripPrefix("/static/",
			http.FileServer(http.Dir("static"))))
	

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {

		if name := r.FormValue("name"); name != "" {
			welcome.Name = name
		}
		if err := templates.ExecuteTemplate(w, "welcome-template.html", welcome); err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
		}
	})

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {

		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	fmt.Println("Listening on port " + getPort())
	fmt.Println(http.ListenAndServe(getPort(), nil))
}
