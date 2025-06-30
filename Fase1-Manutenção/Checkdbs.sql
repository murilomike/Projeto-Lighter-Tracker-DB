USE LighterTrackDB

-- Padrão
DBCC CHECKDB (LighterTrackDB)


--	Tabelas Isoladas - Ideal para não comprometer a performance 
DBCC CHECKTABLE (Isqueiros)




-- Apenas alocação de disco
DBCC CHECKDB (LighterTrackDB) with PHYSICAL_ONLY;




-- Sem informações
DBCC CHECKDB (LighterTrackDB) with NO_INFOMSGS;







-- Não verifica índices
DBCC CHECKDB (LighterTrackDB, NOINDEX);







ALTER DATABASE LighterTrackDB 
SET SINGLE_USER 
WITH ROLLBACK IMMEDIATE;
GO

-- Recupera o que for possível sem perda de dados
DBCC CHECKDB (LighterTrackDB, REPAIR_REBUILD) with NO_INFOMSGS;





-- Recupera o banco com perda de dados
DBCC CHECKDB (LighterTrackDB, REPAIR_ALLOW_DATA_LOSS) with NO_INFOMSGS;









ALTER DATABASE LighterTrackDB 
SET MULTI_USER 
WITH ROLLBACK IMMEDIATE;
GO

