-- =========================================================
-- LIGHTERTRACK DATABASE - MODELAGEM COMPLETA
-- Sistema de An�lise de Consumo de Isqueiros
-- =========================================================

-- =========================================================
-- 1. CRIA��O DO DATABASE E CONFIGURA��ES INICIAIS
-- =========================================================

-- Usar o database
USE LighterTrackDB;

-- Configurar recovery model para FULL
ALTER DATABASE LighterTrackDB SET RECOVERY FULL;


-- =========================================================
-- 2. CRIA��O DAS TABELAS PRINCIPAIS
-- =========================================================

-- Tabela de Estados (lookup)
CREATE TABLE Estados (
    EstadoID INT IDENTITY(1,1) PRIMARY KEY,
    SiglaEstado CHAR(2) NOT NULL UNIQUE,
    NomeEstado VARCHAR(50) NOT NULL,
    Regiao VARCHAR(20) NOT NULL,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    DataAtualizacao DATETIME2 DEFAULT GETDATE()
);

INSERT INTO Estados (SiglaEstado, NomeEstado, Regiao) VALUES 
('AC', 'Acre', 'Norte'),
('AL', 'Alagoas', 'Nordeste'),
('AP', 'Amap�', 'Norte'),
('AM', 'Amazonas', 'Norte'),
('BA', 'Bahia', 'Nordeste'),
('CE', 'Cear�', 'Nordeste'),
('DF', 'Distrito Federal', 'Centro-Oeste'),
('ES', 'Esp�rito Santo', 'Sudeste'),
('GO', 'Goi�s', 'Centro-Oeste'),
('MA', 'Maranh�o', 'Nordeste'),
('MT', 'Mato Grosso', 'Centro-Oeste'),
('MS', 'Mato Grosso do Sul', 'Centro-Oeste'),
('MG', 'Minas Gerais', 'Sudeste'),
('PA', 'Par�', 'Norte'),
('PB', 'Para�ba', 'Nordeste'),
('PR', 'Paran�', 'Sul'),
('PE', 'Pernambuco', 'Nordeste'),
('PI', 'Piau�', 'Nordeste'),
('RJ', 'Rio de Janeiro', 'Sudeste'),
('RN', 'Rio Grande do Norte', 'Nordeste'),
('RS', 'Rio Grande do Sul', 'Sul'),
('RO', 'Rond�nia', 'Norte'),
('RR', 'Roraima', 'Norte'),
('SC', 'Santa Catarina', 'Sul'),
('SP', 'S�o Paulo', 'Sudeste'),
('SE', 'Sergipe', 'Nordeste'),
('TO', 'Tocantins', 'Norte');

SELECT * FROM Estados;

-- Tabela de Cidades
CREATE TABLE Cidades (
    CidadeID INT IDENTITY(1,1) PRIMARY KEY,
    EstadoID INT NOT NULL,
    NomeCidade VARCHAR(100) NOT NULL,
    Populacao INT,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (EstadoID) REFERENCES Estados(EstadoID)
);

-- Algumas cidades principais (focando em MT)
INSERT INTO Cidades (EstadoID, NomeCidade, Populacao) VALUES
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Cuiab�', 650000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'V�rzea Grande', 280000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Rondon�polis', 230000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Sinop', 140000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Tangar� da Serra', 110000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'C�ceres', 95000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Barra do Gar�as', 60000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'SP'), 'S�o Paulo', 12300000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'RJ'), 'Rio de Janeiro', 6700000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MG'), 'Belo Horizonte', 2500000),
-- Cidades principais de DF e GO
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'DF'), 'Bras�lia', 3100000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Goi�nia', 1530000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Aparecida de Goi�nia', 600000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'An�polis', 400000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Rio Verde', 250000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Luzi�nia', 210000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), '�guas Lindas de Goi�s', 210000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Valpara�so de Goi�s', 180000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Senador Canedo', 130000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Trindade', 130000);

-- Tabela de Usu�rios
CREATE TABLE Usuarios (
    UsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    Telefone VARCHAR(20),
    DataNascimento DATE,
    Genero CHAR(1) CHECK (Genero IN ('M', 'F', 'O')),
    CidadeID INT,
    CEP VARCHAR(10),
    Profissao VARCHAR(100),
    RendaFamiliar DECIMAL(10,2),
    Fumante BIT DEFAULT 0,
    DataCadastro DATETIME2 DEFAULT GETDATE(),
    DataUltimaAtualizacao DATETIME2 DEFAULT GETDATE(),
    Ativo BIT DEFAULT 1,
    FOREIGN KEY (CidadeID) REFERENCES Cidades(CidadeID)
);

