source create_uovsystem.zedboard.tcl
source create_uovipcore.zedboard.tcl
source design_uovsystem.zedboard.tcl

set_property strategy Performance_ExtraTimingOpt [get_runs impl_1]
set_param general.maxThreads 8

launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

set_property pfm_name {} [get_files -all {uovsystem/uovsystem.srcs/sources_1/bd/system0/system0.bd}]
write_hw_platform -fixed -include_bit -force -file uovsystem/system0_wrapper.xsa
