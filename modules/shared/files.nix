{ ... }:

{
  # Vim won't create this
  ".local/state/vim/undo/.keep".text = "";

  # Private halves in Bitwarden
  ".ssh/id_personal.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJnXxpMb9oT+WVzgsDudTm2wo+a78fWsydWXRK4bFnDS\n";
  ".ssh/id_albacore.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEhhXsoID9MS10YXPV0FTtzwzVecZV0nEJs2U9Rus1ob\n";
  ".ssh/id_general.pub".text =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE0AQwCemBJeR4calT4tKXcEoTS0TGSZ5RZrz6ft7K3n\n";

  # No home-manager option
  ".claude/keybindings.json".source = ./config/claude/keybindings.json;
  ".claude/CLAUDE.md".source = ./config/claude/CLAUDE.md;
}
