#!/usr/bin/env bash

if [ ! -d ~/blender-git ]
then
  mkdir ~/blender-git
fi

if [ ! -d ~/blender-git/blender ]
then
  cd ~/blender-git
  git clone https://git.blender.org/blender.git
  git submodule update --init --recursive
  git submodule foreach git checkout master
  git submodule foreach git pull --rebase origin master
elif [ -d ~/blender-git/blender -a -d ~/blender-git/.git ]
then
  cd ~/blender-git/blender
  git pull --rebase
  git submodule foreach git pull --rebase origin master
fi

sudo apt-get install git build-essential

cd ~/blender-git/blender
./build_files/build_environment/install_deps.sh --with-all --source ~/blender-git/blender-deps

cd ~/blender-git/blender
make full BUILD_CMAKE_ARGS="-U *SNDFILE* -U *PYTHON* -U *BOOST* -U *Boost* -U *OPENCOLORIO* -U *OPENEXR* -U *OPENIMAGEIO* -U *LLVM* -U *CYCLES* -U *OPENSUBDIV* -U *OPENVDB* -U *COLLADA* -U *FFMPEG* -U *ALEMBIC* -D WITH_CODEC_SNDFILE=ON -D PYTHON_VERSION=3.5 -D WITH_OPENCOLORIO=ON -D OPENCOLORIO_ROOT_DIR=/opt/lib/ocio -D WITH_OPENIMAGEIO=ON -D OPENIMAGEIO_ROOT_DIR=/opt/lib/oiio -D WITH_CYCLES_OSL=ON -D WITH_LLVM=ON -D LLVM_VERSION=3.4 -D OSL_ROOT_DIR=/opt/lib/osl -D LLVM_ROOT_DIR=/opt/lib/llvm -D LLVM_STATIC=ON -D WITH_OPENSUBDIV=ON -D OPENSUBDIV_ROOT_DIR=/opt/lib/osd -D WITH_OPENVDB=ON -D WITH_OPENVDB_BLOSC=ON -D WITH_OPENCOLLADA=ON -D WITH_ALEMBIC=ON -D ALEMBIC_ROOT_DIR=/opt/lib/alembic -D WITH_CODEC_FFMPEG=ON -D FFMPEG_LIBRARIES='avformat;avcodec;avutil;avdevice;swscale;swresample;lzma;rt;theoradec;theora;theoraenc;vorbisenc;vorbisfile;vorbis;ogg;xvidcore;vpx;mp3lame;x264;openjpeg;openjpeg_JPWL'"
