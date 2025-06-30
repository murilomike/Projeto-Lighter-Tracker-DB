# Projeto-Lighter-Tracker-DB

 Documentação Técnica: Modelagem de Banco de Dados LighterTrackDB
================================================================

1\. Introdução
--------------

Este documento técnico detalha o procedimento completo para a criação e configuração do banco de dados `LighterTrackDB`, um sistema projetado para a análise do consumo de isqueiros. O objetivo principal é fornecer uma estrutura robusta e escalável para coletar, armazenar e gerenciar dados relacionados a usuários, isqueiros (produtos e instâncias físicas), transações de compra e padrões de utilização.

A modelagem foi concebida para suportar análises de comportamento do consumidor, rastreamento de produtos, eficiência de uso e insights sobre o ciclo de vida dos isqueiros. Utilizando Data Definition Language (DDL) para SQL Server, este projeto visa garantir integridade referencial, consistência de dados e otimização para futuras operações de consulta e relatórios.

2\. Visão Geral do Projeto LighterTrackDB
-----------------------------------------

O `LighterTrackDB` é a espinha dorsal de um sistema que permite monitorar e analisar o consumo de isqueiros. Imagine um aplicativo onde usuários registram suas compras de isqueiros, o uso diário e até mesmo a manutenção. Este banco de dados é a base para armazenar todas essas informações, permitindo identificar tendências, entender o ciclo de vida dos produtos e gerar relatórios valiosos.

**Objetivos da Modelagem:**

-   **Rastreabilidade:** Permite rastrear isqueiros desde a compra até o descarte.

-   **Análise Comportamental:** Fornece dados para entender padrões de uso do consumidor.

-   **Integridade dos Dados:** Garante que os dados sejam precisos e consistentes através de chaves e restrições.

-   **Escalabilidade:** Estrutura flexível para acomodar o crescimento futuro dos dados.

**Tecnologia:** SQL Server (DDL - Data Definition Language).

3\. Procedimento de Criação do Banco de Dados e Configurações Iniciais
----------------------------------------------------------------------

A primeira etapa envolve a criação do banco de dados principal e a definição de suas propriedades fundamentais.

### 3.1. Criação do Database Principal

```
CREATE DATABASE LighterTrackDB
ON (
    NAME = 'LighterTrackDB_Data',
    FILENAME = 'C:\Data\LighterTrackDB.mdf',
    SIZE = 100MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 10MB
)
LOG ON (
    NAME = 'LighterTrackDB_Log',
    FILENAME = 'C:\Data\LighterTrackDB.ldf',
    SIZE = 10MB,
    MAXSIZE = 100MB,
    FILEGROWTH = 10%
);

```

-   **`CREATE DATABASE LighterTrackDB`**: Comando para iniciar a criação do banco de dados com o nome `LighterTrackDB`.

-   **`ON (...)`**: Define as propriedades do arquivo de dados (data file).

    -   **`NAME = 'LighterTrackDB_Data'`**: Nome lógico do arquivo de dados.

    -   **`FILENAME = 'C:\Data\LighterTrackDB.mdf'`**: Caminho físico e nome do arquivo de dados. É crucial que o diretório `C:\Data\` exista e o SQL Server tenha permissões de escrita.

    -   **`SIZE = 100MB`**: Tamanho inicial do arquivo de dados.

    -   **`MAXSIZE = 1GB`**: Tamanho máximo que o arquivo de dados pode atingir. Define um limite para evitar consumo excessivo de espaço em disco.

    -   **`FILEGROWTH = 10MB`**: Define o incremento de crescimento do arquivo de dados quando ele atinge seu limite atual. Um incremento em MB é preferível a uma porcentagem para um crescimento mais previsível.

-   **`LOG ON (...)`**: Define as propriedades do arquivo de log de transações (log file).

    -   **`NAME = 'LighterTrackDB_Log'`**: Nome lógico do arquivo de log.

    -   **`FILENAME = 'C:\Data\LighterTrackDB.ldf'`**: Caminho físico e nome do arquivo de log.

    -   **`SIZE = 10MB`**: Tamanho inicial do arquivo de log.

    -   **`MAXSIZE = 100MB`**: Tamanho máximo que o arquivo de log pode atingir.

    -   **`FILEGROWTH = 10%`**: Incremento de crescimento do arquivo de log em porcentagem. Para logs de transação, um incremento em MB fixo também pode ser considerado, dependendo do perfil de transações.

### 3.2. Usar o Database

```
USE LighterTrackDB;

