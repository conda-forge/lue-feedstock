#!/usr/bin/env bash
set -e

mkdir build
cd build

set lue_build_view="TRUE"

if [[ "$target_platform" == "osx-64" ]]; then
    export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
    export CXXFLAGS="${CXXFLAGS} -DTARGET_OS_OSX"
fi

if [[ "$target_platform" == "osx-arm64" ]]; then
    export CXXFLAGS="${CXXFLAGS} -DTARGET_OS_OSX"
    # Conan fails to build imgui
    set lue_build_view="FALSE"
fi

cmake \
    .. \
    -G "Ninja" \
    ${CMAKE_ARGS} \
    -D CMAKE_BUILD_TYPE="Release" \
    -D LUE_INSTALL_PYTHON_PACKAGE_DIR="${SP_DIR}/lue" \
    -D LUE_HAVE_DOCOPT:BOOL=TRUE \
    -D LUE_HAVE_MS_GSL:BOOL=FALSE \
    -D LUE_DATA_MODEL_WITH_PYTHON_API=TRUE \
    -D LUE_DATA_MODEL_WITH_UTILITIES=TRUE \
    -D LUE_BUILD_QA=TRUE \
    -D LUE_QA_WITH_PYTHON_API=TRUE \
    -D LUE_FRAMEWORK_WITH_PYTHON_API=TRUE \
    -D LUE_BUILD_VIEW=$lue_build_view \
    -D HPX_IGNORE_COMPILER_COMPATIBILITY=TRUE \
    -D Python3_EXECUTABLE="${PYTHON}"

cmake --build . --target all
cmake --install . --component lue_runtime
