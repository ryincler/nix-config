{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "iosevka-fixed";
  version = "33.2.6";

  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaFixed-${version}.zip";
    sha256 = "sha256-a/YY9BgS7TNX1Gu/jrVOLqvAdMAVXrjKdk7PQ/UXWDw=";
  };

  installPhase = ''
    mkdir -p $out/share/fonts
    cp -r * $out/share/fonts/
  '';

  meta = with lib; {
    description = "Iosevka monospace font.";
    homepage = "https://github.com/be5invis/Iosevka";
    license = licenses.ofl;
    platforms = platforms.all;
  };
}

