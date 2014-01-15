# Gets the libcouchbase version
# Sets:
#  LCB_VERSION: Version string
#  LCB_CHANGESET: SCM Revision number
#  LCB_VERSION_HEX Numeric hex version
#  LCB_VERSION_MAJOR
#  LCB_VERSION_MINOR
#  LCB_VERSION_PATCH

## Try git first ##
IF(NOT WIN32)
    EXECUTE_PROCESS(
        COMMAND git describe
        COMMAND tr '-' '_'
        COMMAND tr -d '\n'
        OUTPUT_VARIABLE LCB_VERSION)
    EXECUTE_PROCESS(
        COMMAND git rev-parse HEAD
        COMMAND tr -d '\n'
        OUTPUT_VARIABLE LCB_VERSION_CHANGESET)
    EXECUTE_PROCESS(
        COMMAND echo ${LCB_VERSION}
        COMMAND awk -F. "{printf \"0x%0.2d%0.2d%0.2d\", $1, $2, $3}"
        OUTPUT_VARIABLE LCB_VERSION_HEX)
ENDIF()

# library version
IF(NOT LCB_VERSION AND EXISTS ${CMAKE_SOURCE_DIR}/VERSION)
    FILE(STRINGS ${CMAKE_SOURCE_DIR}/VERSION lines)
    FOREACH(line ${lines})
        STRING(REGEX REPLACE "^([^=]+)=(.*)" "\\1" varname "${line}")
        STRING(REGEX REPLACE "^([^=]+)=(.*)" "\\2" varvalue "${line}")
        SET(LCB_${varname} "${varvalue}")
    ENDFOREACH()
ENDIF()

IF (NOT LCB_VERSION)
    SET(LCB_VERSION "2.3.0")
ENDIF()
IF (NOT LCB_VERSION_CHANGESET)
    SET(LCB_VERSION_CHANGESET "0xdeadbeef")
ENDIF()
IF (NOT LCB_VERSION_HEX)
    SET(LCB_VERSION_HEX 0x020300)
ENDIF()

# Now parse the version string
STRING(REPLACE "." ";" LCB_VERSION_LIST "${LCB_VERSION}")
LIST(GET LCB_VERSION_LIST 0 LCB_VERSION_MAJOR)
LIST(GET LCB_VERSION_LIST 1 LCB_VERSION_MINOR)
LIST(GET LCB_VERSION_LIST 2 LCB_VERSION_PATCH)

MESSAGE(STATUS
    "libcouchbase ${LCB_VERSION_MAJOR},${LCB_VERSION_MINOR},${LCB_VERSION_PATCH}")
MESSAGE(STATUS "Building libcouchbase ${LCB_VERSION}/${LCB_VERSION_CHANGESET}")
