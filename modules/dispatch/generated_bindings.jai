//
// This file was auto-generated using the following command:
//
// /Users/adragomi/work/personal/jaitest/modules/dispatch/generate
//




#scope_file

libdispatch :: #foreign_system_library "libSystem";
#scope_file

#if OS == .WINDOWS {
    libdispatch :: #foreign_system_library "libdispatch";
} else #if OS == .LINUX {
    libdispatch :: #foreign_system_library "libdispatch";
} else #if OS == .MACOS {
    libdispatch :: #foreign_system_library "libdispatch";
}
