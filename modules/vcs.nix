{
  programs.git = {
    enable = true;
    userName = "keksc";
    userEmail = "pboursin2008@orange.fr";
    lfs.enable = true;
  };
  programs.gh.enable = true;
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "pboursin2008@orange.fr";
        name = "keksc";
      };
    };
  };
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        editor = "nvim";
        diff-editor = "nvim";
      };
    };
  };
  programs.jjui.enable = true;
}
