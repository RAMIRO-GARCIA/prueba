package models

import "api_rest_naps/db"

type Nap struct {
	ID               int    `json:"id"`
	OrganizationName string `json:"organizationname"`
	Zone             int    `json:"zone_id"`
	Zonename         string `json:"zone_name"`
}
type Proyect struct {
	ID   int    `json:"id"`
	City string `json:"city"`
}

type Naps []Nap
type Proyects []Proyect

func ListNaps() ([]Nap, error) {
	db.Connect()
	sql := `SELECT naps.nap_id,naps.organizationName,zone.zone_id,zone.zone_name
FROM kigo_nap.naps_name AS naps
INNER JOIN pv_zones AS zone on zone.zone_id = naps.ZoneId
ORDER BY  naps.ZoneId asc;`
	naps := Naps{}
	rows, err := db.Query(sql)
	for rows.Next() {
		nap := Nap{}
		rows.Scan(&nap.ID, &nap.OrganizationName, &nap.Zone, &nap.Zonename)
		naps = append(naps, nap)
	}
	defer rows.Close()
	return naps, err

}
func ListProyects() ([]Proyect, error) {
	db.Connect()
	sql := `SELECT ID,CITY FROM kigo_naps.proyectospvca ORDER BY PRODUCT_TYPE ASC`
	proyects := Proyects{}
	rows, err := db.Query(sql)
	for rows.Next() {
		proyect := Proyect{}
		rows.Scan(&proyect.ID, &proyect.City)
		proyects = append(proyects, proyect)
	}
	defer rows.Close()
	return proyects, err

}
