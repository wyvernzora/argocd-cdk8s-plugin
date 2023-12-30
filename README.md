# ArgoCD cdk8s plugin
This is a fairly minimal plugin for building and syncing TypeScript based cdk8s apps via ArgoCD.

## Usage
This is a sidecar-type config management plugin, thus the overall setup instructions can be found in the [ArgoCD Config Management Plugins documentation](https://argo-cd.readthedocs.io/en/stable/operator-manual/config-management-plugins/#register-the-plugin-sidecar).

Following is an example manifest patch for this plugin:
```yaml
spec:
    containers:
      - name: cdk8s-plugin
        image: ghcr.io/wyvernzora/argocd-cdk8s-plugin
        command:
          - /var/run/argocd/argocd-cmp-server
        volumeMounts:
          - name: var-files
            mountPath: /var/run/argocd
          - name: plugins
            mountPath: /home/argocd/cmp-server/plugins
          - name: cdk8s-working-dir
            mountPath: /tmp
        securityContext:
            runAsNonRoot: true
            runAsUser: 999
    volumes:
      - name: cdk8s-working-dir
        emptyDir: { }
```

## cdk8s notes
 - ArgoCD passes the release name via the `ARGOCD_APP_NAME` and desired namespace via `ARGOCD_APP_NAMESPACE` environment variables. It is up to the CDK app author to detect and apply these environment variables to their `cdk8s.App` instance.
 - cdk8s apps are intended to be self-contained, and thus do not have an officially supported mechanism for passing in synth parameters. There are multiple strategies for dealing with this:
    - For non-sensitive values, include them in the cdk8s app source code
    - For secrets and credentials, use a separate secret injection mechanism and reference secrets from cdk8s app
    - For other configuration that should be kept private, separate the constructs and config parts of the cdk8s app and keep the config in a private repository
