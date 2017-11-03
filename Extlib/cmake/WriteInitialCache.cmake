# WriteInitialCache.cmake

function(_extlibParseCacheArgs output_var args)
    # Parse set of -D<variable-name>:<type>=<value> into coressponding
    # lines of cmake "set cache" statements of the form:
    # set(<variable-name> <value> CACHE <type> "Initial cache" FORCE)
    set(script_initial_cache "")
    set(regex "^([^:]+):([^=]+)=(.*)$")
    set(setArg "")
    foreach(line ${args})
        if("${line}" MATCHES "^-D")
            if(setArg)
                # This is required to build up lists in variables, or complete
                # an entry
                set(setArg
                    "${setArg}${accumulator}\" CACHE ${type} \"Initial cache\" FORCE)"
                )
                set(script_initial_cache "${script_initial_cache}\n${setArg}")
                set(accumulator "")
                set(setArg "")
            endif()
            string(REGEX REPLACE "^-D" "" line ${line})
            if("${line}" MATCHES "${regex}")
                string(REGEX MATCH "${regex}" match "${line}")
                set(name "${CMAKE_MATCH_1}")
                set(type "${CMAKE_MATCH_2}")
                set(value "${CMAKE_MATCH_3}")
                set(setArg "set(${name} \"${value}")
            else()
                message(WARNING "Line '${line}' does not match regex."
                    "Ignoring."
                )
            endif()
        else()
            # Assume this is a list to append to the last var
            set(accumulator "${accumulator};${line}")
        endif()
    endforeach(line)
    if(setArg)
        set(setArg
            "${setArg}${accumulator}\" CACHE ${type} \"Initial cache\" FORCE)"
        )
        set(script_initial_cache "${script_initial_cache}\n${setArg}")
    endif(setArg)
    set(${output_var} "${script_initial_cache}" PARENT_SCOPE)
endfunction(_extlibParseCacheArgs)

function(_extlibParseNoneCacheArgs output_var args)
    # Parse set of -D<variable-name>=<value> into coressponding
    # lines of cmake "set" statements of the form:
    # set(<variable-name> <value>)
    set(script_initial_cache "")
    set(regex "^([^=]+)=(.*)$")
    set(setArg "")
    foreach(line ${args})
        if("${line}" MATCHES "^-D")
            if(setArg)
                # This is required to build up lists in variables, or complete
                # an entry
                set(setArg "${setArg}${accumulator}\")")
                set(script_initial_cache "${script_initial_cache}\n${setArg}")
                set(accumulator "")
                set(setArg "")
            endif()
            string(REGEX REPLACE "^-D" "" line ${line})
            if("${line}" MATCHES "${regex}")
                string(REGEX MATCH "${regex}" match "${line}")
                set(name "${CMAKE_MATCH_1}")
                set(value "${CMAKE_MATCH_2}")
                set(setArg "set(${name} \"${value}")
            else()
                message(WARNING "Line '${line}' does not match regex."
                    "Ignoring."
                )
            endif()
        else()
            # Assume this is a list to append to the last var
            set(accumulator "${accumulator};${line}")
        endif()
    endforeach()
    if(setArg)
        set(setArg "${setArg}${accumulator}\")")
        set(script_initial_cache "${script_initial_cache}\n${setArg}")
    endif(setArg)
    set(${output_var} "${script_initial_cache}" PARENT_SCOPE)
endfunction(_extlibParseNoneCacheArgs)


function(WriteInitialCache script_filename args)
    # Write out values into an initial cache, that will be passed to CMake
    # with -C
    _extlibParseCacheArgs(script_initial_cache "${args}")

    # Write out the initial cache file to the location specified.
    file(WRITE "${script_filename}.in" "\@script_initial_cache\@\n")
    configure_file("${script_filename}.in" "${script_filename}")
endfunction(WriteInitialCache)

include(CMakeParseArguments)
# 
# WriteInitialCacheEx - writes initial cache file that can be passed to
# cmake as argument to -C option.
# OUTPUT_FILE - provides the name of output file to create
# CMAKE_CACHE_ARGS - the arguments in the form
#   -D<VARIABLE_NAME>:<VARIABLE_TYPE>=<VALUE>
function(WriteInitialCacheEx)
    set(options )
    set(oneValueArgs OUTPUT_FILE)
    set(multiValueArgs CMAKE_CACHE_ARGS)
    cmake_parse_arguments(WriteInitialCacheEx 
        "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT WriteInitialCacheEx_OUTPUT_FILE)
        message(FATAL_ERROR "NO OUTPUT_FILE option provided")
    endif(NOT WriteInitialCacheEx_OUTPUT_FILE)

    WriteInitialCache(
        ${WriteInitialCacheEx_OUTPUT_FILE}
        "${WriteInitialCacheEx_CMAKE_CACHE_ARGS}"
    )
endfunction(WriteInitialCacheEx)

#
# ExtlibWriteConfig
function(ExtlibWriteConfig)
    set(options)
    set(oneValueArgs OUTPUT_FILE)
    set(multiValueArgs CMAKE_SET_ARGS CMAKE_CACHE_ARGS)
    cmake_parse_arguments(PARSED_ARGS "${options}" "${oneValueArgs}"
        "${multiValueArgs}" ${ARGN}
    )
    if(NOT PARSED_ARGS_OUTPUT_FILE)
        message(FATAL_ERROR "No OUTPUT_FILE option provided")
    endif(NOT PARSED_ARGS_OUTPUT_FILE)

    if(PARSED_ARGS_CMAKE_SET_ARGS)
        _extlibParseNoneCacheArgs(set_args "${PARSED_ARGS_CMAKE_SET_ARGS}")
        if(PARSED_ARGS_CMAKE_CACHE_ARGS)
            _extlibParseCacheArgs(cache_args "${PARSED_ARGS_CMAKE_CACHE_ARGS}")
            set(result "${set_args}${cache_args}\n")
        else(PARSED_ARGS_CMAKE_CACHE_ARGS)
            set(result "${set_args}\n")
        endif(PARSED_ARGS_CMAKE_CACHE_ARGS)
    elseif(PARSED_ARGS_CMAKE_CACHE_ARGS)
        _extlibParseCacheArgs(cache_args "${PARSED_ARGS_CMAKE_CACHE_ARGS}")
        set(result "${cache_args}\n")
    else(PARSED_ARGS_CMAKE_CACHE_ARGS)
        message(WARNING "Nether CMAKE_SET_ARGS nor CMAKE_CACHE_ARGS options"
            "are given."
        )
        set(result "")
    endif(PARSED_ARGS_CMAKE_SET_ARGS)
    file(WRITE "${PARSED_ARGS_OUTPUT_FILE}" "${result}")
endfunction(ExtlibWriteConfig)

