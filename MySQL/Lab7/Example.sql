CREATE DATABASE	Lab10
GO
USE AdventureWorks2016CTP3
SELECT * INTO Lab10.dbo.WorkOrder FROM Production.WorkOrder

USE Lab10
SELECT * FROM Lab10.dbo.WorkOrder 
SELECT* INTO WorkOrderIX FROM Production.WorkOrder

SELECT * FROM Production.WorkOrder
SELECT * FROM Production.WorkOrderRouting

CREATE INDEX IX_WorkOrderID ON WordOrderIX(WoekOrderID)
SELECT * FROM Production.WorkOrder WHERE WorkOrderID = 7200
SELECT * FROM Production.WorkOrderRouting WHERE WorkOrderID = 7200
