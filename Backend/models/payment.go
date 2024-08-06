package models

import "api_rest_naps/db"

type Payment struct {
	PaymentID     int64   `json:"payment_id"`
	SaleID        int     `json:"sale_id"`
	OperatorID    int     `json:"operator_id"`
	PaymentAmount float64 `json:"payment_amount"`
	PaymentDate   string  `json:"payment_date"`
	PaymentNote   string  `json:"payment_note"`
}

type Moneypayment struct {
	Money float64 `json:"money"`
}
type Payments []Payment

const SaleSchemaPayment string = `CREATE TABLE ko_operator_payments (
    payment_id INT NOT NULL AUTO_INCREMENT,
    sale_id INT NOT NULL,
    operator_id INT NOT NULL,
    payment_amount  DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_update DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    payment_note VARCHAR(255),
    PRIMARY KEY (payment_id),
    FOREIGN KEY (sale_id) REFERENCES ko_operator_balance_sale(sale_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id)
);`

// Crea un Abono
func NewPayment(sale int, operatorid int, paymentamount float64, paymentnote string) *Payment {
	payment := &Payment{SaleID: sale, OperatorID: operatorid, PaymentAmount: paymentamount, PaymentNote: paymentnote}
	return payment
}

func NewMoney(money float64) *Moneypayment {
	moneypayment := &Moneypayment{Money: money}
	return moneypayment
}

// Crear un abono e insertar
func CreatePayment(sale int, operatorid int, paymentamount float64, paymentnote string) *Payment {

	payment := NewPayment(sale, operatorid, paymentamount, paymentnote)
	payment.Save()
	return payment
}

// Insertar registro del abono
func (payment *Payment) Insert() {
	db.Connect()
	sql := `INSERT api_test.payments SET 
    sale_id=?,
	operator_id=?,
    payment_amount=?,
    note=?;`
	result, _ := db.Exec(sql, payment.SaleID, payment.OperatorID, payment.PaymentAmount, payment.PaymentNote)
	payment.PaymentID, _ = result.LastInsertId()

}

func ListPayment(id int) ([]Payment, error) {
	db.Connect()
	sql := `SELECT 
    idpayment, operator_id,sale_id, payment_amount, 
     create_at, note 
	FROM api_test.payments
	WHERE sale_id = ?
	order by  idpayment desc;`
	payments := Payments{}
	rows, err := db.Query(sql, id)
	for rows.Next() {
		payment := Payment{}
		rows.Scan(&payment.PaymentID, &payment.OperatorID, &payment.SaleID, &payment.PaymentAmount,
			&payment.PaymentDate, &payment.PaymentNote)
		payments = append(payments, payment)

	}
	defer rows.Close()
	return payments, err
}

func GetPayment(id int) (*Payment, error) {
	payment := NewPayment(0, 0, 0.0, "")
	sql := `SELECT 
    idpayment, operator_id,sale_id, payment_amount, 
    create_at, note 
	FROM api_test.payments WHERE idpayment=?;`

	if rows, err := db.Query(sql, id); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&payment.PaymentID, &payment.OperatorID, &payment.SaleID,
				&payment.PaymentAmount, &payment.PaymentDate,
				&payment.PaymentNote)
		}
		defer rows.Close()
		return payment, nil
	}
}

func GetMoney(id int) (*Moneypayment, error) {
	money := NewMoney(0.0)
	sql := `SELECT SUM(payment_amount) 
			FROM   api_test.payments 
			WHERE sale_id=?;`

	if rows, err := db.Query(sql, id); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&money.Money)
		}
		defer rows.Close()
		return money, nil
	}
}

func (payment *Payment) Update() {
	sql := `UPDATE api_test.payments SET
	 payment_amount=?, note=?
	WHERE idpayment=?;`

	db.Exec(sql, payment.PaymentAmount,
		payment.PaymentNote, payment.PaymentID)

}

func (payment *Payment) Save() {
	if payment.PaymentID == 0 {
		payment.Insert()
	} else {
		payment.Update()
	}
}

func (payment *Payment) DeletePayment() {
	sql := `DELETE FROM api_test.payments WHERE idpayment=?; `
	db.Exec(sql, payment.PaymentID)
}
