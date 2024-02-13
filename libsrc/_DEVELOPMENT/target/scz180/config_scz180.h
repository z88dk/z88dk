





#ifndef __CONFIG_Z88DK_H_
#define __CONFIG_Z88DK_H_

// Automatically Generated at Library Build Time














#undef  __Z88DK
#define __Z88DK  2300












#undef  __SCZ180
#define __SCZ180  1

#define __CPU_CLOCK  18432000

#define __CLOCKS_PER_SECOND 50

#define __ASCI0_RX_SIZE  0x100
#define __ASCI0_RX_FULLISH  0xf0
#define __ASCI0_RX_EMPTYISH  0x08
#define __ASCI0_TX_SIZE  0x080

#define __ASCI1_RX_SIZE  0x100
#define __ASCI1_TX_SIZE  0x080

#define __IO_BASE_ADDRESS 0xc0

#define __IO_DIO_PORT  0x00

#define __IO_SYSTEM  0x0C
#define __IO_LED_OUTPUT  0x0D
#define __IO_LED_STATUS  0x0E

#define __IO_CF_PORT  0x10












#undef  __Z180
#define __Z180  0x04

#define __Z180_Z80180  0x01
#define __Z180_Z8L180  0x02
#define __Z180_Z8S180  0x04

#define __CPU_INFO  0x00

#define __CPU_INFO_ENABLE_SLL  0x01

