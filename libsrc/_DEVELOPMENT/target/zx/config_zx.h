





#ifndef __CONFIG_Z88DK_H_
#define __CONFIG_Z88DK_H_

// Automatically Generated at Library Build Time














#undef  __Z88DK
#define __Z88DK  2200












#undef  __SPECTRUM
#define __SPECTRUM  1

#define __SPECTRUM_48        1
#define __SPECTRUM_128       2
#define __SPECTRUM_128_P2    4
#define __SPECTRUM_128_P2A   8
#define __SPECTRUM_128_P3    16
#define __SPECTRUM_PENTAGON  32

#define __USE_SPECTRUM_128_SECOND_DFILE  0












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

#define __CLIB_OPT_UNROLL  0x00

#define __CLIB_OPT_UNROLL_MEMCPY  0x01
#define __CLIB_OPT_UNROLL_MEMSET  0x02
#define __CLIB_OPT_UNROLL_OTIR  0x10
#define __CLIB_OPT_UNROLL_LDIR  0x20
#define __CLIB_OPT_UNROLL_USER_SMC  0x40
#define __CLIB_OPT_UNROLL_LIB_SMC  0x80

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
#define __EIO  7
#define __EMFILE  8
#define __ENFILE  9
#define __ENOLCK  10
#define __ENOMEM  11
#define __ENOTSUP  12
#define __EOVERFLOW  13
#define __ERANGE  14
#define __ESTAT  15
#define __EAGAIN  16
#define __EWOULDBLOCK  16

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
#define ITERM_MSG_REJECT  16
#define ITERM_MSG_INTERRUPT  17
#define ITERM_MSG_PUTC  18
#define ITERM_MSG_PRINT_CURSOR  19
#define ITERM_MSG_ERASE_CURSOR  20
#define ITERM_MSG_ERASE_CURSOR_PWD  21
#define ITERM_MSG_BS  22
#define ITERM_MSG_BS_PWD  23
#define ITERM_MSG_READLINE_BEGIN  24
#define ITERM_MSG_READLINE_END  25
#define ITERM_MSG_READLINE_SCROLL_LIMIT  26
#define ITERM_MSG_BELL  27
      
#define __MESSAGE_ITERM_NEXT__  28

#define OTERM_MSG_PUTC  30
#define OTERM_MSG_TTY  31
#define OTERM_MSG_FZX_PUTC  32
#define OTERM_MSG_PRINTC  33
#define OTERM_MSG_SCROLL  34
#define OTERM_MSG_SCROLL_LIMIT  35
#define OTERM_MSG_CLS  36
#define OTERM_MSG_PAUSE  37
#define OTERM_MSG_BELL  38
#define OTERM_MSG_PSCROLL  39
#define OTERM_MSG_FZX_GET_XOR_DRAW  40
      
#define __MESSAGE_OTERM_NEXT__  41

#define ICHAR_MSG_GETC  15
#define OCHAR_MSG_PUTC_BIN  30
#define OCHAR_MSG_PUTC  33
  
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
#define IOCTL_OTERM_SCROLL_LIMIT  0x0902

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












#define __ESXDOS_BASE_HOOK  128
#define __ESXDOS_BASE_MISC  136
#define __ESXDOS_BASE_FSYS  152

#define __ESXDOS_SYSCALL  0x08
#define __ESXDOS_ROMCALL  0x18
#define __ESXDOS_AUXCALL  0x30

#define __ESXDOS_SYS_DISK_STATUS  128
#define __ESXDOS_SYS_DISK_READ  129
#define __ESXDOS_SYS_DISK_WRITE  130
#define __ESXDOS_SYS_DISK_IOCTL  131
#define __ESXDOS_SYS_DISK_INFO  132

#define __ESXDOS_SYS_M_DOSVERSION  136
#define __ESXDOS_SYS_M_GETSETDRV  137
#define __ESXDOS_SYS_M_DRIVEINFO  138
#define __ESXDOS_SYS_M_TAPEIN  139
#define __ESXDOS_SYS_M_TAPEOUT  140
#define __ESXDOS_SYS_M_GETHANDLE  141
#define __ESXDOS_SYS_M_GETDATE  142