```

-   **`USE LighterTrackDB`**: Este comando define `LighterTrackDB` como o banco de dados ativo para todas as operações subsequentes, garantindo que as tabelas e outros objetos sejam criados no contexto correto.

### 3.3. Configurar Recovery Model para FULL

```
ALTER DATABASE LighterTrackDB SET RECOVERY FULL;

```

-   **`ALTER DATABASE ... SET RECOVERY FULL`**: Define o modelo de recuperação do banco de dados como `FULL`.

    -   **FULL Recovery Model**: Este modelo registra todas as transações no log de transações. Ele permite a recuperação pontual (point-in-time recovery) do banco de dados, o que significa que o banco de dados pode ser restaurado para qualquer ponto no tempo desde o último backup completo, diferencial ou de log. É ideal para ambientes de produção que exigem alta disponibilidade e mínima perda de dados.

    -   **Outros Modelos**: `SIMPLE` (permite apenas restauração para o último backup completo ou diferencial, sem backups de log) e `BULK_LOGGED` (híbrido, otimizado para operações em massa). A escolha do `FULL` reflete a necessidade de alta resiliência e capacidade de recuperação detalhada para um sistema de rastreamento de dados.

4\. Modelagem e Criação das Tabelas Principais
----------------------------------------------

A modelagem de dados foi cuidadosamente projetada para representar as entidades e relacionamentos do sistema LighterTrack. Cada tabela é criada com colunas, tipos de dados e restrições apropriadas para garantir a integridade e a validade dos dados.

### 4.1. Tabela `Estados` (Lookup)

Esta tabela armazena informações sobre os estados, servindo como uma tabela de lookup para padronizar e validar dados geográficos.

```
CREATE TABLE Estados (
    EstadoID INT IDENTITY(1,1) PRIMARY KEY,
    SiglaEstado CHAR(2) NOT NULL UNIQUE,
    NomeEstado VARCHAR(50) NOT NULL,
    Regiao VARCHAR(20) NOT NULL,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    DataAtualizacao DATETIME2 DEFAULT GETDATE()
);

```

-   **`EstadoID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável, garantindo um identificador único para cada estado.

-   **`SiglaEstado CHAR(2) NOT NULL UNIQUE`**: Armazena a sigla do estado (ex: 'SP', 'RJ'). `CHAR(2)` garante tamanho fixo e `UNIQUE` impede duplicidade. `NOT NULL` exige um valor.

-   **`NomeEstado VARCHAR(50) NOT NULL`**: Nome completo do estado.

-   **`Regiao VARCHAR(20) NOT NULL`**: Região geográfica (ex: 'Sudeste').

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação, com valor padrão sendo a data e hora atuais.

-   **`DataAtualizacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora da última atualização.

### 4.2. Tabela `Cidades`

Armazena informações sobre cidades, com um relacionamento com a tabela `Estados`.

```
CREATE TABLE Cidades (
    CidadeID INT IDENTITY(1,1) PRIMARY KEY,
    EstadoID INT NOT NULL,
    NomeCidade VARCHAR(100) NOT NULL,
    Populacao INT,
    DataCriacao DATETIME2 DEFAULT GETDATE(),
    FOREIGN KEY (EstadoID) REFERENCES Estados(EstadoID)
);

```

-   **`CidadeID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`EstadoID INT NOT NULL`**: Chave estrangeira referenciando `Estados.EstadoID`, garantindo que toda cidade esteja associada a um estado válido. `NOT NULL` assegura que a relação seja obrigatória.

