echo on

mkdir build
if errorlevel 1 exit /b 1

:: Unset CMAKE_GENERATOR_PLATFORM. The platform is already specified in Conan's preset. Otherwise:
:: Generator
::     Ninja
:: does not support platform specification, but platform
::     x64
:: was specified.
set CMAKE_GENERATOR_PLATFORM=

:: Unset CMAKE_GENERATOR_TOOLSET. Otherwise:
:: Generator
::   Ninja
:: does not support toolset specification, but toolset
::   v142
:: was specified.
set CMAKE_GENERATOR_TOOLSET=

set CMAKE_PREFIX_PATH=build

cmake --preset lue_release_windows_node ^
    %CMAKE_ARGS% ^
    -D CMAKE_INSTALL_LIBDIR=lib ^
    -D LUE_INSTALL_PYTHON_PACKAGE_DIR="%SP_DIR%/lue" ^
    -D LUE_DATA_MODEL_WITH_PYTHON_API=TRUE ^
    -D LUE_DATA_MODEL_WITH_UTILITIES=TRUE ^
    -D LUE_BUILD_VIEW=FALSE ^
    -D LUE_BUILD_QA=TRUE ^
    -D LUE_QA_WITH_PYTHON_API=TRUE ^
    -D LUE_FRAMEWORK_WITH_IMAGE_LAND=TRUE ^
    -D LUE_FRAMEWORK_WITH_PYTHON_API=TRUE ^
    -D HPX_IGNORE_COMPILER_COMPATIBILITY=TRUE ^
    -D Python_EXECUTABLE="%PYTHON%"
if errorlevel 1 exit /b 1

cmake --build build --config Release --target all
if errorlevel 1 exit /b 1

cmake --install build --config Release --component lue_runtime
if errorlevel 1 exit /b 1
