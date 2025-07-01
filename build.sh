GPTK="https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-3.0-beta1/game-porting-toolkit-3.0-beta1.tar.xz"
DXVK="https://github.com/doitsujin/dxvk/releases/download/v2.6.2/dxvk-2.6.2.tar.gz"
DXMT="https://github.com/3Shain/dxmt/releases/download/v0.60/dxmt-v0.60-builtin.tar.gz"
MVK="https://github.com/KhronosGroup/MoltenVK/releases/download/v1.3.0-rc1/MoltenVK-macos.tar"

mkdir -p work
cd work
# rm -rf *
if [ ! -d dxvk ]; then
    mkdir -p dxvk
    echo "[*] DXVK"
    curl -L "$DXVK" | tar xz --strip-components=1 -C dxvk
fi
if [ ! -d dxmt ]; then
    mkdir -p dxmt
    echo "[*] DXMT"
    curl -L "$DXMT" | tar xz --strip-components=1 -C dxmt
fi
if [ ! -d mvk ]; then
    mkdir -p mvk
    echo "[*] MoltenVK"
    curl -L "$MVK" | tar xz --strip-components=1 -C mvk
fi
if [ ! -d gptk ]; then
    mkdir -p gptk
    echo "[*] Game Porting Toolkit"
    curl -L "$GPTK" | tar xJ --strip-components=1 -C gptk
fi

mkdir -p bundled/Converge.bundle

echo "[»] Game Porting Toolkit"
cp -r gptk/Contents/Resources/wine bundled/Converge.bundle/
echo "[*] Patching DLSS"
mv bundled/Converge.bundle/wine/lib/wine/x86_64-windows/nvngx-on-metalfx.dll bundled/Converge.bundle/wine/lib/wine/x86_64-windows/nvngx.dll

echo "[»] MoltenVK"
cp -r mvk/MoltenVK/dynamic/dylib/macOS/libMoltenVK.dylib bundled/Converge.bundle/wine/lib/

echo "[»] DXMT"
cp -r dxmt bundled/Converge.bundle/wine/lib/

echo "[»] DXVK"
mkdir -p bundled/Converge.bundle/wine/lib/dxvk
cp -r dxvk/x32 bundled/Converge.bundle/wine/lib/dxvk/i386-windows
cp -r dxvk/x64 bundled/Converge.bundle/wine/lib/dxvk/x86_64-windows
