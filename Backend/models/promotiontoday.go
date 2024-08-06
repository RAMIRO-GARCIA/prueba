package models

import (
	"api_rest_naps/db"
	"fmt"
)

type Promotion struct {
	ID             int
	PromotionType  string
	PromotionValue string
}

type Promotions []Promotion

func NewByPromotion(id int, Promotiontype, Promotionvalue string) *Promotion {
	promotion := &Promotion{ID: id, PromotionType: Promotiontype, PromotionValue: Promotionvalue}
	return promotion
}

func ListPromotion(zone_id int) (*Promotion, error) {
	promotion := NewByPromotion(0, "", "")
	sql := `SELECT 
	promotion_id,
	promotion_type,
	promotion_value
	FROM ko_promotions
	WHERE zone_id=? AND b_active=1;`
	rows, err := db.Query(sql, zone_id)
	if err != nil {
		return nil, fmt.Errorf("error executing query: %v", err)
	}

	if rows == nil {
		return nil, fmt.Errorf("no rows returned")
	}

	for rows.Next() {
		if err := rows.Scan(&promotion.ID, &promotion.PromotionType, &promotion.PromotionValue); err != nil {
			return nil, fmt.Errorf("error scanning row: %v", err)
		}
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating rows: %v", err)
	}
	defer rows.Close()
	return promotion, nil
}
