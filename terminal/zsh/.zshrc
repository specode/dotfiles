# ==========================================
# 0. 基础环境
# ==========================================
export EDITOR="nvim"
export VISUAL="$EDITOR"

if command -v brew >/dev/null 2>&1; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

# ==========================================
# 1. Antidote 插件管理
# ==========================================
if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  ANTIDOTE_PATH="$HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh"
  if [[ -f "$ANTIDOTE_PATH" ]]; then
    source "$ANTIDOTE_PATH"
    antidote load
  fi
fi

# ==========================================
# 2. 现代 CLI 工具替换
# ==========================================
alias vim="nvim"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons"
  alias ll="eza -lh --icons --grid --group-directories-first"
  alias la="eza -lah --icons --grid --group-directories-first"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

# ==========================================
# 3. 高频工作流
# ==========================================
alias gst="git status -sb"
alias gco="git checkout"
alias gcm="git commit -m"

ENV_CACHE="$HOME/.env"
if [[ -f "$ENV_CACHE" || -p "$ENV_CACHE" ]]; then
  set -a
  source "$ENV_CACHE"
  set +a
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]] && [[ -d "$HOMEBREW_PREFIX/opt/luajit" ]]; then
  export LUAJIT_DIR="$HOMEBREW_PREFIX/opt/luajit"
fi

# ==========================================
# 4. Starship 提示符
# ==========================================
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# ==========================================
# 5. zoxide (须在最后初始化，确保其 hook 最后注册)
# ==========================================
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
  alias cd="z"
fi
export PATH="$HOME/.local/bin:$PATH"
