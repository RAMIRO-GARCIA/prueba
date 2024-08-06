package handles

import (
	"api_rest_naps/models"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

// Crea una nueva venta
func CreateDeposit(rw http.ResponseWriter, r *http.Request) {
	deposit := models.Deposit{}
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&deposit); err != nil {
		models.SendUnprocessableEntity(rw)
	} else {
		deposit.Save()
		models.SendData(rw, deposit)
	}
}

func GetDeposits(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	operstorId, _ := strconv.Atoi(vars["id"])
	if deposits, err := models.ListDeposit(operstorId); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, deposits)
	}
}

func GetDeposit(rw http.ResponseWriter, r *http.Request) {
	if deposit, err := getDepositByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, deposit)
	}
}

func getDepositByRequest(r *http.Request) (models.Deposit, error) {
	//OBtener Id
	vars := mux.Vars(r)
	depositId, _ := strconv.Atoi(vars["id"])

	if deposit, err := models.GetDeposit(depositId); err != nil {
		return *deposit, err
	} else {
		return *deposit, nil
	}

}
func GetBank(rw http.ResponseWriter, r *http.Request) {
	if bank, err := getBankByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, bank)
	}
}
func getBankByRequest(r *http.Request) (models.Bankaccount, error) {
	//OBtener Id
	vars := mux.Vars(r)
	bankId, _ := strconv.Atoi(vars["id"])

	if bank, err := models.GetBank(bankId); err != nil {
		return *bank, err
	} else {
		return *bank, nil
	}

}

func UpdateDeposit(rw http.ResponseWriter, r *http.Request) {

	var depositId int64
	if deposit, err := getDepositByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		depositId = deposit.DepositId
	}
	deposit := models.Deposit{}
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&deposit); err != nil {
		models.SendUnprocessableEntity(rw)
	} else {
		deposit.DepositId = depositId
		deposit.Update()
		models.SendData(rw, deposit)
	}
}

func DeleteDeposit(rw http.ResponseWriter, r *http.Request) {
	if deposit, err := getDepositByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		deposit.Delete()
		models.SendData(rw, deposit)
	}
}
