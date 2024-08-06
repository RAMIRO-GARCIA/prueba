package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func getTotalDepositByRequest(r *http.Request) (models.Carddeposittotal, error) {

	vars := mux.Vars(r)
	peopleId, _ := strconv.Atoi(vars["people_id"])
	month, _ := strconv.Atoi(vars["month_id"])
	year, _ := strconv.Atoi(vars["year_id"])

	if totaldeposit, err := models.GetDeposittotal(month, year, peopleId); err != nil {
		return *totaldeposit, err
	} else {
		return *totaldeposit, nil
	}
}

func GetTotalDeposit(rw http.ResponseWriter, r *http.Request) {

	if totaldeposit, err := getTotalDepositByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, totaldeposit)
	}
}
