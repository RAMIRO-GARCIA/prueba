package models

import (
	"api_rest_naps/db"
	"log"
	"time"

	"github.com/golang-jwt/jwt"
)

type Login struct {
	ID       int    `json:"id"`
	Password string `json:"password"`
	Email    string `json:"email"`
	Wallet   int    `json:"wallet"`
}

type Userlogin []Login

func ListUsers() ([]Login, error) {
	db.Connect()
	sql := `SELECT operator.operator_id, operator.password_hash, 
	operator.operator_email,wallet.operator_wallet_id 
	FROM api_test.ko_operators as operator
	INNER JOIN api_test.ko_operator_wallet as wallet on operator.operator_id=wallet.operator_id;`
	users := Userlogin{}
	rows, err := db.Query(sql)

	for rows.Next() {
		user := Login{}
		rows.Scan(&user.ID, &user.Password, &user.Email, &user.Wallet)
		users = append(users, user)
	}
	defer rows.Close()

	return users, err
}

type User struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type JWTResponse struct {
	Token      string `json:"token"`
	Refresh    string `json:"refresh_token"`
	OperatorID int    `json:"operator_id"`
	WalletID   int    `json:"wallet"`
}

func (u *User) Valid() (*Login, bool) {
	users, _ := ListUsers()
	for _, user := range users {
		if user.Email == u.Email && user.Password == u.Password {
			return &user, true
		}
	}
	return nil, false
}

func SingToken(operatorID int, walletID int) string {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"operator_id": operatorID,
		"wallet_id":   walletID,
		"exp":         time.Now().Add(time.Hour * 72).Unix(),
	})
	MySigningKey := []byte("AllYourBase")
	t, err := token.SignedString(MySigningKey)

	if err != nil {
		log.Println(err.Error())
		return ""
	}
	return t
}

func SingRefreshToken(operatorID int) string {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"operator_id": operatorID,
		"exp":         time.Now().Add(time.Hour * 72).Unix(),
		"refresh":     true,
	})

	MySigningKey := []byte("AllYourBase")
	t, err := token.SignedString(MySigningKey)

	if err != nil {
		log.Println(err.Error())
		return ""
	}
	return t
}
