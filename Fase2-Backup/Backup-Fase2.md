# 💾 Plano de Backup – LighterTrackDB (Fase 2)

**Projeto:** LighterTrackDB  
**Objetivo:** Garantir a recuperação completa e segura do banco de dados com uma estratégia de backup eficiente e rastreável  
**Base teórica:** Trilha “Manutenção Automatizada” – *Iniciativa DBA*

---

| Tipo de Backup       | Frequência       | Retenção sugerida | Observações                          |
|----------------------|------------------|-------------------|--------------------------------------|
| **Full Backup**      | 1x por semana    | 4 semanas         | Cópia completa do banco              |
| **Differential**     | Diariamente      | 7 dias            | Apenas alterações desde o último full |
| **Log de Transações**| A cada 30 minutos| 24h ou mais       | Necessário para recuperação ponto-a-ponto |

📄 [Documentação da Fase 2 no Google Docs](https://docs.google.com/document/d/1_VRbnaXSKanYKhBF_m-apPUUtROep6F4xVxZyrh3c30/edit?usp=sharing)
