cmake_minimum_required(VERSION 3.6)
project(Playground_Extlib)

include(ExternalProject)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if(NOT DEFINED EXTLIB_INSTALL_PREFIX)
        set(EXTLIB_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/Install")
    endif()    
    set(CMAKE_INSTALL_PREFIX "${EXTLIB_INSTALL_PREFIX}" CACHE PATH "Install Path" FORCE)
endif(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)

if (NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT CMAKE_BUILD_TYPE)
        if(NOT DEFINED EXTLIB_BUILD_TYPE)
            set(EXTLIB_BUILD_TYPE "Release")
        endif()
        set(CMAKE_BUILD_TYPE ${EXTLIB_BUILD_TYPE} CACHE STRING "Choose Extlib Build Type" FORCE)
        set(PROPERTY CACHE CMAKE_BUILD_TYPE
            PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelwithDebInfo" )
        message("CMake hasnt set build type")
    else()
        message("CMake already set build type ${CMAKE_BUILD_TYPE}")
    endif()
endif()

set(EXTLIB_PROJECT_DIR "${CMAKE_BINARY_DIR}/Projects")
set(KEYSTONE_PROJECT_DIR "${EXTLIB_PROJECT_DIR}/KeystoneEngine")

set(EXTLIB_TARGETS)


ExternalProject_Add(KeystoneEngine
    GIT_REPOSITORY "https://github.com/keystone-engine/keystone.git"
    GIT_TAG db87c0bcc233a6e88ef09f8aec276e28b6b38d4b

    CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}

    PATCH_COMMAND ${CMAKE_COMMAND} -E copy
        "${CMAKE_SOURCE_DIR}/patch/KeystoneEngine/llvm/keystone/CMakeLists.txt"
        "<SOURCE_DIR>/llvm/keystone/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E copy
        "${CMAKE_SOURCE_DIR}/patch/KeystoneEngine/llvm/keystone/keystone-config.cmake"
        "<SOURCE_DIR>/llvm/keystone/keystone-config.cmake"

    PREFIX "${KEYSTONE_PROJECT_DIR}"
    BINARY_DIR "${KEYSTONE_PROJECT_DIR}/build"
    TMP_DIR "${KEYSTONE_PROJECT_DIR}/temp"
    STAMP_DIR "${KEYSTONE_PROJECT_DIR}/stamp"
)

list(APPEND EXTLIB_TARGETS KeystoneEngine)

ExternalProject_Get_Property(KeystoneEngine BINARY_DIR)
set(KEYSTONE_BUILD_DIR ${BINARY_DIR})

include("cmake/CompilerSettings.cmake")
include("cmake/WriteInitialCache.cmake")

ExtlibWriteConfig(
    OUTPUT_FILE "${CMAKE_BINARY_DIR}/TempCache.txt"
    CMAKE_CACHE_ARGS

        ${EXTLIB_COMPILER_ARGS}

        -DEXTLIB_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
        -DEXTLIB_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DEXTLIB_GENERATOR:STRING=${CMAKE_GENERATOR}

        -DEXTILB_TARGETS_DIR:PATH=${CMAKE_INSTALL_PREFIX}/targets
        -DKEYSTONE_DIR:PATH=${KEYSTONE_BUILD_DIR}
        # -DKSTOOL_:FILEPATH=${CMAKE_INSTALL_PREFIX}/targets/ktstoolTarget.cmake
)

add_custom_command(OUTPUT "${CMAKE_BINARY_DIR}/ExtlibCache.txt"
    COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_BINARY_DIR}/TempCache.txt" "${CMAKE_BINARY_DIR}/ExtlibCache.txt"
    DEPENDS "${CMAKE_BINARY_DIR}/TempCache.txt"
    COMMENT "Generating ExtlibCache.txt"
)

add_custom_target(ExtlibCache ALL
    DEPENDS ${EXTLIB_TARGETS} "${CMAKE_BINARY_DIR}/ExtlibCache.txt"
)