# SPDX-License-Identifier: Apache-2.0
set_property(GLOBAL PROPERTY CSTD c11)

cmake_minimum_required(VERSION 3.13.1)
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(dumb_http_server)

# FILE(GLOB app_sources src/*.c)
FILE(GLOB app_sources src/extra.c src/build/*.c)
target_sources(app PRIVATE ${app_sources})

set(gen_dir ${ZEPHYR_BINARY_DIR}/include/generated/)
include(${ZEPHYR_BASE}/samples/net/common/common.cmake)