#define __CPU_TIMER_SCALE  20


   // Z8S180 / Z8L180 CLASS

   #define __IO_CNTLA0  0xc0
   #define __IO_CNTLA1  0xc1
   #define __IO_CNTLB0  0xc2
   #define __IO_CNTLB1  0xc3
   #define __IO_STAT0  0xc4
   #define __IO_STAT1  0xc5
   #define __IO_TDR0  0xc6
   #define __IO_TDR1  0xc7
   #define __IO_RDR0  0xc8
   #define __IO_RDR1  0xc9
   #define __IO_ASEXT0  0xd2
   #define __IO_ASEXT1  0xd3
   #define __IO_ASTC0L  0xda
   #define __IO_ASTC0H  0xdb
   #define __IO_ASTC1L  0xdc
   #define __IO_ASTC1H  0xdd

   #define __IO_CNTR  0xca
   #define __IO_TRDR  0xcb

   #define __IO_TMDR0L  0xcc
   #define __IO_TMDR0H  0xcd
   #define __IO_RLDR0L  0xce
   #define __IO_RLDR0H  0xcf
   #define __IO_TCR  0xd0
   #define __IO_TMDR1L  0xd4
   #define __IO_TMDR1H  0xd5
   #define __IO_RLDR1L  0xd6
   #define __IO_RLDR1H  0xd7

   #define __IO_FRC  0xd8
   #define __IO_CMR  0xde
   #define __IO_CCR  0xdf

   #define __IO_SAR0L  0xe0
   #define __IO_SAR0H  0xe1
   #define __IO_SAR0B  0xe2
   #define __IO_DAR0L  0xe3
   #define __IO_DAR0H  0xe4
   #define __IO_DAR0B  0xe5
   #define __IO_BCR0L  0xe6
   #define __IO_BCR0H  0xe7
   #define __IO_MAR1L  0xe8
   #define __IO_MAR1H  0xe9
   #define __IO_MAR1B  0xea
   #define __IO_IAR1L  0xeb
   #define __IO_IAR1H  0xec
   #define __IO_IAR1B  0xed
   #define __IO_BCR1L  0xee
   #define __IO_BCR1H  0xef
   #define __IO_DSTAT  0xf0
   #define __IO_DMODE  0xf1
   #define __IO_DCNTL  0xf2

   #define __IO_IL  0xf3
   #define __IO_ITC  0xf4

   #define __IO_RCR  0xf6

   #define __IO_CBR  0xf8
   #define __IO_BBR  0xf9
   #define __IO_CBAR  0xfa

   #define __IO_OMCR  0xfe
   #define __IO_ICR  0x3f

   // I/O REGISTER BIT FIELDS

   #define __IO_CNTLA0_MPE   0x80
   #define __IO_CNTLA0_RE   0x40
   #define __IO_CNTLA0_TE   0x20
   #define __IO_CNTLA0_RTS0   0x10
   #define __IO_CNTLA0_MPBR   0x08
   #define __IO_CNTLA0_EFR   0x08
   #define __IO_CNTLA0_MODE_MASK   0x07
   #define __IO_CNTLA0_MODE_8P2   0x07
   #define __IO_CNTLA0_MODE_8P1   0x06
   #define __IO_CNTLA0_MODE_8N2   0x05
   #define __IO_CNTLA0_MODE_8N1   0x04
   #define __IO_CNTLA0_MODE_7P2   0x03
   #define __IO_CNTLA0_MODE_7P1   0x02
   #define __IO_CNTLA0_MODE_7N2   0x01
   #define __IO_CNTLA0_MODE_7N1   0x00

   #define __IO_CNTLA1_MPE   0x80
   #define __IO_CNTLA1_RE   0x40
   #define __IO_CNTLA1_TE   0x20
   #define __IO_CNTLA1_CKA1D   0x10
   #define __IO_CNTLA1_MPBR   0x08
   #define __IO_CNTLA1_EFR   0x08
   #define __IO_CNTLA1_MODE_MASK   0x07
   #define __IO_CNTLA1_MODE_8P2   0x07
   #define __IO_CNTLA1_MODE_8P1   0x06
   #define __IO_CNTLA1_MODE_8N2   0x05
   #define __IO_CNTLA1_MODE_8N1   0x04
   #define __IO_CNTLA1_MODE_7P2   0x03
   #define __IO_CNTLA1_MODE_7P1   0x02
   #define __IO_CNTLA1_MODE_7N2   0x01
   #define __IO_CNTLA1_MODE_7N1   0x00

   #define __IO_CNTLB0_MPBT   0x80
   #define __IO_CNTLB0_MP   0x40
   #define __IO_CNTLB0_CTS   0x20
   #define __IO_CNTLB0_PS   0x20
   #define __IO_CNTLB0_PEO   0x10
   #define __IO_CNTLB0_DR   0x08
   #define __IO_CNTLB0_SS_MASK   0x07
   #define __IO_CNTLB0_SS_EXT   0x07
   #define __IO_CNTLB0_SS_DIV_64   0x06
   #define __IO_CNTLB0_SS_DIV_32   0x05
   #define __IO_CNTLB0_SS_DIV_16   0x04
   #define __IO_CNTLB0_SS_DIV_8   0x03
   #define __IO_CNTLB0_SS_DIV_4   0x02
   #define __IO_CNTLB0_SS_DIV_2   0x01
   #define __IO_CNTLB0_SS_DIV_1   0x00

   #define __IO_CNTLB1_MPBT   0x80
   #define __IO_CNTLB1_MP   0x40
   #define __IO_CNTLB1_CTS   0x20
   #define __IO_CNTLB1_PS   0x20
   #define __IO_CNTLB1_PEO   0x10
   #define __IO_CNTLB1_DR   0x08
   #define __IO_CNTLB1_SS_MASK   0x07
   #define __IO_CNTLB1_SS_EXT   0x07
   #define __IO_CNTLB1_SS_DIV_64   0x06
   #define __IO_CNTLB1_SS_DIV_32   0x05
   #define __IO_CNTLB1_SS_DIV_16   0x04
   #define __IO_CNTLB1_SS_DIV_8   0x03
   #define __IO_CNTLB1_SS_DIV_4   0x02
   #define __IO_CNTLB1_SS_DIV_2   0x01
   #define __IO_CNTLB1_SS_DIV_1   0x00

   #define __IO_STAT0_RDRF   0x80
   #define __IO_STAT0_OVRN   0x40
   #define __IO_STAT0_PE   0x20
   #define __IO_STAT0_FE   0x10
   #define __IO_STAT0_RIE   0x08
   #define __IO_STAT0_DCD0   0x04
   #define __IO_STAT0_TDRE   0x02
   #define __IO_STAT0_TIE   0x01

   #define __IO_STAT1_RDRF   0x80
   #define __IO_STAT1_OVRN   0x40
   #define __IO_STAT1_PE   0x20
   #define __IO_STAT1_FE   0x10
   #define __IO_STAT1_RIE   0x08
   #define __IO_STAT1_CTS1E   0x04
   #define __IO_STAT1_TDRE   0x02
   #define __IO_STAT1_TIE   0x01

   #define __IO_CNTR_EF   0x80
   #define __IO_CNTR_EIE   0x40
   #define __IO_CNTR_RE   0x20
   #define __IO_CNTR_TE   0x10
   #define __IO_CNTR_SS_MASK   0x07
   #define __IO_CNTR_SS_EXT   0x07
   #define __IO_CNTR_SS_DIV_1280   0x06
   #define __IO_CNTR_SS_DIV_640   0x05
   #define __IO_CNTR_SS_DIV_320   0x04
   #define __IO_CNTR_SS_DIV_160   0x03
   #define __IO_CNTR_SS_DIV_80   0x02
   #define __IO_CNTR_SS_DIV_40   0x01
   #define __IO_CNTR_SS_DIV_20   0x00

   // PRT REGISTER BIT FIELDS

   #define __IO_TCR_TIF1    0x80
   #define __IO_TCR_TIF0    0x40
   #define __IO_TCR_TIE1    0x20
   #define __IO_TCR_TIE0    0x10
   #define __IO_TCR_TOC1    0x08
   #define __IO_TCR_TOC0    0x04
   #define __IO_TCR_TDE1    0x02
   #define __IO_TCR_TDE0    0x01

   // DMA REGISTER BIT FIELDS

   #define __IO_DSTAT_DE1    0x80
   #define __IO_DSTAT_DE0    0x40
   #define __IO_DSTAT_DWE1   0x20
   #define __IO_DSTAT_DWE0   0x10
   #define __IO_DSTAT_DIE1   0x08
   #define __IO_DSTAT_DIE0   0x04
   #define __IO_DSTAT_DME    0x01

   #define __IO_DMODE_DM1    0x20
   #define __IO_DMODE_DM0    0x10
   #define __IO_DMODE_SM1    0x08
   #define __IO_DMODE_SM0    0x04
   #define __IO_DMODE_MMOD   0x02

   #define __IO_DCNTL_MWI1   0x80
   #define __IO_DCNTL_MWI0   0x40
   #define __IO_DCNTL_IWI1   0x20
   #define __IO_DCNTL_IWI0   0x10
   #define __IO_DCNTL_DMS1   0x08
   #define __IO_DCNTL_DMS0   0x04
   #define __IO_DCNTL_DIM1   0x02
   #define __IO_DCNTL_DIM0   0x01

   // INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   #define __IO_ITC_TRAP   0x80
   #define __IO_ITC_UFO   0x40
   #define __IO_ITC_ITE2   0x04
   #define __IO_ITC_ITE1   0x02
   #define __IO_ITC_ITE0   0x01

   // Refresh CONTROL REGISTER (RCR) BIT FIELDS

   #define __IO_RCR_REFE   0x80
   #define __IO_RCR_REFW   0x40
   #define __IO_RCR_CYC1   0x02
   #define __IO_RCR_CYC0   0x01

   // Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   #define __IO_OMCR_M1E   0x80
   #define __IO_OMCR_M1TE   0x40
   #define __IO_OMCR_IOC   0x20

   // CPU CLOCK MULTIPLIER REGISTER (CMR) BIT FIELDS (Z8S180 & higher Only)

   #define __IO_CMR_X2   0x80
   #define __IO_CMR_LN_XTAL   0x40

   // CPU CONTROL REGISTER (CCR) BIT FIELDS (Z8S180 & higher Only)

   #define __IO_CCR_XTAL_X2   0x80
   #define __IO_CCR_STANDBY   0x40
   #define __IO_CCR_BREXT   0x20
   #define __IO_CCR_LNPHI   0x10
   #define __IO_CCR_IDLE   0x08
   #define __IO_CCR_LNIO   0x04
   #define __IO_CCR_LNCPUCTL   0x02
   #define __IO_CCR_LNAD   0x01













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
#define CHAR_BS  8
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






























