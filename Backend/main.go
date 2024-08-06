package main

import (
	"api_rest_naps/handles"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

func main() {
	mux := mux.NewRouter()

	go LoginApi(mux)
	go CardsApi(mux)
	go SalesApi(mux)
	go DepositApi(mux)
	go PaymentApi(mux)
	mux.HandleFunc("/api/naps/", handles.Getproyects).Methods("GET")
	mux.HandleFunc("/api/naps/proyects/", handles.Getproyects).Methods("GET")
	// Configurar el manejador para subir imágenes
	mux.HandleFunc("/api/imagen/", handles.UploadImageHandler).Methods("POST")

	//fmt.Println("Run server: http://localhost:3000")
	//go log.Fatal(http.ListenAndServe(":8080", mux))
	srv := &http.Server{
		Handler:      mux,
		Addr:         "0.0.0.0:8080",
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	log.Println("Run server: http://localhost:8080")
	log.Fatal(srv.ListenAndServe())
}

func CardsApi(r *mux.Router) {
	//Obtiene el total de ventas filtrado por operator_id, year_id y month_id
	r.HandleFunc("/api/sales/total/{month:[0-9]+}/{year:[0-9]+}/{people_id:[0-9]+}/", handles.GetSaletotal).Methods("GET")
	//OBtiene el total de los depositos por medio del operator_id y el mes
	r.HandleFunc("/api/deposits/total/{month_id:[0-9]+}/{year_id:[0-9]+}/{people_id:[0-9]+}/", handles.GetTotalDeposit).Methods("GET")
	//Obtiene el efectivo en posecion para depositar (Suma las ventas a contado y los abonos filtrado por operator,month y year)
	r.HandleFunc("/api/bydeposits/{id:[0-9]+}/", handles.GetBydeposit).Methods("GET")
	//Obtiene el efectivo faltante por cobrar
	r.HandleFunc("/api/money/by/phy/{id:[0-9]+}/", handles.Getdefaultmoney).Methods("GET")
}
func SalesApi(r *mux.Router) {
	r.HandleFunc("/api/sales/", handles.CreateSale).Methods("POST")
	r.HandleFunc("/api/sales/operator/{id:[0-9]+}/", handles.GetSales).Methods("GET")
	r.HandleFunc("/api/sales/{id:[0-9]+}/", handles.Getsale).Methods("GET")
	r.HandleFunc("/api/sales/update/{id:[0-9]+}/", handles.UpdateSale).Methods("PUT")
	r.HandleFunc("/api/sales/{id:[0-9]+}/", handles.DeleteSale).Methods("DELETE")
	r.HandleFunc("/api/sales/promotios/{zone_id:[0-9]+}/", handles.GetPromotions).Methods("GET")
	r.HandleFunc("/api/sales/deudores/{id:[0-9]+}/", handles.GetDeudores).Methods("GET")
}

func DepositApi(r *mux.Router) {

	r.HandleFunc("/api/deposits/", handles.CreateDeposit).Methods("POST")
	r.HandleFunc("/api/deposits/list/{id:[0-9]+}/", handles.GetDeposits).Methods("GET")
	r.HandleFunc("/api/deposits/by/{id:[0-9]+}/", handles.GetDeposit).Methods("GET")
	r.HandleFunc("/api/deposits/{id:[0-9]+}/", handles.UpdateDeposit).Methods("PUT")
	r.HandleFunc("/api/depositsbyid/{id:[0-9]+}/", handles.DeleteDeposit).Methods("DELETE")
	r.HandleFunc("/api/deposits/bank/{id:[0-9]+}/", handles.GetBank).Methods("GET")
	//Referencias bancarias
	r.HandleFunc("/api/references/{operator_id:[0-9]+}/", handles.GetReferences).Methods("GET")

}

func PaymentApi(r *mux.Router) {
	r.HandleFunc("/api/payments/total/{id:[0-9]+}/", handles.GetMoney).Methods("GET")
	r.HandleFunc("/api/payments/", handles.CreatePayment).Methods("POST")
	r.HandleFunc("/api/payments/{id:[0-9]+}/", handles.GetPayments).Methods("GET")
	//r.HandleFunc("/api/payments/{id:[0-9]+}/", handles.GetPayment).Methods("GET")
	r.HandleFunc("/api/paymentbyid/{id:[0-9]+}/", handles.UpdatePayment).Methods("PUT")
	r.HandleFunc("/api/paymentbyid/{id:[0-9]+}/", handles.GetPayment).Methods("GET")
	r.HandleFunc("/api/paymentbyid/{id:[0-9]+}/", handles.DeletePayment).Methods("DELETE")
}

func LoginApi(r *mux.Router) {
	//Autentificacion de usuario con JWT
	//r.HandleFunc("/login/token/", handles.ValidateTokenMiddleware(handles.SecureGreentings())).Methods("GET")
	//r.HandleFunc("/login/", handles.UserHandler()).Methods("POST")
	r.HandleFunc("/login/", handles.UserHandler()).Methods("POST")
	r.HandleFunc("/api/operator/{id:[0-9]+}/", handles.GetOperator).Methods("GET")
}