-   **`NomeCidade VARCHAR(100) NOT NULL`**: Nome da cidade.

-   **`Populacao INT`**: População estimada da cidade (opcional, pode ser NULL).

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação.

-   **`FOREIGN KEY (EstadoID) REFERENCES Estados(EstadoID)`**: Define o relacionamento um-para-muitos entre `Estados` e `Cidades`.

### 4.3. Tabela `Usuarios`

Contém informações detalhadas sobre os usuários do sistema.

```
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

```

-   **`UsuarioID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`Nome VARCHAR(100) NOT NULL`**: Nome completo do usuário.

-   **`Email VARCHAR(150) UNIQUE NOT NULL`**: Endereço de e-mail do usuário. `UNIQUE` garante que cada e-mail seja único no sistema.

-   **`Telefone VARCHAR(20)`**: Número de telefone (opcional).

-   **`DataNascimento DATE`**: Data de nascimento.

-   **`Genero CHAR(1) CHECK (Genero IN ('M', 'F', 'O'))`**: Gênero do usuário. `CHECK` restringe os valores permitidos a 'M' (Masculino), 'F' (Feminino) ou 'O' (Outro).

-   **`CidadeID INT`**: Chave estrangeira para `Cidades`, relacionando o usuário à sua cidade. É opcional, permitindo usuários sem cidade registrada.

-   **`CEP VARCHAR(10)`**: Código de Endereçamento Postal.

-   **`Profissao VARCHAR(100)`**: Profissão do usuário.

-   **`RendaFamiliar DECIMAL(10,2)`**: Renda familiar, com 10 dígitos totais e 2 casas decimais.

-   **`Fumante BIT DEFAULT 0`**: Indicador booleano (0 para Não, 1 para Sim) se o usuário é fumante. Padrão é 0.

-   **`DataCadastro DATETIME2 DEFAULT GETDATE()`**: Data e hora do cadastro do usuário.

-   **`DataUltimaAtualizacao DATETIME2 DEFAULT GETDATE()`**: Data e hora da última atualização do registro do usuário.

-   **`Ativo BIT DEFAULT 1`**: Indicador booleano para status de ativação do usuário. Padrão é 1 (Ativo).

-   **`FOREIGN KEY (CidadeID) REFERENCES Cidades(CidadeID)`**: Relacionamento opcional com a tabela `Cidades`.

### 4.4. Tabela `CategoriasIsqueiros`

Armazena as categorias de isqueiros disponíveis.

```
CREATE TABLE CategoriasIsqueiros (
    CategoriaID INT IDENTITY(1,1) PRIMARY KEY,
    NomeCategoria VARCHAR(50) NOT NULL UNIQUE,
    Descricao VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

```

-   **`CategoriaID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`NomeCategoria VARCHAR(50) NOT NULL UNIQUE`**: Nome da categoria (ex: 'Recarregável', 'Descartável'). `UNIQUE` garante nomes de categoria únicos.

-   **`Descricao VARCHAR(200)`**: Descrição opcional da categoria.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação.

### 4.5. Tabela `Marcas`

Armazena informações sobre as marcas de isqueiros.

```
CREATE TABLE Marcas (
    MarcaID INT IDENTITY(1,1) PRIMARY KEY,
    NomeMarca VARCHAR(50) NOT NULL UNIQUE,
    PaisOrigem VARCHAR(50),
    DataFundacao DATE,
    Website VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

```

-   **`MarcaID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`NomeMarca VARCHAR(50) NOT NULL UNIQUE`**: Nome da marca (ex: 'Bic', 'Zippo'). `UNIQUE` garante nomes de marca únicos.

-   **`PaisOrigem VARCHAR(50)`**: País de origem da marca.

-   **`DataFundacao DATE`**: Data de fundação da marca.

-   **`Website VARCHAR(200)`**: URL do website da marca.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação.

### 4.6. Tabela `Isqueiros` (Catálogo de Produtos)

Representa o catálogo de modelos de isqueiros, não as instâncias físicas.

```
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

```

-   **`IsqueiroID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`MarcaID INT NOT NULL`**: Chave estrangeira para `Marcas`.

-   **`CategoriaID INT NOT NULL`**: Chave estrangeira para `CategoriasIsqueiros`.

-   **`Modelo VARCHAR(100) NOT NULL`**: Nome do modelo do isqueiro (ex: 'Standard Maxi', 'Classic Chrome').

-   **`Cor VARCHAR(30)`**: Cor do isqueiro.

-   **`Material VARCHAR(50)`**: Material de fabricação.

-   **`TipoCombustivel VARCHAR(20) CHECK (TipoCombustivel IN ('Butano', 'Gasolina', 'Outro'))`**: Tipo de combustível. `CHECK` restringe os valores.

-   **`CapacidadeML DECIMAL(5,2)`**: Capacidade de combustível em mililitros.

-   **`Peso DECIMAL(5,2)`**: Peso em gramas ou outra unidade de medida.

-   **`Dimensoes VARCHAR(50)`**: Dimensões do isqueiro (ex: '2x3x1 cm').

-   **`PrecoSugerido DECIMAL(8,2)`**: Preço de varejo sugerido.

-   **`VidaUtilEstimadaDias INT`**: Vida útil estimada em dias.

-   **`Descricao TEXT`**: Campo para uma descrição detalhada do isqueiro. `TEXT` é adequado para strings longas.

-   **`CodigoBarras VARCHAR(50) UNIQUE`**: Código de barras único para o produto.

-   **`DataLancamento DATE`**: Data de lançamento do modelo.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`Ativo BIT DEFAULT 1`**: Indicador de ativação do modelo no catálogo.

-   **`FOREIGN KEY (MarcaID) REFERENCES Marcas(MarcaID)`**: Relacionamento com `Marcas`.

-   **`FOREIGN KEY (CategoriaID) REFERENCES CategoriasIsqueiros(CategoriaID)`**: Relacionamento com `CategoriasIsqueiros`.

### 4.7. Tabela `TiposEstabelecimento`

Lookup table para tipos de estabelecimentos comerciais.

```
CREATE TABLE TiposEstabelecimento (
    TipoEstabelecimentoID INT IDENTITY(1,1) PRIMARY KEY,
    NomeTipo VARCHAR(50) NOT NULL UNIQUE,
    Descricao VARCHAR(200),
    DataCriacao DATETIME2 DEFAULT GETDATE()
);

```

-   **`TipoEstabelecimentoID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`NomeTipo VARCHAR(50) NOT NULL UNIQUE`**: Nome do tipo (ex: 'Supermercado', 'Tabacaria', 'Loja de Conveniência').

-   **`Descricao VARCHAR(200)`**: Descrição opcional.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação.

### 4.8. Tabela `Estabelecimentos`

Armazena informações sobre os locais de compra (estabelecimentos).

```
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

```

-   **`EstabelecimentoID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`TipoEstabelecimentoID INT NOT NULL`**: Chave estrangeira para `TiposEstabelecimento`.

-   **`CidadeID INT NOT NULL`**: Chave estrangeira para `Cidades`.

-   **`NomeEstabelecimento VARCHAR(100) NOT NULL`**: Nome do estabelecimento (ex: 'Mercado Bom Preço').

-   **`Endereco VARCHAR(200)`**: Endereço completo.

-   **`CEP VARCHAR(10)`**: CEP do estabelecimento.

-   **`Latitude DECIMAL(10,8)`**: Coordenada de latitude. `DECIMAL(10,8)` oferece precisão adequada para geolocalização.

-   **`Longitude DECIMAL(11,8)`**: Coordenada de longitude. `DECIMAL(11,8)` oferece precisão adequada.

-   **`Telefone VARCHAR(20)`**: Telefone do estabelecimento.

-   **`HorarioFuncionamento VARCHAR(100)`**: Descrição do horário de funcionamento.

-   **`DataAbertura DATE`**: Data de abertura do estabelecimento.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`Ativo BIT DEFAULT 1`**: Indicador de ativação do estabelecimento.

-   **`FOREIGN KEY (TipoEstabelecimentoID) REFERENCES TiposEstabelecimento(TipoEstabelecimentoID)`**: Relacionamento com `TiposEstabelecimento`.

-   **`FOREIGN KEY (CidadeID) REFERENCES Cidades(CidadeID)`**: Relacionamento com `Cidades`.

### 4.9. Tabela `Compras` (Transações)

Registra as transações de compra de isqueiros pelos usuários.

```
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

```

-   **`CompraID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`UsuarioID INT NOT NULL`**: Chave estrangeira para `Usuarios`.

-   **`EstabelecimentoID INT NOT NULL`**: Chave estrangeira para `Estabelecimentos`.

-   **`DataCompra DATETIME2 NOT NULL`**: Data e hora da compra.

-   **`ValorTotal DECIMAL(10,2) NOT NULL`**: Valor total da compra.

-   **`MetodoPagamento VARCHAR(20) CHECK (MetodoPagamento IN ('Dinheiro', 'Cartão Débito', 'Cartão Crédito', 'PIX', 'Outro'))`**: Método de pagamento utilizado.

-   **`NumeroNF VARCHAR(50)`**: Número da Nota Fiscal (opcional).

-   **`Observacoes TEXT`**: Campo para observações adicionais sobre a compra.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)`**: Relacionamento com `Usuarios`.

-   **`FOREIGN KEY (EstabelecimentoID) REFERENCES Estabelecimentos(EstabelecimentoID)`**: Relacionamento com `Estabelecimentos`.

### 4.10. Tabela `ItensCompra`

Detalha os itens individuais contidos em cada compra.

```
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

```

-   **`ItemCompraID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`CompraID INT NOT NULL`**: Chave estrangeira para `Compras`. Parte do relacionamento para identificar a qual compra o item pertence.

-   **`IsqueiroID INT NOT NULL`**: Chave estrangeira para `Isqueiros`, identificando o modelo do isqueiro comprado.

-   **`Quantidade INT NOT NULL DEFAULT 1`**: Quantidade de isqueiros do mesmo modelo comprados neste item. Padrão é 1.

-   **`PrecoUnitario DECIMAL(8,2) NOT NULL`**: Preço unitário do isqueiro no momento da compra.

-   **`Desconto DECIMAL(5,2) DEFAULT 0`**: Desconto aplicado ao item, em porcentagem (ex: 5.00 para 5%). Padrão é 0.

-   **`SubTotal AS (Quantidade * PrecoUnitario * (1 - Desconto/100))`**: **Coluna Calculada**. O `SubTotal` é automaticamente calculado com base na quantidade, preço unitário e desconto. Não armazena o valor fisicamente, mas o calcula em tempo de execução. `(1 - Desconto/100)` permite aplicar o desconto corretamente.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`FOREIGN KEY (CompraID) REFERENCES Compras(CompraID)`**: Relacionamento com `Compras`.

-   **`FOREIGN KEY (IsqueiroID) REFERENCES Isqueiros(IsqueiroID)`**: Relacionamento com `Isqueiros`.

### 4.11. Tabela `IsqueirosUsuario` (Instâncias Físicas)

Esta tabela representa as instâncias físicas de isqueiros que um usuário possui, ligadas a um item de compra específico.

```
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

```

-   **`IsqueiroUsuarioID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável para cada isqueiro individual do usuário.

-   **`UsuarioID INT NOT NULL`**: Chave estrangeira para `Usuarios`, indicando o proprietário do isqueiro.

-   **`ItemCompraID INT NOT NULL`**: Chave estrangeira para `ItensCompra`, vinculando a instância física à sua transação de compra original.

-   **`NumeroSerie VARCHAR(50)`**: Número de série do isqueiro (se aplicável).

-   **`Apelido VARCHAR(50)`**: Apelido dado pelo usuário ao isqueiro (ex: 'Meu Zippo Velho').

-   **`DataCompra DATETIME2 NOT NULL`**: Data da compra do isqueiro (redundante com `ItensCompra.DataCriacao`, mas útil para acesso direto).

-   **`DataPrimeiroUso DATETIME2`**: Data do primeiro uso registrado do isqueiro.

-   **`StatusAtual VARCHAR(20) CHECK (StatusAtual IN ('Novo', 'Em Uso', 'Perdido', 'Quebrado', 'Vazio', 'Descartado')) DEFAULT 'Novo'`**: Status atual do isqueiro. `CHECK` restringe os valores permitidos, `DEFAULT 'Novo'` define o status inicial.

-   **`LocalAtual VARCHAR(200)`**: Descrição textual do local atual do isqueiro.

-   **`DataUltimaLocalizacao DATETIME2`**: Carimbo de data/hora da última atualização de localização.

-   **`CombustivelAtual DECIMAL(5,2) DEFAULT 0`**: Nível atual de combustível do isqueiro. Padrão é 0.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`DataAtualizacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora da última atualização do registro.

-   **`FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID)`**: Relacionamento com `Usuarios`.

-   **`FOREIGN KEY (ItemCompraID) REFERENCES ItensCompra(ItemCompraID)`**: Relacionamento com `ItensCompra`.

### 4.12. Tabela `Locais` (Contextos de Uso)

Registra locais genéricos onde os isqueiros podem ser utilizados.

```
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

