{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "iosevka-fixed";
  version = "33.2.4";

  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaFixed-${version}.zip";
    sha256 = "sha256-1bl9nXzzFRXB1BWYl2iTI8qBemzVNHGiJP/79X4q+cw=";
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

