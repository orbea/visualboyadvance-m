# FindSSP.cmake
#
# Find libssp necessary when using gcc with e.g. -fstack-protector=strong
#
# See: http://wiki.osdev.org/Stack_Smashing_Protector
#
# To use:
#
# put a copy into your <project_root>/CMakeScripts/
#
# In your main CMakeLists.txt do something like this:
#
# IF(WIN32)
#     SET(SSP_STATIC ON)
# ENDIF(WIN32)
#
# FIND_PACKAGE(SSP)
#
# IF(SSP_LIBRARY)
#     SET(CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_LINK_EXECUTABLE} ${SSP_LIBRARY}")
#     SET(CMAKE_C_LINK_EXECUTABLE   "${CMAKE_C_LINK_EXECUTABLE}   ${SSP_LIBRARY}")
# ENDIF(SSP_LIBRARY)
#
# BSD 2-Clause License
#
# Copyright (c) 2016, Rafael Kitover
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# only do this when compiling with gcc/g++
IF(NOT (CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_GNUC))
    RETURN()
ENDIF()

GET_FILENAME_COMPONENT(GCC_DIRNAME ${CMAKE_C_COMPILER} DIRECTORY)

EXECUTE_PROCESS(COMMAND ${CMAKE_C_COMPILER} --print-libgcc-file-name OUTPUT_VARIABLE LIBGCC_FILE OUTPUT_STRIP_TRAILING_WHITESPACE)

GET_FILENAME_COMPONENT(LIBGCC_DIRNAME ${LIBGCC_FILE} DIRECTORY)

SET(SSP_SEARCH_PATHS ${GCC_DIRNAME} ${LIBGCC_DIRNAME})

SET(CURRENT_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})

IF(SSP_STATIC)
    IF(WIN32)
        SET(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a)
    ELSE(WIN32)
        SET(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    ENDIF(WIN32)
ENDIF(SSP_STATIC)

FIND_LIBRARY(SSP_LIBRARY
    NAMES ssp libssp
    HINTS ${SSP_SEARCH_PATHS}
    PATH_SUFFIXES lib64 lib lib/x64 lib/x86
)

SET(CMAKE_FIND_LIBRARY_SUFFIXES ${CURRENT_FIND_LIBRARY_SUFFIXES})

FOREACH(VAR GCC_DIRNAME LIBGCC_FILE LIBGCC_DIRNAME SSP_SEARCH_PATHS CURRENT_FIND_LIBRARY_SUFFIXES)
    UNSET(${VAR})
ENDFOREACH()

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(SSP REQUIRED_VARS SSP_LIBRARY)