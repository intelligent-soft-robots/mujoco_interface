

macro(INSTALL_MUJOCO)

  # installing if not installed
  # todo: should message with STATUS mode, but then
  # nothing shows up in the terminal. Using INFO for now
  # (but print to stderr)
  set(local_mujoco "$ENV{HOME}/.mpi-is/mujoco")
  message(INFO " installing mujoco in ${local_mujoco}")
  if (NOT EXISTS ${local_mujoco})
    execute_process(
      COMMAND bash -c "${CMAKE_CURRENT_SOURCE_DIR}/install"
      OUTPUT_VARIABLE mujoco_install_stdout
      RESULT_VARIABLE mujoco_install_exit_code)
    if (mujoco_install_exit_code EQUAL "1")
      message(ERROR " failed to install mujoco with stdout:\n${mujoco_install_stdout}\n")
    else ()
      message(INFO " installed mujoco")
    endif ()
  else ()
    message(INFO " mujoco already installed in ${local_mujoco}, skipping")
  endif ()

  # from cmake_always_do/cmake/always_do.cmake
  # ensure this macro will be called everytime 'colcon build'
  # is called (even despite the cache)
  ALWAYS_DO("installing mujoco") 
  
endmacro()

