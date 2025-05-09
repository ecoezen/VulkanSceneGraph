cmake_minimum_required(VERSION 3.30)

project(vsg
    VERSION 1.1.11
    DESCRIPTION "VulkanSceneGraph library"
    LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake
                              ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules 
                              ${CMAKE_CURRENT_SOURCE_DIR}/cmake/vsg
                              ${CMAKE_CURRENT_SOURCE_DIR}/cmake/maintainer                              
                              )

include(vsgMacros)


set(VSG_MAX_DEVICES 1 CACHE STRING "Set maximum number of vk/vsg::Device that are supported.")
set(VSG_MAX_INSTRUMENTATION_LEVEL 1 CACHE STRING "Set the instrumentation level to build into the VSG library, 0 for off, 1 coarse grained, 2 medium, 3 fine grained." )
option(VSG_SUPPORTS_ShaderCompiler  "Optional shader compiler support" ON)
option(VSG_SUPPORTS_ShaderOptimizer "Optional shader optimizer support" ON)
option(VSG_SUPPORTS_Windowing "Optional native windowing support providing a default implementation of vsg::Window::create()" ON )
option(ENABLE_MP_FLAG "Turning on this option will add the multi-processor flag in MSVC for VSG and its included projects" ON)
option(DISABLE_CHECKED_ITERATORS "Turning on this option will disable checked iterators in debug mode for visual studio. All imported projects must adhere to this requirement" OFF)
option(VSG_SHARED "Build shared libraries. Can be combined with VSG_BUILD_STATIC" ON)
option(VSG_STATIC "Build static libraries. Can be combined with VSG_BUILD_SHARED" OFF)
option(VSG_SKIP_INSTALL "Skip install step" OFF)


set(VSG_SOVERSION 14)
set(VSG_RELEASE_CANDIDATE 0)
set(VSG_SOURCE_DIR "${CMAKE_SOURCE_DIR}" CACHE INTERNAL "Root source directory of VulkanSceneGraph.")
set(VSG_BINARY_DIR "${CMAKE_BINARY_DIR}" CACHE INTERNAL "Root binary directory of VulkanSceneGraph.")
set(VSG_MAINTAINER_CMAKE_DIR "${CMAKE_SOURCE_DIR}/cmake/maintainer" CACHE INTERNAL "Root maintainer cmake directory of VulkanSceneGraph.")
set(VSG_CMAKE_DIR "${CMAKE_SOURCE_DIR}/cmake/vsg" CACHE INTERNAL "Root cmake directory of VulkanSceneGraph.")



if (VULKAN_SDK)
    set(ENV{VULKAN_SDK} ${VULKAN_SDK})
endif()

if(CMAKE_CROSSCOMPILING AND CMAKE_HOST_WIN32) # NOT COMPLETED. NEED A CUSTOM FindVulkan.cmake to bring cross-binaries
 # starting from VulkanSDK "1.4.313" onwards, cross-binaries are provided in the SDK (windows-only).
    set(Vulkan_MIN_VERSION 1.4.313.0)
    # setting sdk folder postfix: https://www.lunarg.com/lunarg-releases-vulkan-sdk-1-4-313-0/
    #                           - cross binaries and packages are populated in Bin-ARM64 Lib-ARM64(on X64 installers) 
    #                           - Bin-X64 and Lib-X64(on ARM64 installers) folders.

    if(CMAKE_SYSTEM_PROCESSOR MATCHES "ARM64")
        set(VULKAN_SDK_POSTFIX "-ARM64")
    else()
        set(VULKAN_SDK_POSTFIX "-X64")
    endif()
    
    # TODO: need a custom FindVulkan.cmake to bring cross-binaries
else()
    set(Vulkan_MIN_VERSION 1.1.70.0)
endif()




vsg_setup_dir_vars()
vsg_setup_build_vars()
vsg_add_target_clobber()

add_subdirectory(maintainer)
add_subdirectory(src/vsg)

vsg_add_feature_summary()
