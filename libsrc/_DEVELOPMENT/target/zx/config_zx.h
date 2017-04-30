





#ifndef __CONFIG_Z88DK_H_
#define __CONFIG_Z88DK_H_

// Automatically Generated at Library Build Time














#undef  __Z88DK
#define __Z88DK  1992












#undef  __SPECTRUM
#define __SPECTRUM  1

#define __SPECTRUM_48        1
#define __SPECTRUM_128       2
#define __SPECTRUM_128_P2    4
#define __SPECTRUM_128_P2A   8
#define __SPECTRUM_128_P3    16
#define __SPECTRUM_PENTAGON  32












#undef  __Z80
#define __Z80  0x01

#define __Z80_NMOS  0x01
#define __Z80_CMOS  0x02

#define __CPU_CLOCK  3500000

#define __CPU_INFO  0x00

#define __CPU_INFO_ENABLE_SLL  0x01












#define __CLIB_OPT_MULTITHREAD  0x00

#define __CLIB_OPT_MULTITHREAD_LOCK_HEAPS  0x01
#define __CLIB_OPT_MULTITHREAD_LOCK_FILES  0x02
#define __CLIB_OPT_MULTITHREAD_LOCK_FLIST  0x04
#define __CLIB_OPT_MULTITHREAD_LOCK_FDTBL  0x08
#define __CLIB_OPT_MULTITHREAD_LOCK_FDSTR  0x10

#define __CLIB_OPT_IMATH  0

#define __CLIB_OPT_IMATH_FAST  0x0f

#define __CLIB_OPT_IMATH_FAST_DIV_UNROLL  0x01
#define __CLIB_OPT_IMATH_FAST_DIV_LZEROS  0x02
#define __CLIB_OPT_IMATH_FAST_MUL_UNROLL  0x04
#define __CLIB_OPT_IMATH_FAST_MUL_LZEROS  0x08
#define __CLIB_OPT_IMATH_FAST_LIA  0x80

#define __CLIB_OPT_IMATH_SELECT  0x00

#define __CLIB_OPT_IMATH_SELECT_FAST_ASR  0x01
#define __CLIB_OPT_IMATH_SELECT_FAST_LSR  0x02
#define __CLIB_OPT_IMATH_SELECT_FAST_LSL  0x04

#define __CLIB_OPT_TXT2NUM  0x04

#define __CLIB_OPT_TXT2NUM_INT_BIN  0x01
#define __CLIB_OPT_TXT2NUM_INT_OCT  0x02
#define __CLIB_OPT_TXT2NUM_INT_DEC  0x04
#define __CLIB_OPT_TXT2NUM_INT_HEX  0x08

#define __CLIB_OPT_TXT2NUM_LONG_BIN  0x10
#define __CLIB_OPT_TXT2NUM_LONG_OCT  0x20
#define __CLIB_OPT_TXT2NUM_LONG_DEC  0x40
#define __CLIB_OPT_TXT2NUM_LONG_HEX  0x80

#define __CLIB_OPT_TXT2NUM_SELECT  0x00

#define __CLIB_OPT_TXT2NUM_SELECT_FAST_BIN  0x01
#define __CLIB_OPT_TXT2NUM_SELECT_FAST_OCT  0x02
#define __CLIB_OPT_TXT2NUM_SELECT_FAST_DEC  0x04
#define __CLIB_OPT_TXT2NUM_SELECT_FAST_HEX  0x08

#define __CLIB_OPT_NUM2TXT  0x00

#define __CLIB_OPT_NUM2TXT_INT_BIN  0x01
#define __CLIB_OPT_NUM2TXT_INT_OCT  0x02
#define __CLIB_OPT_NUM2TXT_INT_DEC  0x04
#define __CLIB_OPT_NUM2TXT_INT_HEX  0x08

#define __CLIB_OPT_NUM2TXT_LONG_BIN  0x10
#define __CLIB_OPT_NUM2TXT_LONG_OCT  0x20
#define __CLIB_OPT_NUM2TXT_LONG_DEC  0x40
#define __CLIB_OPT_NUM2TXT_LONG_HEX  0x80

#define __CLIB_OPT_NUM2TXT_SELECT  0x00

#define __CLIB_OPT_NUM2TXT_SELECT_FAST_BIN  0x01
#define __CLIB_OPT_NUM2TXT_SELECT_FAST_OCT  0x02
#define __CLIB_OPT_NUM2TXT_SELECT_FAST_DEC  0x04
#define __CLIB_OPT_NUM2TXT_SELECT_FAST_HEX  0x08

#define __CLIB_OPT_STDIO  0x00

