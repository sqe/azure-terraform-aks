# Reference to the AKS cluster


resource "helm_release" "argocd" {
  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"

  values = [file("../../modules/argocd/values/argocd.yaml")]
}

# ArgoCD Bootstrap the app of apps 
resource "null_resource" "argocd_bootstrap" {
  provisioner "local-exec" {
    command = "kubectl apply -f ../../modules/argocd/apps/applications.yaml"
  }

  depends_on = [helm_release.argocd]
}