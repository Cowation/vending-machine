set origin_dir [file normalize [file join [file dirname [info script]] ../..]]

proc read_filelist {filelist_path} {
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

        if {[file extension $line] eq ".svh"} {
            continue
        }

        lappend files [file normalize [file join $filelist_dir $line]]
    }

    close $fh
    return $files
}

set rtl_files [read_filelist [file join $origin_dir filelists rtl.f]]
set tb_files  [read_filelist [file join $origin_dir filelists tb.f]]

foreach f $rtl_files {
    if {[llength [get_files -quiet $f]] == 0} {
        add_files -norecurse -fileset sources_1 $f
    }
}

foreach f $tb_files {
    if {[llength [get_files -quiet $f]] == 0} {
        add_files -norecurse -fileset sim_1 $f
    }
}

set_property include_dirs [list [file join $origin_dir include]] [get_filesets sources_1]
set_property include_dirs [list [file join $origin_dir include]] [get_filesets sim_1]

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1