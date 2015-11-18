
// startup=0 //////////////////////////////////////////////////

include(../../clib_instantiate_begin.m4)

include(../driver/terminal/cpm_00_input_cons.m4)
m4_cpm_00_input_cons(_stdin, 0x0100, 64)

include(../driver/terminal/cpm_00_output_cons.m4)
m4_cpm_00_output_cons(_stdout, 0x0010)

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl

include(../driver/character/cpm_00_input_reader.m4)
m4_cpm_00_input_reader(_stdrdr, 0x0100)

include(../driver/character/cpm_00_output_punch.m4)
m4_cpm_00_output_punch(_stdpun, 0x0010)

include(../driver/character/cpm_00_output_list.m4)
m4_cpm_00_output_list(_stdlst, 0x0010)

include(../../clib_instantiate_end.m4)


// startup=4 //////////////////////////////////////////////////

include(../../clib_instantiate_begin.m4)

include(../driver/terminal/cpm_01_input_kbd_dcio.m4)
m4_cpm_01_input_kbd_dcio(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64)

include(../driver/terminal/cpm_01_output_dcio.m4)
m4_cpm_01_output_dcio(_stdout, 0x2370)

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl

include(../driver/character/cpm_00_input_reader.m4)
m4_cpm_00_input_reader(_stdrdr, 0x0100)

include(../driver/character/cpm_00_output_punch.m4)
m4_cpm_00_output_punch(_stdpun, 0x0010)

include(../driver/character/cpm_00_output_list.m4)
m4_cpm_00_output_list(_stdlst, 0x0010)

include(../../clib_instantiate_end.m4)

///////////////////////////////////////////////////////////////
