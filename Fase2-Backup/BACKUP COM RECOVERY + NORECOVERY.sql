RESTORE DATABASE LighterTrackDB WITH RECOVERY;


-- Script completo da operação de backups

USE [master]
GO

-- Etapa 1: Restaurar o backup FULL com NORECOVERY
RESTORE DATABASE [LighterTrackerDB] 
FROM DISK = N'D:\TMP\lightertracker_full.bak'
WITH FILE = 1,
MOVE N'LighterTrackerDB' TO N'D:\Program Files\Microsoft SQL Server\MSSQL13.SQLVIATIALIA\MSSQL\DATA\LighterTrackerDB.mdf',
MOVE N'LighterTrackerDB_log' TO N'D:\Program Files\Microsoft SQL Server\MSSQL13.SQLVIATIALIA\MSSQL\DATA\LighterTrackerDB_log.ldf',
NORECOVERY, NOUNLOAD, STATS = 5
GO

-- Etapa 2: Restaurar o backup DIFFERENTIAL com NORECOVERY
RESTORE DATABASE [LighterTrackerDB] 
FROM DISK = N'D:\TMP\lightertracker_diff.bak'
WITH FILE = 1, 
NORECOVERY, NOUNLOAD, STATS = 10
GO

-- Etapa 3: Restaurar o backup de LOG com RECOVERY
RESTORE LOG [LighterTrackerDB] 
FROM DISK = N'D:\TMP\lightertracker_log.trn'
WITH FILE = 1, 
RECOVERY, NOUNLOAD, STATS = 10
GO