#define __BF_CIO  0x00
#define __BF_CIOIN  0x0
#define __BF_CIOOUT  0x1
#define __BF_CIOIST  0x2
#define __BF_CIOOST  0x3
#define __BF_CIOINIT  0x4
#define __BF_CIOQUERY  0x5
#define __BF_CIODEVICE  0x6

#define __BF_DIO  0x10
#define __BF_DIOSTATUS  0x10
#define __BF_DIORESET  0x11
#define __BF_DIOSEEK  0x12
#define __BF_DIOREAD  0x13
#define __BF_DIOWRITE  0x14
#define __BF_DIOVERIFY  0x15
#define __BF_DIOFORMAT  0x16
#define __BF_DIODEVICE  0x17
#define __BF_DIOMEDIA  0x18
#define __BF_DIODEFMED  0x19
#define __BF_DIOCAP  0x1a
#define __BF_DIOGEOM  0x1b

#define __BF_RTC  0x20
#define __BF_RTCGETTIM  0x20
#define __BF_RTCSETTIM  0x21
#define __BF_RTCGETBYT  0x22
#define __BF_RTCSETBYT  0x23
#define __BF_RTCGETBLK  0x24
#define __BF_RTCSETBLK  0x25

#define __BF_EMU  0x30

#define __BF_VDA  0x40
#define __BF_VDAINI  0x40
#define __BF_VDAQRY  0x41
#define __BF_VDARES  0x42
#define __BF_VDADEV  0x43
#define __BF_VDASCS  0x44
#define __BF_VDASCP  0x45
#define __BF_VDASAT  0x46
#define __BF_VDASCO  0x47
#define __BF_VDAWRC  0x48
#define __BF_VDAFIL  0x49
#define __BF_VDACPY  0x4a
#define __BF_VDASCR  0x4b
#define __BF_VDAKST  0x4c
#define __BF_VDAKFL  0x4d
#define __BF_VDAKRD  0x4e

