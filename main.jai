#import "Basic";
#import "String";
#import "POSIX";
#import "File";
#import "File_Utilities";
// Math :: #import "Math";
// Process :: #import "Process";
// File_Async :: #import "File_Async";
// File_Utilities :: #import "File_Utilities";
// File_Watcher :: #import "File_Watcher";
// Text_File_Handler :: #import "Text_File_Handler";
// Thread :: #import "Thread";
System :: #import "System";
// Atomics :: #import "Atomics";
// Base64_Encode :: #import "Base64_Encode";
// Bit_Array :: #import "Bit_Array";
// Bit_Operations :: #import "Bit_Operations";
// Bucket_Array :: #import "Bucket_Array";
// Command_Line :: #import "Command_Line";
// Deep_Copy :: #import "Deep_Copy";
// Hash :: #import "Hash";
// Hash_Table :: #import "Hash_Table";
// Mail :: #import "Mail";
// PCG :: #import "PCG";
// Pool :: #import "Pool";
// Print_Color :: #import "Print_Color";
// RadixSort :: #import "RadixSort";
// Random :: #import "Random";
// Reflection :: #import "Reflection";
// Sloppy_Math :: #import "Sloppy_Math";
// Sort :: #import "Sort";
// Tagged_Union :: #import "Tagged_Union";

dnssd :: #import,dir "./modules/dnssd";
proto :: #import,dir "./modules/proto";
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

test_send_as_view :: (in: []u8) {
    print("view: % %\n", in.count, cast (string) in);
}

test_add :: (in: *[..]u8) {
    array_add(in, .. cast([]u8)"some more");
}

xxx :: (b: []u8) {
    index := 0;
    while index < b.count {

    }
}

main :: () {
    test := 10;
    val := ifx test == 1 {
        10;
    } else ifx test == 2 {
        20;
    } else {
        x := 5;
        x + 1;
    };
    val2 := ifx 1 {
        y := 10;
        y + 1;
    }
    print("val %, val2: %\n", val, val2);
    message_val: mtproto.TestMessage;
    {
        message_val.mstrings = resizable(string.["a", "bbb", "CCCC"]);
        sva: mtproto.SubTestMessage;

        ffloat64 := cast (float64) 10.5;
        sva.ffloat64 = *ffloat64;
        sva.ffstring = "aaaa";
        sva.fu32 = cast(u32) 40;
        sva.ftestenum = mtproto.TestEnum.Val1;

        message_val.msub = sva;
    }
    message_val_output : [..]u8;
    print("Encoding\n");
    mtproto.TestMessage.encode(*message_val_output, message_val);
    print("len: %, val: % \n", message_val_output.count, message_val_output);
    {
        print("decoding %\n", message_val_output);
        msg := mtproto.TestMessage.decode(message_val_output);
        print("msg: %\n", msg);
        print("float: %\n", << msg.msub.ffloat64);
    }
}