#define __ESXDOS_SYS_F_MOUNT  152
#define __ESXDOS_SYS_F_UMOUNT  153
#define __ESXDOS_SYS_F_OPEN  154
#define __ESXDOS_SYS_F_CLOSE  155
#define __ESXDOS_SYS_F_SYNC  156
#define __ESXDOS_SYS_F_READ  157
#define __ESXDOS_SYS_F_WRITE  158
#define __ESXDOS_SYS_F_SEEK  159
#define __ESXDOS_SYS_F_FGETPOS  160
#define __ESXDOS_SYS_F_FSTAT  161
#define __ESXDOS_SYS_F_FTRUNCATE  162
#define __ESXDOS_SYS_F_OPENDIR  163
#define __ESXDOS_SYS_F_READDIR  164
#define __ESXDOS_SYS_F_TELLDIR  165
#define __ESXDOS_SYS_F_SEEKDIR  166
#define __ESXDOS_SYS_F_REWINDDIR  167
#define __ESXDOS_SYS_F_GETCWD  168
#define __ESXDOS_SYS_F_CHDIR  169
#define __ESXDOS_SYS_F_MKDIR  170
#define __ESXDOS_SYS_F_RMDIR  171
#define __ESXDOS_SYS_F_STAT  172
#define __ESXDOS_SYS_F_UNLINK  173
#define __ESXDOS_SYS_F_TRUNCATE  174
#define __ESXDOS_SYS_F_CHMOD  175
#define __ESXDOS_SYS_F_RENAME  176
#define __ESXDOS_SYS_F_GETFREE  177

#define __ESXDOS_PATH_MAX  128
#define __ESXDOS_NAME_MAX  128

#define __ESXDOS_MODE_READ  0x01
#define __ESXDOS_MODE_WRITE  0x02
#define __ESXDOS_MODE_OPEN_EXIST  0x00
#define __ESXDOS_MODE_OPEN_CREAT  0x08
#define __ESXDOS_MODE_CREAT_NOEXIST  0x04
#define __ESXDOS_MODE_CREAT_TRUNC  0x0c
#define __ESXDOS_MODE_USE_HEADER  0x40

#define __ESXDOS_ATTR_READ_ONLY  0x01
#define __ESXDOS_ATTR_HIDDEN  0x02
#define __ESXDOS_ATTR_SYSTEM  0x04
#define __ESXDOS_ATTR_VOLUME_LABEL  0x08
#define __ESXDOS_ATTR_DIRECTORY  0x10
#define __ESXDOS_ATTR_ARCHIVE  0x20

#define __ESXDOS_DRIVE_CURRENT  0x2a
#define __ESXDOS_DRIVE_SYSTEM  0x24

#define __ESXDOS_SEEK_SET  0
#define __ESXDOS_SEEK_FWD  1
#define __ESXDOS_SEEK_BWD  2

#define __ESXDOS_OK  0
#define __ESXDOS_EOK  1
#define __ESXDOS_ENONSENSE  2
#define __ESXDOS_ESTEND  3
#define __ESXDOS_EWRTYPE  4
#define __ESXDOS_ENOENT  5
#define __ESXDOS_EIO  6
#define __ESXDOS_EINVAL  7
#define __ESXDOS_EACCES  8
#define __ESXDOS_ENOSPC  9
#define __ESXDOS_ENXIO  10
#define __ESXDOS_ENODRV  11
#define __ESXDOS_ENFILE  12
#define __ESXDOS_EBADF  13
#define __ESXDOS_ENODEV  14
#define __ESXDOS_EOVERFLOW  15
#define __ESXDOS_EISDIR  16
#define __ESXDOS_ENOTDIR  17
#define __ESXDOS_EEXIST  18
#define __ESXDOS_EPATH  19
#define __ESXDOS_ENOSYS  20
#define __ESXDOS_ENAMETOOLONG  21
#define __ESXDOS_ENOCMD  22
#define __ESXDOS_EINUSE  23
#define __ESXDOS_ERDONLY  24
#define __ESXDOS_EVERIFY  25
#define __ESXDOS_ELOADINGKO  26
#define __ESXDOS_EDIRINUSE  27
#define __ESXDOS_EMAPRAMACTIVE  28
#define __ESXDOS_EDRIVEBUSY  29
#define __ESXDOS_EFSUNKNOWN  30
#define __ESXDOS_EDEVICEBUSY  31
#define __ESXDOS_EMAXCODE  31












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