```

-   **`LocalID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`NomeLocal VARCHAR(100) NOT NULL`**: Nome do local (ex: 'Minha Casa', 'Cafeteria do Trabalho').

-   **`TipoLocal VARCHAR(50)`**: Tipo de local (ex: 'Casa', 'Trabalho', 'Bar', 'Restaurante').

-   **`Endereco VARCHAR(200)`**: Endereço do local.

-   **`Latitude DECIMAL(10,8)`**: Coordenada de latitude.

-   **`Longitude DECIMAL(11,8)`**: Coordenada de longitude.

-   **`Descricao TEXT`**: Descrição detalhada do local.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação.

### 4.13. Tabela `Utilizacao` (Eventos de Uso)

Registra cada evento de uso de um isqueiro específico por um usuário.

```
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

```

-   **`UtilizacaoID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`IsqueiroUsuarioID INT NOT NULL`**: Chave estrangeira para `IsqueirosUsuario`, indicando qual isqueiro foi usado.

-   **`LocalID INT`**: Chave estrangeira opcional para `Locais`, indicando onde o uso ocorreu.

-   **`DataHoraUso DATETIME2 NOT NULL`**: Data e hora exata do uso.

-   **`TipoUso VARCHAR(50)`**: Finalidade do uso (ex: 'Cigarro', 'Vela', 'Churrasqueira').

-   **`DuracaoUsoSegundos INT`**: Duração estimada do uso em segundos.

-   **`ConsumoEstimadoML DECIMAL(5,3)`**: Consumo estimado de combustível em mililitros para este uso. `DECIMAL(5,3)` permite alta precisão.

-   **`Temperatura DECIMAL(5,2)`**: Temperatura ambiente no momento do uso.

-   **`UmidadeAr DECIMAL(5,2)`**: Umidade do ar no momento do uso.

-   **`Observacoes TEXT`**: Observações adicionais sobre o evento de uso.

-   **`Latitude DECIMAL(10,8)`**: Coordenada de latitude do evento de uso.

-   **`Longitude DECIMAL(11,8)`**: Coordenada de longitude do evento de uso.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`FOREIGN KEY (IsqueiroUsuarioID) REFERENCES IsqueirosUsuario(IsqueiroUsuarioID)`**: Relacionamento com `IsqueirosUsuario`.

-   **`FOREIGN KEY (LocalID) REFERENCES Locais(LocalID)`**: Relacionamento opcional com `Locais`.

### 4.14. Tabela `HistoricoLocalizacao`

Registra o histórico de localização de cada isqueiro do usuário.

```
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

