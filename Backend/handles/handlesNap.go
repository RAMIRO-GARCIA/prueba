package handles

import (
	"api_rest_naps/models"
	"net/http"
)

func Getproyects(rw http.ResponseWriter, r *http.Request) {
	if sales, err := models.ListNaps(); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, sales)
	}
}