#define __ULAP_COLOR_ZXNR_NAVY  0x01
#define __ULAP_COLOR_ZXNR_MAROON  0x08
#define __ULAP_COLOR_ZXNR_INDIGO  0x09
#define __ULAP_COLOR_ZXNR_RACING_GREEN  0x40
#define __ULAP_COLOR_ZXNR_SHERPA_BLUE  0x41
#define __ULAP_COLOR_ZXNR_OLIVE  0x48
#define __ULAP_COLOR_ZXNR_BLACK  0x00
#define __ULAP_COLOR_ZXNR_MIDNIGHT_BLUE  0x02
#define __ULAP_COLOR_ZXNR_DARK_RED  0x10
#define __ULAP_COLOR_ZXNR_DARK_VIOLET  0x12
#define __ULAP_COLOR_ZXNR_ISLAMIC_GREEN  0x80
#define __ULAP_COLOR_ZXNR_BONDI_BLUE  0x82
#define __ULAP_COLOR_ZXNR_BRIGHT_OLIVE  0x90
#define __ULAP_COLOR_ZXNR_GUNPOWDER_GRAY  0x49
#define __ULAP_COLOR_ZXNR_BLUE  0x03
#define __ULAP_COLOR_ZXNR_RED  0x1c
#define __ULAP_COLOR_ZXNR_MAGENTA  0x3f
#define __ULAP_COLOR_ZXNR_GREEN  0xe0
#define __ULAP_COLOR_ZXNR_AQUA  0xe3
#define __ULAP_COLOR_ZXNR_YELLOW  0xfc
#define __ULAP_COLOR_ZXNR_MIST_GRAY  0xb6
#define __ULAP_COLOR_ZXNR_SLATE_BLUE  0x6f
#define __ULAP_COLOR_ZXNR_BITTERSWEET  0x7d
#define __ULAP_COLOR_ZXNR_ULTRA_PINK  0x7f
#define __ULAP_COLOR_ZXNR_SCREAMING_GREEN  0xed
#define __ULAP_COLOR_ZXNR_ELECTRIC_BLUE  0xf3
#define __ULAP_COLOR_ZXNR_LASER_LEMON  0xfd
#define __ULAP_COLOR_ZXNR_WHITE  0xff
#define __ULAP_COLOR_ZXNR_LAVENDER_BLUE  0xb7
#define __ULAP_COLOR_ZXNR_MELON  0xbe
#define __ULAP_COLOR_ZXNR_LAVENDER_ROSE  0xbf
#define __ULAP_COLOR_ZXNR_MINT_GREEN  0xf6
#define __ULAP_COLOR_ZXNR_COLUMBIA_BLUE  0xf7
#define __ULAP_COLOR_ZXNR_CANARY  0xfe

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












#define __SYS_IY  SYS_IY
#define __SYS_HLP  SYS_HLP

