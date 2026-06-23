# Previsão de Preço de Carros Usados com Aprendizado de Máquina

**Disciplina:** PCO213 — Aprendizado de Máquina e Mineração de Dados
**Universidade Federal de Itajubá (UNIFEI) — 1º semestre/2026**

> **Nota:** a entrega oficial é o artigo em formato IEEE (`relatorio/Article_PCO213.tex` / `.pdf`).
> Este markdown é uma versão de leitura rápida, com os mesmos resultados.

---

## Resumo

Este trabalho aplica técnicas de aprendizado de máquina para prever o preço de venda de carros usados a partir de um conjunto de dados real do mercado indiano (CarDekho). Após exploração, limpeza e engenharia de atributos, o alvo foi modelado em escala logarítmica e **seis** modelos foram comparados por validação cruzada de 5 folds com **partição agrupada pelo veículo** (anti-vazamento). O **XGBoost** obteve o melhor desempenho (R² = 0,916 no teste; MAPE 16,2%), superando o Gradient Boosting de forma **estatisticamente significativa** (p = 0,044). Ano, potência e torque foram os preditores dominantes.

**Palavras-chave:** regressão, XGBoost, floresta aleatória, validação cruzada, precificação, mineração de dados.

---

## 1. Introdução

A precificação de veículos usados envolve fatores que se relacionam de forma não linear. O projeto usa o dataset **Car details v3** (8.128 anúncios) para estimar o preço de venda (`selling_price`), identificando os atributos mais influentes e o algoritmo mais adequado.

---

## 2. Metodologia

### 2.1 Pré-processamento

1. Remoção de 1.202 duplicatas (6.926 restantes).
2. Engenharia de atributos: extração de **marca e modelo** do nome; conversão de campos textuais em numéricos.
3. Outliers: percentis 1–99 (preço e km) e ano ≥ 1990 → **6.663 amostras**.
4. Imputação (mediana/moda); One-Hot (categóricas) + padronização (numéricas).

### 2.2 EDA e PCA

Preço assimétrico à direita (motiva o log). Correlação positiva com potência/torque/ano e negativa com km. PCA: 3 componentes ~80% da variância, com atributos de motor dominando o PC1.

### 2.3 Modelagem

- **Alvo em escala log** (`log1p`/`expm1`).
- **Split agrupado pelo nome do veículo** → 5.183 treino / 1.480 teste, sem vazamento.
- **6 algoritmos:** Regressão Linear, Árvore de Decisão, KNN, Gradient Boosting, Random Forest (ajustado por busca em grade) e **XGBoost**.
- **Validação cruzada 5-fold agrupada**; métricas MAE, RMSE, MAPE e R².
- **Teste t pareado** entre os dois melhores; **importância por permutação**.

---

## 3. Resultados

### Tabela 1 — Desempenho dos modelos

| Modelo | CV RMSE | CV R² | Teste MAE | Teste RMSE | Teste MAPE | Teste R² |
|--------|--------:|------:|----------:|-----------:|-----------:|---------:|
| Regressão Linear | 133.910 | 0,847 | 72.547 | 125.663 | 17,5% | 0,877 |
| Árvore de Decisão | 155.336 | 0,795 | 88.565 | 160.497 | 21,4% | 0,799 |
| KNN | 145.094 | 0,818 | 82.233 | 138.288 | 19,8% | 0,851 |
| Gradient Boosting | 123.926 | 0,869 | 70.175 | 115.459 | 17,0% | 0,896 |
| Random Forest (tuned) | 132.325 | 0,850 | 73.526 | 122.037 | 17,8% | 0,884 |
| **XGBoost** | **117.532** | **0,881** | **64.986** | **103.740** | **16,2%** | **0,916** |

*MAE e RMSE em rúpias indianas (INR).*

**Teste estatístico:** XGBoost vs Gradient Boosting → t = 2,90, **p = 0,044** (XGBoost significativamente melhor).

### 3.1 Importância por permutação (XGBoost)

1. **year** — queda de 0,49 no R²
2. **max_power_bhp** — 0,29
3. **torque_nm** — 0,09
4. **brand** — 0,07 (maior que na importância por impureza)
5. **engine_cc** — 0,05

---

## 4. Discussão

O XGBoost vence por combinar redução de viés (boosting sequencial) com regularização explícita; sua vantagem sobre o GB é estatisticamente significativa. A árvore isolada foi a mais penalizada pelo split agrupado (alta variância). A importância por permutação corrige o viés da importância por impureza, revelando a marca como fator relevante.

**Limitações:** (i) único mercado; (ii) nome reduzido a marca/modelo; (iii) desbalanceamento entre marcas; (iv) sem validação temporal.

---

## 5. Conclusão

Pipeline completo e robusto, da limpeza de 8.128 registros à comparação de 6 algoritmos com CV agrupada. O XGBoost lidera (R² = 0,916 no teste), com ano, potência e torque como preditores dominantes. Atende aos requisitos de EDA, pré-processamento, modelagem, interpretação e comunicação do projeto PCO213.

---

## Referências

- CarDekho / Kaggle. *Used Car Price Prediction Dataset* (Car details v3).
- Pedregosa et al. *Scikit-learn: Machine Learning in Python*. JMLR, 2011.
- Breiman, L. *Random Forests*. Machine Learning, 2001.
- Friedman, J. H. *Greedy function approximation: a gradient boosting machine*. Annals of Statistics, 2001.
- Chen, T.; Guestrin, C. *XGBoost: A Scalable Tree Boosting System*. ACM SIGKDD, 2016.
