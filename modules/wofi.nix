{
  programs.wofi = {
    enable = true;
    style = ''
      window {
        margin: 1px;
        border-radius: 10px;
        background: radial-gradient(circle, rgba(255, 0, 198, 0.8), rgba(155, 38, 118, 0.1) 100%);
      }

      #input, #entry {
        color: white;
      }

      #input {
        margin: 5px;
        border-color: rgba(195, 23, 87, 0.7);
        background: linear-gradient(331deg, rgba(255, 0, 87, 1) 0%, rgba(155, 38, 118, 1) 100%);
      }

      #inner-box {
        margin: 5px;
      }

      #entry:selected {
        background-color: rgba(155, 28, 118, 0.7);
      }
    '';
    settings = {
      allow_images = true;
      insensitive = true;
      location = "center";
      width = "300px";
      height = "200px";
      border-width = "0";
      show = "drun";
    };
  };
}
