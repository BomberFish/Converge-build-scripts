CX="https://media.codeweavers.com/pub/crossover/source/crossover-sources-25.0.1.tar.gz"
GPTK="https://github.com/Gcenx/game-porting-toolkit/releases/download/Game-Porting-Toolkit-3.0-beta1/game-porting-toolkit-3.0-beta1.tar.xz"
DXVK="https://github.com/doitsujin/dxvk/releases/download/v2.6.2/dxvk-2.6.2.tar.gz"
DXMT="https://github.com/3Shain/dxmt/releases/download/v0.60/dxmt-v0.60-builtin.tar.gz"
MVK="https://github.com/KhronosGroup/MoltenVK/releases/download/v1.3.0-rc1/MoltenVK-macos.tar"

rm -rf work/bundled
mkdir -p work
cd work
if [ ! -d cx ]; then
    mkdir -p cx
    echo "[*] CrossOver"
    curl -L "$CX" | tar xz --strip-components=1 -C cx
fi
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

set -e
cd cx/wine
echo "[*] Building 64-bit Wine"
export MACOSX_DEPLOYMENT_TARGET=15.0
PATH="/opt/homebrew/opt/llvm/bin:/opt/homebrew/opt/bison/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin MACOSX_DEPLOYMENT_TARGET=15.0" ./configure CC="clang" CXX="clang++" --enable-win32on64 --host=x86_64-apple-darwin24.0.0
make -j$(sysctl -n hw.ncpu)
cd ../..
set +e

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