SELECT * FROM Usuarios
-- Os inserts ser�o feitos depois. 


-- Tabela de Categorias de Isqueiros
CREATE TABLE CategoriasIsqueiros (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NomeCategoria VARCHAR(50) NOT NULL UNIQUE,
    Descricao VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

-- Categorias de Isqueiros
INSERT INTO CategoriasIsqueiros (NomeCategoria, Descricao) VALUES
('Descart�vel', 'Isqueiros de uso �nico, n�o recarreg�veis'),
('Recarreg�vel', 'Isqueiros que podem ser reabastecidos'),
('Eletr�nico', 'Isqueiros el�tricos/USB'),
('Premium', 'Isqueiros de luxo e colecion�veis'),
('Ma�arico', 'Isqueiros com chama forte para charutos'),
('Vela', 'Isqueiros com chama longa para velas'),
('Cozinha', 'Isqueiros espec�ficos para uso culin�rio');

SELECT * FROM CategoriasIsqueiros

-- Tabela de Marcas
CREATE TABLE Marcas (
    MarcaID INT IDENTITY(1,1) PRIMARY KEY,
    NomeMarca VARCHAR(50) NOT NULL UNIQUE,
    PaisOrigem VARCHAR(50),
    DataFundacao DATE,
    Website VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

-- Marcas de Isqueiros
INSERT INTO Marcas (NomeMarca, PaisOrigem, Website) VALUES
('BIC', 'Fran�a', 'www.bic.com'),
('Clipper', 'Espanha', 'www.clipper.es'),
('Zippo', 'Estados Unidos', 'www.zippo.com'),
('Cricket', 'Fran�a', 'www.cricket-lighter.com'),
('Ronson', 'Reino Unido', 'www.ronson.com'),
('S.T. Dupont', 'Fran�a', 'www.st-dupont.com'),
('Colibri', 'Estados Unidos', 'www.colibri.com'),
('Flamagas', 'Espanha', 'www.flamagas.com');



-- Tabela de Isqueiros (Cat�logo de Produtos)
CREATE TABLE Isqueiros (
    IsqueiroID INT IDENTITY(1,1) PRIMARY KEY,
    MarcaID INT NOT NULL,
    CategoriaID INT NOT NULL,
    Modelo VARCHAR(100) NOT NULL,
    Cor VARCHAR(30),
    Material VARCHAR(50),
    TipoCombustivel VARCHAR(20) CHECK (TipoCombustivel IN ('Butano', 'Gasolina', 'Outro')),
    CapacidadeML DECIMAL(5,2),
    Peso DECIMAL(5,2),
    Dimensoes VARCHAR(50),
    PrecoSugerido DECIMAL(8,2),
    VidaUtilEstimadaDias INT,
    Descricao TEXT,
    CodigoBarras VARCHAR(50) UNIQUE,
    DataLancamento DATE,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    Ativo BIT DEFAULT 1,
    FOREIGN KEY (MarcaID) REFERENCES Marcas(MarcaID),
    FOREIGN KEY (CategoriaID) REFERENCES CategoriasIsqueiros(CategoriaID)
);

-- Os inserts ser�o adicionados depois
-- Cat�logo de Isqueiros
INSERT INTO Isqueiros (MarcaID, CategoriaID, Modelo, Cor, Material, TipoCombustivel, CapacidadeML, PrecoSugerido, VidaUtilEstimadaDias, CodigoBarras) VALUES
((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'BIC'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Descart�vel'),
 'BIC Classic', 'Branco', 'Pl�stico', 'Butano', 4.2, 2.50, 30, '7891234567890'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'BIC'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Descart�vel'),
 'BIC Mini', 'Colorido', 'Pl�stico', 'Butano', 2.1, 1.80, 20, '7891234567891'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'Clipper'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Recarreg�vel'),
 'Clipper Classic', 'Preto', 'Metal', 'Butano', 8.0, 12.90, 365, '7891234567892'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'Zippo'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Premium'),
 'Zippo Chrome', 'Cromado', 'Metal', 'Gasolina', 6.0, 89.90, 1825, '7891234567893'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'Cricket'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Descart�vel'),
 'Cricket Original', 'Transparente', 'Pl�stico', 'Butano', 3.8, 2.20, 25, '7891234567894');





SELECT * FROM Isqueiros

-- Tabela de Tipos de Estabelecimento
CREATE TABLE TiposEstabelecimento (
    TipoEstabelecimentoID INT IDENTITY(1,1) PRIMARY KEY,
    NomeTipo VARCHAR(50) NOT NULL UNIQUE,
    Descricao VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

-- Tipos de Estabelecimento
INSERT INTO TiposEstabelecimento (NomeTipo, Descricao) VALUES
('Conveni�ncia', 'Lojas de conveni�ncia e postos'),
('Supermercado', 'Redes de supermercado'),
('Tabacaria', 'Lojas especializadas em produtos de tabaco'),
('Bar/Boteco', 'Estabelecimentos que servem bebidas'),
('Farm�cia', 'Drogarias e farm�cias'),
('Bazar', 'Lojas de variedades'),
('Online', 'Vendas pela internet'),
('Atacado', 'Vendas em grande quantidade');


-- Tabela de Estabelecimentos
CREATE TABLE Estabelecimentos (
    EstabelecimentoID INT IDENTITY(1,1) PRIMARY KEY,
    TipoEstabelecimentoID INT NOT NULL,
    CidadeID INT NOT NULL,
    NomeEstabelecimento VARCHAR(100) NOT NULL,
    Endereco VARCHAR(200),
    CEP VARCHAR(10),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    Telefone VARCHAR(20),
    HorarioFuncionamento VARCHAR(100),
    DataAbertura DATE,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    Ativo BIT DEFAULT 1,
    FOREIGN KEY (TipoEstabelecimentoID) REFERENCES TiposEstabelecimento(TipoEstabelecimentoID),
    FOREIGN KEY (CidadeID) REFERENCES Cidades(CidadeID)
);

-- Alguns estabelecimentos em Barra do Gar�as
INSERT INTO Estabelecimentos (TipoEstabelecimentoID, CidadeID, NomeEstabelecimento, Endereco, CEP) VALUES
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Conveni�ncia'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Gar�as'),
 'Posto Shell Centro', 'Av. Ministro Jo�o Alberto, 1234', '78600-000'),
 
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Supermercado'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Gar�as'),
 'Supermercado Comper', 'Rua 13 de Junho, 567', '78600-001'),
 
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Tabacaria'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Gar�as'),
 'Tabacaria do Centro', 'Av. Rio Branco, 890', '78600-002'),
 
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Bar/Boteco'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Gar�as'),
 'Bar do Pescador', 'Rua das Gar�as, 123', '78600-003');



