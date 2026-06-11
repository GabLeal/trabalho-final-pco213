# Previsão de Preço de Carros Usados com Aprendizado de Máquina

**Disciplina:** PCO213 — Aprendizado de Máquina e Mineração de Dados  
**Universidade Federal de Itajubá — 1º semestre/2026**

---

## Resumo

Este trabalho aplica técnicas de aprendizado de máquina para prever o preço de venda de carros usados a partir de um conjunto de dados real do mercado indiano (CarDekho). Após exploração, limpeza e engenharia de atributos, foram treinados três modelos de regressão — Regressão Linear, Random Forest e KNN — com validação cruzada de 5 folds. O Random Forest obteve o melhor desempenho (R² = 0,89 no teste), evidenciando que ano, potência e torque são os preditores mais relevantes. O estudo demonstra um pipeline completo de ML aplicável a problemas tabulares de precificação.

**Palavras-chave:** regressão, random forest, validação cruzada, precificação, mineração de dados.

---

## 1. Introdução

A precificação de veículos usados envolve múltiplos fatores — idade, quilometragem, especificações técnicas e características de mercado — que se relacionam de forma não linear. Modelos de aprendizado de máquina permitem automatizar essa estimativa a partir de dados históricos de anúncios.

Este projeto utiliza o dataset **Car details v3**, composto por 8.128 anúncios de carros usados na Índia, com informações sobre preço, ano, quilometragem, combustível, transmissão e atributos do motor. Embora o domínio não corresponda diretamente ao tema central da dissertação de mestrado, o trabalho exercita um **pipeline metodológico transferível** (EDA → pré-processamento → modelagem → interpretação) exigido pela disciplina e aplicável a outros contextos de previsão com dados tabulares.

**Objetivo:** desenvolver e comparar modelos preditivos para estimar o preço de venda (`selling_price`) com base nas características disponíveis.

---

## 2. Metodologia

### 2.1 Conjunto de dados

Fonte: `Car details v3.csv` (Kaggle/CarDekho). Variáveis originais: nome do veículo, ano, preço, km rodados, combustível, tipo de vendedor, transmissão, proprietário, consumo, cilindrada, potência, torque e assentos.

### 2.2 Pré-processamento

1. **Remoção de duplicatas:** 1.202 registros repetidos eliminados (6.926 restantes).
2. **Engenharia de atributos:** extração de marca a partir do nome; conversão de campos textuais (`mileage`, `engine`, `max_power`, `torque`) para valores numéricos.
3. **Tratamento de outliers:** remoção de registros fora dos percentis 1–99 em preço e quilometragem, e com ano anterior a 1990 (263 removidos). **Dataset final: 6.663 amostras.**
4. **Valores ausentes:** imputação pela mediana (numéricas) e moda (categóricas).
5. **Codificação:** One-Hot Encoding para variáveis categóricas (`fuel`, `seller_type`, `transmission`, `owner`, `brand`); padronização (`StandardScaler`) para numéricas.

### 2.3 Análise exploratória

A distribuição de preços é assimétrica à direita, com mediana inferior à média. Boxplots indicam que veículos a diesel e com transmissão automática tendem a preços mais elevados. Correlações positivas foram observadas entre preço e ano, potência e cilindrada; correlação negativa entre preço e quilometragem.

### 2.4 Modelagem

- **Partição:** 80% treino / 20% teste (`random_state=42`).
- **Algoritmos:** Regressão Linear (baseline), Random Forest (200 árvores, `max_depth=20`) e KNN (`k=7`, pesos por distância).
- **Validação:** cross-validation 5-fold no conjunto de treino.
- **Métricas:** MAE, RMSE e R².

Implementação em Python (scikit-learn), notebook `projeto_pco213_car_price.ipynb`.

---

## 3. Resultados

### Tabela 1 — Desempenho dos modelos (validação cruzada e teste)

| Modelo            | CV MAE (INR) | CV RMSE (INR) | CV R²  | Teste MAE | Teste RMSE | Teste R² |
|-------------------|-------------:|--------------:|-------:|----------:|-----------:|---------:|
| Regressão Linear  | 109.243      | 158.454       | 0,790  | 110.376   | 164.388    | 0,784    |
| **Random Forest** | **71.304**   | **116.317**   | **0,887** | **68.756** | **117.420** | **0,890** |
| KNN               | 81.261       | 131.306       | 0,856  | 81.104    | 132.222    | 0,860    |

O Random Forest apresentou menor erro em todas as métricas. A Regressão Linear, embora interpretável, subestima relações não lineares entre marca e especificações técnicas. O KNN ficou intermediário, sensível à escala mesmo após normalização.

### 3.1 Importância das variáveis (Random Forest)

As features mais relevantes foram:

1. **year** (29,9%)
2. **max_power_bhp** (29,4%)
3. **torque_nm** (26,3%)
4. **km_driven** (3,2%)
5. **engine_cc** (2,7%)

Marcas premium (Mercedes-Benz, Toyota) e transmissão automática também contribuem, porém com menor peso relativo. O resultado confirma que desvalorização por idade e especificações do motor são os principais drivers de preço neste mercado.

---

## 4. Discussão

O Random Forest é o modelo mais adequado para este problema: captura interações entre marca, ano e atributos mecânicos sem exigir transformações manuais complexas. O erro médio absoluto de ~69 mil rúpias indianas (~R$ 4.200, ordem de grandeza) deve ser interpretado no contexto de preços medios superiores a 500 mil INR.

**Limitações:** (i) dados de um único mercado (Índia); (ii) variável `name` reduzida a marca simples; (iii) possível vazamento de informação se modelos distintos compartilham especificações idênticas; (iv) ausência de validação temporal.

**Originalidade e relevância:** embora o dataset seja público e recorrente em tutoriais, a combinação de parsing de atributos textuais, comparação sistemática com CV e interpretação de importância atende aos critérios avaliativos da disciplina.

---

## 5. Conclusão

Foi desenvolvido um pipeline completo de previsão de preços de carros usados, desde a limpeza de 8.128 registros brutos até a comparação de três algoritmos com validação cruzada. O Random Forest superou os demais (R² = 0,89), com ano, potência e torque como preditores dominantes. O trabalho cumpre os requisitos de EDA, pré-processamento, modelagem, interpretação e comunicação de resultados previstos no projeto PCO213.

---

## Referências

- CarDekho / Kaggle. *Used Car Price Prediction Dataset* (Car details v3).
- Scikit-learn developers. *Scikit-learn: Machine Learning in Python*. JMLR, 2011.
- Bernardes Vitor, G. PCO213 — Aprendizado de Máquina e Mineração de Dados. UFJF, 2026.

---

*Relatório elaborado para entrega no formato de artigo (≤ 6 páginas). Adaptar ao template oficial do SIGAA antes da submissão final.*
