cmake_minimum_required(VERSION 3.10.2)

project(mujoco_interface)


# TODO
# clean this up. Too much hard-coded
# commands here.
# all this assumes mujoco has been unzipped
# in /opt/mpi-is/mujoco200_linux
# (as opposed as the usual location:
#  /home/user/.mujoco)
#

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED on)


################
# Dependencies #
################

find_package(ament_cmake REQUIRED)

ament_export_dependencies()

# prepare to export all needed targets
set(all_targets)
set(all_target_exports)


####################
# Mujoco libraries #
####################

# it is assumed mujoco has been unzipped in
# /opt/mpi-is/mujoco200_linux (deprecated) or /usr/local/mujoco200_linux
if (EXISTS "/opt/mpi-is/mujoco200_linux")
  set(mujoco_lib_dir "/opt/mpi-is/mujoco200_linux/bin")
  set(mujoco_include_dir "/opt/mpi-is/mujoco200_linux/include")
elseif (EXISTS "/usr/local/mujoco200_linux")
  set(mujoco_lib_dir "/usr/local/mujoco200_linux/bin")
  set(mujoco_include_dir "/usr/local/mujoco200_linux/include")
else()
  message(ERROR "failed to find /usr/local/mujoco200_linux or /opt/mpi-is/mujoco200_linux")
endif()
set(mujoco_libs)
list(APPEND mujoco_libs "libglew.so")
list(APPEND mujoco_libs "libglewegl.so")
list(APPEND mujoco_libs "libglfw.so.3")
list(APPEND mujoco_libs "libmujoco200.so")

if(NOT EXISTS ${mujoco_include_dir})
  message(FATAL_ERROR "failed to find ${mujoco_include_dir}")
endif()

if(NOT EXISTS ${mujoco_lib_dir})
  message(FATAL_ERROR "failed to find ${mujoco_lib_dir}")
endif()

foreach(mujoco_lib ${mujoco_libs})
  if(NOT EXISTS ${mujoco_lib_dir}/${mujoco_lib})
    message(FATAL_ERROR "failed to find ${mujoco_lib_dir}/${mujoco_lib}")
  endif()
endforeach(mujoco_lib)

add_library(${PROJECT_NAME} SHARED ${mujoco_include_dir}/uitools.c)
target_include_directories(
  ${PROJECT_NAME} PUBLIC ${mujoco_include_dir} )
foreach(mujoco_lib ${mujoco_libs})
  target_link_libraries(${PROJECT_NAME} ${mujoco_lib_dir}/${mujoco_lib})
endforeach(mujoco_lib)
target_link_libraries(${PROJECT_NAME} -lpthread -lm)
ament_export_interfaces(export_${PROJECT_NAME} HAS_LIBRARY_TARGET)
list(APPEND all_targets ${PROJECT_NAME})
list(APPEND all_target_exports export_${PROJECT_NAME})


######################
# Install and export #
######################

install(
  TARGETS ${all_targets}
  EXPORT ${all_target_exports}
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES
  DESTINATION)
ament_package()
