#import "Basic";
#import "Compiler";

#load "/Users/adragomi/build_cross.jai";

build :: () {
    set_working_directory(#filepath);
    w := create_workspace_darwin("main", "main");
    opts := get_build_options(w);

    import_path : [..] string;
    array_add(*import_path, ..opts.import_path);
    array_add(*import_path, tprint("%/modules/", #filepath));
    opts.import_path = import_path;
    set_build_options(opts, w);

    run_build_darwin(string.["main.jai"], w, false);
}

#run build();
