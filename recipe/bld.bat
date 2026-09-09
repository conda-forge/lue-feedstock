mkdir build
if errorlevel 1 exit /b 1

cmake -S . -B build %CMAKE_ARGS% ^
    --preset lue_release_windows_node ^
    -G Ninja ^
    -D CMAKE_INSTALL_LIBDIR=lib ^
    -D LUE_INSTALL_PYTHON_PACKAGE_DIR="%SP_DIR%/lue" ^
    -D LUE_DATA_MODEL_WITH_PYTHON_API=TRUE ^
    -D LUE_DATA_MODEL_WITH_UTILITIES=TRUE ^
    -D LUE_BUILD_VIEW=FALSE ^
    -D LUE_BUILD_QUALITY_ASSURANCE=TRUE ^
    -D LUE_QUALITY_ASSURANCE_WITH_PYTHON_API=TRUE ^
    -D LUE_FRAMEWORK_WITH_IMAGE_LAND=FALSE ^
    -D LUE_FRAMEWORK_WITH_PYTHON_API=TRUE ^
    -D Python_EXECUTABLE="%PYTHON%"
if errorlevel 1 exit /b 1

REM Build runs out of memory. Replacing %CPU_COUNT% by 3 (one core less than available)
cmake --build build --config Release --target all --parallel 3
if errorlevel 1 exit /b 1

cmake --install build --config Release --component lue_runtime
if errorlevel 1 exit /b 1
