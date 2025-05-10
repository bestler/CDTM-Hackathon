# Build

1. docker buildx build --platform linux/amd64 -t europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/frontend/dashboard:latest .
2. docker tag dashboard:latest europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/frontend/dashboard:latest
3. docker push europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/frontend/dashboard:latest
4. gcloud run deploy dashboard \
  --image europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/frontend/dashboard:latest \
  --platform managed \
  --region europe-west3 \
  --allow-unauthenticated
