-- =========================================================
-- LIGHTERTRACK DATABASE - MODELAGEM COMPLETA
-- Sistema de Análise de Consumo de Isqueiros
-- =========================================================

-- =========================================================
-- 1. CRIAÇÃO DO DATABASE E CONFIGURAÇÕES INICIAIS
-- =========================================================

-- Usar o database
USE LighterTrackDB;

-- Configurar recovery model para FULL
ALTER DATABASE LighterTrackDB SET RECOVERY FULL;


-- =========================================================
-- 2. CRIAÇÃO DAS TABELAS PRINCIPAIS
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
('AP', 'Amapá', 'Norte'),
('AM', 'Amazonas', 'Norte'),
('BA', 'Bahia', 'Nordeste'),
('CE', 'Ceará', 'Nordeste'),
('DF', 'Distrito Federal', 'Centro-Oeste'),
('ES', 'Espírito Santo', 'Sudeste'),
('GO', 'Goiás', 'Centro-Oeste'),
('MA', 'Maranhão', 'Nordeste'),
('MT', 'Mato Grosso', 'Centro-Oeste'),
('MS', 'Mato Grosso do Sul', 'Centro-Oeste'),
('MG', 'Minas Gerais', 'Sudeste'),
('PA', 'Pará', 'Norte'),
('PB', 'Paraíba', 'Nordeste'),
('PR', 'Paraná', 'Sul'),
('PE', 'Pernambuco', 'Nordeste'),
('PI', 'Piauí', 'Nordeste'),
('RJ', 'Rio de Janeiro', 'Sudeste'),
('RN', 'Rio Grande do Norte', 'Nordeste'),
('RS', 'Rio Grande do Sul', 'Sul'),
('RO', 'Rondônia', 'Norte'),
('RR', 'Roraima', 'Norte'),
('SC', 'Santa Catarina', 'Sul'),
('SP', 'São Paulo', 'Sudeste'),
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
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Cuiabá', 650000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Várzea Grande', 280000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Rondonópolis', 230000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Sinop', 140000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Tangará da Serra', 110000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Cáceres', 95000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MT'), 'Barra do Garças', 60000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'SP'), 'São Paulo', 12300000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'RJ'), 'Rio de Janeiro', 6700000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'MG'), 'Belo Horizonte', 2500000),
-- Cidades principais de DF e GO
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'DF'), 'Brasília', 3100000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Goiânia', 1530000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Aparecida de Goiânia', 600000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Anápolis', 400000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Rio Verde', 250000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Luziânia', 210000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Águas Lindas de Goiás', 210000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Valparaíso de Goiás', 180000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Senador Canedo', 130000),
((SELECT EstadoID FROM Estados WHERE SiglaEstado = 'GO'), 'Trindade', 130000);

-- Tabela de Usuários
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
-- Os inserts serão feitos depois. 