#define __SYSVAR_SWAP  0x5b00
#define __SYSVAR_STOO  0x5b10
#define __SYSVAR_YOUNGER  0x5b21
#define __SYSVAR_REGNUOY  0x5b2a
#define __SYSVAR_ONERR  0x5b3a
#define __SYSVAR_OLDHL  0x5b52
#define __SYSVAR_OLDBC  0x5b54
#define __SYSVAR_OLDAF  0x5b56
#define __SYSVAR_TARGET  0x5b58
#define __SYSVAR_RETADDR  0x5b5a
#define __SYSVAR_BANKM  0x5b5c
#define __SYSVAR_RAMRST  0x5b5d
#define __SYSVAR_RAMERR  0x5b5e
#define __SYSVAR_BAUD  0x5b5f
#define __SYSVAR_SERFL  0x5b61
#define __SYSVAR_COL  0x5b63
#define __SYSVAR_WIDTH  0x5b64
#define __SYSVAR_TVPARS  0x5b65
#define __SYSVAR_FLAGS3  0x5b66
#define __SYSVAR_BANK678  0x5b67
#define __SYSVAR_FLAGN  0x5b68
#define __SYSVAR_MAXBNK  0x5b69
#define __SYSVAR_OLDSP  0x5b6a
#define __SYSVAR_SYNRET  0x5b6c
#define __SYSVAR_LASTV  0x5b6e
#define __SYSVAR_TILEBNKL  0x5b73
#define __SYSVAR_TILEML  0x5b74
#define __SYSVAR_TILEBNK2  0x5b75
#define __SYSVAR_TILEM2  0x5b76
#define __SYSVAR_NXTBNK  0x5b77
#define __SYSVAR_DATABNK  0x5b78
#define __SYSVAR_LODDRV  0x5b79
#define __SYSVAR_SAVDRV  0x5b7a
#define __SYSVAR_L2SOFT  0x5b7b
#define __SYSVAR_TILEWL  0x5b7c
#define __SYSVAR_TILEW2  0x5b7e
#define __SYSVAR_TILEOFFL  0x5b80
#define __SYSVAR_TILEOFF2  0x5b82
#define __SYSVAR_COORDSL  0x5b84
#define __SYSVAR_COORDS2  0x5b86
#define __SYSVAR_COORDSULA  0x5b88
#define __SYSVAR_COORDSHR  0x5b8a
#define __SYSVAR_COORDSHC  0x5b8c
#define __SYSVAR_INKL  0x5b8e
#define __SYSVAR_INK2  0x5b8f
#define __SYSVAR_ATTRULA  0x5b90
#define __SYSVAR_ATTRHR  0x5b91
#define __SYSVAR_ATTRHC  0x5b92
#define __SYSVAR_INKMASK  0x5b93
#define __SYSVAR_TMPVARS  0x5b94

#define __SYSVAR_TSTACK  0x5bff

#define __SYSVAR_KSTATE  0x5c00
#define __SYSVAR_LASTK  0x5c08
#define __SYSVAR_REPDEL  0x5c09
#define __SYSVAR_REPPER  0x5c0a
#define __SYSVAR_DEFADD  0x5c0b
#define __SYSVAR_KDATA  0x5c0d
#define __SYSVAR_TVDATA  0x5c0e
#define __SYSVAR_STRMS  0x5c10
#define __SYSVAR_CHARS  0x5c36
#define __SYSVAR_RASP  0x5c38
#define __SYSVAR_PIP  0x5c39
#define __SYSVAR_ERRNR  0x5c3a
#define __SYSVAR_FLAGS  0x5c3b
#define __SYSVAR_TVFLAG  0x5c3c
#define __SYSVAR_ERRSP  0x5c3d
#define __SYSVAR_LISTSP  0x5c3f
#define __SYSVAR_MODE  0x5c41
#define __SYSVAR_NEWPPC  0x5c42
#define __SYSVAR_NSPPC  0x5c44
#define __SYSVAR_PPC  0x5c45
#define __SYSVAR_SUBPPC  0x5c47
#define __SYSVAR_BORDCR  0x5c48
#define __SYSVAR_EPPC  0x5c49
#define __SYSVAR_VARS  0x5c4b
#define __SYSVAR_DEST  0x5c4d
#define __SYSVAR_CHANS  0x5c4f
#define __SYSVAR_CURCHL  0x5c51
#define __SYSVAR_PROG  0x5c53
#define __SYSVAR_NXTLIN  0x5c55
#define __SYSVAR_DATADD  0x5c57
#define __SYSVAR_ELINE  0x5c59
#define __SYSVAR_KCUR  0x5c5b
#define __SYSVAR_CHADD  0x5c5d
#define __SYSVAR_XPTR  0x5c5f
#define __SYSVAR_WORKSP  0x5c61
#define __SYSVAR_STKBOT  0x5c63
#define __SYSVAR_STKEND  0x5c65
#define __SYSVAR_BREG  0x5c67
#define __SYSVAR_MEM  0x5c68
#define __SYSVAR_FLAGS2  0x5c6a
#define __SYSVAR_DFSZ  0x5c6b
#define __SYSVAR_STOP  0x5c6c
#define __SYSVAR_OLDPPC  0x5c6e
#define __SYSVAR_OSPPC  0x5c70
#define __SYSVAR_FLAGX  0x5c71
#define __SYSVAR_STRLEN  0x5c72
#define __SYSVAR_TADDR  0x5c74
#define __SYSVAR_SEED  0x5c76
#define __SYSVAR_FRAMES  0x5c78
#define __SYSVAR_UDG  0x5c7b
#define __SYSVAR_COORDS  0x5c7d
#define __SYSVAR_GMODE  0x5c7f
#define __SYSVAR_PRCC  0x5c80
#define __SYSVAR_ECHOE  0x5c82
#define __SYSVAR_DFCC  0x5c84
#define __SYSVAR_DFCCL  0x5c86
#define __SYSVAR_SPOSN  0x5c88
#define __SYSVAR_SPOSNL  0x5c8a
#define __SYSVAR_SCRCT  0x5c8c
#define __SYSVAR_ATTRP  0x5c8d
#define __SYSVAR_MASKP  0x5c8e
#define __SYSVAR_ATTRT  0x5c8f
#define __SYSVAR_MASKT  0x5c90
#define __SYSVAR_PFLAG  0x5c91
#define __SYSVAR_MEMBOT  0x5c92
#define __SYSVAR_NMIADD  0x5cb0
#define __SYSVAR_RAMTOP  0x5cb2
#define __SYSVAR_PRAMT  0x5cb4