#define __CLIB_OPT_STDIO_VALID  0x01

#define CHAR_CR  13
#define CHAR_LF  10
#define CHAR_BS  12
#define CHAR_ESC  27
#define CHAR_CAPS  6
#define CHAR_BELL  7
#define CHAR_CTRL_C  3
#define CHAR_CTRL_D  4
#define CHAR_CTRL_Z  26
#define CHAR_CURSOR_UC  45
#define CHAR_CURSOR_LC  95
#define CHAR_PASSWORD  42

#define __CLIB_OPT_PRINTF  0x002ff6ff

#define __CLIB_OPT_PRINTF_d  0x00000001
#define __CLIB_OPT_PRINTF_u  0x00000002
#define __CLIB_OPT_PRINTF_x  0x00000004
#define __CLIB_OPT_PRINTF_X  0x00000008
#define __CLIB_OPT_PRINTF_o  0x00000010
#define __CLIB_OPT_PRINTF_n  0x00000020
#define __CLIB_OPT_PRINTF_i  0x00000040
#define __CLIB_OPT_PRINTF_p  0x00000080
#define __CLIB_OPT_PRINTF_B  0x00000100
#define __CLIB_OPT_PRINTF_s  0x00000200
#define __CLIB_OPT_PRINTF_c  0x00000400
#define __CLIB_OPT_PRINTF_I  0x00000800
#define __CLIB_OPT_PRINTF_ld  0x00001000
#define __CLIB_OPT_PRINTF_lu  0x00002000
#define __CLIB_OPT_PRINTF_lx  0x00004000
#define __CLIB_OPT_PRINTF_lX  0x00008000
#define __CLIB_OPT_PRINTF_lo  0x00010000
#define __CLIB_OPT_PRINTF_ln  0x00020000
#define __CLIB_OPT_PRINTF_li  0x00040000
#define __CLIB_OPT_PRINTF_lp  0x00080000
#define __CLIB_OPT_PRINTF_lB  0x00100000
#define __CLIB_OPT_PRINTF_a  0x00400000
#define __CLIB_OPT_PRINTF_A  0x00800000
#define __CLIB_OPT_PRINTF_e  0x01000000
#define __CLIB_OPT_PRINTF_E  0x02000000
#define __CLIB_OPT_PRINTF_f  0x04000000
#define __CLIB_OPT_PRINTF_F  0x08000000
#define __CLIB_OPT_PRINTF_g  0x10000000
#define __CLIB_OPT_PRINTF_G  0x20000000

#define __CLIB_OPT_PRINTF_2  0x00

#define __CLIB_OPT_PRINTF_2_lld  0x01
#define __CLIB_OPT_PRINTF_2_llu  0x02
#define __CLIB_OPT_PRINTF_2_llx  0x04
#define __CLIB_OPT_PRINTF_2_llX  0x08
#define __CLIB_OPT_PRINTF_2_llo  0x10
#define __CLIB_OPT_PRINTF_2_lli  0x40

#define __CLIB_OPT_SCANF  0x002ff6ff

#define __CLIB_OPT_SCANF_d  0x00000001
#define __CLIB_OPT_SCANF_u  0x00000002
#define __CLIB_OPT_SCANF_x  0x00000004
#define __CLIB_OPT_SCANF_X  0x00000008
#define __CLIB_OPT_SCANF_o  0x00000010
#define __CLIB_OPT_SCANF_n  0x00000020
#define __CLIB_OPT_SCANF_i  0x00000040
#define __CLIB_OPT_SCANF_p  0x00000080
#define __CLIB_OPT_SCANF_B  0x00000100
#define __CLIB_OPT_SCANF_s  0x00000200
#define __CLIB_OPT_SCANF_c  0x00000400
#define __CLIB_OPT_SCANF_I  0x00000800
#define __CLIB_OPT_SCANF_ld  0x00001000
#define __CLIB_OPT_SCANF_lu  0x00002000
#define __CLIB_OPT_SCANF_lx  0x00004000
#define __CLIB_OPT_SCANF_lX  0x00008000
#define __CLIB_OPT_SCANF_lo  0x00010000
#define __CLIB_OPT_SCANF_ln  0x00020000
#define __CLIB_OPT_SCANF_li  0x00040000
#define __CLIB_OPT_SCANF_lp  0x00080000
#define __CLIB_OPT_SCANF_lB  0x00100000
#define __CLIB_OPT_SCANF_BRACKET  0x00200000
#define __CLIB_OPT_SCANF_a  0x00400000
#define __CLIB_OPT_SCANF_A  0x00800000
#define __CLIB_OPT_SCANF_e  0x01000000
#define __CLIB_OPT_SCANF_E  0x02000000
#define __CLIB_OPT_SCANF_f  0x04000000
#define __CLIB_OPT_SCANF_F  0x08000000
#define __CLIB_OPT_SCANF_g  0x10000000
#define __CLIB_OPT_SCANF_G  0x20000000

