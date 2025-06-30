USE LighterTrackDB

-- Padr�o
DBCC CHECKDB (LighterTrackDB)


--	Tabelas Isoladas - Ideal para n�o comprometer a performance 
DBCC CHECKTABLE (Isqueiros)




-- Apenas aloca��o de disco
DBCC CHECKDB (LighterTrackDB) with PHYSICAL_ONLY;




-- Sem informa��es
DBCC CHECKDB (LighterTrackDB) with NO_INFOMSGS;







-- N�o verifica �ndices
DBCC CHECKDB (LighterTrackDB, NOINDEX);







ALTER DATABASE LighterTrackDB 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE;
GO

-- Recupera o que for poss�vel sem perda de dados
DBCC CHECKDB (LighterTrackDB, REPAIR_REBUILD) with NO_INFOMSGS;





-- Recupera o banco com perda de dados
DBCC CHECKDB (LighterTrackDB, REPAIR_ALLOW_DATA_LOSS) with NO_INFOMSGS;









ALTER DATABASE LighterTrackDB 
SET MULTI_USER 
WITH ROLLBACK IMMEDIATE;
GO

