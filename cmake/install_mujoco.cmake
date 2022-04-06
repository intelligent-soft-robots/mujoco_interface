

macro(INSTALL_MUJOCO)

    execute_process(
      COMMAND bash -c "${CMAKE_CURRENT_SOURCE_DIR}/install_folder"
      OUTPUT_VARIABLE install_folder
      ERROR_VARIABLE install_folder_stderr
      RESULT_VARIABLE install_folder_exit_code)

    if(NOT install_folder_exit_code EQUAL "0")
      message(ERROR " failed to determine mujoco installation location: ${install_folder_stderr}")
    endif()
    
    message(INFO " installing mujoco in ${install_folder}")
    if (NOT EXISTS "${install_folder}")
      execute_process(
	COMMAND bash -c "${CMAKE_CURRENT_SOURCE_DIR}/install"
	OUTPUT_VARIABLE mujoco_install_stdout
	RESULT_VARIABLE mujoco_install_exit_code)
      if (NOT mujoco_install_exit_code EQUAL "0")
	message(ERROR " failed to install mujoco with stdout:\n${mujoco_install_stdout}\n")
      else ()
	message(INFO " installed mujoco")
      endif ()
    else ()
      message(INFO " mujoco already installed in ${install_folder}, skipping")
    endif ()
    
    # from cmake_always_do/cmake/always_do.cmake
    # ensure this macro will be called everytime 'colcon build'
    # is called (even despite the cache)
    ALWAYS_DO("installing mujoco") 
    
endmacro()

