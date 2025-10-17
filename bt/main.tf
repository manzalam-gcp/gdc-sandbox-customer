provider "kubernetes" {
    alias       = "org"
  config_path = "/home/sandboxuser3/org1-admin-kubeconfig"
}

resource "kubernetes_manifest" "project-create" {
  provider = "kubernetes.org"
  manifest = {
    "apiVersion" = "resourcemanager.global.gdc.goog/v1"
    "kind" = "Project"
    "metadata" = {
      "name" = "tack-2"
      "namespace" = "platform"
    }
  }
}