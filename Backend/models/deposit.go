package models

import "api_rest_naps/db"

type Deposit struct {
	DepositId      int64   `json:"deposit_id"`
	DepositAmount  float64 `json:"deposit_amount"`
	AmountYear     int     `json:"deposit_year"`
	AmountMonth    int     `json:"deposit_month"`
	DepositReceipt string  `json:"deposit_receipt"`
	DepositDate    string  `json:"deposit_date"`
	DepositNotes   string  `json:"deposit_notes"`
	OperatorID     int     `json:"operator_id"`
	BankAccountId  int     `json:" bank_account_id"`
	CreateDate     string  `json:"creation_date"`
}

type Bankaccount struct {
	BankAccountId int    `json:"bank_account_id"`
	Bankclabe     string `json:"bank_clabe"`
	AccountNumber string `json:"account_number"`
	Bankname      string `json:"bank_name"`
}
type Deposits []Deposit

const DepositSchema string = `CREATE TABLE ko_operator_bank_deposit (
    deposit_id INT NOT NULL AUTO_INCREMENT,
    deposit_amount DECIMAL(10, 2) NOT NULL,
    amount_year YEAR NOT NULL,
    amount_month MONTH NOT NULL,
    deposit_receipt TEXT,
    deposit_date DATE,
    deposit_notes VARCHAR(255),
    operator_id INT NOT NULL,
    bank_account_id INT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (deposit_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id),
    FOREIGN KEY (bank_account_id) REFERENCES ko_operator_zone_bank_account(bank_account_id)
);`

// Crea un nuevo deposito
func NewDeposit(deposit_amount float64, amount_year int,
	amount_month int, deposit_receipt string, deposit_date string,
	deposit_notes string, operator_id int, bank_account_id int) *Deposit {

	deposit := &Deposit{DepositAmount: deposit_amount, AmountYear: amount_year,
		AmountMonth: amount_month, DepositReceipt: deposit_receipt,
		DepositDate: deposit_date, DepositNotes: deposit_notes,
		OperatorID: operator_id, BankAccountId: bank_account_id}

	return deposit
}
func NewBank(id int, clabe string, account string, name string) *Bankaccount {
	bank := &Bankaccount{BankAccountId: id, Bankclabe: clabe, AccountNumber: account, Bankname: name}
	return bank
}

func CreateDeposit(deposit_amount float64, amount_year int,
	amount_month int, deposit_receipt string, deposit_date string,
	deposit_notes string, operator_id int, bank_account_id int) *Deposit {

	deposit := NewDeposit(deposit_amount, amount_year,
		amount_month, deposit_receipt, deposit_date,
		deposit_notes, operator_id, bank_account_id)
	deposit.Insert()
	return deposit
}

func (deposit *Deposit) Insert() {
	sql := `INSERT ko_operator_bank_deposit SET
    deposit_amount=?,
    amount_year=?,
    amount_month=?,
    deposit_receipt=?,
    deposit_date=?,
    deposit_notes=?,
    operator_id=?,
    bank_account_id=?;`

	result, _ := db.Exec(sql, deposit.DepositAmount, deposit.AmountYear,
		deposit.AmountMonth, deposit.DepositReceipt, deposit.DepositDate,
		deposit.DepositNotes, deposit.OperatorID, deposit.BankAccountId)
	deposit.DepositId, _ = result.LastInsertId()
}

func ListDeposit(id int) ([]Deposit, error) {
	db.Connect()
	sql := `SELECT 
    deposit_id,deposit_amount, amount_year, amount_month,
    deposit_receipt, deposit_date,deposit_notes,operator_id,
    bank_account_id,creation_date
	FROM  api_test.ko_operator_bank_deposit
	WHERE operator_id=?
	order by deposit_id desc;`
	deposits := Deposits{}
	rows, err := db.Query(sql, id)
	for rows.Next() {
		deposit := Deposit{}
		rows.Scan(&deposit.DepositId, &deposit.DepositAmount, &deposit.AmountYear,
			&deposit.AmountMonth, &deposit.DepositReceipt, &deposit.DepositDate,
			&deposit.DepositNotes, &deposit.OperatorID, &deposit.BankAccountId,
			&deposit.CreateDate)
		deposits = append(deposits, deposit)
	}
	defer rows.Close()
	return deposits, err
}

func GetDeposit(id int) (*Deposit, error) {
	db.Connect()
	deposit := NewDeposit(0.0, 0, 0, "", "", "", 0, 0)
	sql := `SELECT 
    deposit_id,deposit_amount, amount_year, amount_month,
    deposit_receipt, deposit_date,deposit_notes,operator_id,
    bank_account_id,creation_date   
	FROM  ko_operator_bank_deposit WHERE deposit_id=? ;`
	if rows, err := db.Query(sql, id); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&deposit.DepositId, &deposit.DepositAmount, &deposit.AmountYear,
				&deposit.AmountMonth, &deposit.DepositReceipt, &deposit.DepositDate,
				&deposit.DepositNotes, &deposit.OperatorID, &deposit.BankAccountId,
				&deposit.CreateDate)
		}
		defer rows.Close()
		return deposit, nil

	}
}

func GetBank(id int) (*Bankaccount, error) {
	bank := NewBank(0, "", "", "")
	sql := ` SELECT bank_account_id,CLABE,account_number,bank_name 
FROM ko_operator_zone_bank_account WHERE  bank_account_id=?;`
	if rows, err := db.Query(sql, id); err != nil {
		return nil, err
	} else {
		for rows.Next() {
			rows.Scan(&bank.BankAccountId, &bank.Bankclabe, &bank.AccountNumber, &bank.Bankname)
		}
		defer rows.Close()
		return bank, nil
	}
}

func (deposit *Deposit) Update() {
	sql := `UPDATE   ko_operator_bank_deposit SET
    deposit_amount=?,
	 amount_year=?, 
	 amount_month=?,
    deposit_receipt=?, 
	deposit_date=?,
	deposit_notes=?,
	operator_id=?,
    bank_account_id=? 
	WHERE deposit_id=? ;`
	db.Exec(sql, deposit.DepositAmount, deposit.AmountYear,
		deposit.AmountMonth, deposit.DepositReceipt,
		deposit.DepositDate, deposit.DepositNotes, deposit.OperatorID,
		deposit.BankAccountId, deposit.DepositId)
}

func (deposit *Deposit) Save() {
	if deposit.DepositId == 0 {
		deposit.Insert()
	} else {
		deposit.Update()
	}
}

func (deposit *Deposit) Delete() {
	sql := `DELETE FROM ko_operator_bank_deposit WHERE deposit_id=? ;`
	db.Exec(sql, deposit.DepositId)
}
