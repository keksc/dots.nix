{ pkgs, ... }:
{
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
    };
  };
}
