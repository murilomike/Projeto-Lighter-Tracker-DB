# 🛠️ Manutenção Preventiva – LighterTrackDB (Fase 1)

**Projeto:** LighterTrackDB  
**Objetivo:** Implementar manutenção preventiva com foco em integridade e rastreabilidade  
**Base teórica:** Trilha “Manutenção Automatizada” – *Iniciativa DBA*

---

## ✅ Implementações concluídas

- **CHECKDB agendado** para verificação de integridade lógica e física do banco
- **Tabela `HistoricoCheckDB`** criada para armazenar os resultados de cada execução
- **Script com tratamento de erro** via `TRY...CATCH` para registrar falhas
- **Pronto para expansão futura** com rotinas de:
  - `REBUILD`
  - `REORGANIZE`
  - `UPDATE STATISTICS`

---

## 🧠 Benefícios

- Auditoria clara das execuções de manutenção
- Base sólida para automação com SQL Server Agent ou Agendador de Tarefas
- Alinhado com boas práticas ensinadas no curso **Iniciativa DBA**

---

## 📌 Próximos passos (futuramente)

- Criar tabela genérica `HistoricoManutencao` para centralizar todos os tipos de manutenção
- Automatizar rotinas de índices e estatísticas com histórico
- Implementar alertas com Database Mail

---

> 💡 Este projeto é parte do meu portfólio técnico como DBA e foi construído com base em boas práticas de manutenção preventiva no SQL Server.

📄 [Documentação da Fase 1 no Google Docs](https://docs.google.com/document/d/1rqNxiXyRRcgVwe8vzQ91Q7SjYCH-5Z66hvv2ghAUU1Q/edit?usp=sharing)