```

-   **`HistoricoID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`IsqueiroUsuarioID INT NOT NULL`**: Chave estrangeira para `IsqueirosUsuario`.

-   **`LocalID INT`**: Chave estrangeira opcional para `Locais` onde o evento de localização ocorreu.

-   **`DataHoraRegistro DATETIME2 NOT NULL`**: Carimbo de data/hora do registro de localização.

-   **`TipoEvento VARCHAR(30) CHECK (TipoEvento IN ('Guardado', 'Encontrado', 'Perdido', 'Movido'))`**: Tipo de evento de localização.

-   **`Latitude DECIMAL(10,8)`**: Coordenada de latitude do registro.

-   **`Longitude DECIMAL(11,8)`**: Coordenada de longitude do registro.

-   **`Descricao VARCHAR(500)`**: Descrição do evento de localização.

-   **`ConfiabilidadeLocalizacao DECIMAL(3,2) DEFAULT 1.0`**: Nível de confiança na precisão da localização (0.0 a 1.0). Padrão é 1.0 (alta confiança).

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`FOREIGN KEY (IsqueiroUsuarioID) REFERENCES IsqueirosUsuario(IsqueiroUsuarioID)`**: Relacionamento com `IsqueirosUsuario`.

-   **`FOREIGN KEY (LocalID) REFERENCES Locais(LocalID)`**: Relacionamento opcional com `Locais`.

