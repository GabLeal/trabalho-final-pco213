# Trabalho Final — PCO213

Previsão de preço de carros usados com aprendizado de máquina.

## Estrutura

| Arquivo / pasta | Descrição |
|-----------------|-----------|
| `datasets/Car details v3.csv` | Dataset principal (8.128 registros) |
| `projeto_pco213_car_price.ipynb` | Notebook com EDA, limpeza, modelagem e interpretação |
| `relatorio.md` | Relatório estilo artigo (adaptar ao template SIGAA) |
| `apresentacao.md` | Roteiro de slides para o seminário (15 min) |
| `outputs/` | Figuras e resumo JSON gerados pela execução |
| `requirements.txt` | Dependências Python |

## Como executar

```bash
cd "TRABALHO FINAL"
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
jupyter notebook projeto_pco213_car_price.ipynb
```

Ou regerar apenas os resultados numéricos:

```bash
source .venv/bin/activate
python -c "import json; print(json.load(open('outputs/results_summary.json')))"
```

## Resultado principal

- **Melhor modelo:** Random Forest
- **R² no teste:** 0,89
- **MAE no teste:** ~68.756 INR

## Entrega

- Prazo: **29/06/2026**
- Grupo: 3–4 integrantes
- Relatório: ≤ 6 páginas (template SIGAA)
- Apresentação: ≤ 15 minutos
