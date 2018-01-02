#!/bin/bash
az vm delete -y --name mysqlTestVM01 --resource-group minschoMysqlRG01
az disk delete -y --name mysqlTestVM01_OsDisk1 --resource-group minschoMysqlRG01

#아래는 data disk만 삭제
az vm disk detach --name mysqlDataDisk01 --vm-name mysqlTestVM01 --resource-group minschoMysqlRG01
az vm disk detach --name mysqlDataDisk02 --vm-name mysqlTestVM01 --resource-group minschoMysqlRG01
az disk delete -y --name mysqlDataDisk01 --resource-group minschoMysqlRG01
az disk delete -y --name mysqlDataDisk02 --resource-group minschoMysqlRG01