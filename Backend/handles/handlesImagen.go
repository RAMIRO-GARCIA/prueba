package handles

import (
	"encoding/json"
	"io"
	"log"
	"log/slog"
	"net/http"
	"os"
	"path/filepath"

	"api_rest_naps/config"
	"api_rest_naps/models"
)

// Manejador para subir imágenes
func UploadImageHandler(w http.ResponseWriter, r *http.Request) {
	// Parsear el formulario multipart
	err := r.ParseMultipartForm(10 << 20) // Tamaño máximo de 10 MB
	if err != nil {
		http.Error(w, "Error al procesar la solicitud", http.StatusBadRequest)
		return
	}

	// Obtener el archivo de la solicitud
	file, handler, err := r.FormFile("file")
	if err != nil {
		http.Error(w, "Error al obtener el archivo", http.StatusBadRequest)
		return
	}
	defer file.Close()

	// Guardar el archivo temporalmente
	tempDir := "./temp/"
	fileName := handler.Filename
	tempFilePath := filepath.Join(tempDir, fileName)
	tempFile, err := os.Create(tempFilePath)
	if err != nil {
		http.Error(w, "Error al crear el archivo temporal", http.StatusInternalServerError)
		return
	}
	defer tempFile.Close()

	// Copiar el archivo al directorio temporal
	_, err = io.Copy(tempFile, file)
	if err != nil {
		http.Error(w, "Error al guardar el archivo", http.StatusInternalServerError)
		return
	}

	// Cargar el archivo a AWS S3 y eliminar el archivo temporal
	process := models.NewProcess(slog.Default())
	configS3 := config.S3Env{
		Region:    os.Getenv("AWS_REGION"),
		Key:       os.Getenv("AWS_ACCESS_KEY_ID"),
		Secret:    os.Getenv("AWS_SECRET_ACCESS_KEY"),
		Bucket:    os.Getenv("AWS_BUCKET"),
		UpLoadDir: os.Getenv("UPLOAD_DIR"),
	}

	// Generar un nombre único para el archivo en S3
	uniqueFileName := models.GenerateFileName()
	// Subir a S3
	fileURL, err := process.UploadS3(uniqueFileName, tempFilePath, configS3)
	if err != nil {
		log.Printf("Error al subir el archivo: %v", err)
		http.Error(w, "Error al subir el archivo a S3", http.StatusInternalServerError)
		return
	}

	// Eliminar el archivo temporal después de subirlo a S3
	defer os.Remove(tempFilePath)

	// Construir la respuesta JSON con la URL de la imagen
	response := map[string]string{
		"message": "Archivo subido correctamente",
		"url":     fileURL,
	}
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}