#define __CLIB_OPT_SCANF_2  0x00

#define __CLIB_OPT_SCANF_2_lld  0x01
#define __CLIB_OPT_SCANF_2_llu  0x02
#define __CLIB_OPT_SCANF_2_llx  0x04
#define __CLIB_OPT_SCANF_2_llX  0x08
#define __CLIB_OPT_SCANF_2_llo  0x10
#define __CLIB_OPT_SCANF_2_lli  0x40

#define __CLIB_OPT_FASTCOPY  0x00

#define __CLIB_OPT_FASTCOPY_MEMCPY  0x01
#define __CLIB_OPT_FASTCOPY_MEMSET  0x02
#define __CLIB_OPT_FASTCOPY_LDIR  0x20
#define __CLIB_OPT_FASTCOPY_LDIR_SMC  0x40
#define __CLIB_OPT_FASTCOPY_MEMCPY_SMC  0x80

#define __CLIB_OPT_STRTOD  0x00

#define __CLIB_OPT_STRTOD_NAN  0x01
#define __CLIB_OPT_STRTOD_INF  0x01
#define __CLIB_OPT_STRTOD_HEX  0x02

#define __CLIB_OPT_SORT  1

#define __CLIB_OPT_SORT_INSERTION  0
#define __CLIB_OPT_SORT_SHELL  1
#define __CLIB_OPT_SORT_QUICK  2

#define __CLIB_OPT_SORT_QSORT  0x0c

#define __CLIB_OPT_SORT_QSORT_PIVOT  0x3
#define __CLIB_OPT_SORT_QSORT_PIVOT_MID  0x0
#define __CLIB_OPT_SORT_QSORT_PIVOT_RAN  0x1
#define __CLIB_OPT_SORT_QSORT_ENABLE_INSERTION  0x04
#define __CLIB_OPT_SORT_QSORT_ENABLE_EQUAL  0x08

#define __CLIB_OPT_ERROR  0x00

#define __CLIB_OPT_ERROR_ENABLED  0x01
#define __CLIB_OPT_ERROR_VERBOSE  0x02
















#define __EOK  0
#define __EACCES  1
#define __EBADF  2
#define __EBDFD  3
#define __EDOM  4
#define __EFBIG  5
#define __EINVAL  6
#define __EMFILE  7
#define __ENFILE  8
#define __ENOLCK  9
#define __ENOMEM  10
#define __ENOTSUP  11
#define __EOVERFLOW  12
#define __ERANGE  13
#define __ESTAT  14
#define __EAGAIN  15
#define __EWOULDBLOCK  15

#define __ERROR_NEXT  50

#define STDIO_SEEK_SET  0
#define STDIO_SEEK_CUR  1
#define STDIO_SEEK_END  2

#define STDIO_MSG_PUTC  1
#define STDIO_MSG_WRIT  2
#define STDIO_MSG_GETC  3
#define STDIO_MSG_EATC  4
#define STDIO_MSG_READ  5
#define STDIO_MSG_SEEK  6
#define STDIO_MSG_ICTL  7
#define STDIO_MSG_FLSH  8
#define STDIO_MSG_CLOS  9

#define ITERM_MSG_GETC  15
#define ITERM_MSG_INTERRUPT  16
#define ITERM_MSG_PUTC  17
#define ITERM_MSG_PRINT_CURSOR  18
#define ITERM_MSG_ERASE_CURSOR  19
#define ITERM_MSG_ERASE_CURSOR_PWD  20
#define ITERM_MSG_BS  21
#define ITERM_MSG_BS_PWD  22
#define ITERM_MSG_READLINE_BEGIN  23
#define ITERM_MSG_READLINE_END  24
#define ITERM_MSG_BELL  25
      
#define __MESSAGE_ITERM_NEXT__  26

#define OTERM_MSG_PUTC  30
#define OTERM_MSG_TTY  31
#define OTERM_MSG_PRINTC  32
#define OTERM_MSG_SCROLL  33
#define OTERM_MSG_CLS  34
#define OTERM_MSG_PAUSE  35
#define OTERM_MSG_BELL  36
#define OTERM_MSG_PSCROLL  37
      
#define __MESSAGE_OTERM_NEXT__  38

