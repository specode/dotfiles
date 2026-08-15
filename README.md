# Dotfiles

个人 macOS 终端开发环境，一次安装常用终端工具、应用、字体和配置。

## 快速开始

```bash
git clone git@github.com:specode/dotfiles.git ~/Code/dotfiles
cd ~/Code/dotfiles
./install.sh
```

以后更新：

```bash
cd ~/Code/dotfiles
git pull
./install.sh
```

## 前置需求依赖

- macOS
- 可访问 GitHub 和 Homebrew 的网络
- Git
- 安装 Homebrew 时可使用管理员权限

Homebrew 无需预先安装，脚本会在缺失时自动安装。

## 本安装的明细

| 类别 | 内容 | 安装位置或配置路径 |
| --- | --- | --- |
| 包管理器 | Homebrew | `/opt/homebrew` 或 `/usr/local` |
| 终端应用 | Ghostty | `/Applications/Ghostty.app` |
| 命令行工具 | Starship、Antidote、eza、bat、zoxide、fd、ripgrep、Neovim | Homebrew |
| 字体 | Maple Mono NF CN、JetBrains Mono Nerd Font | macOS 字体目录 |
| Ghostty 配置 | 字体、主题、窗口、滚动与快捷行为 | `~/.config/ghostty/config` |
| Starship 配置 | Shell 提示符样式 | `~/.config/starship.toml` |
| Zsh 配置 | Shell 环境与插件清单 | `~/.zshrc`、`~/.zsh_plugins.txt` |
