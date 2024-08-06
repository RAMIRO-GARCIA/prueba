package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func Getdefaultmoney(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	peopleId, _ := strconv.Atoi(vars["id"])
	if totalbypay, err := models.Getdefault(peopleId); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, totalbypay)
	}
}