#define ICHAR_MSG_GETC  15
#define OCHAR_MSG_PUTC_BIN  30
#define OCHAR_MSG_PUTC  32
  
#define __MESSAGE_NEXT__  45

#define mtx_plain  0x01
#define mtx_recursive  0x02
#define mtx_timed  0x04

#define thrd_success  0x00
#define thrd_error  0x01
#define thrd_nomem  0x02
#define thrd_busy  0x04
#define thrd_timedout  0x08

#define IOCTL_RESET  0x0000

#define IOCTL_ITERM_ECHO  0xc081
#define IOCTL_ITERM_PASS  0xc041
#define IOCTL_ITERM_LINE  0xc021
#define IOCTL_ITERM_COOK  0xc011
#define IOCTL_ITERM_CAPS  0xc009
#define IOCTL_ITERM_CRLF  0xc101
#define IOCTL_ITERM_CURS  0xc201
   
#define IOCTL_ITERM_TIE  0x0201
#define IOCTL_ITERM_GET_EDITBUF  0x0381
#define IOCTL_ITERM_SET_EDITBUF  0x0301

#define IOCTL_OTERM_PAGE  0xc082
#define IOCTL_OTERM_PAUSE  0xc042
#define IOCTL_OTERM_COOK  0xc022
#define IOCTL_OTERM_CRLF  0xc012
#define IOCTL_OTERM_CLEAR  0xe002
#define IOCTL_OTERM_SIGNAL  0xc202
#define IOCTL_OTERM_BELL  0xc102

#define IOCTL_OTERM_CLS  0x0102
#define IOCTL_OTERM_RESET_SCROLL  0x0202
#define IOCTL_OTERM_GET_WINDOW_COORD  0x0382
#define IOCTL_OTERM_SET_WINDOW_COORD  0x0302
#define IOCTL_OTERM_GET_WINDOW_RECT  0x0482
#define IOCTL_OTERM_SET_WINDOW_RECT  0x0402
#define IOCTL_OTERM_GET_CURSOR_COORD  0x0582
#define IOCTL_OTERM_SET_CURSOR_COORD  0x0502
#define IOCTL_OTERM_GET_OTERM  0x0602
#define IOCTL_OTERM_SCROLL  0x0702
#define IOCTL_OTERM_FONT  0x0802

#define IOCTL_OTERM_FZX_GET_PAPER_COORD  0x0a82
#define IOCTL_OTERM_FZX_SET_PAPER_COORD  0x0a02
#define IOCTL_OTERM_FZX_GET_PAPER_RECT  0x0b82
#define IOCTL_OTERM_FZX_SET_PAPER_RECT  0x0b02
#define IOCTL_OTERM_FZX_LEFT_MARGIN  0x0c02
#define IOCTL_OTERM_FZX_LINE_SPACING  0x0d02
#define IOCTL_OTERM_FZX_SPACE_EXPAND  0x0e02
#define IOCTL_OTERM_FZX_GET_FZX_STATE  0x0f82
#define IOCTL_OTERM_FZX_SET_FZX_STATE  0x0f02

#define IOCTL_ICHAR_CRLF  0xc103
   
#define IOCTL_OCHAR_CRLF  0xc014














#define IOCTL_ITERM_GET_DELAY  0x1081
#define IOCTL_ITERM_SET_DELAY  0x1001

#define IOCTL_ITERM_LASTK      0x1101

#define IOCTL_OTERM_FCOLOR     0x1002
#define IOCTL_OTERM_FMASK      0x1102
#define IOCTL_OTERM_BCOLOR     0x1202















#define __BIFROST2_ANIM_GROUP      4
#define __BIFROST2_STATIC_MIN      128
#define __BIFROST2_STATIC_OVERLAP  128
#define __BIFROST2_TILE_IMAGES     49000
#define __BIFROST2_TILE_ORDER      7
#define __BIFROST2_TILE_MAP        65281
#define __BIFROST2_TOTAL_ROWS      22
#define __BIFROST2_HOLE            64839
#define __BIFROST2_HOLE_SIZE       0












#define __BIFROSTH_ANIM_SPEED      4
#define __BIFROSTH_ANIM_GROUP      4
#define __BIFROSTH_STATIC_MIN      128
#define __BIFROSTH_STATIC_OVERLAP  128
#define __BIFROSTH_TILE_IMAGES     48500
#define __BIFROSTH_TILE_MAP        65281
#define __BIFROSTH_TILE_ORDER      7
#define __BIFROSTH_SHIFT_COLUMNS   0
#define __BIFROSTH_SPRITE_MODE     0












