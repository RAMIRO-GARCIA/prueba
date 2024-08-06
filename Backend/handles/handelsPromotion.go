package handles

import (
	"api_rest_naps/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

func getPromotionByRequest(r *http.Request) (models.Promotion, error) {
	//Obtiene variables
	vars := mux.Vars(r)

	zone_id, _ := strconv.Atoi(vars["zone_id"])

	if promotionNow, err := models.ListPromotion(zone_id); err != nil {
		return *promotionNow, err
	} else {
		return *promotionNow, nil
	}
}

func GetPromotions(rw http.ResponseWriter, r *http.Request) {

	if promotionNow, err := getPromotionByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, promotionNow)
	}
}
