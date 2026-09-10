{
  config,
  pkgs,
  lib,
  ...
}:

{
  gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  git = {
    enable = true;
    ignores = [
      "*.swp"
      ".DS_Store"
      "**/.claude/settings.local.json"
    ];
    lfs = {
      enable = true;
    };
    settings = {
      user.name = "Matias Kotlik";
      user.email = "matiaskotlik@users.noreply.github.com";
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      pull.rebase = true;
      rebase.autoStash = true;
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
      };
    };
    # Repos under ~/albacore
    includes = [
      {
        condition = "gitdir:~/albacore/";
        contents = {
          user.email = "matias-albacore@users.noreply.github.com";
          core.sshCommand = "ssh -o IdentitiesOnly=yes -i ~/.ssh/id_albacore.pub";
        };
      }
    ];
  };

  fish = {
    enable = true;
    plugins = [
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];
    interactiveShellInit = "fish_vi_key_bindings";
    shellAliases.claude = "claude --allow-dangerously-skip-permissions";
  };

  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  claude-code = {
    enable = true;
    # Homebrew cask provides it
    package = null;
    settings = {
      # Claude runs brew upgrade
      env.CLAUDE_CODE_PACKAGE_MANAGER_AUTO_UPDATE = "1";
      permissions.defaultMode = "auto";
      # Bypass mode needs no prompt
      skipDangerousModePermissionPrompt = true;
      worktree.baseRef = "fresh";
      enabledPlugins = {
        "vercel@claude-plugins-official" = true;
        "linear@claude-plugins-official" = true;
      };
      tui = "fullscreen";
      theme = "dark";
      editorMode = "vim";
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      # iTerm2 per-tab status
      hooks =
        lib.genAttrs
          [
            "Notification"
            "PermissionRequest"
            "PostToolUse"
            "PreToolUse"
            "SessionEnd"
            "SessionStart"
            "Stop"
            "StopFailure"
            "SubagentStop"
            "UserPromptSubmit"
          ]
          (_: [
            {
              hooks = [
                {
                  type = "command";
                  command = "${config.xdg.configHome}/iterm2/cc-status";
                }
              ];
            }
          ]);
    };
  };

  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set modelines=0
      set scrolloff=3
      set hidden
      set wildmode=list:longest
      set cursorline
      set nowrap

      " No backups, no swap
      set nowritebackup
      set noswapfile

      " State under XDG_STATE_HOME
      set viminfofile=~/.local/state/vim/viminfo
      set undofile
      set undodir=~/.local/state/vim/undo

      " Relative line numbers for easy movement
      set relativenumber

      "" Whitespace rules
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set gdefault

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/Projects',
        \ '~/Documents',
        \ ]

      "" Statusbar
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config_external" ];
    settings = {
      # Albacore repos override this
      "github.com" = {
        IdentitiesOnly = true;
        IdentityFile = [ "~/.ssh/id_personal.pub" ];
      };
      "*" = lib.hm.dag.entryAfter [ "github.com" ] {
        # Defaults worth keeping
        SendEnv = [
          "LANG"
          "LC_*"
        ];
        HashKnownHosts = true;
        # Keys live in Bitwarden
        IdentityAgent =
          if pkgs.stdenv.hostPlatform.isDarwin then
            "~/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock"
          else
            "~/.bitwarden-ssh-agent.sock";
      };
    };
  };

  tmux = {
    enable = true;
    focusEvents = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      yank
      prefix-highlight
      {
        plugin = power-theme;
        extraConfig = ''
          set -g @tmux_power_theme 'gold'
        '';
      }
      {
        plugin = resurrect; # Used by tmux-continuum

        # Session layout is XDG state
        # https://github.com/tmux-plugins/tmux-resurrect/issues/348
        extraConfig = ''
          set -g @resurrect-dir '$HOME/.local/state/tmux/resurrect'
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-pane-contents-area 'visible'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '5' # minutes
        '';
      }
    ];
    prefix = "C-x";
    extraConfig = ''
      # -----------------------------------------------------------------------------
      # Key bindings
      # -----------------------------------------------------------------------------

      # Unbind default keys
      unbind C-b
      unbind '"'
      unbind %

      # Split panes
      bind-key x split-window -v
      bind-key v split-window -h

      # Vim-like pane movement
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-j select-pane -D
      bind-key -n M-l select-pane -R

      # From vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l
    '';
  };
}
