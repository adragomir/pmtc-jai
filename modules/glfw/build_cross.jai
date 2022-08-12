#import "Basic";
#import "Compiler";
#import "Process";
#import "File";
#import "File_Utilities";
#import "String";
Program_Print :: #import "Program_Print";

replace_system_library_darwin :: (lib: string) -> string {
    // TODO: add frameworks handling
    if contains(lib, "libc") return "-lc";
    if contains(lib, "libm") return "-lm";
    if contains(lib, "libpthread") return "-lc";
    if contains(lib, "Metal") return "-framework \"Metal\"";
    if contains(lib, "CoreFoundation") return "-framework \"CoreFoundation\"";
    if contains(lib, "GameController") return "-framework \"GameController\"";
    if contains(lib, "CoreGraphics") return "-framework \"CoreGraphics\"";
    if contains(lib, "CoreServices") return "-framework \"CoreServices\"";
    if contains(lib, "QuartzCore") return "-framework \"QuartzCore\"";
    if contains(lib, "Foundation") return "-framework \"Foundation\"";
    if contains(lib, "AppKit") return "-framework \"AppKit\"";
    if contains(lib, "Cocoa") return "-framework \"Cocoa\"";
    if contains(lib, "OpenGL") return "-framework \"OpenGL\"";
    if contains(lib, "libdl.so") return "";
    if contains(lib, "AudioUnit") return "-framework \"AudioUnit\"";
    if contains(lib, "AudioToolbox") return "-framework \"AudioToolbox\"";
    if contains(lib, "CoreAudio") return "-framework \"CoreAudio\"";
    log("[WARNING] [SYSTEM_LIB] Don't know what to do with %\n", lib);
    return "";
}

replace_user_library_darwin :: (lib: string) -> string {
    lib_path := parse_path(lib);
    if path_contains(lib_path, string.["jai", "modules"]) {
        // it's a module lib
        actual_lib := lib_path.words[lib_path.words.count - 1];
        if contains(actual_lib, ".so") {
            replaced := replace(actual_lib, ".so", ".dylib");
            lib_path.words[lib_path.words.count - 1] = replaced;
        }
        arch_index := lib_path.words.count - 2;
        if contains(lib_path.words[arch_index], "linux") {
            lib_path.words[arch_index] = "mac";
        }
        return path_to_string(lib_path);
    } else {
        log("[WARNING] [USER_LIB] Don't know how to change %, returning\n", lib);
        return lib;
    }
}

