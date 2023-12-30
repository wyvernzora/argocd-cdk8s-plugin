FROM bitnami/node

# Set up cdk8s things
RUN npm install -g cdk8s-cli

# Run as user 999 as required by ArgoCD
RUN  useradd -u 999 argocd
USER argocd

# Copy plugin manifest as required by ArgoCD
WORKDIR /home/argocd/cmp-server/config/
COPY plugin.yaml ./

# Copy any scripts
# TODO
