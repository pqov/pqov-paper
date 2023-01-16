create_bd_design "system0"

### MIG
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram "system0" 
endgroup
delete_bd_objs [get_bd_nets clk_ref_i_1] [get_bd_ports clk_ref_i]
connect_bd_net [get_bd_pins mig_7series_0/ui_addn_clk_0] [get_bd_pins mig_7series_0/clk_ref_i]
apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {reset ( Reset ) } Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins mig_7series_0/sys_rst]

### Clock Wizard
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
endgroup
connect_bd_net [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins clk_wiz_0/reset]
connect_bd_net [get_bd_pins mig_7series_0/ui_clk] [get_bd_pins clk_wiz_0/clk_in1]
startgroup
#set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {20.000} CONFIG.CLKOUT1_JITTER {151.636}] [get_bd_cells clk_wiz_0]
#set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {80.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.500} CONFIG.CLKOUT1_JITTER {137.143}] [get_bd_cells clk_wiz_0]
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} CONFIG.CLKOUT1_JITTER {130.958}] [get_bd_cells clk_wiz_0]
#set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} CONFIG.CLKOUT1_JITTER {125.247}] [get_bd_cells clk_wiz_0]
endgroup

### MicroBlaze
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {1} axi_periph {Enabled} cache {4KB} clk {/clk_wiz_0/clk_out1 (100 MHz)} cores {1} debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}}  [get_bd_cells microblaze_0]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_0/clk_out1 (100 MHz)} Clk_slave {/mig_7series_0/ui_clk (100 MHz)} Clk_xbar {Auto} Master {/microblaze_0 (Cached)} Slave {/mig_7series_0/S_AXI} ddr_seg {Auto} intc_ip {New AXI SmartConnect} master_apm {0}}  [get_bd_intf_pins mig_7series_0/S_AXI]
startgroup
set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells microblaze_0_xlconcat]
endgroup

### UART
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0
apply_board_connection -board_interface "usb_uart" -ip_intf "axi_uartlite_0/UART" -diagram "system0" 
endgroup
set_property -dict [list CONFIG.C_BAUDRATE {9600} CONFIG.UARTLITE_BOARD_INTERFACE {usb_uart}] [get_bd_cells axi_uartlite_0]
connect_bd_net [get_bd_pins axi_uartlite_0/interrupt] [get_bd_pins microblaze_0_xlconcat/In0]

### UOV
startgroup
create_bd_cell -type ip -vlnv user.org:user:uovipcore:1.0 uovipcore_0
endgroup

startgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_0/clk_out1 (100 MHz)} Clk_slave {Auto} Clk_xbar {/clk_wiz_0/clk_out1 (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_uartlite_0/S_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_uartlite_0/S_AXI]
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_0/clk_out1 (100 MHz)} Clk_slave {Auto} Clk_xbar {/clk_wiz_0/clk_out1 (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/uovipcore_0/S00_AXI} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins uovipcore_0/S00_AXI]
endgroup

### Add QSPI
# startgroup
# create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 axi_quad_spi_0
# endgroup
# startgroup
# set_property -dict [list CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {50.000} CONFIG.MMCM_CLKOUT1_DIVIDE {20} CONFIG.NUM_OUT_CLKS {2} CONFIG.CLKOUT2_JITTER {151.636} CONFIG.CLKOUT2_PHASE_ERROR {98.575}] [get_bd_cells clk_wiz_0]
# endgroup
# startgroup
# apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/clk_wiz_0/clk_out1 (100 MHz)} Clk_slave {Auto} Clk_xbar {/clk_wiz_0/clk_out1 (100 MHz)} Master {/microblaze_0 (Periph)} Slave {/axi_quad_spi_0/AXI_LITE} ddr_seg {Auto} intc_ip {/microblaze_0_axi_periph} master_apm {0}}  [get_bd_intf_pins axi_quad_spi_0/AXI_LITE]
# apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {qspi_flash ( QSPI Flash ) } Manual_Source {Auto}}  [get_bd_intf_pins axi_quad_spi_0/SPI_0]
# endgroup
# startgroup
# connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins axi_quad_spi_0/ext_spi_clk]
# endgroup
# disconnect_bd_net /microblaze_0_Clk [get_bd_pins rst_clk_wiz_0_100M/slowest_sync_clk]
# connect_bd_net [get_bd_pins clk_wiz_0/clk_out2] [get_bd_pins rst_clk_wiz_0_100M/slowest_sync_clk]

regenerate_bd_layout
save_bd_design

close_bd_design [get_bd_designs system0]

make_wrapper -files [get_files uovsystem/uovsystem.srcs/sources_1/bd/system0/system0.bd] -top
import_files -force -norecurse uovsystem/uovsystem.srcs/sources_1/bd/system0/hdl/system0_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

add_files -fileset constrs_1 -norecurse Nexys-Video-Master.xdc
import_files -fileset constrs_1 Nexys-Video-Master.xdc
