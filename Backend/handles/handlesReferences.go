package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func GetRefrerencesByRequest(rw http.ResponseWriter, r *http.Request) {
	//Obtiene el id del promotor
	vars := mux.Vars(r)
	operator, _ := strconv.Atoi(vars["operator_id"])
	if reference, err := models.ListReferences(operator); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, reference)
	}
}

func GetReferences(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	operator, _ := strconv.Atoi(vars["operator_id"])
	if payments, err := models.ListReferences(operator); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, payments)
	}
}
