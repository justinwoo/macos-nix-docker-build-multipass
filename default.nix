{ system ? builtins.currentSystem
, pkgs ? import ./nix/pinned-24_05.nix { inherit system; }
}:

let
  base-image = pkgs.dockerTools.buildImage {
    name = "hello-docker";

    copyToRoot = pkgs.buildEnv {
      name = "image-root";
      paths = with pkgs; [
        coreutils
        bashInteractive
      ];
      pathsToLink = [
        "/"
      ];
    };
  };

in
pkgs.dockerTools.buildLayeredImage {
  name = "hello-layered";

  fromImage = base-image;

  contents = [
    pkgs.hello
  ];

  config = {
    Cmd = "hello";
  };
}
