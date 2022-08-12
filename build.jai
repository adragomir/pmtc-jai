#import "Basic";
#import "Compiler";

#load "build_cross.jai";

build :: () {
    set_working_directory(#filepath);
    w := create_workspace_darwin("main", "main");
    run_build_darwin(string.["main.jai"], w, false);
}

#run build();
