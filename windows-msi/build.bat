REM update submodules
git submodule update --init --recursive

REM bootstrap vcpkg
call %~dp0\vcpkg\bootstrap-vcpkg.bat

REM build openvpn
cd %~dp0\openvpn
msbuild /m /p:Configuration=Release /p:Platform=x64 .
msbuild /m /p:Configuration=Release /p:Platform=Win32 .
msbuild /m /p:Configuration=Release /p:Platform=ARM64 .
cd ..

REM build openvpn-gui
cd %~dp0\openvpn-gui
mkdir build_x64
cd build_x64 && cmake -DCMAKE_TOOLCHAIN_FILE=%~dp0\vcpkg\scripts\buildsystems\vcpkg.cmake -A x64 .. && cmake --build . --config Release && cd ..

mkdir build_Win32
cd build_win32 && cmake -DCMAKE_TOOLCHAIN_FILE=%~dp0\vcpkg\scripts\buildsystems\vcpkg.cmake -A Win32 .. && cmake --build . --config Release && cd ..

mkdir build_arm64
cd build_arm64 && cmake -DCMAKE_TOOLCHAIN_FILE=%~dp0\vcpkg\scripts\buildsystems\vcpkg.cmake -A arm64 .. && cmake --build . --config Release && cd ..
cd ..

REM build MSI
cscript build.wsf msi