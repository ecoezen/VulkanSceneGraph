if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/install_manifest.txt")

    message(STATUS "Uninstalling VSG...")
    file(READ "${CMAKE_CURRENT_LIST_DIR}/install_manifest.txt" files)
    string(REGEX REPLACE "\n" ";" files "${files}")

    foreach(file ${files})
        if(EXISTS "${file}")

            message(STATUS "[VSG] Uninstalling \"${file}\"")
            file(REMOVE_RECURSE ${file})
        endif()
    endforeach()

else()

    # changed from error to warning as install_manifest.txt is created only after install step.
    message(WARNING "[VSG] Cannot find install manifest: \"${CMAKE_CURRENT_LIST_DIR}/install_manifest.txt\"")
endif()
