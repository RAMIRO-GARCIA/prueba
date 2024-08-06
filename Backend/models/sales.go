package models

import (
	"api_rest_naps/db"
)

type Sale struct {
	SaleID              int64   `json:"sale_id"`
	SaleNumber          string  `json:"sale_number"`
	SaleType            string  `json:"sale_type"`
	SalesAmount         float64 `json:"sales_amount"`
	BalanceSold         float64 `json:"balance_sold"`
	Reference           string  `json:"reference"`
	DepositAccount      string  `json:"deposit_account"`
	PromotionID         int     `json:"promotion_id"`
	OperatorID          int     `json:"operator_id"`
	OperatorWalletID    int64   `json:"operator_wallet"`
	WalletPreviousFunds float64 `json:"wallet_previous_funds"`
	WalletFinalFunds    float64 `json:"wallet_final_funds"`
	SaleDate            string  `json:"sale_date"`
	LegacyResellerID    int     `json:"legacy_reseller_id"`
	OrganizationName    string  `json:"Organizationname"`
	OwnerFirst          string  `json:"firstname"`
	OwnerLast           string  `json:"lastname"`
}
type Listdeuda struct {
	Name   string  `json:"nameorganization"`
	Label  string  `json:"label"`
	Saleid int     `json:"saleid"`
	Abono  float64 `json:"abono"`
	Venta  float64 `json:"venta"`
	Month  int     `json:"mes"`
}
type Zone struct {
	Id        int     `json:"saleid"`
	Nap       string  `json:"nap"`
	Zone      string  `json:"zone"`
	Salemoney float64 `json:"money"`
	Payment   float64 `json:"payment"`
	Month     int     `json:"month"`
	Year      int     `json:"year"`
}
type Zones []Zone
type Sales []Sale
type Listdeudas []Listdeuda

const SaleSchemaSale string = `CREATE TABLE ko_operator_balance_sale (
    sale_id INT NOT NULL AUTO_INCREMENT,
    sale_number VARCHAR(255),
    sale_type ENUM('credito', 'contado') NOT NULL,
    sales_amount DECIMAL(10, 2) NOT NULL,
    balance_sold DECIMAL(10, 2) NOT NULL,
    reference VARCHAR(255), 
    deposit_account VARCHAR(255),
    promotion_id INT,
    operator_id INT NOT NULL,
    operator_wallet_id INT,
    wallet_previous_funds DECIMAL(10, 2),
    wallet_final_funds DECIMAL(10, 2),
    sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    legacy_reseller_id INT,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (promotion_id) REFERENCES ko_promotions(promotion_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id),
    FOREIGN KEY (operator_wallet_id) REFERENCES ko_operator_wallet(operator_wallet_id)
);`

// Crea una venta
func NewSale(salenumber string, kind string, reference string, account string,
	promotion int, operator int, wallet int64, legacy int, amount float64, sold float64,
	wallet_previous float64, wallet_final float64) *Sale {
	sale := &Sale{SaleNumber: salenumber, SaleType: kind,
		BalanceSold: sold, Reference: reference,
		DepositAccount: account, PromotionID: promotion,
		OperatorID: operator, OperatorWalletID: wallet,
		WalletPreviousFunds: wallet_previous,
		WalletFinalFunds:    wallet_final, LegacyResellerID: legacy}
	return sale
}

// Crear una venta e insertar
func CreateSale(salenumber string, kind string, reference string, account string,
	promotion int, operator int, wallet int64, legacy int, amount float64,
	sold float64, wallet_previous float64, wallet_final float64) *Sale {

	sale := NewSale(salenumber, kind, reference, account, promotion,
		operator, wallet, legacy, amount, sold, wallet_previous,
		wallet_final)
	sale.Save()
	return sale
}

// Insertar Registro
func (sale *Sale) Insert() {
	sql := `INSERT ko_operator_balance_sale SET 
	sale_number=?,
	sale_type=?,
	sales_amount=?,
	balance_sold=?,
	reference=?,
	deposit_account=?,
	promotion_id=?,
	operator_id=?,
	operator_wallet_id=?,
	wallet_previous_funds=?,
	wallet_final_funds=?,
	legacy_reseller_id=?;`

	result, _ := db.Exec(sql, sale.SaleNumber, sale.SaleType,
		sale.SalesAmount, sale.BalanceSold, sale.Reference, sale.DepositAccount,
		sale.PromotionID, sale.OperatorID, sale.OperatorWalletID,
		sale.WalletPreviousFunds, sale.WalletFinalFunds, sale.LegacyResellerID)

	sale.SaleID, _ = result.LastInsertId()

}

