# This file assumes the install executable (same folder)
# has been called, i.e. mujoco is installed in either
# ~/.mpi-is/mujoco or /opt/mpi-is/mujoco


# 1. set these variables:
# mujoco_dir (to either ~/.mpi-is/mujoco or /opt/mpi-is/mujoco
# mujoco_lib_dir (${mujoco_dir}/lib)
# mujoco_include_dir (${mujoco_dir}/include)
# mujoco_sample_dir (${mujoco_dir}/sample)
# mujoco_libs (libglew.so, libglewegl.so, libmujoco.so)
# 2. add the mujoco_libs (expected to be found in 
# ${mujoco_lib_dir}
macro(ADD_MUJOCO_LIBS)
  
  set(local_mujoco "$ENV{HOME}/.mpi-is/mujoco")
  set(global_mujoco "/opt/mpi-is/mujoco")
  
  # checking mujoco has been installed
  if (EXISTS ${local_mujoco})
    set(mujoco_dir ${local_mujoco})
  elseif(EXISTS ${global_mujoco})
    set(mujoco_dir ${global_mujoco})
  else()
    message(ERROR "failed to find ${local_mujoco} nor ${global_mujoco}")
  endif()

  # checking all expected sub-directories are there
  set(mujoco_lib_dir "${mujoco_dir}/lib")
  set(mujoco_include_dir "${mujoco_dir}/include")
  set(mujoco_sample_dir "${mujoco_dir}/sample")
  if(NOT EXISTS ${mujoco_include_dir})
    message(FATAL_ERROR "failed to find ${mujoco_include_dir}")
  endif()
  if(NOT EXISTS ${mujoco_lib_dir})
    message(FATAL_ERROR "failed to find ${mujoco_lib_dir}")
  endif()
  if(NOT EXISTS ${mujoco_sample_dir})
    message(FATAL_ERROR "failed to find ${mujoco_sample_dir}")
  endif()

  # we need these libraries provided by mujoco and expected
  # in the lib folder
  list(APPEND mujoco_libs "libmujoco.so")
  foreach(mujoco_lib ${mujoco_libs})
    if(NOT EXISTS ${mujoco_lib_dir}/${mujoco_lib})
      message(FATAL_ERROR "failed to find ${mujoco_lib_dir}/${mujoco_lib}")
    endif()
  endforeach(mujoco_lib)

  # adding the libraries to the current project
  set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE) # keeping linkage during installation
  foreach(mujoco_lib ${mujoco_libs})
    add_library(${mujoco_lib} SHARED IMPORTED)
    set_target_properties( ${mujoco_lib} PROPERTIES IMPORTED_LOCATION ${mujoco_lib_dir}/${mujoco_lib})
    ament_export_libraries(${mujoco_lib})
  endforeach(mujoco_lib)

endmacro(ADD_MUJOCO_LIBS)


# Link the target against all mujoco libraries
# ($mujoco_libs as set by a call to the add_mujoco_libs macro,
#  located in this file)
macro(LINK_AGAINST_MUJOCO target_name)

  foreach(mujoco_lib ${mujoco_libs})
    target_link_libraries(${target_name} ${mujoco_lib})
  endforeach(mujoco_lib)
  
endmacro(LINK_AGAINST_MUJOCO)
