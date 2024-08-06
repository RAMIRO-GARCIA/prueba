package handles

import (
	"api_rest_naps/models"
	"encoding/json"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

// Crea una nueva venta
func CreateSale(rw http.ResponseWriter, r *http.Request) {
	sale := models.Sale{}
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&sale); err != nil {
		models.SendUnprocessableEntity(rw)
	} else {
		sale.Save()
		models.SendData(rw, sale)
	}
}

// Actuliza una venta
func UpdateSale(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	saleId, err := strconv.Atoi(vars["id"])
	if err != nil {
		models.SendNotFound(rw)
		return
	}

	sale := models.Sale{}
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&sale); err != nil {
		models.SendUnprocessableEntity(rw)
		return
	}

	sale.SaleID = int64(saleId)
	// Log the sale ID for debugging
	log.Printf("Updating sale with ID: %d\n", sale.SaleID)
	sale.Save()
	models.SendData(rw, sale)
}

func GetSales(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	Idoperator, _ := strconv.Atoi(vars["id"])
	if sales, err := models.ListSale(Idoperator); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, sales)
	}
}

func Getsale(rw http.ResponseWriter, r *http.Request) {

	if sale, err := getSaleByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, sale)
	}
}

func getSaleByRequest(r *http.Request) (models.Sale, error) {
	//Obtener ID
	vars := mux.Vars(r)
	saleId, _ := strconv.Atoi(vars["id"])

	if sale, err := models.GetSale(saleId); err != nil {
		return *sale, err
	} else {
		return *sale, nil
	}
}

func DeleteSale(rw http.ResponseWriter, r *http.Request) {

	if sale, err := getSaleByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		sale.Delete()
		models.SendData(rw, sale)
	}
}

func GetDeudores(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	operatorId, _ := strconv.Atoi(vars["id"])
	if sales, err := models.GetDeudores(operatorId); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, sales)
	}
}