run_darwin_link :: (w: Workspace, m: *Message_Phase) {
    cmd :: (args: .. string, redirect_stdout_to_file := "", loc := #caller_location) -> bool {
        log("[CMD] %\n", get_quoted_command_string(args));

        result, output_string, error_string := run_command(..args, capture_and_return_output = redirect_stdout_to_file != "");
        if result.exit_code {
            if output_string then log("%", output_string);
            if error_string then log("%", error_string);
            print("Command failed with exit code '%'.\n", result.exit_code);
            return false;
        }

        if redirect_stdout_to_file then write_entire_file(redirect_stdout_to_file, output_string);
        return true;
    }

    options := get_build_options(w);

    arguments: [..] string;

    // clang throws an error if the -framework XXX args are added separately
    // some weird interaction with shell quoting
    array_add(*arguments, "/bin/bash");
    array_add(*arguments, "-c");

    sb : String_Builder;
    print_to_builder(*sb, "%", "clang-14");
    print_to_builder(*sb, "%", " --verbose");
    print_to_builder(*sb, "%", " -fuse-ld=lld");

    sysroot := "/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk";
    print_to_builder(*sb, "%", " --sysroot");
    print_to_builder(*sb, "%", " /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk");
    print_to_builder(*sb, "%", " -L");
    print_to_builder(*sb, "%", " /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/lib");
    print_to_builder(*sb, "%", " --target=x86_64-apple-macosx10.10.0-macho");
    for m.user_libraries {
        replaced := replace_user_library_darwin(it);
        if contains(replaced, "dylib") {
            lib_path := parse_path(replaced);
            lib_file := lib_path.words[lib_path.words.count - 1];
            lib_path.words.count -=1;
            lib_dir := path_to_string(lib_path);
            log("[XXXXX] % %\n", lib_file, lib_dir);
            print_to_builder(*sb, "%", " -L");
            print_to_builder(*sb, "%", lib_dir);
            lib_file = replace(lib_file, ".dylib", "");
            lib_file = replace(lib_file, "lib", "-l");
            print_to_builder(*sb, " %", lib_file);
        }
        log("user_library:\n  %\n  %\n", it, replaced);
        // print_to_builder(*sb, " %", replaced);
    }

    for m.compiler_generated_object_files {
        log("compiler_generated_object_file %\n", it);
        print_to_builder(*sb, " %", it);
    }
    // FIXME ?
    // for m.support_object_files {
    //     log("support_object_files %\n", it);
    //     print_to_builder(*sb, "%", it);
    // }
    // FIXME ? needed ? 
    // print_to_builder(*sb, "%", "-export_dynamic");
    // print_to_builder(*sb, "%", "-dynamic");
    print_to_builder(*sb, "%", " -o");

    target_filename := tprint("%1%2%3", options.output_path, options.output_executable_name, "");
    log("target_filename: %\n", target_filename);
    print_to_builder(*sb, " %", target_filename);

    // FIXME ? NEEDED ? 
    // print_to_builder(*sb, "%", "-macosx_version_min");
    // print_to_builder(*sb, "%", "10.10");

    for m.system_libraries {
        replaced := replace_system_library_darwin(it);
        log("system_library:\n  %\n  %\n", it, replaced);
        print_to_builder(*sb, " %", replaced);
    }
    for m.user_libraries {
        replaced := replace_user_library_darwin(it);
        if contains(replaced, "dylib") {
            continue;
        }
        log("user_library:\n  %\n  %\n", it, replaced);
        print_to_builder(*sb, " %", replaced);
    }
    array_add(*arguments, builder_to_string(*sb));

    print("Link line: %\n", get_quoted_command_string(arguments));
    cmd(..arguments);
    compiler_custom_link_command_is_complete(w);
}

create_workspace_darwin :: (name: string, output: string) -> Workspace {
    w := compiler_create_workspace(name);
    if !w {
        log_error("Error: Could not create a workspace\n");
        exit(1);
    }
    opts := get_build_options();
    opts.lazy_foreign_function_lookups = true;
    opts.os_target = Operating_System_Tag.MACOS;
    opts.output_executable_name = output;
    opts.llvm_options.output_bitcode       = true;
    opts.llvm_options.output_llvm_ir       = false;
    opts.llvm_options.enable_split_modules = false;
    opts.llvm_options.target_system_triple = "x86_64-apple-macosx10.10.0-macho";
    opts.use_custom_link_command = true;
    set_build_options(opts, w);
    return w;
}

run_build_darwin :: (files: [] string, w: Workspace, verbose: bool) {
    pp := Program_Print.get_plugin();

    compiler_begin_intercept(w);
    for files {
        add_build_file(it, w);
    }
    post_write_messages: [..] *Message_Phase;
    while true {
        message := compiler_wait_for_message();
        if !message break;
        Program_Print.program_print_receive_message(pp, message);

        if message.kind == {
            case .PHASE; {
                phase := cast(*Message_Phase) message;
                if phase.phase == .POST_WRITE_EXECUTABLE {
                    array_add(*post_write_messages, phase);
                }
                if phase.phase == .READY_FOR_CUSTOM_LINK_COMMAND {
                    run_darwin_link(message.workspace, phase);
                }
            }

            case .COMPLETE; break;
        }
    }
    if verbose {
        Program_Print.program_print_finish(pp);
        for m: post_write_messages {
            log("\n");
            if m.executable_write_failed {
                log_error("--- FAILED: Workspace %,  \"%\" ---\n", m.workspace, get_name(m.workspace));
            } else {
                log("--- Workspace %,  \"%\" ---\n", m.workspace, get_name(m.workspace));
            }
            log("Compiled Objects: %\n", join(..m.compiler_generated_object_files, ", "));
            log("Support Objects: %\n",  join(..m.support_object_files, ", "));
            log("System Libraries: %\n", join(..m.system_libraries, ", "));
            log("User Libraries: %\n",   join(..m.user_libraries, ", "));
            log("\n");
        }
    }
    compiler_end_intercept(w);
    set_build_options_dc(.{do_output=false, write_added_strings=false});
}
