# Política de Backup – Lighter Tracker

Este repositório documenta a estratégia de backup e recuperação adotada no projeto Lighter Tracker, incluindo scripts de backup físico e lógico, definição de RTO/RPO e práticas de validação.

## 🔐 Objetivos

- Garantir a integridade e disponibilidade dos dados
- Minimizar perda de dados (RPO)
- Reduzir o tempo de indisponibilidade (RTO)
- Automatizar e validar os processos de backup

## 📁 Conteúdo

- `scripts/`: Scripts SQL para backup e restauração
- `docs/`: Documentação da política de continuidade
- `assets/`: Imagens e evidências do processo

## 📌 Destaques

- RPO: 15 minutos
- RTO: 1 hora
- Backups físicos: Full, Differential, Log
- Backups lógicos: Scripts e BCP
- Validação periódica em ambiente de homologação

---

### 🧩 Perfil do Sistema – Lighter Tracker

- **Criticidade**: Média a alta
- **Usuários ativos**: Pequena equipe (5–10 usuários), com potencial de expansão
- **Impacto de indisponibilidade**: Alto durante janelas operacionais — pode afetar entregas e controle de SLA

---

### 📊 Política de Continuidade

Com base no perfil do sistema, foi definida a seguinte política de backup e recuperação:

| Parâmetro                        | Valor           | Justificativa                                                  |
|----------------------------------|------------------|----------------------------------------------------------------|
| **RPO** (Recovery Point Objective) | 15 minutos       | Minimizar perda de dados recentes em caso de falha             |
| **RTO** (Recovery Time Objective) | 1 hora           | Garantir retorno rápido da operação com impacto mínimo         |
| **Frequência de backup de log**   | A cada 15 minutos| Alinhado ao RPO                                                |
| **Plano de restauração**          | Testado em ambiente de homologação | Alinhado ao RTO                                  |

[Documentação da Fase 2.1 no Google Docs](https://docs.google.com/document/d/1gcsYRgoWPPBTyUtyF_WRqW1m34jBrWF8KVj6YaUqm_o/edit?usp=sharing)