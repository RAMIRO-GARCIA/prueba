package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func GetBydeposit(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)

	operator_id, _ := strconv.Atoi(vars["id"])
	if bydeposit, err := models.GetCashbydeposit(operator_id); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, bydeposit)
	}

}
