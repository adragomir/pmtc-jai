#import "Basic";

#import "POSIX";
#import "macos";
#import "System";
#import "File";
#import "File_Utilities";
Math :: #import "Math";
Process :: #import "Process";
Clipboard :: #import "Clipboard";
Curl :: #import "Curl";
File_Async :: #import "File_Async";
File_Utilities :: #import "File_Utilities";
File_Watcher :: #import "File_Watcher";
Ft2121 :: #import "freetype-2.12.1";
Ft255 :: #import "freetype255";
Gamepad :: #import "Gamepad";
Input :: #import "Input";
// GetRect - not done
ImGui :: #import "ImGui";
GL :: #import "GL";
Iprof :: #import "Iprof";
Keymap :: #import "Keymap";
Lz4 :: #import "lz4-1.9.1";
Meow_Hash :: #import "Meow_Hash";
MeshOptimizer :: #import "meshoptimizer";
Metal :: #import "Metal";
MojoShader :: #import "MojoShader";
// nvtt incomplete for mac
Objective_C :: #import "Objective_C";
PlMpeg :: #import "pl_mpeg";
SDL :: #import "SDL";
Shared_Memory_Channel :: #import "Shared_Memory_Channel";
Simp :: #import "Simp";
Sound_Player :: #import "Sound_Player";
Stb_Image :: #import "stb_image";
Text_File_Handler :: #import "Text_File_Handler";
Thekla_Atlas :: #import "Thekla_Atlas";
Thread :: #import "Thread";
Window_Creation :: #import "Window_Creation";
System :: #import "System";

Adpcm :: #import "Adpcm";
Atomics :: #import "Atomics";
Base64_Encode :: #import "Base64_Encode";
Bit_Array :: #import "Bit_Array";
Bit_Operations :: #import "Bit_Operations";
Bucket_Array :: #import "Bucket_Array";
Command_Line :: #import "Command_Line";
Crc :: #import "Crc";
Deep_Copy :: #import "Deep_Copy";
Float16 :: #import "Float16";
Hash :: #import "Hash";
Hash_Table :: #import "Hash_Table";
Icon :: #import "Icon";
IntroSort :: #import "IntroSort";
Mail :: #import "Mail";
PCG :: #import "PCG";
Pool :: #import "Pool";
Print_Color :: #import "Print_Color";
RadixSort :: #import "RadixSort";
Random :: #import "Random";
Reflection :: #import "Reflection";
Sloppy_Math :: #import "Sloppy_Math";
Soa :: #import "Soa";
Sort :: #import "Sort";
Tagged_Union :: #import "Tagged_Union";
Unicode :: #import "Unicode";
Wav_File :: #import "Wav_File";
Window_Type :: #import "Window_Type";
Zip_File_Directory :: #import "Zip_File_Directory";
Md5 :: #import "md5";

dnssd :: #import,dir "./modules/dnssd";
mtproto :: #import,dir "./modules/machinetalk_proto";

browse_reply_callback :: (ref: dnssd.DNSServiceRef, flags: dnssd.DNSServiceFlags, iface: u32, err: dnssd.DNSServiceErrorType, name: *u8, regtype: *u8, domain: *u8, a7: *void) #c_call{
    new_context: Context;
    push_context new_context {
        print("AAAAAAAAAAAAAA % % %\n", to_string(name), to_string(regtype), to_string(domain));
    }
}

