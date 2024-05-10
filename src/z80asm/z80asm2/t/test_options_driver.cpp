#include "test.h"
#include "xassert.h"
#include "../options.h"
#include <string>
using namespace std;

void test_option_flags();
void test_exit_copyright();
void test_exit_help();
void test_option_cpu1();
void test_option_cpu2();
void test_option_cpu3();
void test_option_cpu4();
void test_option_swap_ixiy();
void test_option_verbose();
void test_option_lib_filename();
void test_option_output_dir();
void test_option_bin_filename();
void test_option_origin1();
void test_option_origin2();
void test_option_filler1();
void test_option_filler2();
void test_option_appmake();
void test_option_m4();
void test_option_include_path();
void test_option_library_path();
void test_option_library();
void test_option_consol_obj_filename();
void test_option_defines();
void test_option_float_format1();
void test_option_float_format2();
void test_option_float_format3();
void test_option_float_format4();
void test_option_input_files1();
void test_option_input_files2();
void test_option_input_files3();
void test_option_input_files4();
void test_option_input_files5();
void test_option_input_files6();
void test_option_input_files7();
void test_option_input_files8();
void test_option_input_files9();
void test_option_input_files10();
void test_option_input_files11();
void test_option_input_files12();
void test_option_input_files13();
void test_option_input_files14();
void test_option_input_files15();
void test_option_input_files16();
void test_option_input_files17();
void test_option_input_files18();
int exec_exit_copyright();
int exec_exit_help();
int exec_option_cpu1_invalid();
int exec_option_verbose1();
int exec_option_verbose2();
int exec_option_origin1();
int exec_option_origin2();
int exec_option_origin3();
int exec_option_origin4();
int exec_option_filler1();
int exec_option_filler2();
int exec_option_filler3();
int exec_option_filler4();
int exec_option_filler5();
int exec_option_float_format();
int exec_option_input_files1();
int exec_option_input_files4();
int exec_option_input_files8();
int exec_option_input_files9();
int exec_option_input_files10();
int exec_option_input_files13();

int main(int argc, char* argv[]) {
	xassert_init(argv[0]);
    start_testing(argv[0]);

    if (argc == 2) {
        string arg = argv[1];
        if (arg == "exec_exit_copyright")
            return exec_exit_copyright();
        if (arg == "exec_exit_help")
            return exec_exit_help();
        if (arg == "exec_option_cpu1_invalid")
            return exec_option_cpu1_invalid();
        if (arg == "exec_option_verbose1")
            return exec_option_verbose1();
        if (arg == "exec_option_verbose2")
            return exec_option_verbose2();
        if (arg == "exec_option_origin1")
            return exec_option_origin1();
        if (arg == "exec_option_origin2")
            return exec_option_origin2();
        if (arg == "exec_option_origin3")
            return exec_option_origin3();
        if (arg == "exec_option_origin4")
            return exec_option_origin4();
        if (arg == "exec_option_filler1")
            return exec_option_filler1();
        if (arg == "exec_option_filler2")
            return exec_option_filler2();
        if (arg == "exec_option_filler3")
            return exec_option_filler3();
        if (arg == "exec_option_filler4")
            return exec_option_filler4();
        if (arg == "exec_option_filler5")
            return exec_option_filler5();
        if (arg == "exec_option_float_format")
            return exec_option_float_format();
        if (arg == "exec_option_input_files1")
            return exec_option_input_files1();
        if (arg == "exec_option_input_files4")
            return exec_option_input_files4();
        if (arg == "exec_option_input_files8")
            return exec_option_input_files8();
        if (arg == "exec_option_input_files9")
            return exec_option_input_files9();
        if (arg == "exec_option_input_files10")
            return exec_option_input_files10();
        if (arg == "exec_option_input_files13")
            return exec_option_input_files13();
        FAIL();
        DIAG("invalid test " << arg);
    }
    else {
        test_option_flags();
        test_exit_copyright();
        test_exit_help();
        test_option_cpu1();
        test_option_cpu2();
        test_option_cpu3();
        test_option_cpu4();
        test_option_swap_ixiy();
        test_option_verbose();
        test_option_lib_filename();
        test_option_output_dir();
        test_option_bin_filename();
        test_option_origin1();
        test_option_origin2();
        test_option_filler1();
        test_option_filler2();
        test_option_appmake();
        test_option_m4();
        test_option_include_path();
        test_option_library_path();
        test_option_library();
        test_option_consol_obj_filename();
        test_option_defines();
        test_option_float_format1();
        test_option_float_format2();
        test_option_float_format3();
        test_option_float_format4();
        test_option_input_files1();
        test_option_input_files2();
        test_option_input_files3();
        test_option_input_files4();
        test_option_input_files5();
        test_option_input_files6();
        test_option_input_files7();
        test_option_input_files8();
        test_option_input_files9();
        test_option_input_files10();
        test_option_input_files11();
        test_option_input_files12();
        test_option_input_files13();
        test_option_input_files14();
        test_option_input_files15();
        test_option_input_files16();
        test_option_input_files17();
        test_option_input_files18();
    }

    done_testing();
}
