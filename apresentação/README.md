# Apresentação — Previsão de Preço de Carros Usados (PCO213)

Site de apresentação (slides em HTML) + roteiro de fala para o seminário.
**Duração-alvo: 10 minutos.**

## Como abrir

Abra [index.html](index.html) em qualquer navegador (duplo clique).
As figuras são carregadas de `../outputs/`, então mantenha a pasta `apresentação/`
dentro do repositório, ao lado de `outputs/`.

### Navegação

| Ação | Tecla / gesto |
|------|---------------|
| Próximo slide | `→` `↓` `Espaço` · clique em "Próximo" · swipe ← |
| Slide anterior | `←` `↑` · clique em "Anterior" · swipe → |
| Primeiro / último | `Home` / `End` |
| Tela cheia | `F` |

Há um **cronômetro** e um **contador de slides** no rodapé, além de uma barra
de progresso no topo — úteis para controlar o tempo durante a fala.

---

## Roteiro de fala (10 min)

Tempo sugerido por bloco. A coluna "acum." ajuda a saber se está adiantado/atrasado.

| Bloco | Slides | Tempo | Acum. |
|-------|--------|------:|------:|
| Abertura + problema | 1–2 | 1:00 | 1:00 |
| Dataset + pipeline | 3–4 | 1:30 | 2:30 |
| EDA + PCA + pré-proc. | 5–7 | 2:00 | 4:30 |
| Modelos + resultados | 8–10 | 2:30 | 7:00 |
| Significância + interpretação + resíduos | 11–13 | 1:30 | 8:30 |
| Conclusões + limitações + perguntas | 14–16 | 1:30 | 10:00 |

---

### Slide 1 — Título (~20s)
Apresentar tema e grupo. "Vamos mostrar um pipeline completo de ML para prever o
preço de carros usados, da limpeza dos dados até um modelo interpretável."

### Slide 2 — Problema e motivação (~40s)
O preço depende de muitos fatores não lineares; avaliação manual é subjetiva.
Aplicação prática: precificação automática em marketplaces. É **regressão**:
prever `selling_price`. Pergunta central: quais atributos importam e qual
algoritmo prevê melhor.

### Slide 3 — Dataset (~45s)
Saímos de **8.128** registros brutos. Removemos **1.202 duplicatas** e **263
outliers** (percentis 1–99 em preço/km e ano ≥ 1990), chegando a **6.663**
amostras com 12 features (7 numéricas + 5 categóricas).

### Slide 4 — Pipeline (~45s)
Mostrar a esteira de 10 etapas. **Destacar** dois pontos: (1) tudo dentro de um
Pipeline do scikit-learn — imputação/padronização ajustadas só no treino; (2) o
split é **agrupado pelo veículo** para evitar vazamento. Voltamos nesses pontos.

### Slide 5 — EDA (~40s)
Preço **assimétrico à direita** → justifica o log do alvo. Ano correlaciona +,
km correlaciona −. Diesel e automático custam mais. ~2,9% de faltantes tratados
por imputação. Apontar a figura.

### Slide 6 — PCA (~40s)
3 componentes ≈ 80% da variância. O PC1 é dominado por **potência, torque e
cilindrada** — atributos de motor andam juntos (multicolinearidade). Diesel ×
gasolina aparecem separáveis. PCA aqui é diagnóstico — os modelos usam as
features originais.

### Slide 7 — Pré-processamento (~40s)
Engenharia: marca/modelo extraídos do nome; "74 bhp" → 74; torque → Nm.
Imputação + One-Hot + StandardScaler. **Alvo em log** (log1p/expm1).
**Enfatizar** o split agrupado: nenhum carro em treino e teste ao mesmo tempo →
5.183 treino / 1.480 teste. Resultado honesto.

### Slide 8 — Modelos (~40s)
Seis algoritmos, do baseline (Linear) ao estado da arte (XGBoost), passando por
Árvore, KNN, Gradient Boosting e Random Forest ajustado por GridSearchCV.
Avaliação: CV 5-fold agrupada + hold-out 20%. Métricas: MAE, RMSE, MAPE, R².

### Slide 9 — Resultados / tabela (~60s)
Ler a tabela de cima para baixo e parar no XGBoost: **melhor em todas as
métricas**. R² = 0,916 → explica 91,6% da variabilidade; MAPE 16,2%.
Os ensembles (GB, RF, XGB) ficam acima dos modelos simples.

### Slide 10 — Comparação visual (~45s)
A figura reforça visualmente: métodos de ensemble lideram consistentemente em
todas as métricas. A árvore isolada é a mais penalizada (alta variância sob o
split agrupado).

### Slide 11 — Significância estatística (~45s)
Não basta o melhor número — testamos se a diferença é real. **Teste t pareado**
XGBoost vs Gradient Boosting sobre os erros por fold: **t = 2,90, p = 0,044** →
significativo. XGBoost ganha por unir boosting sequencial (reduz viés) e
regularização (controla variância).

### Slide 12 — Importância das variáveis (~45s)
Importância por **permutação** (queda no R² ao embaralhar): **ano (0,49)** domina,
seguido de potência (0,29), torque (0,09), marca (0,07), cilindrada (0,05).
A permutação corrige o viés da importância por impureza — a **marca** aparece
como fator genuíno. Coerente com o PCA.

### Slide 13 — Resíduos (~30s)
Resíduos centrados em zero e simétricos → sem viés sistemático. A escala log
cumpriu seu papel de estabilizar a variância dos erros.

### Slide 14 — Conclusões (~40s)
Recapitular: dataset apto após limpeza; ensembles vencem; XGBoost é o melhor de
forma estatisticamente significativa; split agrupado garantiu honestidade; ano e
motor são os drivers. Erro de ~65 mil INR / 16% — útil na prática.

### Slide 15 — Limitações e futuro (~30s)
Limitações: único mercado, desbalanceamento de marcas, sem versão do modelo, sem
validação temporal. Futuro: SHAP, LightGBM/redes tabulares, validação temporal,
incerteza.

### Slide 16 — Perguntas (~20s)
Agradecer e abrir para perguntas. Ter à mão o notebook e o artigo IEEE.

---

## Números-chave para ter na ponta da língua

- **6.663** amostras finais (de 8.128 brutas)
- Split agrupado: **5.183 treino / 1.480 teste**
- Melhor modelo: **XGBoost** — R² **0,916**, MAE **64.986 INR**, MAPE **16,2%**
- Teste t pareado vs GB: **t = 2,90 · p = 0,044**
- Top preditores (permutação): **ano (0,49) · potência (0,29) · torque (0,09)**

## Possíveis perguntas da banca

- **Por que log do alvo?** Preço é assimétrico à direita; o log estabiliza a
  variância, lineariza relações multiplicativas e reduz o impacto de valores altos.
- **Por que split agrupado e não aleatório?** O mesmo modelo de carro aparece
  várias vezes; um split aleatório vazaria informação entre treino e teste e
  inflaria artificialmente o R².
- **Por que permutação e não a importância nativa (impureza)?** A impureza
  favorece variáveis de alta cardinalidade e dummies específicas; a permutação
  mede o impacto real no desempenho preditivo.
- **XGBoost é muito melhor que Gradient Boosting?** Estatisticamente sim
  (p = 0,044), mas a diferença prática é modesta — ambos são fortes.