-- Tabela de Compras (Transa��es)
CREATE TABLE Compras (
    CompraID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    EstabelecimentoID INT NOT NULL,
    DataCompra DATETIME2 NOT NULL,
    ValorTotal DECIMAL(10,2) NOT NULL,
    MetodoPagamento VARCHAR(20) CHECK (MetodoPagamento IN ('Dinheiro', 'Cart�o D�bito', 'Cart�o Cr�dito', 'PIX', 'Outro')),
    NumeroNF VARCHAR(50),
    Observacoes TEXT,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (EstabelecimentoID) REFERENCES Estabelecimentos(EstabelecimentoID)
);

-- Tabela de Itens da Compra
CREATE TABLE ItensCompra (
    ItemCompraID INT IDENTITY(1,1) PRIMARY KEY,
    CompraID INT NOT NULL,
    IsqueiroID INT NOT NULL,
    Quantidade INT NOT NULL DEFAULT 1,
    PrecoUnitario DECIMAL(8,2) NOT NULL,
    Desconto DECIMAL(5,2) DEFAULT 0,
    SubTotal AS (Quantidade * PrecoUnitario * (1 - Desconto/100)),
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (CompraID) REFERENCES Compras(CompraID),
    FOREIGN KEY (IsqueiroID) REFERENCES Isqueiros(IsqueiroID)
);