#define __ERRB_0_OK  0
#define __ERRB_1_NEXT_WITHOUT_FOR  1
#define __ERRB_2_VARIABLE_NOT_FOUND  2
#define __ERRB_3_SUBSCRIPT_WRONG  3
#define __ERRB_4_OUT_OF_MEMORY  4
#define __ERRB_5_OUT_OF_SCREEN  5
#define __ERRB_6_NUMBER_TOO_BIG  6
#define __ERRB_7_RETURN_WITHOUT_GOSUB  7
#define __ERRB_8_END_OF_FILE  8
#define __ERRB_9_STOP_STATEMENT  9
#define __ERRB_A_INVALID_ARGUMENT  10
#define __ERRB_B_INTEGER_OUT_OF_RANGE  11
#define __ERRB_C_NONSENSE_IN_BASIC  12
#define __ERRB_D_BREAK_CONT_REPEATS  13
#define __ERRB_E_OUT_OF_DATA  14
#define __ERRB_F_INVALID_FILENAME  15
#define __ERRB_G_NO_ROOM_FOR_LINE  16
#define __ERRB_H_STOP_IN_INPUT  17
#define __ERRB_I_FOR_WITHOUT_NEXT  18
#define __ERRB_J_INVALID_IO_DEVICE  19
#define __ERRB_K_INVALID_COLOUR  20
#define __ERRB_K_INVALID_COLOR  20
#define __ERRB_L_BREAK_INTO_PROGRAM  21
#define __ERRB_M_RAMTOP_NO_GOOD  22
#define __ERRB_N_STATEMENT_LOST  23
#define __ERRB_O_INVALID_STREAM  24
#define __ERRB_P_FN_WITHOUT_DEF  25
#define __ERRB_Q_PARAMETER_ERROR  26
#define __ERRB_R_TAPE_LOADING_ERROR  27












#define __NEXTOS_IDE_MODE  0x01d5

#define __ESX_RST_SYS  0x08
#define __ESX_RST_ROM  0x18
#define __ESX_RST_EXITDOT  0x20

#define __ESX_PATHNAME_MAX  256
#define __ESX_FILENAME_MAX  12
#define __ESX_FILENAME_LFN_MAX  260

#define __ESX_DISK_FILEMAP  0x85
#define __ESX_DISK_STRMSTART  0x86
#define __ESX_DISK_STRMEND  0x87

#define __ESX_M_DOSVERSION  0x88
#define __ESX_M_GETSETDRV  0x89

#define __ESX_M_TAPEIN  0x8b
#define __esx_tapein_open  0
#define __esx_tapein_close  1
#define __esx_tapein_info  2
#define __esx_tapein_setpos  3
#define __esx_tapein_getpos  4
#define __esx_tapein_pause  5
#define __esx_tapein_flags  6

#define __ESX_M_TAPEOUT  0x8c
#define __esx_tapeout_open  0
#define __esx_tapeout_close  1
#define __esx_tapeout_info  2
#define __esx_tapeout_trunc  3

