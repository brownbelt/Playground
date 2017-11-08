cmake_minimum_required(VERSION 2.8)
project(Playground)

if(NOT EXTLIB_BUILD_PATH)
    set(EXTLIB_BUILD_PATH "${CMAKE_BINARY_DIR}/Extlib-Build" CACHE PATH "Route Exlib Build here")
endif()

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if(NOT DEFINED EXTLIB_INSTALL_PREFIX)
        set(EXTLIB_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/Install")
    endif()    
    set(CMAKE_INSTALL_PREFIX "${EXTLIB_INSTALL_PREFIX}" CACHE PATH "Install Path" FORCE)
endif(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    if(NOT DEFINED EXTLIB_BUILD_TYPE)
        set(EXTLIB_BUILD_TYPE "Debug")
    endif()
    set(CMAKE_BUILD_TYPE ${EXTLIB_BUILD_TYPE} CACHE STRING "Choose Extlib Build Type" FORCE)
    set(PROPERTY CACHE CMAKE_BUILD_TYPE
        PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelwithDebInfo" )
endif()

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")

message("Extlib Cache: ${EXTLIB_BUILD_PATH}/ExtlibCache.txt")
message("Current Generator is ${CMAKE_GENERATOR}")
if (EXISTS "${EXTLIB_BUILD_PATH}/ExtlibCache.txt")
    include( "${EXTLIB_BUILD_PATH}/ExtlibCache.txt")
    if(NOT ${CMAKE_GENERATOR} STREQUAL ${EXTLIB_GENERATOR})
        message(FATAL_ERROR "Generators are incompatible")
    endif()

    add_subdirectory("Root")
endif()