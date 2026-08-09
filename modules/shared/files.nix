{ pkgs, config, ... }:

{
  # Vim state dirs, vim will not create them
  ".config/vim/undo/.keep".text = "";
  ".config/vim/backups/.keep".text = "";
  ".config/vim/swap/.keep".text = "";
}
