# scripts/vivado/create_project.tcl

set origin_dir [file normalize [file join [file dirname [info script]] ../..]]
set build_dir  [file join $origin_dir build vivado]
set proj_name  "vending-machine"

# Vivado requires an FPGA part even if you only use simulation.
# Pick one that every teammate has installed.
set part_name "xc7a35tcpg236-1"

file mkdir $build_dir
create_project $proj_name $build_dir -part $part_name -force

set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]

proc add_filelist {fileset filelist_path} {
    set filelist_dir [file dirname [file normalize $filelist_path]]
    set fh [open $filelist_path r]

    set files {}
    while {[gets $fh line] >= 0} {
        set line [string trim $line]

        if {$line eq ""} {
            continue
        }

        if {[string match "#*" $line]} {
            continue
        }

        # Skip include header lines here if you list .svh files.
        # Vivado does not compile .svh directly; it includes them from source files.
        if {[file extension $line] eq ".svh"} {
            continue
        }

        lappend files [file normalize [file join $filelist_dir $line]]
    }

    close $fh

    if {[llength $files] > 0} {
        add_files -norecurse -fileset $fileset $files
    }
}

add_filelist sources_1 [file join $origin_dir filelists rtl.f]
add_filelist sim_1     [file join $origin_dir filelists tb.f]

set_property include_dirs [list [file join $origin_dir include]] [get_filesets sources_1]
set_property include_dirs [list [file join $origin_dir include]] [get_filesets sim_1]

set_property top top    [get_filesets sources_1]
set_property top top_tb [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1