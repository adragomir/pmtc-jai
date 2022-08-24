#import "System";

#run {
    if get_current_workspace() != 2   return;

    #load "build_cross.jai";

    // set_build_options_dc(.{do_output=false});
    // options := get_build_options();
    //
    // w := compiler_create_workspace("Main program");
    // options.output_type = .EXECUTABLE;
    // set_build_options(options, w);
    //
    // add_build_file("generate.jai", w);

    set_working_directory(#filepath);
    w := create_workspace_darwin("generate", "generate");
    run_build_darwin(string.["generate.jai"], w, false);
}

main :: () {
    set_working_directory(path_strip_filename(get_path_of_running_executable()));
    if !generate_bindings() {
        exit(1);
    }
}

//--------------------

OMIT_LIST :: string.[
];

generate_bindings :: () -> bool {
    output_filename: string;
    opts: Generate_Bindings_Options;
    {
        using opts;

        output_filename  = "generated_bindings.jai";
        array_add(*libpaths, sprint("%bin/dyld-cache/usr/lib/", GENERATOR_ROOT));
        array_add(*libnames, "libSystem");
        array_add(*source_files, "/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include/dispatch/dispatch.h");
        array_add(*system_include_paths, GENERATOR_DEFAULT_SYSTEM_INCLUDE_PATH);
        array_add(*system_include_paths, "/Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include");

        // generate_foreign_library_declarations = false;
        will_print_bindings = () {
            // Change the library name to be the same on all platforms
            // so that we don't have to generate identical bindings for every platform just because the library name is different.
            context.compiler.libraries[0].name = "libdispatch";
        };
        footer = DISPATCH_FOOTER;

        strip_flags = Strip_Flags.FUNCTIONS_WITH_VALIST;
        log_stripped_declarations = true;
        try_to_preserve_comments = false;
        visitor     = dispatch_visitor;
        generate_compile_time_struct_checks = false;
    }

    return generate_bindings(opts, output_filename);
}

available_flag_bits: Table(string, *Enum);
struct_type_decl: *Enum;

dispatch_visitor :: (decl: *Declaration, parent_decl: *Declaration) -> Declaration_Visit_Result {
    log("VISIT % %\n", decl.name, decl.kind);
    if !starts_with(decl.name, "dispatch") {
        decl.decl_flags |= .OMIT_FROM_OUTPUT;
        return .STOP;
    } else {
        log("OUTPUT % %\n", decl.name, decl.kind);
    }
    // Omit header definitions
    // if decl.kind == .MACRO_DEFINITION && ends_with(decl.name, "_H") {
    //     print("MACRO_DEFINITION removed: %\n", decl.name);
    //     decl.decl_flags |= .OMIT_FROM_OUTPUT;
    //     return .STOP;
    // }

    // Omit our OMIT_LIST
    // if !parent_decl && array_find(OMIT_LIST, decl.name) {
    //     print("OMIT_LIST: %\n", decl.name);
    //     decl.decl_flags |= .OMIT_FROM_OUTPUT;
    //     return .STOP;
    // }

    if decl.kind == .ENUM {
        // en := cast(*Enum)decl;
        // if en.name == "VkStructureType" {
        //     struct_type_decl = en; // Save for later
        // }
        //
        // // Almost all enums should be unsigned
        // if en.type && decl.name != "VkResult" {
        //     if en.type.size == {
        //         case 1;
        //             en.type = context.compiler.type_def_u8;
        //         case 2;
        //             en.type = context.compiler.type_def_u16;
        //         case 4;
        //             en.type = context.compiler.type_def_u32;
        //         case 8;
        //             en.type = context.compiler.type_def_u64;
        //     }
        // }
        //
        // if contains(decl.name, "FlagBits") {
        //     en.flags |= .IS_ENUM_FLAGS;
        //     en.flags |= .VALUES_IN_HEX;
        //
        //     // Remember this so we can replace the generic VkFlags aliases with the actual enum_flag's type below. :VkFlags
        //     table_add(*available_flag_bits, decl.name, en);
        // }
    }

    // Replace typedef which has "VkFlags" as value. :VkFlags
    // VkAccessFlags :: VkFlags   ->   VkAccessFlags :: VkAccessFlagBits;
    // We don't change the name of the FlagBits enum directly because both the ...FlagBits and the ...Flags aliases are used in declarations.
    if decl.kind == .TYPEDEF && decl.type.type_of_typedef &&  decl.type.type_of_typedef.name == "VkFlags" {
        //print("TYPEDEF(VkFlags):%\n", << decl.name);
        // flags_name := replace(decl.name, "Flags", "FlagBits");
        // enum_decl, found := table_find(*available_flag_bits, flags_name);
        // if found {
        //     type := New(CType);
        //     type.type_of_enum = enum_decl;
        //     type.size = enum_decl.type.size;
        //     decl.type = type;
        // }
    }

    // Set the default value for sType.
    // if parent_decl && parent_decl.kind == .STRUCT && parent_decl.name != "VkBaseInStructure" && parent_decl.name != "VkBaseOutStructure" && 
    //         decl.kind == .DECLARATION && decl.name == "sType" {
    //
    //     enum_value_name := get_sType_default_value_from_struct_name(parent_decl.name);
    //     enum_value: *Enum.Enumerate;
    //     for * struct_type_decl.enumerates {
    //         if it.output_name == enum_value_name {
    //             enum_value = it;
    //             break;
    //         }
    //     }
    //     assert(enum_value != null, "Could not find % enum value for \"%\"", struct_type_decl.name, enum_value_name);
    //
    //     literal := New(Literal);
    //     literal.literal_kind = .ENUM;
    //     literal.enum_type = struct_type_decl;
    //     literal.enum_value = enum_value;
    //     decl.expression = literal;
    // }
    //
    return .RECURSE;
}

get_sType_default_value_from_struct_name :: (name: string) -> string {
    assert(name.count >= 3);

    is_upper :: (byte: u8) -> bool {
        if byte >= #char "A" && byte <= #char "Z" return true;
        return false;
    }

    is_num :: (byte: u8) -> bool {
        if byte >= #char "0" && byte <= #char "9" return true;
        return false;
    }

    builder: String_Builder;
    append(*builder, name[2]);
    for i:3..name.count-1 {
        if is_upper(name[i]) {
            is_first_uppercase := !is_upper(name[i-1]);
            is_end_of_uppercase_word := (i != name.count-1 && !is_upper(name[i+1]));
            is_bit_count := is_num(name[i-1]) && slice(name, i, 3) == "Bit";
            if (is_first_uppercase || is_end_of_uppercase_word) && !is_bit_count {
                append(*builder, #char "_");
            } else if (i >= 4 && slice(name, i-4, 4) == "AABB") { // Special case hack for names involing AABB
                append(*builder, #char "_");
            }
            append(*builder, name[i]);
        } else if is_num(name[i]) {
            if !is_num(name[i-1]) {
                append(*builder, #char "_");
            }
            append(*builder, name[i]);
        } else {
            append(*builder, to_upper(name[i]));
        }
    }

    return builder_to_string(*builder);
}

#scope_file
#import "Basic";
#import "Compiler";
#import "Check";
#import "Bindings_Generator";
#import "File";
#import "String";
#import "Hash_Table";

DISPATCH_FOOTER :: #string END
#scope_file

#if OS == .WINDOWS {
    libdispatch :: #foreign_system_library "libdispatch";
} else #if OS == .LINUX {
    libdispatch :: #foreign_system_library "libdispatch";
} else #if OS == .MACOS {
    libdispatch :: #foreign_system_library "libdispatch";
}
END