#define __BIFROSTL_ANIM_SPEED      4
#define __BIFROSTL_ANIM_GROUP      4
#define __BIFROSTL_STATIC_MIN      128
#define __BIFROSTL_STATIC_OVERLAP  128
#define __BIFROSTL_TILE_IMAGES     48500
#define __BIFROSTL_TILE_MAP        65281
#define __BIFROSTL_TILE_ORDER      7












#define __NIRVANAM_OPTIONS  0

#define __NIRVANAM_OPTIONS_WIDE_DRAW     0x01
#define __NIRVANAM_OPTIONS_WIDE_SPRITES  0x02

#define __NIRVANAM_TOTAL_ROWS   22
#define __NIRVANAM_HOLE         64994
#define __NIRVANAM_HOLE_SIZE    0

#define __NIRVANAM_TILE_IMAGES  48000
#define __NIRVANAM_WIDE_IMAGES  54000
#define __NIRVANAM_CHAR_TABLE   15360












#define __NIRVANAP_OPTIONS  0

#define __NIRVANAP_OPTIONS_WIDE_DRAW     0x01
#define __NIRVANAP_OPTIONS_WIDE_SPRITES  0x02

#define __NIRVANAP_TOTAL_ROWS   23
#define __NIRVANAP_HOLE         64262
#define __NIRVANAP_HOLE_SIZE    0

#define __NIRVANAP_TILE_IMAGES  48000
#define __NIRVANAP_WIDE_IMAGES  54000
#define __NIRVANAP_CHAR_TABLE   15360












#define __SOUND_BIT_METHOD      1
#define __SOUND_BIT_PORT        0xfe
#define __SOUND_BIT_TOGGLE      0x10
#define __SOUND_BIT_TOGGLE_POS  4
#define __SOUND_BIT_READ_MASK   0x17
#define __SOUND_BIT_WRITE_MASK  0xe8












#define SP1V_DISPORIGX    0
#define SP1V_DISPORIGY    0
#define SP1V_DISPWIDTH    32
#define SP1V_DISPHEIGHT   24

#define SP1V_PIXELBUFFER  0xd1f7
#define SP1V_ATTRBUFFER   0xd1ff

#define SP1V_TILEARRAY    0xf000
#define SP1V_UPDATEARRAY  0xd200
#define SP1V_ROTTBL       0xf000

#define SP1V_UPDATELISTH  0xd1ed
#define SP1V_UPDATELISTT  0xd1ef











#define __IO_ULAP_REGISTER  0xbf3b
#define __IO_ULAP_DATA      0xff3b

#define __ULAP_COLOR_MONO_BLACK  0x00
#define __ULAP_COLOR_MONO_GREY_0  0x00
#define __ULAP_COLOR_MONO_GREY_1  0x49
#define __ULAP_COLOR_MONO_GREY_2  0x92
#define __ULAP_COLOR_MONO_GREY_3  0xff
#define __ULAP_COLOR_MONO_WHITE  0xff

#define __ULAP_COLOR_AMBER_0  0x00
#define __ULAP_COLOR_AMBER_1  0x04
#define __ULAP_COLOR_AMBER_2  0x28
#define __ULAP_COLOR_AMBER_3  0x2c
#define __ULAP_COLOR_AMBER_4  0x50
#define __ULAP_COLOR_AMBER_5  0x54
#define __ULAP_COLOR_AMBER_6  0x78
#define __ULAP_COLOR_AMBER_7  0x7c

#define __ULAP_COLOR_GREEN_0  0x00
#define __ULAP_COLOR_GREEN_1  0x20
#define __ULAP_COLOR_GREEN_2  0x40
#define __ULAP_COLOR_GREEN_3  0x60
#define __ULAP_COLOR_GREEN_4  0x80
#define __ULAP_COLOR_GREEN_5  0xa0
#define __ULAP_COLOR_GREEN_6  0xc0
#define __ULAP_COLOR_GREEN_7  0xe0

#define __ULAP_COLOR_RB_RED  0x1c
#define __ULAP_COLOR_RB_ORANGE  0x7c
#define __ULAP_COLOR_RB_YELLOW  0xfc
#define __ULAP_COLOR_RB_GREEN  0xe0
#define __ULAP_COLOR_RB_BLUE  0x03
#define __ULAP_COLOR_RB_VIOLET  0x0a
#define __ULAP_COLOR_RB_INDIGO  0x13