### 4.15. Tabela `Manutencao` (Recarga, Reparo, etc.)

Registra eventos de manutenção para as instâncias de isqueiros dos usuários.

```
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

```

-   **`ManutencaoID INT IDENTITY(1,1) PRIMARY KEY`**: Chave primária auto-incrementável.

-   **`IsqueiroUsuarioID INT NOT NULL`**: Chave estrangeira para `IsqueirosUsuario`.

-   **`TipoManutencao VARCHAR(50) CHECK (TipoManutencao IN ('Recarga', 'Troca Pedra', 'Reparo', 'Limpeza'))`**: Tipo de manutenção realizada.

-   **`DataManutencao DATETIME2 NOT NULL`**: Data e hora da manutenção.

-   **`Custo DECIMAL(8,2)`**: Custo da manutenção.

-   **`EstabelecimentoID INT`**: Chave estrangeira opcional para `Estabelecimentos` onde a manutenção foi realizada.

-   **`Observacoes TEXT`**: Observações adicionais sobre a manutenção.

-   **`DataCriacao DATETIME2 DEFAULT GETDATE()`**: Carimbo de data/hora de criação do registro.

-   **`FOREIGN KEY (IsqueiroUsuarioID) REFERENCES IsqueirosUsuario(IsqueiroUsuarioID)`**: Relacionamento com `IsqueirosUsuario`.

-   **`FOREIGN KEY (EstabelecimentoID) REFERENCES Estabelecimentos(EstabelecimentoID)`**: Relacionamento opcional com `Estabelecimentos`.

5\. Conclusão
-------------

A modelagem do `LighterTrackDB` foi executada com foco na criação de um esquema de banco de dados robusto, escalável e com alta integridade de dados. A utilização de chaves primárias e estrangeiras, restrições `NOT NULL`, `UNIQUE`, `CHECK` e valores `DEFAULT` garante a consistência e a validação dos dados no nível do banco de dados, reduzindo a necessidade de validações complexas na camada da aplicação.

Este design permite o rastreamento abrangente do ciclo de vida de isqueiros, desde a compra até o descarte, incluindo o monitoramento de padrões de uso e eventos de manutenção. A estrutura de dados está pronta para suportar diversas análises, como consumo por usuário, durabilidade de marcas/modelos, impacto de variáveis ambientais (temperatura/umidade) no uso, e otimização de estoque/reabastecimento. O modelo é uma base sólida para o desenvolvimento de dashboards analíticos e sistemas de suporte à decisão.
