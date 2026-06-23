# Trabalho Final — PCO213

Previsão de preço de carros usados com aprendizado de máquina e mineração de dados.
**UNIFEI — Aprendizado de Máquina (PCO213) — 1º semestre/2026.**

## Estrutura

| Arquivo / pasta | Descrição |
|-----------------|-----------|
| `datasets/Car details v3.csv` | Dataset principal (8.128 registros, CarDekho/Kaggle) |
| `projeto_pco213_car_price.ipynb` | Notebook: limpeza, EDA, PCA, modelagem, tuning e interpretação |
| `relatorio/Article_PCO213.tex` | **Artigo (entrega oficial)** no template IEEE — compila em `.pdf` |
| `relatorio/Article_PCO213.pdf` | Artigo compilado (≤ 6 páginas) |
| `relatorio/Figures/` | Figuras usadas no artigo |
| `relatorio.md` | Versão markdown do relatório (leitura rápida) |
| `apresentacao.md` | Roteiro de slides para o seminário (15 min) |
| `outputs/` | Figuras (EDA, PCA, importância, resíduos) e `results_summary.json` |
| `requirements.txt` | Dependências Python |

## Metodologia

Pipeline completo: limpeza e *parsing* → EDA + PCA → pré-processamento (imputação, One-Hot, padronização) com **alvo em escala log** → **split agrupado pelo veículo (anti-vazamento)** → **6 modelos** comparados por **validação cruzada 5-fold agrupada** → **teste estatístico** entre os melhores → interpretação por **impureza e permutação** + resíduos.

Modelos avaliados: Regressão Linear, Árvore de Decisão, KNN, Gradient Boosting, Random Forest (ajustado via `GridSearchCV`) e **XGBoost**. Métricas: MAE, RMSE, MAPE e R².

## Como executar o notebook

```bash
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
jupyter notebook projeto_pco213_car_price.ipynb
```

A execução regenera as figuras em `outputs/` e o resumo `outputs/results_summary.json`.

## Como compilar o artigo

```bash
cd relatorio
pdflatex Article_PCO213.tex
pdflatex Article_PCO213.tex   # 2ª passada para referências cruzadas
```

## Resultados principais

O **XGBoost** lidera em todas as métricas e é **estatisticamente superior** ao Gradient Boosting (teste t pareado, p = 0,044). Resultados com split agrupado (sem vazamento): 5.183 amostras de treino / 1.480 de teste.

| Modelo | Teste R² | Teste MAE (INR) | Teste MAPE |
|--------|---------:|----------------:|-----------:|
| Regressão Linear | 0,877 | 72.547 | 17,5% |
| Árvore de Decisão | 0,799 | 88.565 | 21,4% |
| KNN | 0,851 | 82.233 | 19,8% |
| Gradient Boosting | 0,896 | 70.175 | 17,0% |
| Random Forest (tuned) | 0,884 | 73.526 | 17,8% |
| **XGBoost** | **0,916** | **64.986** | **16,2%** |

**Preditores dominantes** (importância por permutação): ano, potência, torque e marca.

## Entrega

- Prazo: **29/06/2026**
- Grupo: 3–4 integrantes (preencher nomes no `.tex` e nos slides)
- Relatório: artigo IEEE ≤ 6 páginas
- Apresentação: ≤ 15 minutos