#define __ULAP_COLOR_ZX_BLACK  0x00
#define __ULAP_COLOR_ZX_BLUE  0x02
#define __ULAP_COLOR_ZX_RED  0x18
#define __ULAP_COLOR_ZX_MAGENTA  0x1b
#define __ULAP_COLOR_ZX_GREEN  0xc0
#define __ULAP_COLOR_ZX_CYAN  0xc3
#define __ULAP_COLOR_ZX_YELLOW  0xd8
#define __ULAP_COLOR_ZX_WHITE  0xdb
#define __ULAP_COLOR_ZX_BRIGHT_BLACK  0x00
#define __ULAP_COLOR_ZX_BRIGHT_BLUE  0x03
#define __ULAP_COLOR_ZX_BRIGHT_RED  0x1c
#define __ULAP_COLOR_ZX_BRIGHT_MAGENTA  0x1f
#define __ULAP_COLOR_ZX_BRIGHT_GREEN  0xe0
#define __ULAP_COLOR_ZX_BRIGHT_CYAN  0xe3
#define __ULAP_COLOR_ZX_BRIGHT_YELLOW  0xfc
#define __ULAP_COLOR_ZX_BRIGHT_WHITE  0xff

#define __ULAP_COLOR_C64_BLACK  0x00
#define __ULAP_COLOR_C64_WHITE  0xff
#define __ULAP_COLOR_C64_RED  0x30
#define __ULAP_COLOR_C64_CYAN  0xaf
#define __ULAP_COLOR_C64_VIOLET  0x52
#define __ULAP_COLOR_C64_GREEN  0xad
#define __ULAP_COLOR_C64_BLUE  0x26
#define __ULAP_COLOR_C64_YELLOW  0xd9
#define __ULAP_COLOR_C64_ORANGE  0x50
#define __ULAP_COLOR_C64_BROWN  0x48
#define __ULAP_COLOR_C64_LIGHTRED  0x75
#define __ULAP_COLOR_C64_GREY1  0x49
#define __ULAP_COLOR_C64_GREY2  0x92
#define __ULAP_COLOR_C64_LIGHTGREEN  0xf6
#define __ULAP_COLOR_C64_LIGHTBLUE  0x6f
#define __ULAP_COLOR_C64_GREY3  0xb6

#define __ULAP_COLOR_G1_BLACK  0x00
#define __ULAP_COLOR_G1_GREY  0x6d
#define __ULAP_COLOR_G1_SILVER  0xb6
#define __ULAP_COLOR_G1_DARK_TEAL  0x62
#define __ULAP_COLOR_G1_GREEN  0xa0
#define __ULAP_COLOR_G1_GREENYELLOW  0xf0
#define __ULAP_COLOR_G1_MAROON  0x0c
#define __ULAP_COLOR_G1_SIENNA  0x54
#define __ULAP_COLOR_G1_SANDYBROWN  0x9c
#define __ULAP_COLOR_G1_KHAKI  0xfd
#define __ULAP_COLOR_G1_WHITE  0xff
#define __ULAP_COLOR_G1_SKYBLUE  0xd3
#define __ULAP_COLOR_G1_SLATEBLUE  0x6b
#define __ULAP_COLOR_G1_BLUE  0x02

#define __ULAP_COLOR_STD_DARK_BLUE  0x02
#define __ULAP_COLOR_STD_BRIGHT_BLUE  0xdb
#define __ULAP_COLOR_STD_BLUE  0x03
#define __ULAP_COLOR_STD_CYAN  0xe3
#define __ULAP_COLOR_STD_BRIGHT_YELLOW  0xdd
#define __ULAP_COLOR_STD_YELLOW  0xfc
#define __ULAP_COLOR_STD_ORANGE  0x9d
#define __ULAP_COLOR_STD_BRIGHT_RED  0x5d
#define __ULAP_COLOR_STD_RED  0x1c
#define __ULAP_COLOR_STD_DARK_RED  0x10
#define __ULAP_COLOR_STD_MAGENTA  0x1f
#define __ULAP_COLOR_STD_BRIGHT_GREEN  0xf2
#define __ULAP_COLOR_STD_GREEN  0xe0
#define __ULAP_COLOR_STD_DARK_GREEN  0x80
#define __ULAP_COLOR_STD_BRIGHT_GREY  0x49
#define __ULAP_COLOR_STD_LIGHT_GREY  0x6d
#define __ULAP_COLOR_STD_GREY  0x24
#define __ULAP_COLOR_STD_WHITE  0xff
#define __ULAP_COLOR_STD_BLACK  0x00

