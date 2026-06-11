# Seminário PCO213 — Previsão de Preço de Carros Usados

**Duração sugerida:** 15 minutos  
**Formato:** slides para conversão em PowerPoint/Google Slides/PDF

---

## Slide 1 — Título

**Previsão de Preço de Carros Usados com Aprendizado de Máquina**

PCO213 — UFJF — 1º semestre/2026  
[Nomes dos integrantes do grupo]

---

## Slide 2 — Problema e motivação

- Estimar o preço de venda de carros usados a partir de características do veículo
- Aplicação prática: precificação automática em marketplaces
- Dataset real: **Car details v3.csv** (mercado indiano, CarDekho/Kaggle)
- Tipo de problema: **regressão** (target: `selling_price`)

---

## Slide 3 — Dataset

| Item | Valor |
|------|------:|
| Registros brutos | 8.128 |
| Após limpeza | 6.663 |
| Features finais | 12 (7 numéricas + 5 categóricas) |

Variáveis: ano, km, combustível, transmissão, marca, potência, torque, cilindrada, etc.

---

## Slide 4 — Pipeline metodológico

```
Dados brutos → Deduplicação → Parsing de campos textuais
            → Remoção de outliers → EDA
            → Imputação + Encoding + Normalização
            → 3 modelos + Cross-validation 5-fold
            → Comparação e interpretação
```

---

## Slide 5 — EDA (principais achados)

- Preço com distribuição assimétrica (cauda alta)
- **Ano** e **quilometragem** correlacionados com preço (+ e −, respectivamente)
- Diesel e transmissão automática associados a preços maiores
- ~2,7% de missing em atributos técnicos (tratados por imputação)

*Inserir figura: `outputs/eda_boxplots.png` ou gráficos do notebook*

---

## Slide 6 — Pré-processamento

1. Extração de **marca** do campo `name`
2. Conversão: `"74 bhp"` → 74, `"23.4 kmpl"` → 23,4
3. Outliers: percentis 1–99 em preço e km
4. **OneHotEncoder** + **StandardScaler** em pipeline scikit-learn

---

## Slide 7 — Modelos avaliados

| Modelo | Justificativa |
|--------|---------------|
| Regressão Linear | Baseline interpretável |
| Random Forest | Relações não lineares + importância de features |
| KNN | Método lazy, comparação com vizinhos |

Validação: **5-fold CV** no treino + hold-out 20% teste

---

## Slide 8 — Resultados (Cross-validation)

| Modelo | MAE (CV) | RMSE (CV) | R² (CV) |
|--------|---------:|----------:|--------:|
| Regressão Linear | 109.243 | 158.454 | 0,79 |
| **Random Forest** | **71.304** | **116.317** | **0,89** |
| KNN | 81.261 | 131.306 | 0,86 |

**Melhor modelo: Random Forest**

---

## Slide 9 — Resultados (Teste)

| Modelo | MAE | RMSE | R² |
|--------|----:|-----:|---:|
| Regressão Linear | 110.376 | 164.388 | 0,78 |
| **Random Forest** | **68.756** | **117.420** | **0,89** |
| KNN | 81.104 | 132.222 | 0,86 |

Erro médio ~69 mil INR no melhor modelo

---

## Slide 10 — Importância das variáveis

Top 3 preditores (Random Forest):

1. **Ano** — 30%
2. **Potência máxima (bhp)** — 29%
3. **Torque (Nm)** — 26%

Km rodados e cilindrada têm peso menor; marca premium também contribui.

*Inserir gráfico de barras do notebook (seção 6)*

---

## Slide 11 — Real vs Previsto

- Scatter plot: eixo x = preço real, eixo y = preço previsto
- Pontos próximos à diagonal indicam boas predições
- Resíduos maiores em veículos de alto valor (cauda da distribuição)

*Inserir figura do notebook (seção 6)*

---

## Slide 12 — Conclusões

- Dataset **Car details v3** é **apto** ao projeto após limpeza
- Random Forest supera Linear e KNN (R² ≈ 0,89)
- Ano e especificações do motor são os principais drivers
- Pipeline completo: EDA → preprocess → CV → interpretação

---

## Slide 13 — Limitações e trabalhos futuros

- Dados de um único país/mercado
- Possível melhoria: agrupamento de modelos, validação temporal
- Transferência da metodologia para domínios do mestrado

---

## Slide 14 — Demonstração / Perguntas

- Código: `projeto_pco213_car_price.ipynb`
- Relatório: `relatorio.md`
- **Perguntas?**

---

### Notas para apresentação (15 min)

| Bloco | Tempo |
|-------|------:|
| Contexto + dataset | 2 min |
| EDA + preprocess | 3 min |
| Modelos + resultados | 5 min |
| Interpretação + conclusão | 3 min |
| Perguntas | 2 min |
