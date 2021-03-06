cmake_minimum_required(VERSION 2.8.3)
project(hrpsys_gazebo_tutorials)

#find_package(catkin REQUIRED COMPONENTS hrpsys_ros_bridge_tutorials collada_tools euscollada)
find_package(catkin REQUIRED COMPONENTS collada_tools euscollada hrpsys_ros_bridge)

find_package(PkgConfig)
pkg_check_modules(openhrp3 openhrp3.1 REQUIRED)
pkg_check_modules(hrpsys hrpsys-base REQUIRED)

catkin_package(
    DEPENDS openhrp3 hrpsys#
    CATKIN_DEPENDS collada_tools euscollada hrpsys_ros_bridge
    INCLUDE_DIRS # TODO include
    LIBRARIES # TODO
)

install(PROGRAMS robot_models/install_robot_common.sh 
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/robot_models/)
install(FILES setup.sh
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION})
install(DIRECTORY euslisp worlds launch config environment_models DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  PATTERN ".svn" EXCLUDE)
install(PROGRAMS scripts/gazebo scripts/gzclient scripts/gzserver scripts/eus2urdf_for_gazebo_pyscript.py scripts/generate_model_database.py scripts/make_fixed_model.py scripts/remove_all_added_models.py scripts/generate_room_world.py scripts/make_static_model.py scripts/remove_all_generated_files.py
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/scripts/)


macro (generate_gazebo_urdf_file _robot_name)
  set(_out_dir "${PROJECT_SOURCE_DIR}/robot_models/${_robot_name}")
  set(_out_urdf_file "${_out_dir}/${_robot_name}.urdf")
  add_custom_command(OUTPUT ${_out_dir}/meshes
    COMMAND mkdir ${_out_dir}/meshes)
  add_custom_command(OUTPUT ${_out_dir}/hrpsys
    COMMAND mkdir ${_out_dir}/hrpsys)
  add_custom_command(OUTPUT ${_out_urdf_file}
    COMMAND ${PROJECT_SOURCE_DIR}/robot_models/install_robot_common.sh ${_robot_name} ${hrpsys_ros_bridge_tutorials_SOURCE_DIR}/models  ${hrpsys_gazebo_tutorials_SOURCE_DIR}/robot_models/${_robot_name} ${collada_tools_PREFIX}/lib/collada_tools/collada_to_urdf ${PROJECT_SOURCE_DIR}/..
    DEPENDS ${_out_dir}/hrpsys ${_out_dir}/meshes ${collada_tools_PREFIX}/lib/collada_tools/collada_to_urdf)
  add_custom_target(${_robot_name}_compile DEPENDS ${_out_urdf_file})
  set(ROBOT ${_robot_name})
  string(TOLOWER ${_robot_name} _sname)
  #configure_file(${PROJECT_SOURCE_DIR}/scripts/default_robot_hrpsys_bringup.launch.in ${PROJECT_SOURCE_DIR}/build/${_sname}_hrpsys_bringup.launch)
  if(NOT EXISTS ${PROJECT_SOURCE_DIR}/launch/gazebo_${_sname}_no_controllers.launch)
    configure_file(${PROJECT_SOURCE_DIR}/scripts/default_gazebo_robot_no_controllers.launch.in ${PROJECT_SOURCE_DIR}/launch/gazebo_${_sname}_no_controllers.launch)
  endif()
  list(APPEND compile_robots ${_robot_name}_compile)
  install(DIRECTORY ${_out_dir} DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/robot_models/ PATTERN ".svn" EXCLUDE)
endmacro()

generate_gazebo_urdf_file(SampleRobot)
generate_gazebo_urdf_file(HRP3HAND_L)
generate_gazebo_urdf_file(HRP3HAND_R)
generate_gazebo_urdf_file(HRP2JSK)
generate_gazebo_urdf_file(HRP2JSKNT)
generate_gazebo_urdf_file(HRP2JSKNTS)
generate_gazebo_urdf_file(STARO)
generate_gazebo_urdf_file(HRP4C)


add_custom_target(all_robots_compile ALL DEPENDS ${compile_robots})
