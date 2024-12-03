{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${toString ./wallpapers/yandere.png}" ];
      wallpaper = [
        ",${toString ./wallpapers/yandere.png}"
      ];
    };
  };
}
