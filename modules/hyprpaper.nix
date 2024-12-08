{
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "${toString ./assets/yandere.png}" ];
      wallpaper = [
        ",${toString ./assets/yandere.png}"
      ];
    };
  };
}
