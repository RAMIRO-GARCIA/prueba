package models

import "api_rest_naps/db"

type Operator struct {
	Id        int    `json:"id"`
	Firstname string `json:"firsname"`
	Lastname  string `json:"lastname"`
}

func NewOperator(id int, firstname string, lastname string) *Operator {
	return &Operator{Id: id, Firstname: firstname, Lastname: lastname}
}

func GetOperator(id int) (*Operator, error) {
	db.Connect()
	operator := NewOperator(0, "", "")
	sql := `SELECT kop.operator_id,
			kop.first_name,kop.last_name
			FROM ko_operators as kop
			WHERE kop.operator_id=?`
	if rows, err := db.Query(sql, id); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&operator.Id, &operator.Firstname, &operator.Lastname)
		}
		defer rows.Close()
		return operator, nil
	}

}
