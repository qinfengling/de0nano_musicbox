#============================================================
# Build by Terasic System Builder
#============================================================
project_new musicbox -overwrite

set_global_assignment -name FAMILY "Cyclone IV E"
set_global_assignment -name DEVICE EP4CE22F17C6
set_global_assignment -name TOP_LEVEL_ENTITY "musicbox"
set_global_assignment -name ORIGINAL_QUARTUS_VERSION 12.0
set_global_assignment -name LAST_QUARTUS_VERSION "12.1 SP1"
set_global_assignment -name PROJECT_CREATION_TIME_DATE "00:59:20 APRIL 08,2013"
set_global_assignment -name SDC_FILE musicbox.SDC
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_FLASH_NCE_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA0_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DATA1_AFTER_CONFIGURATION "USE AS REGULAR IO"
set_global_assignment -name RESERVE_DCLK_AFTER_CONFIGURATION "USE AS REGULAR IO"

#============================================================
# CLOCK
#============================================================
set_location_assignment PIN_R8 -to CLOCK_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to CLOCK_50

#============================================================
# SPEAKER
#============================================================
set_location_assignment PIN_D3 -to SPEAKER
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to SPEAKER

#============================================================
# LED
#============================================================
set_location_assignment PIN_L3 -to LED
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to LED

#============================================================
# End of pin assignments by Terasic System Builder
#============================================================

set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
set_global_assignment -name VERILOG_FILE musicbox.v
set_global_assignment -name SOURCE_FILE musicbox.qsf
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

project_close
