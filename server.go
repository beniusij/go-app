package main

import "net/http"

type Handler interface {
	ServeHTTP(w http.ResponseWriter, r *http.Request)
}

//func ListenAndServe(addr string, handler Handler) error {}