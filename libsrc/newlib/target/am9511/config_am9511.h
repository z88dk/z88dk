





#ifndef __CONFIG_Z88DK_AM9511__H_
#define __CONFIG_Z88DK_AM9511__H_

// Automatically Generated at Library Build Time
























#define __IO_APU_DATA  0x42
#define __IO_APU_CONTROL  0x43
#define __IO_APU_STATUS  0x43

#define __IO_APU_STATUS_BUSY  0x80
#define __IO_APU_STATUS_SIGN  0x40
#define __IO_APU_STATUS_ZERO  0x20
#define __IO_APU_STATUS_DIV0  0x10
#define __IO_APU_STATUS_NEGRT  0x08
#define __IO_APU_STATUS_UNDFL  0x04
#define __IO_APU_STATUS_OVRFL  0x02
#define __IO_APU_STATUS_CARRY  0x01

#define __IO_APU_STATUS_ERROR  0x1E

#define __IO_APU_COMMAND_SVREQ 0x80

#define __IO_APU_OP_ENT  0x40
#define __IO_APU_OP_REM  0x50
#define __IO_APU_OP_ENT16  0x40
#define __IO_APU_OP_ENT32  0x41
#define __IO_APU_OP_REM16  0x50
#define __IO_APU_OP_REM32  0x51

#define __IO_APU_OP_SADD  0x6C
#define __IO_APU_OP_SSUB  0x6D
#define __IO_APU_OP_SMUL  0x6E
#define __IO_APU_OP_SMUU  0x76
#define __IO_APU_OP_SDIV  0x6F

#define __IO_APU_OP_DADD  0x2C
#define __IO_APU_OP_DSUB  0x2D
#define __IO_APU_OP_DMUL  0x2E
#define __IO_APU_OP_DMUU  0x36
#define __IO_APU_OP_DDIV  0x2F

#define __IO_APU_OP_FADD  0x10
#define __IO_APU_OP_FSUB  0x11
#define __IO_APU_OP_FMUL  0x12
#define __IO_APU_OP_FDIV  0x13

#define __IO_APU_OP_SQRT  0x01
#define __IO_APU_OP_SIN  0x02
#define __IO_APU_OP_COS  0x03
#define __IO_APU_OP_TAN  0x04
#define __IO_APU_OP_ASIN  0x05
#define __IO_APU_OP_ACOS  0x06
#define __IO_APU_OP_ATAN  0x07
#define __IO_APU_OP_LOG  0x08
#define __IO_APU_OP_LN  0x09
#define __IO_APU_OP_EXP  0x0A
#define __IO_APU_OP_PWR  0x0B

#define __IO_APU_OP_NOP  0x00
#define __IO_APU_OP_FIXS  0x1F
#define __IO_APU_OP_FIXD  0x1E
#define __IO_APU_OP_FLTS  0x1D
#define __IO_APU_OP_FLTD  0x1C
#define __IO_APU_OP_CHSS  0x74
#define __IO_APU_OP_CHSD  0x34
#define __IO_APU_OP_CHSF  0x15
#define __IO_APU_OP_PTOS  0x77
#define __IO_APU_OP_PTOD  0x37
#define __IO_APU_OP_PTOF  0x17
#define __IO_APU_OP_POPS  0x78
#define __IO_APU_OP_POPD  0x38
#define __IO_APU_OP_POPF  0x18
#define __IO_APU_OP_XCHS  0x79
#define __IO_APU_OP_XCHD  0x39
#define __IO_APU_OP_XCHF  0x19
#define __IO_APU_OP_PUPI  0x1A












#define __IO_APU0_DATA  0x42
#define __IO_APU0_CONTROL  0x43
#define __IO_APU0_STATUS  0x43

#define __IO_APU1_DATA  0x62
#define __IO_APU1_CONTROL  0x63
#define __IO_APU1_STATUS  0x63

#define __IO_APU2_DATA  0xc2
#define __IO_APU2_CONTROL  0xc3
#define __IO_APU2_STATUS  0xc3

#define __IO_APU3_DATA  0xe2
#define __IO_APU3_CONTROL  0xe3
#define __IO_APU3_STATUS  0xe3





#endif