#define __ESX_M_GETHANDLE  0x8d
#define __ESX_M_GETDATE  0x8e
#define __ESX_M_EXECCMD  0x8f

#define __ESX_M_SETCAPS  0x91
#define __esx_caps_fast_trunc  0x80

#define __ESX_M_DRVAPI  0x92
#define __ESX_M_GETERR  0x93
#define __ESX_M_P3DOS  0x94
#define __ESX_M_ERRH  0x95

#define __ESX_F_OPEN  0x9a
#define __esx_mode_read  0x01
#define __esx_mode_write  0x02
#define __esx_mode_use_header  0x40
#define __esx_mode_open_exist  0x00
#define __esx_mode_open_creat  0x08
#define __esx_mode_creat_noexist  0x04
#define __esx_mode_creat_trunc  0x0c

#define __ESX_F_CLOSE  0x9b
#define __ESX_F_SYNC  0x9c
#define __ESX_F_READ  0x9d
#define __ESX_F_WRITE  0x9e

#define __ESX_F_SEEK  0x9f
#define __esx_seek_set  0x00
#define __esx_seek_fwd  0x01
#define __esx_seek_bwd  0x02

#define __ESX_F_FGETPOS  0xa0
#define __ESX_F_FSTAT  0xa1
#define __ESX_F_FTRUNCATE  0xa2

#define __ESX_F_OPENDIR  0xa3
#define __esx_dir_use_lfn  0x10
#define __esx_dir_use_header  0x40

#define __ESX_F_READDIR  0xa4
#define __esx_dir_a_rdo  0x01
#define __esx_dir_a_hid  0x02
#define __esx_dir_a_sys  0x04
#define __esx_dir_a_vol  0x08
#define __esx_dir_a_dir  0x10
#define __esx_dir_a_arch  0x20
#define __esx_dir_a_dev  0x40
#define __esx_dir_a_res  0x80

#define __ESX_F_TELLDIR  0xa5
#define __ESX_F_SEEKDIR  0xa6
#define __ESX_F_REWINDDIR  0xa7
#define __ESX_F_GETCWD  0xa8
#define __ESX_F_CHDIR  0xa9
#define __ESX_F_MKDIR  0xaa
#define __ESX_F_RMDIR  0xab
#define __ESX_F_STAT  0xac
#define __ESX_F_UNLINK  0xad
#define __ESX_F_TRUNCATE  0xae

#define __ESX_F_CHMOD  0xaf
#define __esx_a_write  0x01
#define __esx_a_read  0x80
#define __esx_a_rdwr  0x81
#define __esx_a_hidden  0x02
#define __esx_a_system  0x04
#define __esx_a_arch  0x20
#define __esx_a_exec  0x40
#define __esx_a_all  0xe7

#define __ESX_F_RENAME  0xb0
#define __ESX_F_GETFREE  0xb1

#define __ESX_OK  0
#define __ESX_EOK  1
#define __ESX_ENONSENSE  2
#define __ESX_ESTEND  3
#define __ESX_EWRTYPE  4
#define __ESX_ENOENT  5
#define __ESX_EIO  6
#define __ESX_EINVAL  7
#define __ESX_EACCES  8
#define __ESX_ENOSPC  9
#define __ESX_ENXIO  10
#define __ESX_ENODRV  11
#define __ESX_ENFILE  12
#define __ESX_EBADF  13
#define __ESX_ENODEV  14
#define __ESX_EOVERFLOW  15
#define __ESX_EISDIR  16
#define __ESX_ENOTDIR  17
#define __ESX_EEXIST  18
#define __ESX_EPATH  19
#define __ESX_ENOSYS  20
#define __ESX_ENAMETOOLONG  21
#define __ESX_ENOCMD  22
#define __ESX_EINUSE  23
#define __ESX_ERDONLY  24
#define __ESX_EVERIFY  25
#define __ESX_ELOADINGKO  26
#define __ESX_EDIRINUSE  27
#define __ESX_EMAPRAMACTIVE  28
#define __ESX_EDRIVEBUSY  29
#define __ESX_EFSUNKNOWN  30
#define __ESX_EDEVICEBUSY  31

#define __ESX_EMAXCODE  31





#endif