-- Tabela de Categorias de Isqueiros
CREATE TABLE CategoriasIsqueiros (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NomeCategoria VARCHAR(50) NOT NULL UNIQUE,
    Descricao VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

-- Categorias de Isqueiros
INSERT INTO CategoriasIsqueiros (NomeCategoria, Descricao) VALUES
('Descartável', 'Isqueiros de uso único, não recarregáveis'),
('Recarregável', 'Isqueiros que podem ser reabastecidos'),
('Eletrônico', 'Isqueiros elétricos/USB'),
('Premium', 'Isqueiros de luxo e colecionáveis'),
('Maçarico', 'Isqueiros com chama forte para charutos'),
('Vela', 'Isqueiros com chama longa para velas'),
('Cozinha', 'Isqueiros específicos para uso culinário');

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
('BIC', 'França', 'www.bic.com'),
('Clipper', 'Espanha', 'www.clipper.es'),
('Zippo', 'Estados Unidos', 'www.zippo.com'),
('Cricket', 'França', 'www.cricket-lighter.com'),
('Ronson', 'Reino Unido', 'www.ronson.com'),
('S.T. Dupont', 'França', 'www.st-dupont.com'),
('Colibri', 'Estados Unidos', 'www.colibri.com'),
('Flamagas', 'Espanha', 'www.flamagas.com');



-- Tabela de Isqueiros (Catálogo de Produtos)
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

-- Os inserts serão adicionados depois
-- Catálogo de Isqueiros
INSERT INTO Isqueiros (MarcaID, CategoriaID, Modelo, Cor, Material, TipoCombustivel, CapacidadeML, PrecoSugerido, VidaUtilEstimadaDias, CodigoBarras) VALUES
((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'BIC'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Descartável'),
 'BIC Classic', 'Branco', 'Plástico', 'Butano', 4.2, 2.50, 30, '7891234567890'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'BIC'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Descartável'),
 'BIC Mini', 'Colorido', 'Plástico', 'Butano', 2.1, 1.80, 20, '7891234567891'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'Clipper'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Recarregável'),
 'Clipper Classic', 'Preto', 'Metal', 'Butano', 8.0, 12.90, 365, '7891234567892'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'Zippo'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Premium'),
 'Zippo Chrome', 'Cromado', 'Metal', 'Gasolina', 6.0, 89.90, 1825, '7891234567893'),

((SELECT MarcaID FROM Marcas WHERE NomeMarca = 'Cricket'), 
 (SELECT CategoriaID FROM CategoriasIsqueiros WHERE NomeCategoria = 'Descartável'),
 'Cricket Original', 'Transparente', 'Plástico', 'Butano', 3.8, 2.20, 25, '7891234567894');





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
('Conveniência', 'Lojas de conveniência e postos'),
('Supermercado', 'Redes de supermercado'),
('Tabacaria', 'Lojas especializadas em produtos de tabaco'),
('Bar/Boteco', 'Estabelecimentos que servem bebidas'),
('Farmácia', 'Drogarias e farmácias'),
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

-- Alguns estabelecimentos em Barra do Garças
INSERT INTO Estabelecimentos (TipoEstabelecimentoID, CidadeID, NomeEstabelecimento, Endereco, CEP) VALUES
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Conveniência'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Garças'),
 'Posto Shell Centro', 'Av. Ministro João Alberto, 1234', '78600-000'),
 
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Supermercado'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Garças'),
 'Supermercado Comper', 'Rua 13 de Junho, 567', '78600-001'),
 
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Tabacaria'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Garças'),
 'Tabacaria do Centro', 'Av. Rio Branco, 890', '78600-002'),
 
((SELECT TipoEstabelecimentoID FROM TiposEstabelecimento WHERE NomeTipo = 'Bar/Boteco'),
 (SELECT CidadeID FROM Cidades WHERE NomeCidade = 'Barra do Garças'),
 'Bar do Pescador', 'Rua das Garças, 123', '78600-003');



-- Tabela de Compras (Transações)
CREATE TABLE Compras (
    CompraID INT IDENTITY(1,1) PRIMARY KEY,
    UsuarioID INT NOT NULL,
    EstabelecimentoID INT NOT NULL,
    DataCompra DATETIME2 NOT NULL,
    ValorTotal DECIMAL(10,2) NOT NULL,
    MetodoPagamento VARCHAR(20) CHECK (MetodoPagamento IN ('Dinheiro', 'Cartão Débito', 'Cartão Crédito', 'PIX', 'Outro')),
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

-- Tabela de Isqueiros do Usuário (Instâncias físicas)
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
('Casa', 'Residencial', 'Residência do usuário'),
('Trabalho', 'Profissional', 'Local de trabalho'),
('Bar/Restaurante', 'Comercial', 'Estabelecimentos de alimentação'),
('Carro', 'Transporte', 'Veículo particular'),
('Rua', 'Público', 'Via pública ou calçada'),
('Amigos', 'Social', 'Casa de amigos ou familiares'),
('Festa/Evento', 'Social', 'Eventos sociais'),
('Desconhecido', 'Indefinido', 'Local não identificado');


-- ESTAS TABELAS ABAIXO SÃO TABELAS ADICIONAIS QUE ESTAREI ADICIONANDO DADOS PARA ANÁLISES DE CONTEXTO FUTURO

-- Tabela de Utilização (Eventos de uso)
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

-- Tabela de Histórico de Localização
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

-- Tabela de Manutenção (Recarga, reparo, etc.)
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

