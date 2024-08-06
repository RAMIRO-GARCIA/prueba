package models

import (
	"api_rest_naps/db"
)

type Reference struct {
	Id            int    `json:"id"`
	Namebank      string `json:"namebank`
	Accountnumber string `json:"accountnumber"`
}

type References []Reference

func ListReferences(operator int) ([]Reference, error) {
	db.Connect()
	sql := `SELECT opzobank.bank_account_id,
			opzobank.bank_name,
			opzobank.account_number
			FROM api_test.ko_operator_zone_bank_account as opzobank
			INNER JOIN api_test.ko_operator_zone as opzone on opzone.operator_zone_id=opzobank.operator_zone_id
			INNER JOIN api_test.ko_operators as op on op.operator_id=opzone.operator_id
			WHERE op.operator_id=?;`
	references := References{}

	rows, err := db.Query(sql, operator)
	for rows.Next() {
		reference := Reference{}
		rows.Scan(&reference.Id, &reference.Namebank, &reference.Accountnumber)
		references = append(references, reference)
	}
	defer rows.Close()
	return references, err

}
