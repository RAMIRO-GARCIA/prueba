package handles

import (
	"api_rest_naps/models"
	"encoding/json"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

// Crea una nueva venta
func CreatePayment(rw http.ResponseWriter, r *http.Request) {
	payment := models.Payment{}
	decoder := json.NewDecoder(r.Body)
	if err := decoder.Decode(&payment); err != nil {
		models.SendUnprocessableEntity(rw)
	} else {
		payment.Insert()
		models.SendData(rw, payment)
	}
}

func GetPayments(rw http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	paymentId, _ := strconv.Atoi(vars["id"])
	if payments, err := models.ListPayment(paymentId); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, payments)
	}
}

func GetPayment(rw http.ResponseWriter, r *http.Request) {

	if payment, err := getPaymentByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, payment)
	}
}
func GetMoney(rw http.ResponseWriter, r *http.Request) {

	if money, err := getMoneyByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		models.SendData(rw, money)
	}
}

// Actuliza una venta
func UpdatePayment(rw http.ResponseWriter, r *http.Request) {
	//Obtener ID
	var paymentId int64
	if payment, err := getPaymentByRequest(r); err != nil {
		models.SendNotFound(rw)
	} else {
		paymentId = payment.PaymentID
	}

	payment := models.Payment{}
	decoder := json.NewDecoder(r.Body)

	if err := decoder.Decode(&payment); err != nil {
		models.SendUnprocessableEntity(rw)
	} else {
		payment.PaymentID = paymentId
		payment.Update()
		models.SendData(rw, payment)
	}
}

func getPaymentByRequest(r *http.Request) (models.Payment, error) {
	//Obtener ID
	vars := mux.Vars(r)
	paymentId, _ := strconv.Atoi(vars["id"])

	if payment, err := models.GetPayment(paymentId); err != nil {
		return *payment, err
	} else {
		return *payment, nil
	}
}
func getMoneyByRequest(r *http.Request) (models.Moneypayment, error) {
	//Obtener ID
	vars := mux.Vars(r)
	saleId, _ := strconv.Atoi(vars["id"])

	if money, err := models.GetMoney(saleId); err != nil {
		return *money, err
	} else {
		return *money, nil
	}
}

func DeletePayment(rw http.ResponseWriter, r *http.Request) {

	if payment, err := getPaymentByRequest(r); err != nil {
		models.SendNotFound(rw)

	} else {
		payment.DeletePayment()
		models.SendData(rw, payment)
	}

}
