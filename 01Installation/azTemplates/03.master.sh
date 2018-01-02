#!/bin/bash
az group create --name minschoMysqlRG01 --location koreacentral
az group deployment create --name networkForMysqlDeployment --resource-group minschoNetRG \
--template-file 00.mysqlNet.json \
--parameters vnet_name=minschoVnet01 \
--parameters subnet_name=testSubnet01 \
--parameters publicip_name=mysqlSingleNodeIP \
--parameters dnsPrefix=mysqltest01 \
--parameters nic_name=mysqlTestNic01


az group deployment create --name createVM --resource-group minschoMysqlRG01 --template-file 02.vm.json \
--parameters vm_name=mysqlTestVM01 \
--parameters adminUserId=minsoojo \
--parameters nic_name=mysqlTestNic01

# disk 두 개 만듬
az group deployment create --name createDataDisk --resource-group minschoMysqlRG01 --template-file 01.dataDisk.json \
--parameters dataDisk_name=mysqlDataDisk01
az group deployment create --name createDataDisk --resource-group minschoMysqlRG01 --template-file 01.dataDisk.json \
--parameters dataDisk_name=mysqlDataDisk02
# data disk attach
az vm disk attach --vm-name mysqlTestVM01 --disk mysqlDataDisk01 --lun 0 --resource-group minschoMysqlRG01
az vm disk attach --vm-name mysqlTestVM01 --disk mysqlDataDisk02 --lun 1 --resource-group minschoMysqlRG01

#disk lun 확인
az vm show --resource-group minschoMysqlRG01 --name mysqlTestVM01 | jq -r .storageProfile.dataDisks
az vm show --resource-group minschoMysqlRG01 --name mysqlTestVM01 | jq -r .storageProfile.dataDisks[].lun