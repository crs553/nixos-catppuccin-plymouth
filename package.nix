{
  lib,
  stdenv,
  imagemagick,
}:

stdenv.mkDerivation {
  pname = "plymouth-theme-nixos-catppuccin-mauve";
  version = "1.0.0";

  nativeBuildInputs = [
    imagemagick
  ];

  dontUnpack = true;

  buildPhase = ''
    runHook preBuild

    themeDir=${./themes/nixos-catppuccin-mauve}

    cp $themeDir/*.plymouth ./
    cp $themeDir/*.script ./
    cp $themeDir/NixOS-Logo.png ./

    convert NixOS-Logo.png -resize 512x512 logo.png
    rm -f NixOS-Logo.png

    convert -size 7x7 xc:none \
      -fill '#cba6f7' \
      -draw 'circle 4,4 4,1' \
      bullet.png

    convert -size 400x40 xc:none \
      -fill '#1e1e2e' -stroke '#cba6f7' -strokewidth 2 \
      -draw 'roundrectangle 1,1 398,38 8,8' \
      entry.png

    convert -size 84x96 xc:none \
      -fill '#cba6f7' \
      -draw 'roundrectangle 18,42 66,92 6,6' \
      -draw 'roundrectangle 28,12 56,42 10,10' \
      -fill '#1e1e2e' \
      -draw 'roundrectangle 32,20 52,42 6,6' \
      -draw 'roundrectangle 34,60 50,80 4,4' \
      -fill '#cba6f7' \
      -draw 'rectangle 41,72 43,80' \
      lock.png

    convert -size 400x8 xc:'#cba6f7' progress_bar.png

    convert -size 400x12 xc:none \
      -fill '#313244' -stroke '#45475a' -strokewidth 1 \
      -draw 'roundrectangle 1,1 398,10 5,5' \
      progress_box.png

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/plymouth/themes/nixos-catppuccin-mauve
    cp *.png *.plymouth *.script $out/share/plymouth/themes/nixos-catppuccin-mauve/
    sed -i "s@ImageDir=/usr/share@ImageDir=$out/share@g" $out/share/plymouth/themes/nixos-catppuccin-mauve/*.plymouth
    sed -i "s@ScriptFile=/usr/share@ScriptFile=$out/share@g" $out/share/plymouth/themes/nixos-catppuccin-mauve/*.plymouth

    runHook postInstall
  '';

  meta = with lib; {
    description = "Catppuccin Mocha Mauve Plymouth theme for NixOS";
    longDescription = ''
      A Plymouth boot splash theme for NixOS featuring a static NixOS logo
      in Catppuccin Mocha Mauve (#cba6f7). Based on the Omarchy Plymouth
      theme design with smooth fake-progress animation, LUKS password dialog,
      and multi-monitor support.
    '';
    homepage = "https://github.com/your-username/plymouth-nix";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
