USE LighterTrackDB;

-- Backup Full

BACKUP DATABASE LighterTrackDB
TO DISK = 'D:\2019\MSSQL15.MURILODB\MSSQL\Backup\LighterTrackDB_Full.bak'
WITH INIT, COMPRESSION, STATS = 10;

-- Backup Diff

BACKUP DATABASE LighterTrackDB
TO DISK = 'D:\2019\MSSQL15.MURILODB\MSSQL\Backup\LighterTrackDB_Diff.bak'
WITH DIFFERENTIAL, INIT, COMPRESSION, STATS = 10;


-- Backup Log de Transações

BACKUP LOG LighterTrackDB
TO DISK = 'D:\2019\MSSQL15.MURILODB\MSSQL\Backup\LighterTrackDB_Log.trn'
WITH INIT, COMPRESSION, STATS = 10;


-- Criação do JOB


