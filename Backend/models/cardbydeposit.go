package models

import (
	"api_rest_naps/db"
)

type Bydeposit struct {
	TotalCash float64 `json:"total_cash"`
	Type      string  `json:"type"`
}
type Bydeposits []Bydeposit

func GetCashbydeposit(people int) ([]Bydeposit, error) {
	db.Connect()
	// Consulta principal para obtener el total de efectivo
	sql := `SELECT SUM(balance_sold) AS efectivo, 'contado' AS type_efectivo
FROM api_test.ko_operator_balance_sale
WHERE sale_type = 'contado' AND operator_id=? UNION ALL
SELECT SUM(payment_amount) AS efectivo, 'payment' AS type_efectivo
FROM api_test.payments 
WHERE  operator_id=? UNION ALL
SELECT SUM(deposit_amount) as efectivo,'deposito' as type_efectivo
FROM api_test.ko_operator_bank_deposit
WHERE operator_id=?;`
	bydeposits := Bydeposits{}
	rows, err := db.Query(sql, people, people, people)

	for rows.Next() {
		bydeposit := Bydeposit{}
		rows.Scan(&bydeposit.TotalCash, &bydeposit.Type)
		bydeposits = append(bydeposits, bydeposit)
	}
	defer rows.Close()
	return bydeposits, err

}