// Obtener todo el registro
func ListSale(idoperator int) ([]Sale, error) {
	db.Connect()
	sql := `SELECT	sale.sale_id,sale.sale_number,sale.sale_type,sale.sales_amount,
	sale.balance_sold,nap.organizationName,sale.deposit_account,
	sale.promotion_id,sale.operator_id,sale.operator_wallet_id,
	sale.wallet_previous_funds, sale.wallet_final_funds,sale.sale_date,
	sale.legacy_reseller_id
    FROM ko_operator_balance_sale as sale
    INNER JOIN kigo_nap.naps_name as nap on nap.nap_id=sale.legacy_reseller_id 
    WHERE operator_id=?    
	order by sale_id desc;`
	sales := Sales{}
	rows, err := db.Query(sql, idoperator)
	for rows.Next() {
		sale := Sale{}
		rows.Scan(&sale.SaleID, &sale.SaleNumber, &sale.SaleType, &sale.SalesAmount, &sale.BalanceSold,
			&sale.Reference, &sale.DepositAccount, &sale.PromotionID, &sale.OperatorID, &sale.OperatorWalletID,
			&sale.WalletPreviousFunds, &sale.WalletFinalFunds, &sale.SaleDate, &sale.LegacyResellerID)
		sales = append(sales, sale)
	}
	defer rows.Close()

	defer rows.Close()
	return sales, err
}

func GetSale(id int) (*Sale, error) {
	db.Connect()
	sale := NewSale("", "", "", "", 0, 0, 0, 0, 0.0, 0.0, 0.0, 0.0)
	sql := `SELECT sale.sale_id,sale.sale_number,sale.sale_type,
sale.sales_amount,sale.balance_sold,sale.reference,
sale.deposit_account,sale.promotion_id,sale.operator_id,
sale.operator_wallet_id,sale.wallet_previous_funds,
sale.wallet_final_funds,sale.sale_date,sale.legacy_reseller_id,
naps.organizationName,naps.firstName,naps.lastName
 FROM api_test.ko_operator_balance_sale as sale
 JOIN kigo_nap.naps_name as naps on naps.nap_id=sale.legacy_reseller_id
 WHERE sale_id=?;`
	if rows, err := db.Query(sql, id); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&sale.SaleID, &sale.SaleNumber, &sale.SaleType, &sale.SalesAmount, &sale.BalanceSold,
				&sale.Reference, &sale.DepositAccount, &sale.PromotionID, &sale.OperatorID, &sale.OperatorWalletID,
				&sale.WalletPreviousFunds, &sale.WalletFinalFunds, &sale.SaleDate, &sale.LegacyResellerID,
				&sale.OrganizationName, &sale.OwnerFirst, &sale.OwnerLast)
		}
		defer rows.Close()
		return sale, nil
	}
}

// Actualizacion Registro
func (sale *Sale) Update() {
	sql := `UPDATE ko_operator_balance_sale SET 
	sale_number=?,sale_type=?,sales_amount=?,
	balance_sold=?,reference=?,deposit_account=?,promotion_id=?,operator_id=?,operator_wallet_id=?,
	wallet_previous_funds=? ,wallet_final_funds=?,legacy_reseller_id=? WHERE sale_id=?`

	db.Exec(sql, sale.SaleNumber, sale.SaleType, sale.SalesAmount,
		sale.BalanceSold, sale.Reference, sale.DepositAccount,
		sale.PromotionID, sale.OperatorID, sale.OperatorWalletID,
		sale.WalletPreviousFunds, sale.WalletFinalFunds,
		sale.LegacyResellerID, sale.SaleID)

}
func (sale *Sale) Save() {
	if sale.SaleID == 0 {
		sale.Insert()
	} else {
		sale.Update()

	}

}

func (sale *Sale) Delete() {
	sql := `DELETE from ko_operator_balance_sale WHERE sale_id=?`
	db.Exec(sql, sale.SaleID)
}

func GetDeudores(operatorid int) ([]Zone, error) {
	db.Connect()
	sql := `SELECT sale.sale_id,nap.organizationName,zone.zone_name, sale.balance_sold as venta,
IFNULL(SUM(pay.payment_amount), 0) as abonos,
month(sale_date)as mes,year(sale_date) as año
FROM ko_operator_balance_sale as sale
LEFT JOIN payments AS pay ON sale.sale_id = pay.sale_id
JOIN kigo_nap.naps_name as nap on sale.legacy_reseller_id=nap.nap_id
INNER JOIN pv_zones as zone on zone.zone_id=nap.zoneId
WHERE sale.operator_id = ?
GROUP BY sale.sale_id
HAVING abonos < sale.balance_sold
ORDER BY year(sale.sale_date) DESC, 
month(sale.sale_date) DESC;`

	zonas := Zones{}
	rows, err := db.Query(sql, operatorid)
	for rows.Next() {
		zona := Zone{}
		rows.Scan(&zona.Id, &zona.Nap, &zona.Zone, &zona.Salemoney, &zona.Payment, &zona.Month, &zona.Year)
		zonas = append(zonas, zona)
	}
	rows.Close()
	return zonas, err

}
