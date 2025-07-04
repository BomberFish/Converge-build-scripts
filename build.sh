WINE="https://github.com/Gcenx/macOS_Wine_builds/releases/download/10.10/wine-devel-10.10-osx64.tar.xz"
DXVK="https://github.com/doitsujin/dxvk/releases/download/v2.6.2/dxvk-2.6.2.tar.gz"
DXMT="https://github.com/3Shain/dxmt/releases/download/v0.60/dxmt-v0.60-builtin.tar.gz"
MVK="https://github.com/KhronosGroup/MoltenVK/releases/download/v1.3.0-rc1/MoltenVK-macos.tar"

if [ ! -d redist ]; then
    echo "[!!] Please copy the redist folder from 'Evaluation environment for Windows games 3.0 beta 1' to the root of this repository."
    exit 1
fi

mkdir -p work
cd work
if [ ! -d wine ]; then
    mkdir -p wine
    echo "[*] Wine"
    curl -L "$WINE" | tar xJ --strip-components=1 -C wine
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

mkdir -p bundled/Converge.bundle

echo "[»] Wine"
cp -r wine/Contents/Resources/wine bundled/Converge.bundle/
cd bundled/Converge.bundle/wine/bin
ln -s wine wine64
cd ../../../../

echo "[»] Game Porting Toolkit"
cp -r ../redist/lib/external bundled/Converge.bundle/wine/lib/
cp ../redist/lib/wine/x86_64-windows/* bundled/Converge.bundle/wine/lib/wine/x86_64-windows/
cp bundled/Converge.bundle/wine/lib/wine/x86_64-windows/nvngx-on-metalfx.dll bundled/Converge.bundle/wine/lib/wine/x86_64-windows/nvngx.dll
cd bundled/Converge.bundle/wine/lib/wine/x86_64-unix

for lib in atidxx64.so d3d10.so d3d11.so d3d12.so dxgi.so nvapi64.so nvngx.so nvngx-on-metalfx.so; do
    ln -s ../../external/libd3dshared.dylib "$lib"
done

cd ../../../../../../

echo "[»] MoltenVK"
cp -r mvk/MoltenVK/dynamic/dylib/macOS/libMoltenVK.dylib bundled/Converge.bundle/wine/lib/

echo "[»] DXMT"
cp -r dxmt bundled/Converge.bundle/wine/lib/

echo "[»] DXVK"
mkdir -p bundled/Converge.bundle/wine/lib/dxvk
cp -r dxvk/x32 bundled/Converge.bundle/wine/lib/dxvk/i386-windows
cp -r dxvk/x64 bundled/Converge.bundle/wine/lib/dxvk/x86_64-windows
