{ pkgs }:
let
  emacs29 = pkgs.emacsPackagesFor pkgs.emacs-unstable;
  treesit-grammars = emacs29.treesit-grammars.with-all-grammars;
in
{
  pkg = emacs29.emacsWithPackages (
    epkgs: with epkgs; [
      ace-window
      catppuccin-theme
      company
      consult
      consult-flycheck
      dirvish
      doom-modeline
      embark
      embark-consult
      envrc
      evil
      evil-collection
      flycheck
      general
      ligature
      lsp-mode
      lsp-ui
      magit
      marginalia
      nerd-icons
      nerd-icons-completion
      nerd-icons-dired
      nerd-icons-ibuffer
      nix-ts-mode
      ob-mermaid
      orderless
      org-bullets
      org-roam
      pdf-tools
      treesit-grammars
      treesit-auto
      vertico
      vterm
      which-key
    ]
  );
  treesit-grammars = treesit-grammars;
}
