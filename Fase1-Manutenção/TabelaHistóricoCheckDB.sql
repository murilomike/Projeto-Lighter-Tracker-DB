-- Criando tabela para automatizar o CHECKDB no SQL Server

CREATE TABLE HistoricoCheckDB (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    DataExecucao DATETIME,
    Resultado NVARCHAR(MAX)
);




-- checkdb_com_historico
DECLARE @DataExecucao DATETIME = GETDATE();
DECLARE @Resultado NVARCHAR(MAX);

BEGIN TRY
    DBCC CHECKDB ('LighterTrackDB') WITH NO_INFOMSGS;
    SET @Resultado = 'CHECKDB executado com sucesso';
END TRY
BEGIN CATCH
    SET @Resultado = ERROR_MESSAGE();
END CATCH;

INSERT INTO HistoricoCheckDB (DataExecucao, Resultado)
VALUES (@DataExecucao, @Resultado);





-- EXEC msdb.dbo.sp_send_dbmail
--    @profile_name = 'SeuPerfilDeEmail',
--    @recipients = 'seuemail@exemplo.com',
--    @subject = 'Resultado do CHECKDB',
--    @body = @Resultado;
