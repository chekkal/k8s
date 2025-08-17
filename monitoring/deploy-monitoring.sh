#!/bin/bash

# Deploy Seata and Redis Monitoring Stack
echo "Deploying monitoring stack for Seata and Redis..."

# Create monitoring namespace
echo "Creating monitoring namespace..."
kubectl apply -f monitoring-namespace.yaml

# Deploy Prometheus
echo "Deploying Prometheus..."
kubectl apply -f prometheus-config.yaml
kubectl apply -f prometheus-deployment.yaml

# Deploy Redis Exporter
echo "Deploying Redis Exporter..."
kubectl apply -f redis-exporter.yaml

# Update Seata deployment with monitoring annotations
echo "Updating Seata deployment..."
kubectl apply -f seata-server-deployment.yaml
kubectl apply -f seata-server-service.yaml

# Deploy Grafana
echo "Deploying Grafana..."
kubectl apply -f grafana-config.yaml
kubectl apply -f grafana-deployment.yaml

# Deploy ServiceMonitors (if Prometheus Operator is available)
echo "Deploying ServiceMonitors..."
kubectl apply -f service-monitors.yaml 2>/dev/null || echo "ServiceMonitors not applied - Prometheus Operator may not be installed"

# Wait for deployments
echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/prometheus -n monitoring
kubectl wait --for=condition=available --timeout=300s deployment/grafana -n monitoring
kubectl wait --for=condition=available --timeout=300s deployment/redis-exporter -n seata-cluster

echo "Monitoring stack deployed successfully!"
echo ""
echo "Access URLs:"
echo "Prometheus: http://<node-ip>:9090 (port-forward: kubectl port-forward -n monitoring svc/prometheus 9090:9090)"
echo "Grafana: http://<node-ip>:30300 (admin/admin)"
echo ""
echo "To port-forward Prometheus: kubectl port-forward -n monitoring svc/prometheus 9090:9090"
echo "To port-forward Grafana: kubectl port-forward -n monitoring svc/grafana 3000:3000"