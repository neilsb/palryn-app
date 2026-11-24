{ pkgs, release }:

with pkgs;
stdenvNoCC.mkDerivation {
  pname = "palryn";
  inherit (release) version;
  src = fetchurl {
    url = "https://downloads.palryn.app/v${release.version}/Palryn_${release.version}_amd64.deb";
    sha256 = release.sha256;
  };

  dontUnpack = true;
  dontStrip = true;
  nativeBuildInputs = [ dpkg autoPatchelfHook wrapGAppsHook3 ];
  buildInputs = [
    stdenv.cc.cc.lib cairo gdk-pixbuf glib gtk3 libsoup_3 webkitgtk_4_1
    glib-networking gsettings-desktop-schemas
  ];

  installPhase = ''
    runHook preInstall
    dpkg-deb -x "$src" unpacked
    mkdir -p "$out"
    cp -a unpacked/usr/. "$out/"
    runHook postInstall
  '';

  preFixup = ''
    # The host Mesa driver may require a newer glibc than this pinned runtime.
    # Avoid loading it through WebKit's DMA-BUF renderer on Wayland.
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]}
      --set PALRYN_NIX_MANAGED 1
      --set-default WEBKIT_DISABLE_DMABUF_RENDERER 1
    )
  '';

  meta = {
    description = "MongoDB desktop workspace";
    homepage = "https://palryn.app";
    license = lib.licenses.unfree;
    mainProgram = "palryn";
    platforms = [ "x86_64-linux" ];
  };
}
