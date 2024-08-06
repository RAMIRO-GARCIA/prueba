package models

import (
	"api_rest_naps/db"
)

type Carddeposittotal struct {
	TotalDeposit float64 `json:"total_deposit"`
}

func NewDeposittotal(totaldeposit float64) *Carddeposittotal {

	deposittotal := &Carddeposittotal{TotalDeposit: totaldeposit}
	return deposittotal
}

func GetDeposittotal(month, year, people int) (*Carddeposittotal, error) {
	db.Connect()
	deposittotal := NewDeposittotal(0.0)
	db.Connect()
	sql := `SELECT SUM(kdep.deposit_amount) totaldeposit
	FROM api_test.ko_operator_bank_deposit  AS kdep 
	WHERE month(kdep.creation_date)=?
	AND year(kdep.creation_date)=?
	  AND kdep.operator_id=?;`
	if rows, err := db.QuerySimple(sql, month, year, people); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&deposittotal.TotalDeposit)
		}
		defer rows.Close()
		return deposittotal, nil
	}
}
