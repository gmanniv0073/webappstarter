# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "tftestresourcegroup" "example" {
  name     = "tfresourcegroupname"
  location = "East US 2"
}

# Create a virtual network within the resource group
resource "tftestvirtualnetwork" "example" {
  name                = "tfvirtualnetworkname"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "kubernetes_manifest" "nginx" {
  provider = "kubernetes"
  manifest = <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        volumeMounts:
        - name: html
          mountPath: /usr/share/nginx/html
      volumes:
      - name: html
        configMap:
          name: html
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
  - name: http
    port: 80
  type: ClusterIP
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: html
data:
  index.html: |-
    <html>
    <head>
      <title>Under Construction</title>
    </head>
    <body>
      <h1>Under Construction</h1>
    </body>
    </html>
EOF
}
