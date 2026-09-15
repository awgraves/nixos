{ inputs, config, pkgs, git-config-dir, ... }:

{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  # Import files from the current configuration directory into the Nix store,
  # and create symbolic links pointing to those store files in the Home directory.

  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # Import the scripts directory into the Nix store,
  # and recursively generate symbolic links in the Home directory pointing to the files in the store.
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    fastfetch

    # utils
    #ripgrep # recursively searches directories for a regex pattern
    #fzf # A command-line fuzzy finder
    lazygit

    # networking tools
    dnsutils  # `dig` + `nslookup`
    nmap # A utility for network discovery and security auditing

    lm_sensors # for `sensors` command
    pciutils # lspci
    usbutils # lsusb

    # apps
    brave
  ];

  programs.git = {
    enable = true;
    userName = "Andrew Organist";
    userEmail = "aorganist@protonmail.com";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "echo what";
      nrs = "sudo nixos-rebuild switch";
      gc = "sudo nix-collect-garbage";
    };
  };

  # Enable XDG base dir management
  xdg.enable = true;
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/${git-config-dir}/app_configs/niri/config.kdl";

  programs.noctalia = {
    enable = true;

    settings = {
     theme = {
       mode="dark";
       source = "wallpaper";
      };

      foo = "bar";
    };
  };

  programs.brave = {
    enable = true;
    extensions = [
      { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # proton pass
      { id = "gighmmpiobklfepjocnamgkkbiglidom"; } # ad block
      { id = "dphilobhebphkdjbpfohgikllaljmgbn"; } # simplelogin
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
    ];
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "26.05";
}
