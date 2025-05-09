cmake_minimum_required(VERSION 3.7)

project(VSGMaintainer
    VERSION 1.1.11
    DESCRIPTION "VulkanSceneGraph library"
    LANGUAGES CXX
)

set(VSG_SHADER_UTILS_DIR "${VSG_SOURCE_DIR}/src/vsg/utils/shaders" CACHE INTERNAL "Root shader sources directory of VulkanSceneGraph.")
set(VSG_SHADER_TEXT_DIR "${VSG_SOURCE_DIR}/src/vsg/text/shaders" CACHE INTERNAL "Root shader sources directory of VulkanSceneGraph.")

vsg_add_target_clang_format(
    FILES
        ${VSG_SOURCE_DIR}/include/vsg/*/*.h
        ${VSG_SOURCE_DIR}/src/vsg/*/*.cpp
        ${VSG_SOURCE_DIR}/include/vsg/platform/unix/*.h
        ${VSG_SOURCE_DIR}/src/vsg/platform/unix/*.cpp
        ${VSG_SOURCE_DIR}/include/vsg/platform/win32/*.h
        ${VSG_SOURCE_DIR}/src/vsg/platform/win32/*.cpp
        ${VSG_SOURCE_DIR}/include/vsg/platform/android/*.h
        ${VSG_SOURCE_DIR}/src/vsg/platform/android/*.cpp
)
vsg_add_target_cppcheck(
    SUPPRESSIONS_LIST
        "${VSG_MAINTAINER_CMAKE_DIR}/cppcheck-suppression-list.txt"
    FILES
        ${VSG_SOURCE_DIR}/include/vsg/*/*.h
        ${VSG_SOURCE_DIR}/src/vsg/*/*.cpp
        -I ${VSG_SOURCE_DIR}/include/
)
vsg_add_target_docs(
    FILES
        ${VSG_SOURCE_DIR}/include/vsg
)

# build_all_h build target to automatically generate the include/vsg/all.h from the headers in the include/vsg/* directories
add_custom_target(build_all_h
    COMMAND ${CMAKE_COMMAND} -DVSG_SOURCE_DIR=${VSG_SOURCE_DIR} -P ${VSG_MAINTAINER_CMAKE_DIR}/build_all_h.cmake
    COMMENT "update all.h to include all the include/vsg/*/*.h"
)



# build_ShaderSets target automatically rebuilds the various built-in ShaderSets.
set(PBR_DEFINES
    -v \"\"
    -v "VSG_DIFFUSE_MAP"
    -v "VSG_EMISSIVE_MAP"
    -v "VSG_LIGHTMAP_MAP"
    -v "VSG_METALLROUGHNESS_MAP"
    -v "VSG_NORMAL_MAP"
    -v "VSG_SKINNING"
    -v "VSG_TWO_SIDED_LIGHTING"
    -v "VSG_WORKFLOW_SPECGLOSS"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP"
    -v "VSG_DIFFUSE_MAP VSG_METALLROUGHNESS_MAP"
    -v "VSG_DIFFUSE_MAP VSG_NORMAL_MAP"
    -v "VSG_DIFFUSE_MAP VSG_SKINNING"
    -v "VSG_DIFFUSE_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_WORKFLOW_SPECGLOSS"
    -v "VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP"
    -v "VSG_LIGHTMAP_MAP VSG_NORMAL_MAP"
    -v "VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP"
    -v "VSG_METALLROUGHNESS_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_NORMAL_MAP"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP"
    -v "VSG_DIFFUSE_MAP VSG_METALLROUGHNESS_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_NORMAL_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_LIGHTMAP_MAP VSG_NORMAL_MAP VSG_WORKFLOW_SPECGLOSS"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_NORMAL_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP VSG_WORKFLOW_SPECGLOSS"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP VSG_LIGHTMAP_MAP VSG_METALLROUGHNESS_MAP VSG_NORMAL_MAP VSG_TWO_SIDED_LIGHTING"
    -v "VSG_DIFFUSE_MAP VSG_EMISSIVE_MAP VSG_LIGHTMAP_MAP VSG_NORMAL_MAP VSG_SPECULAR_MAP VSG_WORKFLOW_SPECGLOSS"
    -v "VSG_DISPLACEMENT_MAP VSG_DIFFUSE_MAP"
    -v "VSG_DISPLACEMENT_MAP VSG_DETAIL_MAP VSG_DIFFUSE_MAP"
)

set(PHONG_DEFINES
    -v \"\"
    -v "VSG_BILLBOARD"
    -v "VSG_DIFFUSE_MAP"
    -v "VSG_BILLBOARD VSG_DIFFUSE_MAP"
    -v "VSG_DISPLACEMENT_MAP VSG_DIFFUSE_MAP"
    -v "VSG_DISPLACEMENT_MAP VSG_DETAIL_MAP VSG_DIFFUSE_MAP"
)

set(FLAT_DEFINES
    -v \"\"
    -v "VSG_BILLBOARD"
    -v "VSG_DIFFUSE_MAP"
    -v "VSG_BILLBOARD VSG_DIFFUSE_MAP"
    -v "VSG_DISPLACEMENT_MAP VSG_DIFFUSE_MAP"
    -v "VSG_DISPLACEMENT_MAP VSG_DETAIL_MAP VSG_DIFFUSE_MAP"
)

set(TEXT_DEFINES
    -v "CPU_LAYOUT"
    -v "CPU_LAYOUT BILLBOARD"
    -v "GPU_LAYOUT"
    -v "GPU_LAYOUT BILLBOARD"
)

add_custom_target(build_ShaderSets
    COMMAND vsgshaderset --pbr ${PBR_DEFINES} -o ${VSG_SHADER_UTILS_DIR}/pbr_ShaderSet.cpp --binary
    COMMAND vsgshaderset --phong ${PHONG_DEFINES}  -o ${VSG_SHADER_UTILS_DIR}/phong_ShaderSet.cpp --binary
    COMMAND vsgshaderset --flat ${FLAT_DEFINES} -o ${VSG_SHADER_UTILS_DIR}/flat_ShaderSet.cpp --binary
    COMMAND vsgshaderset --text ${TEXT_DEFINES}  -o ${VSG_SHADER_TEXT_DIR}/text_ShaderSet.cpp  --binary
    WORKING_DIRECTORY ${VSG_SOURCE_DIR}
    COMMENT "update built-in ShaderSets"
)
add_custom_target(build_simple_ShaderSets
    COMMAND vsgshaderset --pbr -o ${VSG_SHADER_UTILS_DIR}/pbr_ShaderSet.cpp
    COMMAND vsgshaderset --phong -o ${VSG_SHADER_UTILS_DIR}/phong_ShaderSet.cpp
    COMMAND vsgshaderset --flat -o ${VSG_SHADER_UTILS_DIR}/flat_ShaderSet.cpp
    COMMAND vsgshaderset --text -o ${VSG_SHADER_TEXT_DIR}/text_ShaderSet.cpp
    WORKING_DIRECTORY ${VSG_SOURCE_DIR}
    COMMENT "update built-in ShaderSets"
)
set_target_properties(build_all_h build_ShaderSets build_simple_ShaderSets
					PROPERTIES FOLDER "${PROJECT_NAME}")


vsg_add_option_maintainer(
    PREFIX v
    RCLEVEL ${VSG_RELEASE_CANDIDATE}
)

