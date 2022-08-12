OS :: Operating_System_Tag.MACOS;

#import "Basic";
#import "String";
#import "File_Utilities";

xxx :: () {
    print("XXXX %\n", type_info(OS));
    lib := "/Users/adragomi/work/personal/jai/modules/stb_sprintf/linux/stb_sprintf.so";
    lib_path := parse_path(lib);
    print("path %\n", lib_path);
    if path_contains(lib_path, string.["jai", "modules"]) {
        actual_lib := lib_path.words[lib_path.words.count - 1];
        if contains(actual_lib, ".so") {
            lib_path.words[lib_path.words.count - 1] = replace(actual_lib, ".so", ".dylib");
        }
        arch_index := lib_path.words.count - 2;
        lib_path.words[arch_index] = "mac";
        // it's a module lib
        print("HACKING %\n", path_to_string(lib_path));
    }
    print("AAAAAAAAAAAA\n");
}

#run xxx();