dnssd_browse :: () {
    root_ref: dnssd.DNSServiceRef;
    err := dnssd.DNSServiceCreateConnection(*root_ref);
    if err != xx dnssd.kDNSServiceErr.kDNSServiceErr_NoError {
        print("ERROR ! %\n", err);
    }
    browse_ref := root_ref;
    err = dnssd.DNSServiceBrowse(
        *browse_ref,
        xx dnssd.kDNSServiceFlag.kDNSServiceFlagsShareConnection,
        dnssd.kDNSServiceInterfaceIndexAny,
        to_c_string("_http._tcp"),
        to_c_string("local."),
        browse_reply_callback,
        null
    );
    if err != xx dnssd.kDNSServiceErr.kDNSServiceErr_NoError {
        print("ERROR Browse ! %\n", err);
    }
    socket := dnssd.DNSServiceRefSockFD(root_ref);
    if socket <= 0 {
        print("ERROR SOCKET % \n", socket);
    }

    poll_fds: [1] pollfd;
    poll_fds[0].fd = socket;
    poll_fds[0].events = POLLIN;
    poll_timeout_ms := cast(s32) 1000;
    while true {
        num_events := poll(poll_fds.data, cast(u32) 1, poll_timeout_ms);
        if num_events == -1 {
            error_code, error_string := System.get_error_value_and_string();
            print("Couldn't poll events: % %\n", error_code, error_string);
            break;
        }
        if num_events > 0 {
            err = dnssd.DNSServiceProcessResult(root_ref);
			if (err) {
				print("DNSServiceProcessResult returned error %\n", err);
			}
			break;
        }
    }
}

print_members_and_types :: ($T: Type, name: string) {
    print("Members and Types of '%':\n", name);

    tis := type_info(T);
    for tis.members {
        builder: String_Builder;
        print_type_to_builder(*builder, it.type);
        type_string := builder_to_string(*builder);
        defer free(type_string);
        
        print("    %: %", it.name, type_string);
        print("\n");
    }
    print("\n");
}

main :: () {
    // t := type_of(mtproto.EmcToolData);
    T :: mtproto.EmcToolData._desc_table;
    desc_table := cast(*T) Dynamic_New(T);
    print("%\n", desc_table.index);
    print("%\n", desc_table.orientation);
    print_members_and_types(mtproto.EmcToolData._desc_table, "EmcToolData");
    // ti := type_info(mtproto.EmcToolData);
    // for ti.members {
    //     print("name: %\n", it.name);
    //     print("  type: %\n", << it.type);
    // }
    // print("%", << ti);
}

cross_compile_test_func :: () {
    set_working_directory(#filepath);

    print("%\n", <<type_info(mach_port_t));
    user, ok := get_username();
    print("%\n", user);
    print("hello sailor\n");
    // Process
    {
        args : [..] string;
        array_add(*args, "ls");
        array_add(*args, "-l");
        process_result, output_string, error_string, timeout_reached := Process.run_command(..args, working_directory="", capture_and_return_output=true, timeout_ms = 1000);

        if process_result.type == .FAILED_TO_LAUNCH {
            log_error("Could not run command: \"%\"", Process.get_quoted_command_string(args));
            return;
        }

        log("Exit code: % (timeout reached: %)", process_result.exit_code, timeout_reached);
        log("stdout:\n%", output_string);
        log("stderr:\n%", error_string);
    }
    {
        t := Clipboard.os_clipboard_get_text();
        print("Clipboard: %\n", t);
    }
    {
        handle := Curl.curl_easy_init();
        assert(handle != null);

        Curl.curl_easy_setopt(handle, .URL, "http://example.com");

        print("[Easy] Perform URL request...\n");
        res : Curl.CURLcode = Curl.curl_easy_perform(handle);
        print("[Easy] %\n", res);

        Curl.curl_easy_cleanup(handle);
    }
    {
        write_entire_file("a.txt", "some data");
        data := read_entire_file("a.txt");
    }
    {
        queue := File_Async.initialize_queue(u64);
        defer File_Async.destroy_queue(queue);

        File_Async.read_entire_file(queue, "a.txt", 0);

        val0, proc_data := File_Async.wait_for_completion(queue);
        assert(val0 == 0, "Was: %\n", val0);

        File_Async.write_entire_file(queue, "b.txt", proc_data, 2);

        val1 := File_Async.wait_for_completion(queue);
        assert(val1 == 2, "Was: %\n", val1);
        print("val1: %\n", val1);
    }
    {
      the_window = Window_Creation.create_window(640, 480, "Window Creation");

      quit := false;
      while !quit {
          Input.update_window_events();

          for Input.events_this_frame {
              if it.type == .QUIT then quit = true;

              if it.type == .KEYBOARD {
                  if it.key_pressed == 0 continue;

                  if it.key_code == .ESCAPE {
                      quit = true;
                  }
              }
          }
      }
    }
}
the_window : Window_Creation.Window_Type;


