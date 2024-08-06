package config

type S3Env struct {
	Bucket    string `json:"bucket"`
	Region    string `json:"region"`
	Key       string `json:"key"`
	Secret    string `json:"secret"`
	UpLoadDir string `json:"upLoadDir"`
}
