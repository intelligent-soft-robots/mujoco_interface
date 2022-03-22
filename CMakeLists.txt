cmake_minimum_required(VERSION 3.10.2)

project(mujoco_interface)



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

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/mujoco_libs.cmake)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/cmake/
        DESTINATION share/${PROJECT_NAME}/cmake)
ADD_MUJOCO_LIBS() # from mujoco_libs.cmake


###########
# Library #
###########

add_library(${PROJECT_NAME} SHARED ${mujoco_sample_dir}/uitools.c)
target_include_directories(
  ${PROJECT_NAME} PUBLIC ${mujoco_include_dir} ${mujoco_sample_dir} )
LINK_AGAINST_MUJOCO(${PROJECT_NAME}) # from mujoco_libs.cmake
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