#define __BF_SYS  0xF0
#define __BF_SYSRESET  0xf0
#define __BF_SYSVER  0xf1
#define __BF_SYSSETBNK  0xf2
#define __BF_SYSGETBNK  0xf3
#define __BF_SYSSETCPY  0xf4
#define __BF_SYSBNKCPY  0xf5
#define __BF_SYSALLOC  0xf6
#define __BF_SYSFREE  0xf7
#define __BF_SYSGET  0xf8
#define __BF_SYSSET  0xf9
#define __BF_SYSPEEK  0xfa
#define __BF_SYSPOKE  0xfb
#define __BF_SYSINT  0xfc

#define __BF_SYSGET_CIOCNT  0x00
#define __BF_SYSGET_DIOCNT  0x10
#define __BF_SYSGET_VDACNT  0x40
#define __BF_SYSGET_TIMER  0xD0
#define __BF_SYSGET_SECS  0xD1
#define __BF_SYSGET_BOOTINFO  0xE0
#define __BF_SYSGET_CPUINFO  0xF0
#define __BF_SYSGET_MEMINFO  0xF1
#define __BF_SYSGET_BNKINFO  0xF2

#define __BF_SYSSET_TIMER  0xD0
#define __BF_SYSSET_SECS  0xD1
#define __BF_SYSSET_BOOTINFO  0xE0

#define __BF_SYSINT_INFO  0x00
#define __BF_SYSINT_GET  0x10
#define __BF_SYSINT_SET  0x20

#define __CIODEV_UART  0x00
#define __CIODEV_ASCI  0x10
#define __CIODEV_TERM  0x20
#define __CIODEV_PRPCON  0x30
#define __CIODEV_PPPCON  0x40
#define __CIODEV_SIO  0x50
#define __CIODEV_ACIA  0x60
#define __CIODEV_PIO  0x70
#define __CIODEV_UF  0x80
#define __CIODEV_CONSOLE  0xD0

#define __DIODEV_MD  0x00
#define __DIODEV_FD  0x10
#define __DIODEV_RF  0x20
#define __DIODEV_IDE  0x30
#define __DIODEV_ATAPI  0x40
#define __DIODEV_PPIDE  0x50
#define __DIODEV_SD  0x60
#define __DIODEV_PRPSD  0x70
#define __DIODEV_PPPSD  0x80
#define __DIODEV_HDSK  0x90

#define __VDADEV_VDU  0x00
#define __VDADEV_CVDU  0x10
#define __VDADEV_NEC  0x20
#define __VDADEV_TMS  0x30
#define __VDADEV_VGA  0x40

#define __EMUTYP_NONE  0x00
#define __EMUTYP_TTY  0x01
#define __EMUTYP_ANSI  0x02

#define __HBX_XFCDAT  0xffe0
#define __HB_CURBNK  0xffe0
#define __HB_INVBNK  0xffe1
#define __HB_SRCADR  0xffe2
#define __HB_SRCBNK  0xffe4
#define __HB_DSTADR  0xffe5
#define __HB_DSTBNK  0xffe7
#define __HB_CPYLEN  0xffe8

#define __HBX_XFCFNS  0xfff0
#define __HB_INVOKE  0xfff0
#define __HB_BNKSEL  0xfff3
#define __HB_BNKCPY  0xfff6
#define __HB_BNKCALL  0xfff9
#define __HB_IDENT  0xfffe












#define __CPM_RCON  1
#define __CPM_WCON  2
#define __CPM_RRDR  3
#define __CPM_WPUN  4
#define __CPM_WLST  5
#define __CPM_DCIO  6
#define __CPM_GIOB  7
#define __CPM_SIOB  8
#define __CPM_PRST  9
#define __CPM_RCOB  10
#define __CPM_ICON  11
#define __CPM_VERS  12
#define __CPM_RDS   13
#define __CPM_LGIN  14
#define __CPM_OPN   15
#define __CPM_CLS   16
#define __CPM_FFST  17
#define __CPM_FNXT  18
#define __CPM_DEL   19
#define __CPM_READ  20
#define __CPM_WRIT  21
#define __CPM_MAKE  22
#define __CPM_REN   23
#define __CPM_ILOG  24
#define __CPM_IDRV  25
#define __CPM_SDMA  26
#define __CPM_SUID  32
#define __CPM_RRAN  33
#define __CPM_WRAN  34
#define __CPM_CFS   35
#define __CPM_DSEG  51





#endif



