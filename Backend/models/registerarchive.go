package models

import (
	configa "api_rest_naps/config"
	"context"
	"fmt"
	"log/slog"
	"math/rand"
	"os"
	"strings"
	"time"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/credentials"
	"github.com/aws/aws-sdk-go-v2/service/s3"
)

type Process struct {
	logger *slog.Logger
}

func NewProcess(logger *slog.Logger) *Process {
	return &Process{logger: logger}
}

func (pr *Process) createSessionS3(configS3 configa.S3Env) (*s3.Client, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO(),
		config.WithRegion(configS3.Region),
		config.WithCredentialsProvider(credentials.NewStaticCredentialsProvider(configS3.Key, configS3.Secret, "")),
	)
	if err != nil {
		pr.logger.Error("Error configuring AWS", "error", err)
		return nil, err
	}
	svc := s3.NewFromConfig(cfg)
	return svc, nil
}

func (pr *Process) UploadS3(fileName string, fileNameTemp string, configS3 configa.S3Env) (string, error) {
	svc, err := pr.createSessionS3(configS3)
	if err != nil {
		pr.logger.Error("Error AWS:", "error", err)
		return "", err
	}
	srcFile, err := os.Open(fileNameTemp)
	if err != nil {
		pr.logger.Error("Error open file ", "filename", fileName, "error", err)
		return "", err
	}
	defer srcFile.Close()

	destPath := configS3.UpLoadDir + fileName
	params := &s3.PutObjectInput{
		Bucket: aws.String(configS3.Bucket),
		Key:    aws.String(destPath),
		Body:   srcFile,
		ACL:    ("public-read"),
	}

	defer os.Remove(fileNameTemp)
	result, err := svc.PutObject(context.TODO(), params)
	if err != nil {
		return "", err
	}
	fileURL := fmt.Sprintf("https://%s.s3.%s.amazonaws.com/%s", configS3.Bucket, configS3.Region, destPath)
	pr.logger.Info("Upload file success", "filename", fileName, "url", result.ResultMetadata)

	return fileURL, nil
	//pr.logger.Info("Upload file success", "info", "filename", fileName, result.ResultMetadata)
	//return nil
}

func generateRandomString(length int) string {
	characters := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var result strings.Builder
	for i := 0; i < length; i++ {
		result.WriteByte(characters[rand.Intn(len(characters))])
	}
	return result.String()
}

func GenerateFileName() string {
	filename := generateRandomString(8) + ".jpg"
	filename = fmt.Sprintf("%d", time.Now().Unix()) + "_" + filename
	return filename
}