-- Tabela de Isqueiros do Usu�rio (Inst�ncias f�sicas)
CREATE TABLE IsqueirosUsuario (
    IsqueiroUsuarioID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    ItemCompraID INT NOT NULL,
    NumeroSerie VARCHAR(50),
    Apelido VARCHAR(50),
    DataCompra DATETIME2 NOT NULL,
    DataPrimeiroUso DATETIME2,
    StatusAtual VARCHAR(20) CHECK (StatusAtual IN ('Novo', 'Em Uso', 'Perdido', 'Quebrado', 'Vazio', 'Descartado')) DEFAULT 'Novo',
    LocalAtual VARCHAR(200),
    DataUltimaLocalizacao DATETIME2,
    CombustivelAtual DECIMAL(5,2) DEFAULT 0,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    DataAtualizacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (ItemCompraID) REFERENCES ItensCompra(ItemCompraID)
);





-- Tabela de Locais (Contextos de uso)
CREATE TABLE Locais (
    LocalID INT IDENTITY(1,1) PRIMARY KEY,
    NomeLocal VARCHAR(100) NOT NULL,
    TipoLocal VARCHAR(50), -- Casa, Trabalho, Bar, Restaurante, etc.
    Endereco VARCHAR(200),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    Descricao TEXT,
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

-- Locais comuns
INSERT INTO Locais (NomeLocal, TipoLocal, Descricao) VALUES
('Casa', 'Residencial', 'Resid�ncia do usu�rio'),
('Trabalho', 'Profissional', 'Local de trabalho'),
('Bar/Restaurante', 'Comercial', 'Estabelecimentos de alimenta��o'),
('Carro', 'Transporte', 'Ve�culo particular'),
('Rua', 'P�blico', 'Via p�blica ou cal�ada'),
('Amigos', 'Social', 'Casa de amigos ou familiares'),
('Festa/Evento', 'Social', 'Eventos sociais'),
('Desconhecido', 'Indefinido', 'Local n�o identificado');


-- ESTAS TABELAS ABAIXO S�O TABELAS ADICIONAIS QUE ESTAREI ADICIONANDO DADOS PARA AN�LISES DE CONTEXTO FUTURO

-- Tabela de Utiliza��o (Eventos de uso)
CREATE TABLE Utilizacao (
    UtilizacaoID INT IDENTITY(1,1) PRIMARY KEY,
    IsqueiroUsuarioID INT NOT NULL,
    LocalID INT,
    DataHoraUso DATETIME2 NOT NULL,
    TipoUso VARCHAR(50), -- Cigarro, Vela, Churrasqueira, etc.
    DuracaoUsoSegundos INT,
    ConsumoEstimadoML DECIMAL(5,3),
    Temperatura DECIMAL(5,2),
    UmidadeAr DECIMAL(5,2),
    Observacoes TEXT,
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (IsqueiroUsuarioID) REFERENCES IsqueirosUsuario(IsqueiroUsuarioID),
    FOREIGN KEY (LocalID) REFERENCES Locais(LocalID)
);

-- Tabela de Hist�rico de Localiza��o
CREATE TABLE HistoricoLocalizacao (
    HistoricoID INT IDENTITY(1,1) PRIMARY KEY,
    IsqueiroUsuarioID INT NOT NULL,
    LocalID INT,
    DataHoraRegistro DATETIME2 NOT NULL,
    TipoEvento VARCHAR(30) CHECK (TipoEvento IN ('Guardado', 'Encontrado', 'Perdido', 'Movido')),
    Latitude DECIMAL(10,8),
    Longitude DECIMAL(11,8),
    Descricao VARCHAR(500),
    ConfiabilidadeLocalizacao DECIMAL(3,2) DEFAULT 1.0, -- 0 a 1
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (IsqueiroUsuarioID) REFERENCES IsqueirosUsuario(IsqueiroUsuarioID),
    FOREIGN KEY (LocalID) REFERENCES Locais(LocalID)
);

-- Tabela de Manuten��o (Recarga, reparo, etc.)
CREATE TABLE Manutencao (
    ManutencaoID INT IDENTITY(1,1) PRIMARY KEY,
    IsqueiroUsuarioID INT NOT NULL,
    TipoManutencao VARCHAR(50) CHECK (TipoManutencao IN ('Recarga', 'Troca Pedra', 'Reparo', 'Limpeza')),
    DataManutencao DATETIME2 NOT NULL,
    Custo DECIMAL(8,2),
    EstabelecimentoID INT,
    Observacoes TEXT,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (IsqueiroUsuarioID) REFERENCES IsqueirosUsuario(IsqueiroUsuarioID),
    FOREIGN KEY (EstabelecimentoID) REFERENCES Estabelecimentos(EstabelecimentoID)
);

