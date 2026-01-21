#!/usr/bin/env bash

# setup.sh — cria e prepara o ambiente virtual (.venv) e instala dependências
# Uso:  ./setup.sh

set -euo pipefail

# --- Funções auxiliares ---
choose_python() {
    # Escolhe o melhor comando de Python disponível
    if command -v python >/dev/null 2>&1; then
        echo "python"
    elif command -v python3 >/dev/null 2>&1; then
        echo "python3"
    elif command -v py >/dev/null 2>&1; then
        # Em alguns ambientes Windows com Git Bash
        echo "py -3"
    else
        echo "Erro: Python não encontrado no PATH." >&2
        exit 1
    fi
}

activate_venv() {
    # Ativa a venv conforme o ambiente (Unix-like vs. Git Bash/Cygwin/Windows)
    if [ -f .venv/bin/activate ]; then
        # Linux/macOS/WSL
        # shellcheck disable=SC1091
        source .venv/bin/activate
    elif [ -f .venv/Scripts/activate ]; then
        # Git Bash / Cygwin no Windows
        # shellcheck disable=SC1091
        source .venv/Scripts/activate
    else
        echo "Aviso: arquivo de ativação da venv não encontrado." >&2
        exit 1
    fi
}

# --- Execução ---
PY_CMD=$(choose_python)

# Cria a venv se não existir
if [ ! -d .venv ]; then
    echo "[1/4] Criando ambiente virtual .venv..."
    eval "$PY_CMD -m venv .venv"
else
    echo "[1/4] Ambiente virtual .venv já existe."
fi

# Ativa a venv
echo "[2/4] Ativando .venv..."
activate_venv

# Garante pip/setuptools/wheel atualizados
echo "[3/4] Atualizando pip, setuptools e wheel..."
python -m pip install --upgrade pip setuptools wheel

# Instala dependências de requirements.txt (se existir)
if [ -f requirements.txt ]; then
    echo "[4/4] Instalando dependências de requirements.txt..."
    pip install -r requirements.txt
else
    echo "[4/4] Nenhum requirements.txt encontrado. Pulando esta etapa."
fi

echo "Ambiente pronto! Para usar depois, ative com:"
if [ -f .venv/bin/activate ]; then
    echo "  source .venv/bin/activate"
elif [ -f .venv/Scripts/activate ]; then
    echo "  source .venv/Scripts/activate  # (Git Bash/Cygwin no Windows)"
fi