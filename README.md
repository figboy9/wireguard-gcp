## wireguard-gcp

### 1. Create .env file

```
PROJECT_ID=<Project ID for GCP>
GCP_KEY_PATH=<GCP Service Account Key Path>
```

### 2. Create GCP resources

```bash
make apply
```

### 3. Show wireguard QR

```bash
make qr
```
