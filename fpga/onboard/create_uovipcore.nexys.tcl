create_peripheral user.org user uovipcore 1.0 -dir uovsystem/ip_repo
add_peripheral_interface S00_AXI -interface_mode slave -axi_type lite [ipx::find_open_core user.org:user:uovipcore:1.0]
set_property VALUE 80 [ipx::get_bus_parameters WIZ_NUM_REG -of_objects [ipx::get_bus_interfaces S00_AXI -of_objects [ipx::find_open_core user.org:user:uovipcore:1.0]]]
generate_peripheral -driver -bfm_example_design -debug_hw_example_design [ipx::find_open_core user.org:user:uovipcore:1.0]
write_peripheral [ipx::find_open_core user.org:user:uovipcore:1.0]
set_property  ip_repo_paths  uovsystem/ip_repo/uovipcore_1.0 [current_project]
update_ip_catalog -rebuild
ipx::edit_ip_in_project -upgrade true -name edit_uovipcore_v1_0 -directory uovsystem/ip_repo uovsystem/ip_repo/uovipcore_1.0/component.xml
update_compile_order -fileset sim_1

file copy -force interface/uovipcore_v1_0_S00_AXI.v uovsystem/ip_repo/uovipcore_1.0/hdl/

file copy -force interface/uovipcore_v1_0.v uovsystem/ip_repo/uovipcore_1.0/hdl/

set infiles [glob -nocomplain ./rtl/*.v]

update_compile_order -fileset sources_1
add_files -force -norecurse -copy_to uovsystem/ip_repo/uovipcore_1.0/src {*}$infiles
update_compile_order -fileset sources_1

ipx::merge_project_changes hdl_parameters [ipx::current_core]

ipx::merge_project_changes files [ipx::current_core]

ipx::create_xgui_files [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project -delete
update_ip_catalog -rebuild -repo_path uovsystem/ip_repo/uovipcore_1.0
