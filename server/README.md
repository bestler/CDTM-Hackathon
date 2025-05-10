# BUILD

1. docker build --platform=linux/amd64 -t fastapi:latest .
2. docker tag fastapi:latest  europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/fastapi-repo/fastapi-app:latest
3. docker push europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/fastapi-repo/fastapi-app:latest
4. gcloud run deploy fastapi-service \                                                            
  --image=europe-west3-docker.pkg.dev/avi-cdtm-hack-team-1277/fastapi-repo/fastapi-app \
  --platform=managed \
  --region=europe-west3 \
  --allow-unauthenticated \
--set-env-vars MISTRAL_API_KEY=cr0jsksN6GrXg0spar0vMPENfHVNza6v

