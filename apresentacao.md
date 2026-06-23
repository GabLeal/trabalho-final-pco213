# Seminário PCO213 — Previsão de Preço de Carros Usados

**Duração sugerida:** 15 minutos
**Formato:** slides para conversão em PowerPoint/Google Slides/PDF

---

## Slide 1 — Título

**Previsão de Preço de Carros Usados com Aprendizado de Máquina**

PCO213 — UNIFEI — 1º semestre/2026
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
| Após deduplicação | 6.926 |
| Após limpeza (final) | 6.663 |
| Features finais | 12 (7 numéricas + 5 categóricas) |

Variáveis: ano, km, combustível, transmissão, marca, potência, torque, cilindrada, etc.

---

## Slide 4 — Pipeline metodológico

```
Dados brutos → Deduplicação → Parsing de campos textuais
            → Remoção de outliers → EDA + PCA
            → Imputação + Encoding + Normalização
            → Alvo em escala log (log1p)
            → Split AGRUPADO pelo veículo (anti-vazamento)
            → Tuning + 6 modelos + CV 5-fold agrupada
            → Teste estatístico + interpretação (permutação) + resíduos
```

---

## Slide 5 — EDA e PCA (principais achados)

- Preço com distribuição **assimétrica à direita** (justifica o log do alvo)
- **Ano** e **quilometragem** correlacionados com preço (+ e −, respectivamente)
- Diesel e transmissão automática associados a preços maiores
- ~2,9% de missing em atributos técnicos (tratados por imputação)
- **PCA:** 3 componentes concentram ~80% da variância; atributos de motor dominam o PC1

*Inserir figuras: histogramas/boxplots do notebook e `outputs/pca_scree_full.png`*

---

## Slide 6 — Pré-processamento

1. Extração de **marca** do campo `name`
2. Conversão: `"74 bhp"` → 74; `"23.4 kmpl"` → 23,4
3. Outliers: percentis 1–99 em preço e km; ano ≥ 1990
4. **OneHotEncoder** + **StandardScaler** em pipeline scikit-learn (sem vazamento)
5. **Alvo em escala log** (`log1p`/`expm1`) para estabilizar a variância

---

## Slide 7 — Modelos avaliados

| Modelo | Papel |
|--------|-------|
| Regressão Linear | Baseline interpretável |
| Árvore de Decisão | Partições não lineares simples |
| KNN | Método lazy, vizinhança |
| Gradient Boosting | Ensemble sequencial (corrige resíduos) |
| Random Forest (tuned) | Ensemble com hiperparâmetros via GridSearchCV |
| **XGBoost** | Boosting otimizado (estado da arte) |

Validação: **5-fold CV agrupada** + hold-out 20% teste
Métricas: **MAE, RMSE, MAPE, R²**

---

## Slide 8 — Resultados (Cross-validation)

| Modelo | MAE (CV) | RMSE (CV) | R² (CV) |
|--------|---------:|----------:|--------:|
| Regressão Linear | 79.079 | 133.910 | 0,847 |
| Árvore de Decisão | 91.814 | 155.336 | 0,795 |
| KNN | 86.136 | 145.094 | 0,818 |
| Gradient Boosting | 75.698 | 123.926 | 0,869 |
| Random Forest (tuned) | 78.360 | 132.325 | 0,850 |
| **XGBoost** | **71.839** | **117.532** | **0,881** |

Split agrupado (anti-vazamento): 5.183 treino / 1.480 teste.

---

## Slide 9 — Resultados (Teste)

| Modelo | MAE | RMSE | MAPE | R² |
|--------|----:|-----:|-----:|---:|
| Regressão Linear | 72.547 | 125.663 | 17,5% | 0,877 |
| Árvore de Decisão | 88.565 | 160.497 | 21,4% | 0,799 |
| KNN | 82.233 | 138.288 | 19,8% | 0,851 |
| Gradient Boosting | 70.175 | 115.459 | 17,0% | 0,896 |
| Random Forest (tuned) | 73.526 | 122.037 | 17,8% | 0,884 |
| **XGBoost** | **64.986** | **103.740** | **16,2%** | **0,916** |

**XGBoost** melhor em tudo; supera o GB com **p = 0,044** (teste t pareado).

---

## Slide 10 — Importância das variáveis (permutação)

Top preditores (XGBoost, queda no R²):

1. **Ano** — 0,49
2. **Potência máxima (bhp)** — 0,29
3. **Torque (Nm)** — 0,09
4. **Marca** — 0,07 (maior que na impureza!)
5. **Cilindrada (cc)** — 0,05

*Importância por permutação corrige o viés da importância por impureza.*

*Inserir `outputs/permutation_importance.png`*

---

## Slide 11 — Significância e resíduos

- **Teste t pareado:** XGBoost > Gradient Boosting (t = 2,90, **p = 0,044**)
- Ensembles têm **menor variância entre dobras** (predições mais estáveis)
- **Resíduos** centrados em zero e simétricos → sem viés sistemático

*Inserir `outputs/residuals.png`*

---

## Slide 12 — Conclusões

- Dataset **Car details v3** é **apto** ao projeto após limpeza
- **Ensembles** superam Linear, Árvore e KNN
- **XGBoost** é o melhor (R² = 0,916 no teste), de forma **estatisticamente significativa**
- Split **agrupado** evita vazamento → resultado mais honesto
- Ano e especificações do motor são os principais drivers

---

## Slide 13 — Limitações e trabalhos futuros

- Dados de um único país/mercado (Índia); desbalanceamento entre marcas
- Nome reduzido a marca/modelo (sem versão); sem validação temporal
- Futuro: **SHAP**, **LightGBM**/redes neurais tabulares
- Futuro: validação **temporal** e quantificação de incerteza

---

## Slide 14 — Demonstração / Perguntas

- Código: `projeto_pco213_car_price.ipynb`
- Artigo: `relatorio/Article_PCO213.pdf`
- **Perguntas?**

---

### Notas para apresentação (15 min)

| Bloco | Tempo |
|-------|------:|
| Contexto + dataset | 2 min |
| EDA + PCA + preprocess | 3 min |
| Modelos + resultados | 5 min |
| Interpretação + conclusão | 3 min |
| Perguntas | 2 min |
