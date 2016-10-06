# facehugger
A way to automatically upload a set of config files to a new environment

## Config File
A config file is required. A sample config is shown below and is located in 
`ENV[HOME]/.config/facehugger/facehugger.yml` by default.

```yaml
---
source: "https://github.com/Codeman655/dotfiles"
config: "/Users/user/.config/facehugger/facehugger.yml"

tmux:
  configfile: "/Users/user/.tmux"

vim:
  configfile: "/Users/user/.vimrc"
  configdir: "/Users/user/.vim"

nvim:
  configfile: "/.config/nvim/init.vim"
  configdir: "/.config/nvim/"

bash:
  configfile: "/Users/user/.bashrc"

zsh:
  configfile: "/Users/user/.zshrc"
  configdir: "/Users/user/.oh-my-zsh"
```

