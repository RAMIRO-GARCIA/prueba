package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func GetSaletotal(rw http.ResponseWriter, r *http.Request) {
	//Obtener Month
	vars := mux.Vars(r)

	CardMonth, _ := strconv.Atoi(vars["month"])
	CardYear, _ := strconv.Atoi(vars["year"])
	CardPeople, _ := strconv.Atoi(vars["people_id"])
	if card, err := models.GetCard(CardMonth, CardYear, CardPeople); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, card)
	}
}
