#import "proto";
#import "Basic";

TestEnum :: enum u32 {
    Val1 :: 1;
    Val2 :: 2;
}

SubTestMessage :: struct {
    ffloat64: *float64;
    ffstring: string;
    fu32: u32;
    ftestenum: TestEnum;
    fbool: bool;

    _desc_table :: struct {
        ffloat64 := FieldDesc.{tag=1, type=type_of(float64), wt=.Fixed64};
        ffstring := FieldDesc.{tag=2, type=type_of(string), wt=.Size};
        fu32 := FieldDesc.{tag=3, type=type_of(u32), wt=.Varint};
        ftestenum := FieldDesc.{tag=4, type=type_of(u32), wt=.Varint};
        fbool := FieldDesc.{tag=5, type=type_of(bool), wt=.Varint};
    };

    encode :: (b: *[..]u8, self: SubTestMessage) {
        encode_code_runtime(b, self);
    }

    decode :: (b: []u8) -> SubTestMessage {
        return decode_code_runtime(b, SubTestMessage);
    }
}

TestMessage :: struct {
    mstrings: [..]string;
    msub: SubTestMessage;
    _desc_table :: struct {
        mstrings := FieldDesc.{tag=1, type=type_of(string), wt=.Size};
        msub := FieldDesc.{tag=2, type=type_of(SubTestMessage), wt=.Size};
    };
    encode :: (b: *[..]u8, self: TestMessage) {
        encode_code_runtime(b, self);
    }

    decode :: (b: []u8) -> TestMessage {
        return decode_code_runtime(b, TestMessage);
    }
}

