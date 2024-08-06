package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func GetOperator(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	id, _ := strconv.Atoi(vars["id"])
	operator, err := models.GetOperator(id)
	if err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, operator)
	}
}
