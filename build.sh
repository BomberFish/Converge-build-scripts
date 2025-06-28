GPTK="https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-3.0-beta1/game-porting-toolkit-3.0-beta1.tar.xz"
# DXVK="https://github.com/doitsujin/dxvk/releases/download/v2.6.2/dxvk-2.6.2.tar.gz"
DXMT="https://github.com/3Shain/dxmt/releases/download/v0.60/dxmt-v0.60-builtin.tar.gz"
# MVK="https://github.com/KhronosGroup/MoltenVK/releases/download/v1.3.0-rc1/MoltenVK-macos.tar"

mkdir -p work
cd work
# rm -rf *
mkdir -p dxmt gptk
# echo "[*] DXVK"
# curl -L "$DXVK" | tar xz --strip-components=1 -C dxvk
#if dxmt isnt downloaded
if [ ! -d dxmt ]; then
    echo "[*] DXMT"
    curl -L "$DXMT" | tar xz --strip-components=1 -C dxmt
fi
# echo "[*] MoltenVK"
# curl -L "$MVK" | tar xz --strip-components=1 -C mvk
if [ ! -d gptk ]; then
    echo "[*] Game Porting Toolkit"
    curl -L "$GPTK" | tar xJ --strip-components=1 -C gptk
fi

mkdir -p bundled/Converge.bundle

cp -r gptk/Contents/Resources/wine bundled/Converge.bundle/

cp -r dxmt/i386-windows/* bundled/Converge.bundle/wine/lib/wine/i386-windows
cp -r dxmt/x86_64-windows/* bundled/Converge.bundle/wine/lib/wine/x86_64-windows
cp -r dxmt/x86_64-unix/* bundled/Converge.bundle/wine/lib/wine/x86_64-unix
