{
  inputs = {
    systems.url = "github:nix-systems/default";
    ocaml-overlays.url = "github:nix-ocaml/nix-overlays";
  };

  outputs =
    {
      self,
      systems,
      nixpkgs,
      ocaml-overlays,
      ...
    }:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          let
            pkgs = nixpkgs.legacyPackages.${system}.extend ocaml-overlays.overlays.default;
          in
          f {
            inherit pkgs system;
            ocamlPackages = pkgs.ocaml-ng.ocamlPackages_latest.overrideScope (
              oself: osuper: {
                # A temporary fix to prevent build failures.
                dune_3 = osuper.dune_3.overrideAttrs rec {
                  version = "3.16.1";
                  src = pkgs.fetchurl {
                    url = "https://github.com/ocaml/dune/releases/download/${version}/dune-${version}.tbz";
                    hash = "sha256-t4GuIPh2E8KhG9BxeAngBHDILWFeFSZPmmTgMwUaw94=";
                  };
                };
              }
            );
          }
        );
    in
    {
      ocamlPackages = eachSystem ({ ocamlPackages, ... }: ocamlPackages);

      packages = eachSystem (
        { pkgs, ocamlPackages, ... }:
        {
          default = ocamlPackages.buildDunePackage {
            pname = "dotenvy";
            version = "n/a";
            duneVersion = "3";
            src = self.outPath;
            buildInputs = with ocamlPackages; [ ocaml-syntax-shims ];
            doCheck = true;
            checkInputs = with ocamlPackages; [
              alcotest
            ];
          };
        }
      );

      devShells = eachSystem (
        { pkgs, ocamlPackages, ... }:
        {
          default = pkgs.mkShell {
            inputsFrom = [ self.packages.${pkgs.system}.default ];
            buildInputs = with ocamlPackages; [
              ocaml-lsp
              ocamlformat
              ocp-indent
              utop
              odoc
            ];
          };

          odoc = pkgs.mkShell {
            inputsFrom = [ self.packages.${pkgs.system}.default ];
            buildInputs = with ocamlPackages; [
              odoc
            ];
          };
        }
      );
    };
}
