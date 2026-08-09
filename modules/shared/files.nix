{ ... }:

{
  # Vim state dir, vim will not create it
  ".local/state/vim/undo/.keep".text = "";

  # Public halves of the Bitwarden-held SSH keys
  ".ssh/id_personal.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnXxpMb9oT+WVzgsDudTm2wo+a78fWsydWXRK4bFnDS\n";
  ".ssh/id_albacore.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEhhXsoID9MS10YXPV0FTtzwzVecZV0nEJs2U9Rus1ob\n";
  ".ssh/id_general.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0AQwCemBJeR4calT4tKXcEoTS0TGSZ5RZrz6ft7K3n\n";

  # Claude Code config, no home-manager option
  ".claude/keybindings.json".source = ./config/claude/keybindings.json;
  ".claude/CLAUDE.md".source = ./config/claude/CLAUDE.md;
}
