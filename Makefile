 #############################################################################
 # Copyright (c) 2020 Cisco and/or its affiliates.
 # Licensed under the Apache License, Version 2.0 (the "License");
 # you may not use this file except in compliance with the License.
 # You may obtain a copy of the License at:
 #
 #     http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
 ##############################################################################

default.target: help

export BASE_DIR=$(shell pwd)

init:
	@mkdir -p usr/lib && mkdir -p usr/include && mkdir -p src

openssl: init
	@if [ ! -d usr/include/openssl ]; then cd scripts/OpenSSL-for-iPhone && ./build-libssl.sh --cleanup  --deprecated --targets="ios-sim-cross-x86_64 ios64-cross-arm64 ios64-cross-arm64e" && cp -r include/openssl ../../usr/include && cp -r lib/*.a ../../usr/lib; fi;
	
download_libevent: init
	@cd ${BASE_DIR}/src && if [ ! -d libevent ]; then echo "libevent not found"; git clone https://github.com/libevent/libevent.git; cd libevent; git checkout tags/release-2.1.11-stable; fi;

libevent: download_libevent
	@mkdir -p build/libevent && cd build/libevent && cmake ${BASE_DIR}/src/libevent -G Xcode -DCMAKE_TOOLCHAIN_FILE=${BASE_DIR}/cmake/ios.toolchain.cmake -DPLATFORM=OS64COMBINED -DCMAKE_FIND_ROOT_PATH=${BASE_DIR}/usr -DCMAKE_INSTALL_PREFIX=${BASE_DIR}/usr -DOPENSSL_ROOT_DIR=${BASE_DIR}/usr -DEVENT__DISABLE_TESTS=ON -DEVENT__DISABLE_SAMPLES=ON -DEVENT__LIBRARY_TYPE=STATIC -DEVENT__HAVE_EPOLL=OFF -DEVENT__HAVE_PIPE2=OFF -DEVENT__DISABLE_BENCHMARK=ON && cmake --build . --config Release --target install

download_libparc: init
	@cd ${BASE_DIR}/src && if [ ! -d cframework ]; then echo "cframework not found"; git clone -b cframework/master https://gerrit.fd.io/r/cicn cframework; fi;

libparc: download_libparc
	@mkdir -p build/libparc && cd build/libparc && cmake ${BASE_DIR}/src/cframework/libparc -G Xcode -DCMAKE_TOOLCHAIN_FILE=${BASE_DIR}/cmake/ios.toolchain.cmake -DPLATFORM=OS64COMBINED -DCMAKE_FIND_ROOT_PATH=${BASE_DIR}/usr -DCMAKE_INSTALL_PREFIX=${BASE_DIR}/usr -DOPENSSL_ROOT_DIR=${BASE_DIR}/usr -DDISABLE_EXECUTABLES=ON -DDISABLE_SHARED_LIBRARIES=ON -DDEPLOYMENT_TARGET=13.0 && cmake --build . --config Release --target install

download_libconfig: init
	@cd ${BASE_DIR}/src && if [ ! -d libconfig ]; then echo "libconfig not found"; git clone https://github.com/hyperrealm/libconfig.git; cd libconfig; git checkout a6b370e78578f5bf594f8efe0802cdc9b9d18f1a; fi;

libconfig: download_libconfig
	@mkdir -p build/libconfig && cd build/libconfig && cmake ${BASE_DIR}/src/libconfig -G Xcode -DCMAKE_TOOLCHAIN_FILE=${BASE_DIR}/cmake/ios.toolchain.cmake -DPLATFORM=OS64COMBINED -DCMAKE_FIND_ROOT_PATH=${BASE_DIR}/usr -DCMAKE_INSTALL_PREFIX=${BASE_DIR}/usr -DBUILD_SHARED_LIBS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF && cmake --build . --config Release --target install

download_asio: init
	@cd ${BASE_DIR}/src && if [ ! -d asio ]; then echo "Asio directory not found"; git clone https://github.com/chriskohlhoff/asio.git; cd asio; git checkout tags/asio-1-12-2;	fi;

asio: download_asio
	@if [ ! -d ${BASE_DIR}/usr/include/asio ]; then cp -r ${BASE_DIR}/src/asio/asio/include/asio* ${BASE_DIR}/usr/include/; fi;

download_hicn: init
	@cd ${BASE_DIR}/src && if [ ! -d hicn ]; then echo "libhicn not found"; git clone https://github.com/FDio/hicn.git; fi;

hicn: download_hicn
	@mkdir -p build/hicn && cd build/hicn && cmake ${BASE_DIR}/src/hicn -G Xcode -DCMAKE_TOOLCHAIN_FILE=${BASE_DIR}/cmake/ios.toolchain.cmake -DPLATFORM=OS64COMBINED -DCMAKE_FIND_ROOT_PATH=${BASE_DIR}/usr  -DCMAKE_INSTALL_PREFIX=${BASE_DIR}/usr -DOPENSSL_ROOT_DIR=${BASE_DIR}/usr -DDISABLE_EXECUTABLES=ON -DDISABLE_SHARED_LIBRARIES=ON -DDEPLOYMENT_TARGET=13.0 && cmake --build . --config Release --target install

update_hicn: init
	@if [ -d ${BASE_DIR}/src/hicn ]; then cd ${BASE_DIR}/src/hicn; git pull; fi;

update_libparc: init
	@if [ -d ${BASE_DIR}/src/cframework ]; then cd ${BASE_DIR}/src/cframework; git pull; fi;

update: update_libparc update_hicn

all: openssl libevent libconfig asio libparc hicn

help:
	@echo "---- Basic build targets ----"
	@echo "make all					- Compile hICN libraries and the dependencies"
	@echo "make openssl					- Compile openssl"
	@echo "make download_libevent				- Download libevent"
	@echo "make libevent					- Download and compile libevent"
	@echo "make download_libparc				- Download libparc source code"
	@echo "make libparc					- Download and compile libparc"
	@echo "make download_libconfig				- Download libconfig source code"
	@echo "make libconfig					- Download and compile libconfig"
	@echo "make download_asio				- Download asio source code"
	@echo "make asio					- Download and install asio"
	@echo "make download_hicn				- Download hicn source code"
	@echo "make hicn					- Download and compile hicn"
	@echo "make update					- Update hicn and libparc source code"
	@echo "make update_hicn				- Update hicn source code"
	@echo "make update_libparc				- Update libparc source code"	