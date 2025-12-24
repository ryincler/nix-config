{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation rec {
  pname = "iosevka-fixed";
  version = "33.3.6";

  src = fetchzip {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/SuperTTC-SGr-IosevkaFixed-${version}.zip";
    sha256 = "sha256-HH0ZHhs18OtoPGF23BpSq3W3hShTjQ0pLTJsbAXh/BI=";
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

