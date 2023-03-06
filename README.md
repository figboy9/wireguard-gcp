## wireguard-gcp

### 1. Create Service Account on GCP

Download service account json key file.

### 2. Create .env file

```
PROJECT_ID=<Project ID for GCP>
GCP_KEY_PATH=<GCP Service Account Key Path>
```

### 3. Create GCP resources

```bash
make apply
```

### 4. Show wireguard QR

```bash
make qr
```
