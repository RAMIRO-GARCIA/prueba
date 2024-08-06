package handles

import (
	"api_rest_naps/models"
	"encoding/json"
	"net/http"
)

func UserHandler() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		if r.Method == "POST" {

			body := r.Body
			defer body.Close()

			var user models.User
			err := json.NewDecoder(body).Decode(&user)

			if err != nil {
				http.Error(w, "cannot decode json", http.StatusBadRequest)
				return
			}
			if validUser, isValid := user.Valid(); isValid {
				res := getTokens(validUser.ID, validUser.Wallet)
				_ = json.NewEncoder(w).Encode(&res)
			} else {
				http.Error(w, "bad credentials", http.StatusBadRequest)
				return
			}

		} else {
			http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		}
	}
}

func getTokens(operatorID int, walletID int) *models.JWTResponse {
	token := models.SingToken(operatorID, walletID)
	refresh := models.SingRefreshToken(operatorID)
	return &models.JWTResponse{
		Token:      token,
		Refresh:    refresh,
		OperatorID: operatorID,
		WalletID:   walletID,
	}
}
