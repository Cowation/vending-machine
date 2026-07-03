# scripts/vivado/sim.tcl

source [file join [file dirname [info script]] create_project.tcl]

set_property xsim.simulate.runtime 1us [get_filesets sim_1]

launch_simulation -simset sim_1 -mode behavioral

run all
quit