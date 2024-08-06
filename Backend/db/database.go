package db

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	"sync"

	_ "github.com/go-sql-driver/mysql"
	"github.com/joho/godotenv"
)

var (
	once sync.Once

	// Guarda la conexion
	db *sql.DB
)

// Cargar las variables de entorno desde el archivo .env
func loadEnv() {
	err := godotenv.Load()
	if err != nil {
		log.Fatalf("Error loading .env file")
	}
}

// Obtener la cadena de conexión de la variable de entorno
func getDatabaseURL() string {
	url := os.Getenv("DATABASE_URL")
	if url == "" {
		log.Fatalf("DATABASE_URL not set in .env file")
	}
	return url
}

// Realizar la conexión
func Connect() {
	once.Do(func() {
		loadEnv() // Cargar las variables de entorno

		// Obtener la cadena de conexión de la variable de entorno
		databaseURL := getDatabaseURL()

		conection, err := sql.Open("mysql", databaseURL)
		if err != nil {
			panic(err)
		}
		// Configurar el número máximo de conexiones abiertas y en espera
		conection.SetMaxOpenConns(5)    // Máximo de 5 conexiones abiertas
		conection.SetMaxIdleConns(2)    // Máximo de 2 conexiones inactivas
		conection.SetConnMaxLifetime(0) // Tiempo máximo de vida de una conexión

		fmt.Println("Conexion exitosa")
		db = conection
	})
}

// Cerrar la Conexion
func Close() {
	db.Close()
}

// Verificar la conexion
func Ping() {
	if err := db.Ping(); err != nil {
		panic(err)
	}
}

// Polimorfismo a Exec
func Exec(query string, args ...interface{}) (sql.Result, error) {
	result, err := db.Exec(query, args...)
	//Close()
	if err != nil {
		fmt.Println(err)
	}
	return result, err
}

// Polimorfismo a Query
func Query(query string, args ...interface{}) (*sql.Rows, error) {
	rows, err := db.Query(query, args...)
	//Close()
	if err != nil {
		fmt.Println(err)
	}

	return rows, nil
}

// Exec para saber hacer operacion sin cerrar o abrir la conexion a la base de datos
func ExecSimple(query string, args ...interface{}) (sql.Result, error) {
	result, err := db.Exec(query, args...)
	if err != nil {
		fmt.Println(err)
	}
	return result, err
}

func QuerySimple(query string, args ...interface{}) (*sql.Rows, error) {
	rows, err := db.Query(query, args...)
	if err != nil {
		fmt.Println(err)
	}

	return rows, nil
}