#define __ULAP_COLOR_HTML_Black  0
#define __ULAP_COLOR_HTML_Navy  2
#define __ULAP_COLOR_HTML_DarkBlue  2
#define __ULAP_COLOR_HTML_MediumBlue  3
#define __ULAP_COLOR_HTML_Blue  3
#define __ULAP_COLOR_HTML_DarkGreen  96
#define __ULAP_COLOR_HTML_Green  128
#define __ULAP_COLOR_HTML_Teal  130
#define __ULAP_COLOR_HTML_DarkCyan  130
#define __ULAP_COLOR_HTML_DeepSkyBlue  163
#define __ULAP_COLOR_HTML_DarkTurquoise  195
#define __ULAP_COLOR_HTML_MediumSpringGreen  226
#define __ULAP_COLOR_HTML_Lime  224
#define __ULAP_COLOR_HTML_SpringGreen  225
#define __ULAP_COLOR_HTML_Aqua  227
#define __ULAP_COLOR_HTML_Cyan  227
#define __ULAP_COLOR_HTML_MidnightBlue  1
#define __ULAP_COLOR_HTML_DodgerBlue  131
#define __ULAP_COLOR_HTML_LightSeaGreen  166
#define __ULAP_COLOR_HTML_ForestGreen  132
#define __ULAP_COLOR_HTML_SeaGreen  133
#define __ULAP_COLOR_HTML_DarkSlateGray  69
#define __ULAP_COLOR_HTML_DarkSlateGrey  69
#define __ULAP_COLOR_HTML_LimeGreen  196
#define __ULAP_COLOR_HTML_MediumSeaGreen  165
#define __ULAP_COLOR_HTML_Turquoise  235
#define __ULAP_COLOR_HTML_RoyalBlue  107
#define __ULAP_COLOR_HTML_SteelBlue  138
#define __ULAP_COLOR_HTML_DarkSlateBlue  42
#define __ULAP_COLOR_HTML_MediumTurquoise  203
#define __ULAP_COLOR_HTML_Indigo  10
#define __ULAP_COLOR_HTML_DarkOliveGreen  104
#define __ULAP_COLOR_HTML_CadetBlue  138
#define __ULAP_COLOR_HTML_CornflowerBlue  143
#define __ULAP_COLOR_HTML_RebeccaPurple  46
#define __ULAP_COLOR_HTML_MediumAquaMarine  206
#define __ULAP_COLOR_HTML_DimGray  109
#define __ULAP_COLOR_HTML_DimGrey  109
#define __ULAP_COLOR_HTML_SlateBlue  79
#define __ULAP_COLOR_HTML_OliveDrab  140
#define __ULAP_COLOR_HTML_SlateGray  142
#define __ULAP_COLOR_HTML_SlateGrey  142
#define __ULAP_COLOR_HTML_LightSlateGray  142
#define __ULAP_COLOR_HTML_LightSlateGrey  142
#define __ULAP_COLOR_HTML_MediumSlateBlue  111
#define __ULAP_COLOR_HTML_LawnGreen  236
#define __ULAP_COLOR_HTML_Chartreuse  236
#define __ULAP_COLOR_HTML_Aquamarine  239
#define __ULAP_COLOR_HTML_Maroon  16
#define __ULAP_COLOR_HTML_Purple  18
#define __ULAP_COLOR_HTML_Olive  144
#define __ULAP_COLOR_HTML_Gray  146
#define __ULAP_COLOR_HTML_Grey  146
#define __ULAP_COLOR_HTML_SkyBlue  211
#define __ULAP_COLOR_HTML_LightSkyBlue  211
#define __ULAP_COLOR_HTML_BlueViolet  51
#define __ULAP_COLOR_HTML_DarkRed  16
#define __ULAP_COLOR_HTML_DarkMagenta  18
#define __ULAP_COLOR_HTML_SaddleBrown  80
#define __ULAP_COLOR_HTML_DarkSeaGreen  178
#define __ULAP_COLOR_HTML_LightGreen  242
#define __ULAP_COLOR_HTML_MediumPurple  115
#define __ULAP_COLOR_HTML_DarkViolet  19
#define __ULAP_COLOR_HTML_PaleGreen  242
#define __ULAP_COLOR_HTML_DarkOrchid  51
#define __ULAP_COLOR_HTML_YellowGreen  208
#define __ULAP_COLOR_HTML_Sienna  84
#define __ULAP_COLOR_HTML_Brown  52
#define __ULAP_COLOR_HTML_DarkGray  182
#define __ULAP_COLOR_HTML_DarkGrey  182
#define __ULAP_COLOR_HTML_LightBlue  215
#define __ULAP_COLOR_HTML_GreenYellow  244
#define __ULAP_COLOR_HTML_PaleTurquoise  247
#define __ULAP_COLOR_HTML_LightSteelBlue  215
#define __ULAP_COLOR_HTML_PowderBlue  247
#define __ULAP_COLOR_HTML_FireBrick  52
#define __ULAP_COLOR_HTML_DarkGoldenRod  148
#define __ULAP_COLOR_HTML_MediumOrchid  87
#define __ULAP_COLOR_HTML_RosyBrown  150
#define __ULAP_COLOR_HTML_DarkKhaki  181
#define __ULAP_COLOR_HTML_Silver  219
#define __ULAP_COLOR_HTML_MediumVioletRed  26
#define __ULAP_COLOR_HTML_IndianRed  89
#define __ULAP_COLOR_HTML_Peru  152
#define __ULAP_COLOR_HTML_Chocolate  120
#define __ULAP_COLOR_HTML_Tan  186
#define __ULAP_COLOR_HTML_LightGray  219
#define __ULAP_COLOR_HTML_LightGrey  219
#define __ULAP_COLOR_HTML_Thistle  187
#define __ULAP_COLOR_HTML_Orchid  123
#define __ULAP_COLOR_HTML_GoldenRod  184
#define __ULAP_COLOR_HTML_PaleVioletRed  122
#define __ULAP_COLOR_HTML_Crimson  24
#define __ULAP_COLOR_HTML_Gainsboro  219
#define __ULAP_COLOR_HTML_Plum  187
#define __ULAP_COLOR_HTML_BurlyWood  186
#define __ULAP_COLOR_HTML_LightCyan  255
#define __ULAP_COLOR_HTML_Lavender  255
#define __ULAP_COLOR_HTML_DarkSalmon  157
#define __ULAP_COLOR_HTML_Violet  159
#define __ULAP_COLOR_HTML_PaleGoldenRod  254
#define __ULAP_COLOR_HTML_LightCoral  158
#define __ULAP_COLOR_HTML_Khaki  254
#define __ULAP_COLOR_HTML_AliceBlue  255
#define __ULAP_COLOR_HTML_HoneyDew  255
#define __ULAP_COLOR_HTML_Azure  255
#define __ULAP_COLOR_HTML_SandyBrown  189
#define __ULAP_COLOR_HTML_Wheat  222
#define __ULAP_COLOR_HTML_Beige  255
#define __ULAP_COLOR_HTML_WhiteSmoke  255
#define __ULAP_COLOR_HTML_MintCream  255
#define __ULAP_COLOR_HTML_GhostWhite  255
#define __ULAP_COLOR_HTML_Salmon  157
#define __ULAP_COLOR_HTML_AntiqueWhite  255
#define __ULAP_COLOR_HTML_Linen  255
#define __ULAP_COLOR_HTML_LightGoldenRodYellow  255
#define __ULAP_COLOR_HTML_OldLace  255
#define __ULAP_COLOR_HTML_Red  28
#define __ULAP_COLOR_HTML_Fuchsia  31
#define __ULAP_COLOR_HTML_Magenta  31
#define __ULAP_COLOR_HTML_DeepPink  30
#define __ULAP_COLOR_HTML_OrangeRed  92
#define __ULAP_COLOR_HTML_Tomato  125
#define __ULAP_COLOR_HTML_HotPink  126
#define __ULAP_COLOR_HTML_Coral  125
#define __ULAP_COLOR_HTML_DarkOrange  156
#define __ULAP_COLOR_HTML_LightSalmon  189
#define __ULAP_COLOR_HTML_Orange  188
#define __ULAP_COLOR_HTML_LightPink  191
#define __ULAP_COLOR_HTML_Pink  223
#define __ULAP_COLOR_HTML_Gold  220
#define __ULAP_COLOR_HTML_PeachPuff  222
#define __ULAP_COLOR_HTML_NavajoWhite  222
#define __ULAP_COLOR_HTML_Moccasin  254
#define __ULAP_COLOR_HTML_Bisque  255
#define __ULAP_COLOR_HTML_MistyRose  255
#define __ULAP_COLOR_HTML_BlanchedAlmond  255
#define __ULAP_COLOR_HTML_PapayaWhip  255
#define __ULAP_COLOR_HTML_LavenderBlush  255
#define __ULAP_COLOR_HTML_SeaShell  255
#define __ULAP_COLOR_HTML_Cornsilk  255
#define __ULAP_COLOR_HTML_LemonChiffon  255
#define __ULAP_COLOR_HTML_FloralWhite  255
#define __ULAP_COLOR_HTML_Snow  255
#define __ULAP_COLOR_HTML_Yellow  252
#define __ULAP_COLOR_HTML_LightYellow  255
#define __ULAP_COLOR_HTML_Ivory  255
#define __ULAP_COLOR_HTML_White  255





#endif



