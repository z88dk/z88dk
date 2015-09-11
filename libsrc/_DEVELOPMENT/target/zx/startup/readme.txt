
startup=0, 32

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(../driver/terminal/zx_01_output_char_32.m4)dnl
m4_zx_01_output_char_32(_stdout, 0x2370, 0, 0, 0, 32, 0, 24, 0, _font_8x8_rom, 56, 0, 56)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl



startup=1, 33

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(../driver/terminal/zx_01_output_char_32_tty_z88dk.m4)dnl
m4_zx_01_output_char_32_tty_z88dk(_stdout, 0x2370, 0, 0, 0, 32, 0, 24, 0, _font_8x8_rom, 56, 0, 56)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl



startup=4, 36

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(../driver/terminal/zx_01_output_char_64.m4)dnl
m4_zx_01_output_char_64(_stdout, 0x2370, 0, 0, 0, 64, 0, 24, 0, _font_4x8_default, 56, 0, 56)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl



startup=5, 37

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(../driver/terminal/zx_01_output_char_64_tty_z88dk.m4)dnl
m4_zx_01_output_char_64_tty_z88dk(_stdout, 0x2370, 0, 0, 0, 64, 0, 24, 0, _font_4x8_default, 56, 0, 56)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl



startup=8, 40

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(../driver/terminal/zx_01_output_fzx.m4)dnl
m4_zx_01_output_fzx(_stdout, 0x2370, 0, 0, 0, 32, 0, 24, 0, _ff_ind_Termino, 56, 0, 56, 0, 256, 0, 192, 1, 0, 3, 0)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl



startup=9, 41

include(../driver/terminal/zx_01_input_kbd_inkey.m4)dnl
m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, 0x03b0, 64, 1, 500, 15)dnl

include(../driver/terminal/zx_01_output_fzx_tty_z88dk.m4)dnl
m4_zx_01_output_fzx_tty_z88dk(_stdout, 0x2370, 0, 0, 0, 32, 0, 24, 0, _ff_ind_Termino, 56, 0, 56, 0, 256, 0, 192, 1, 0, 3, 0)dnl

include(../../m4_file_dup.m4)dnl
m4_file_dup(_stderr, 0x80, __i_fcntl_fdstruct_1)dnl

