# This is a tickle script to print out the utilization result and worst negative slack.
# One can dump result to temp.txt and run:
# cat temp.txt | grep -e "slack " -e "Loaded user IP repository" -e "DSPs" -e "| Block RAM Tile" -e "| Slice LUTs                 |" -e "| Slice Registers            |" -e "| Slice                                      |" | awk -F "|" '{print $1 $3}' | tail -n +2 | tr '\n' ' ' | awk -F " " "{print \$3\" \"\$1\" \"\$2\" \"\$4\" \"\$5\" \"1000/(10-\$7)}"
# to parse the output. (FMAX (MHz) = max(1000/(T - WNS)))

if { $argc != 1 } {
    puts "Usage vivado -mode tcl -source ./scripts/report.tcl -tclargs FOLDER_PATH"
    exit
}

set path [lindex $argv 0]
set xpr "$path/uovsystem/uovsystem.xpr"

if {![file exists $xpr]} {
    puts "No xpr file found in $path"
    puts "Run ./run_synthesis first"
    exit
}

open_project $xpr
open_run impl_1

# Only print the utilization of uovipcore
report_utilization -cells system0_i/uovipcore_0
report_timing -nworst 1 -path_type full -input_pins

close_design
close_project
exit
