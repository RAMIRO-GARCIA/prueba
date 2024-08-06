package models

import "api_rest_naps/db"

type Cardtotalsale struct {
	SaleTotal float64 `json:"sale_total"`
	SaleType  string  `json:"sale_type"`
}

type Cardtotalsales []Cardtotalsale

func GetCard(month, year, operator int) ([]Cardtotalsale, error) {
	db.Connect()
	sql := `SELECT sum(sales_amount),sale_type
 FROM api_test.ko_operator_balance_sale
 WHERE month(sale_date)=? AND year(sale_date)=? AND operator_id=?
group  by sale_type;`
	totalsales := Cardtotalsales{}
	rows, err := db.Query(sql, month, year, operator)
	for rows.Next() {
		totalsale := Cardtotalsale{}
		rows.Scan(&totalsale.SaleTotal, &totalsale.SaleType)
		totalsales = append(totalsales, totalsale)
	}
	defer rows.Close()
	return totalsales, err

}
