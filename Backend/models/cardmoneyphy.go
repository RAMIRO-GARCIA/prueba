package models

import "api_rest_naps/db"

type Cobrar struct {
	Money       float64 `json:"money"`
	Description string  `json:"description"`
}

func NewDefault(money float64, description string) *Cobrar {
	moneydefault := &Cobrar{Money: money, Description: description}
	return moneydefault
}

func Getdefault(operatorid int) (*Cobrar, error) {
	db.Connect()
	moneydefault := NewDefault(0.0, "")
	sql := `
SELECT (total_sales - total_payments) AS total_balance,
'Efectivo por cobrar' AS description
FROM (SELECT IFNULL(SUM(sale.balance_sold), 0) AS total_sales
FROM ko_operator_balance_sale AS sale
WHERE sale.sale_type = 'credito' AND sale.operator_id = ?
) AS sales_subquery,
(SELECT IFNULL(SUM(pay.payment_amount), 0) AS total_payments
FROM payments AS pay
WHERE pay.operator_id = ?
) AS payments_subquery;
`

	if rows, err := db.Query(sql, operatorid, operatorid); err != nil {
		return nil, err
	} else {
		println("Solicitud peticion de efectivo")
		for rows.Next() {
			rows.Scan(&moneydefault.Money, &moneydefault.Description)
		}
		defer rows.Close()
		return moneydefault, nil
	}
}