// main2 :: () {
//     // t := type_of(mtproto.EmcToolData);
//     // T :: mtproto.EmcToolData._desc_table;
//     // desc_table := cast(*T) Dynamic_New(T);
//     // print("%\n", desc_table.index);
//     // print("%\n", desc_table.orientation);
//     //
//     message_val: mtproto.TestMessage;
//     {
//         message_val.mstrings = resizable(string.["a", "bbb", "CCCC"]);
//         sva: mtproto.SubMessage;
//
//         ffloat64 := cast (float64) 10.5;
//         sva.ffloat64 = *ffloat64;
//         sva.ffstring = "aaaa";
//         sva.fu32 = cast(u32) 40;
//         sva.ftestenum = mtproto.TestEnum.Val1;
//
//         message_val.msub = sva;
//     }
//     message_val_output : [..]u8;
//     print("Encoding\n");
//     mtproto.Message.encode(*message_val_output, message_val);
//     print("len: %, val: % \n", message_val_output.count, message_val_output);
//     // // encode(*val);
//     // // x := mtproto.HalPinDirection.HAL_IN;
//     // // y := type_info(type_of(x));
//     // // print("% % % ::: %\n", cast(s32)x, << y, y.type, cast(u8) true);
//     //
//     // val_test1 : mtproto.Test1;
//     // test1_a := cast(s32) 150;
//     // val_test1.a = *test1_a;
//     // output_test1 : [..]u8;
//     // mtproto.Test1.encode(*output_test1, val_test1);
//     //
//     // format_int := *context.print_style.default_format_int;  // Get a pointer to this so we can play with it.
//     // format_int.base = 16;
//     // print("len: %, val: % \n", output_test1.count, output_test1);
//     //
//     // // {
//     // //     val_test2 : mtproto.Test2;
//     // //     test2_b := "testing";
//     // //     val_test2.b = *test2_b;
//     // //     output_test2 : [..]u8;
//     // //     mtproto.Test2.encode(*output_test2, val_test2);
//     // //
//     // //     format_int := *context.print_style.default_format_int;  // Get a pointer to this so we can play with it.
//     // //     format_int.base = 16;
//     // //     print("len: %, val: % \n", output_test2.count, output_test2);
//     // // }
//     // // {
//     // //     val_test3 : mtproto.Test3;
//     // //     val_test3.c = *val_test1;
//     // //     output_test3 : [..]u8;
//     // //     mtproto.Test3.encode(*output_test3, val_test3);
//     // //
//     // //     format_int := *context.print_style.default_format_int;  // Get a pointer to this so we can play with it.
//     // //     format_int.base = 16;
//     // //     print("len: %, val: % \n", output_test3.count, output_test3);
//     // // }
//     // // {
//     // //     val_test4 : mtproto.Test4;
//     // //     val_test4.d = s32.[3, 270, 86942];
//     // //     output_test4 : [..]u8;
//     // //     mtproto.Test4.encode(*output_test4, val_test4);
//     // //
//     // //     format_int := *context.print_style.default_format_int;  // Get a pointer to this so we can play with it.
//     // //     format_int.base = 16;
//     // //     print("len: %, val: % \n", output_test4.count, output_test4);
//     // // }
//     // //
//     // // format_int.base = 10;
//     // //
//     // // {
//     // //     u_32 := u8.[ 2, 0, 0, 0 ];
//     // //     tmp, read := proto.decode_fixed(u32, u_32);
//     // //     print("% %\n", tmp, read);
//     // // }
//     // // {
//     // //     u_64 := u8.[ 1, 0, 0, 0, 0, 0, 0, 0 ];
//     // //     tmp, read := proto.decode_fixed(u64, u_64);
//     // //     print("% %\n", tmp, read);
//     // // }
//     // // {
//     // //     i_32 := u8.[ 0xFF, 0xFF, 0xFF, 0xFF ];
//     // //     tmp, read := proto.decode_fixed(s32, i_32);
//     // //     print("% %\n", tmp, read);
//     // // }
//     // // {
//     // //     i_64 := u8.[ 0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF ];
//     // //     tmp, read := proto.decode_fixed(s64, i_64);
//     // //     print("% %\n", tmp, read);
//     // // }
//     // // {
//     // //     f_32 := u8.[ 0x00, 0x00, 0xa0, 0x40 ];
//     // //     tmp, read := proto.decode_fixed(float32, f_32);
//     // //     print("% %\n", tmp, read);
//     // // }
//     // // {
//     // //     f_64 := u8.[ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x14, 0x40 ];
//     // //     tmp, read := proto.decode_fixed(float64, f_64);
//     // //     print("% %\n", tmp, read);
//     // // }
//     // // {
//     // //     tmp : [..]u8;
//     // //     val := cast(float64)5.0;
//     // //     proto.append_fixed(*tmp, val, proto.FieldDesc.{});
//     // // }
//     // // {
//     // //     buf := u8.[0x96, 0x01];
//     // //     val, read := proto.decode_varint(s32, buf);
//     // //     print("decoded varint: % %\n", val, read);
//     // // }
//     // // {
//     // //     // arr := u8.[0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47];
//     // //     // f :: (in: []u8) {
//     // //     //     print("got %\n", cast(string) in);
//     // //     // }
//     // //     // f(arr[1..2]);
//     // // }
//     // // {
//     // //     arr : [..]u8;
//     // //     proto.append_tag(*arr, proto.FieldDesc.{tag=150, type=string, wt= .Varint});
//     // //     tag, wire, read := proto.decode_tag(arr);
//     // //     print("% % %\n", tag, wire, read);
//     // // }
//     // // {
//     // //     arr := u8.[18];
//     // //     tag, wire, read := proto.decode_tag(arr);
//     // //     print("tag / wire / read: % % %\n", tag, wire, read);
//     // // }
//     // // {
//     // //     arr : [..]u8;
//     // //     val := cast(float64) 10.5;
//     // //     print("result before append fixed : % %\n", arr, arr.count);
//     // //     proto.append_fixed(*arr, val, proto.FieldDesc.{});
//     // //     print("result after append fixed : % %\n", arr, arr.count);
//     // //     val2 := proto.decode_fixed(float64, arr);
//     // //     print("decoded result: %\n", val2);
//     // // }
//     {
//         print("decoding %\n", message_val_output);
//         msg := mtproto.Message.decode(message_val_output);
//         print("msg: %\n", msg);
//         print("float: %\n", << msg.msub.ffloat64);
//     }
//     // print(proto.decode_code_writer(mtproto.Message.{}));
//     // print("------------------\n");
//     // print(proto.decode_code_writer(mtproto.SubMessage.{}));
//     // print("AAAAAAAA\n");
//     // arr : [..]u8;
//     // KK :: enum u32 {
//     //     val1 :: 1;
//     //     val2 :: 2;
//     // }
//     // proto.append_varint(*arr, u32, cast(u32) 1430, proto.FieldDesc.{tag=1, type=type_of(u32), wt=.Varint});
//     // proto.append_varint(*arr, s32, cast(s32) 1430, proto.FieldDesc.{tag=1, type=type_of(s32), wt=.Varint});
//     // proto.append_varint(*arr, KK, KK.val2, proto.FieldDesc.{tag=1, type=type_of(KK), wt=.Varint});
//     // proto.append_varint(*arr, bool, true, proto.FieldDesc.{tag=1, type=type_of(bool), wt=.Varint});
//     // print("aaaa %\n", arr);
// }

