#!/bin/bash

# 输入参数：资源组名称
RESOURCE_GROUP=$1

# 获取 NSG 的名称
NSG_NAME=$(az network nsg list --resource-group $RESOURCE_GROUP --query '[0].name' -o tsv)

# 添加 NSG 规则
az network nsg rule create \
  --resource-group $RESOURCE_GROUP \
  --nsg-name $NSG_NAME \
  --name MyCustomInboundRule \
  --priority 111 \
  --source-address-prefixes '*' \
  --destination-port-ranges 7880 7881 50000-60000 \
  --direction Inbound \
  --access Allow \
  --protocol Tcp \
  --description "Allow inbound for livekit server"

echo "NSG rule added to $NSG_NAME in $NODE_RESOURCE_GROUP"
