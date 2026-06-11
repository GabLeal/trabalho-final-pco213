#!/usr/bin/env bash
# Publica o projeto no GitHub (repositório público: trabalho-final-pco213)
set -euo pipefail

cd "$(dirname "$0")"

if ! gh auth status >/dev/null 2>&1; then
  echo "Faça login no GitHub primeiro:"
  gh auth login --hostname github.com --git-protocol https --web
fi

if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote origin já configurado. Enviando commits..."
  git push -u origin main
else
  gh repo create trabalho-final-pco213 \
    --public \
    --source=. \
    --remote=origin \
    --description "Trabalho final PCO213 — previsão de preço de carros usados (ML/DM)" \
    --push
fi

echo ""
echo "Pronto! Repositório: https://github.com/$(gh api user -q .login)/trabalho-final-pco213"
