FROM node:alpine

# Set up dependencies and cdk8s things
RUN apk add --no-cache jq yq
RUN npm install -g cdk8s-cli

# Run as user 999 as required by ArgoCD
RUN  adduser -DSu 999 argocd
USER argocd

# Copy plugin manifest as required by ArgoCD
WORKDIR /home/argocd/cmp-server/config/
COPY plugin.yaml ./
