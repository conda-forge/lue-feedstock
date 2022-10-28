#!/usr/bin/env bash
set -e
set -x


# LUE may have to patch sources of 3rd party sources it uses (OTF2, HPX, ...). This only works
# when the build directory is not a ѕubdirectory of the source directory.

mkdir $HOME/lue_build && cd $HOME/lue_build

if [[ "$target_platform" == "osx-64" ]]; then
    export CXXFLAGS="${CXXFLAGS} -DTARGET_OS_OSX -D_LIBCPP_DISABLE_AVAILABILITY"
fi

cmake $SRC_DIR -G"Ninja" \
    ${CMAKE_ARGS} \
    -D LUE_INSTALL_PYTHON_PACKAGE_DIR="${SP_DIR}/lue" \
    -D LUE_HAVE_BOOST:BOOL=TRUE \
    -D LUE_HAVE_FMT:BOOL=TRUE \
    -D LUE_HAVE_PYBIND11:BOOL=TRUE \
    -D LUE_HAVE_HDF5:BOOL=TRUE \
    -D LUE_HAVE_GDAL:BOOL=TRUE \
    -D LUE_HAVE_DOCOPT:BOOL=TRUE \
    -D LUE_HAVE_GLFW:BOOL=TRUE \
    -D LUE_HAVE_MS_GSL:BOOL=FALSE \
    -D LUE_HAVE_NLOHMANN_JSON:BOOL=TRUE \
    -D LUE_DATA_MODEL_WITH_PYTHON_API=ON \
    -D LUE_DATA_MODEL_WITH_UTILITIES=ON \
    -D LUE_BUILD_VIEW=ON \
    -D LUE_BUILD_FRAMEWORK=ON \
    -D LUE_FRAMEWORK_WITH_PYTHON_API=ON \
    -D LUE_BUILD_HPX=ON \
    -D HPX_USE_CMAKE_CXX_STANDARD=ON \
    -D HPX_WITH_MALLOC="tcmalloc" \
    -D HPX_WITH_PKGCONFIG=OFF \
    -D HPX_WITH_EXAMPLES=OFF \
    -D HPX_WITH_TESTS=OFF \
    -D Python3_EXECUTABLE="${PYTHON}"

# Use parallel build for as many targets as possible, but not for framework/algorithm
cmake --build . --target source/{data_model,view}/all source/framework/{core,partitioned_array}/all

# Build remaining targets with fewer cores. Compiling these modules requires more memory.
cmake --build . --target all --parallel 2

cmake --install . --component hpx_runtime
cmake --install . --component lue_runtime
