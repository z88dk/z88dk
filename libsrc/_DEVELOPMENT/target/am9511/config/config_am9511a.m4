divert(-1)

###############################################################
# AM9511A CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_APU_DATA',    0x`'eval(__IO_APU_PORT_BASE+0x00,16))  # APU0 Data Port
define(`__IO_APU_CONTROL', 0x`'eval(__IO_APU_PORT_BASE+0x01,16))  # APU0 Control Port
define(`__IO_APU_STATUS',  0x`'eval(__IO_APU_PORT_BASE+0x01,16))  # APU0 Status Port == Control Port

define(`__IO_APU_STATUS_BUSY',  0x80)
define(`__IO_APU_STATUS_SIGN',  0x40)
define(`__IO_APU_STATUS_ZERO',  0x20)
define(`__IO_APU_STATUS_DIV0',  0x10)
define(`__IO_APU_STATUS_NEGRT', 0x08)
define(`__IO_APU_STATUS_UNDFL', 0x04)
define(`__IO_APU_STATUS_OVRFL', 0x02)
define(`__IO_APU_STATUS_CARRY', 0x01)

define(`__IO_APU_STATUS_ERROR', 0x1E)

define(`__IO_APU_COMMAND_SVREQ',0x80)

# added APU operations for interrupt driver
define(`__IO_APU_OP_ENT',   0x40)
define(`__IO_APU_OP_REM',   0x50)
define(`__IO_APU_OP_ENT16', 0x40)
define(`__IO_APU_OP_ENT32', 0x41)
define(`__IO_APU_OP_REM16', 0x50)
define(`__IO_APU_OP_REM32', 0x51)

# 16bit fixed APU operations
define(`__IO_APU_OP_SADD',  0x6C)
define(`__IO_APU_OP_SSUB',  0x6D)
define(`__IO_APU_OP_SMUL',  0x6E)
define(`__IO_APU_OP_SMUU',  0x76)
define(`__IO_APU_OP_SDIV',  0x6F)

# 32bit fixed APU operations
define(`__IO_APU_OP_DADD',  0x2C)
define(`__IO_APU_OP_DSUB',  0x2D)
define(`__IO_APU_OP_DMUL',  0x2E)
define(`__IO_APU_OP_DMUU',  0x36)
define(`__IO_APU_OP_DDIV',  0x2F)

# 32bit floating APU operations
define(`__IO_APU_OP_FADD',  0x10)
define(`__IO_APU_OP_FSUB',  0x11)
define(`__IO_APU_OP_FMUL',  0x12)
define(`__IO_APU_OP_FDIV',  0x13)

# 32bit floating derived APU operations
define(`__IO_APU_OP_SQRT',  0x01)
define(`__IO_APU_OP_SIN',   0x02)
define(`__IO_APU_OP_COS',   0x03)
define(`__IO_APU_OP_TAN',   0x04)
define(`__IO_APU_OP_ASIN',  0x05)
define(`__IO_APU_OP_ACOS',  0x06)
define(`__IO_APU_OP_ATAN',  0x07)
define(`__IO_APU_OP_LOG',   0x08)
define(`__IO_APU_OP_LN',    0x09)
define(`__IO_APU_OP_EXP',   0x0A)
define(`__IO_APU_OP_PWR',   0x0B)

# data and stack manipulation APU operations
define(`__IO_APU_OP_NOP',   0x00)
define(`__IO_APU_OP_FIXS',  0x1F)
define(`__IO_APU_OP_FIXD',  0x1E)
define(`__IO_APU_OP_FLTS',  0x1D)
define(`__IO_APU_OP_FLTD',  0x1C)
define(`__IO_APU_OP_CHSS',  0x74)
define(`__IO_APU_OP_CHSD',  0x34)
define(`__IO_APU_OP_CHSF',  0x15)
define(`__IO_APU_OP_PTOS',  0x77)
define(`__IO_APU_OP_PTOD',  0x37)
define(`__IO_APU_OP_PTOF',  0x17)
define(`__IO_APU_OP_POPS',  0x78)
define(`__IO_APU_OP_POPD',  0x38)
define(`__IO_APU_OP_POPF',  0x18)
define(`__IO_APU_OP_XCHS',  0x79)
define(`__IO_APU_OP_XCHD',  0x39)
define(`__IO_APU_OP_XCHF',  0x19)
define(`__IO_APU_OP_PUPI',  0x1A)

#
# END OF CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_APU_DATA'
PUBLIC `__IO_APU_CONTROL'
PUBLIC `__IO_APU_STATUS'

PUBLIC `__IO_APU_STATUS_BUSY'
PUBLIC `__IO_APU_STATUS_SIGN'
PUBLIC `__IO_APU_STATUS_ZERO'
PUBLIC `__IO_APU_STATUS_DIV0'
PUBLIC `__IO_APU_STATUS_NEGRT'
PUBLIC `__IO_APU_STATUS_UNDFL'
PUBLIC `__IO_APU_STATUS_OVRFL'
PUBLIC `__IO_APU_STATUS_CARRY'

PUBLIC `__IO_APU_STATUS_ERROR'

PUBLIC `__IO_APU_COMMAND_SVREQ'

PUBLIC `__IO_APU_OP_ENT'
PUBLIC `__IO_APU_OP_REM'
PUBLIC `__IO_APU_OP_ENT16'
PUBLIC `__IO_APU_OP_ENT32'
PUBLIC `__IO_APU_OP_REM16'
PUBLIC `__IO_APU_OP_REM32'

PUBLIC `__IO_APU_OP_SADD'
PUBLIC `__IO_APU_OP_SSUB'
PUBLIC `__IO_APU_OP_SMUL'
PUBLIC `__IO_APU_OP_SMUU'
PUBLIC `__IO_APU_OP_SDIV'

PUBLIC `__IO_APU_OP_DADD'
PUBLIC `__IO_APU_OP_DSUB'
PUBLIC `__IO_APU_OP_DMUL'
PUBLIC `__IO_APU_OP_DMUU'
PUBLIC `__IO_APU_OP_DDIV'

PUBLIC `__IO_APU_OP_FADD'
PUBLIC `__IO_APU_OP_FSUB'
PUBLIC `__IO_APU_OP_FMUL'
PUBLIC `__IO_APU_OP_FDIV'

PUBLIC `__IO_APU_OP_SQRT'
PUBLIC `__IO_APU_OP_SIN'
PUBLIC `__IO_APU_OP_COS'
PUBLIC `__IO_APU_OP_TAN'
PUBLIC `__IO_APU_OP_ASIN'
PUBLIC `__IO_APU_OP_ACOS'
PUBLIC `__IO_APU_OP_ATAN'
PUBLIC `__IO_APU_OP_LOG'
PUBLIC `__IO_APU_OP_LN'
PUBLIC `__IO_APU_OP_EXP'
PUBLIC `__IO_APU_OP_PWR'

PUBLIC `__IO_APU_OP_NOP'
PUBLIC `__IO_APU_OP_FIXS'
PUBLIC `__IO_APU_OP_FIXD'
PUBLIC `__IO_APU_OP_FLTS'
PUBLIC `__IO_APU_OP_FLTD'
PUBLIC `__IO_APU_OP_CHSS'
PUBLIC `__IO_APU_OP_CHSD'
PUBLIC `__IO_APU_OP_CHSF'
PUBLIC `__IO_APU_OP_PTOS'
PUBLIC `__IO_APU_OP_PTOD'
PUBLIC `__IO_APU_OP_PTOF'
PUBLIC `__IO_APU_OP_POPS'
PUBLIC `__IO_APU_OP_POPD'
PUBLIC `__IO_APU_OP_POPF'
PUBLIC `__IO_APU_OP_XCHS'
PUBLIC `__IO_APU_OP_XCHD'
PUBLIC `__IO_APU_OP_XCHF'
PUBLIC `__IO_APU_OP_PUPI'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_APU_DATA' = __IO_APU_DATA
defc `__IO_APU_CONTROL' = __IO_APU_CONTROL
defc `__IO_APU_STATUS' = __IO_APU_STATUS

defc `__IO_APU_STATUS_BUSY' = __IO_APU_STATUS_BUSY
defc `__IO_APU_STATUS_SIGN' = __IO_APU_STATUS_SIGN
defc `__IO_APU_STATUS_ZERO' = __IO_APU_STATUS_ZERO
defc `__IO_APU_STATUS_DIV0' = __IO_APU_STATUS_DIV0
defc `__IO_APU_STATUS_NEGRT' = __IO_APU_STATUS_NEGRT
defc `__IO_APU_STATUS_UNDFL' = __IO_APU_STATUS_UNDFL
defc `__IO_APU_STATUS_OVRFL' = __IO_APU_STATUS_OVRFL
defc `__IO_APU_STATUS_CARRY' = __IO_APU_STATUS_CARRY

defc `__IO_APU_STATUS_ERROR' = __IO_APU_STATUS_ERROR

defc `__IO_APU_COMMAND_SVREQ' = __IO_APU_COMMAND_SVREQ

defc `__IO_APU_OP_ENT' = __IO_APU_OP_ENT
defc `__IO_APU_OP_REM' = __IO_APU_OP_REM
defc `__IO_APU_OP_ENT16' = __IO_APU_OP_ENT16
defc `__IO_APU_OP_ENT32' = __IO_APU_OP_ENT32
defc `__IO_APU_OP_REM16' = __IO_APU_OP_REM16
defc `__IO_APU_OP_REM32' = __IO_APU_OP_REM32

defc `__IO_APU_OP_SADD' = __IO_APU_OP_SADD
defc `__IO_APU_OP_SSUB' = __IO_APU_OP_SSUB
defc `__IO_APU_OP_SMUL' = __IO_APU_OP_SMUL
defc `__IO_APU_OP_SMUU' = __IO_APU_OP_SMUU
defc `__IO_APU_OP_SDIV' = __IO_APU_OP_SDIV

defc `__IO_APU_OP_DADD' = __IO_APU_OP_DADD
defc `__IO_APU_OP_DSUB' = __IO_APU_OP_DSUB
defc `__IO_APU_OP_DMUL' = __IO_APU_OP_DMUL
defc `__IO_APU_OP_DMUU' = __IO_APU_OP_DMUU
defc `__IO_APU_OP_DDIV' = __IO_APU_OP_DDIV

defc `__IO_APU_OP_FADD' = __IO_APU_OP_FADD
defc `__IO_APU_OP_FSUB' = __IO_APU_OP_FSUB
defc `__IO_APU_OP_FMUL' = __IO_APU_OP_FMUL
defc `__IO_APU_OP_FDIV' = __IO_APU_OP_FDIV

defc `__IO_APU_OP_SQRT' = __IO_APU_OP_SQRT
defc `__IO_APU_OP_SIN' = __IO_APU_OP_SIN
defc `__IO_APU_OP_COS' = __IO_APU_OP_COS
defc `__IO_APU_OP_TAN' = __IO_APU_OP_TAN
defc `__IO_APU_OP_ASIN' = __IO_APU_OP_ASIN
defc `__IO_APU_OP_ACOS' = __IO_APU_OP_ACOS
defc `__IO_APU_OP_ATAN' = __IO_APU_OP_ATAN
defc `__IO_APU_OP_LOG' = __IO_APU_OP_LOG
defc `__IO_APU_OP_LN' = __IO_APU_OP_LN
defc `__IO_APU_OP_EXP' = __IO_APU_OP_EXP
defc `__IO_APU_OP_PWR' = __IO_APU_OP_PWR

defc `__IO_APU_OP_NOP' = __IO_APU_OP_NOP
defc `__IO_APU_OP_FIXS' = __IO_APU_OP_FIXS
defc `__IO_APU_OP_FIXD' = __IO_APU_OP_FIXD
defc `__IO_APU_OP_FLTS' = __IO_APU_OP_FLTS
defc `__IO_APU_OP_FLTD' = __IO_APU_OP_FLTD
defc `__IO_APU_OP_CHSS' = __IO_APU_OP_CHSS
defc `__IO_APU_OP_CHSD' = __IO_APU_OP_CHSD
defc `__IO_APU_OP_CHSF' = __IO_APU_OP_CHSF
defc `__IO_APU_OP_PTOS' = __IO_APU_OP_PTOS
defc `__IO_APU_OP_PTOD' = __IO_APU_OP_PTOD
defc `__IO_APU_OP_PTOF' = __IO_APU_OP_PTOF
defc `__IO_APU_OP_POPS' = __IO_APU_OP_POPS
defc `__IO_APU_OP_POPD' = __IO_APU_OP_POPD
defc `__IO_APU_OP_POPF' = __IO_APU_OP_POPF
defc `__IO_APU_OP_XCHS' = __IO_APU_OP_XCHS
defc `__IO_APU_OP_XCHD' = __IO_APU_OP_XCHD
defc `__IO_APU_OP_XCHF' = __IO_APU_OP_XCHF
defc `__IO_APU_OP_PUPI' = __IO_APU_OP_PUPI
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_APU_DATA'  __IO_APU_DATA
`#define' `__IO_APU_CONTROL'  __IO_APU_CONTROL
`#define' `__IO_APU_STATUS'  __IO_APU_STATUS

`#define' `__IO_APU_STATUS_BUSY'  __IO_APU_STATUS_BUSY
`#define' `__IO_APU_STATUS_SIGN'  __IO_APU_STATUS_SIGN
`#define' `__IO_APU_STATUS_ZERO'  __IO_APU_STATUS_ZERO
`#define' `__IO_APU_STATUS_DIV0'  __IO_APU_STATUS_DIV0
`#define' `__IO_APU_STATUS_NEGRT'  __IO_APU_STATUS_NEGRT
`#define' `__IO_APU_STATUS_UNDFL'  __IO_APU_STATUS_UNDFL
`#define' `__IO_APU_STATUS_OVRFL'  __IO_APU_STATUS_OVRFL
`#define' `__IO_APU_STATUS_CARRY'  __IO_APU_STATUS_CARRY

`#define' `__IO_APU_STATUS_ERROR'  __IO_APU_STATUS_ERROR

`#define' `__IO_APU_COMMAND_SVREQ' __IO_APU_COMMAND_SVREQ

`#define' `__IO_APU_OP_ENT'  __IO_APU_OP_ENT
`#define' `__IO_APU_OP_REM'  __IO_APU_OP_REM
`#define' `__IO_APU_OP_ENT16'  __IO_APU_OP_ENT16
`#define' `__IO_APU_OP_ENT32'  __IO_APU_OP_ENT32
`#define' `__IO_APU_OP_REM16'  __IO_APU_OP_REM16
`#define' `__IO_APU_OP_REM32'  __IO_APU_OP_REM32

`#define' `__IO_APU_OP_SADD'  __IO_APU_OP_SADD
`#define' `__IO_APU_OP_SSUB'  __IO_APU_OP_SSUB
`#define' `__IO_APU_OP_SMUL'  __IO_APU_OP_SMUL
`#define' `__IO_APU_OP_SMUU'  __IO_APU_OP_SMUU
`#define' `__IO_APU_OP_SDIV'  __IO_APU_OP_SDIV

`#define' `__IO_APU_OP_DADD'  __IO_APU_OP_DADD
`#define' `__IO_APU_OP_DSUB'  __IO_APU_OP_DSUB
`#define' `__IO_APU_OP_DMUL'  __IO_APU_OP_DMUL
`#define' `__IO_APU_OP_DMUU'  __IO_APU_OP_DMUU
`#define' `__IO_APU_OP_DDIV'  __IO_APU_OP_DDIV

`#define' `__IO_APU_OP_FADD'  __IO_APU_OP_FADD
`#define' `__IO_APU_OP_FSUB'  __IO_APU_OP_FSUB
`#define' `__IO_APU_OP_FMUL'  __IO_APU_OP_FMUL
`#define' `__IO_APU_OP_FDIV'  __IO_APU_OP_FDIV

`#define' `__IO_APU_OP_SQRT'  __IO_APU_OP_SQRT
`#define' `__IO_APU_OP_SIN'  __IO_APU_OP_SIN
`#define' `__IO_APU_OP_COS'  __IO_APU_OP_COS
`#define' `__IO_APU_OP_TAN'  __IO_APU_OP_TAN
`#define' `__IO_APU_OP_ASIN'  __IO_APU_OP_ASIN
`#define' `__IO_APU_OP_ACOS'  __IO_APU_OP_ACOS
`#define' `__IO_APU_OP_ATAN'  __IO_APU_OP_ATAN
`#define' `__IO_APU_OP_LOG'  __IO_APU_OP_LOG
`#define' `__IO_APU_OP_LN'  __IO_APU_OP_LN
`#define' `__IO_APU_OP_EXP'  __IO_APU_OP_EXP
`#define' `__IO_APU_OP_PWR'  __IO_APU_OP_PWR

`#define' `__IO_APU_OP_NOP'  __IO_APU_OP_NOP
`#define' `__IO_APU_OP_FIXS'  __IO_APU_OP_FIXS
`#define' `__IO_APU_OP_FIXD'  __IO_APU_OP_FIXD
`#define' `__IO_APU_OP_FLTS'  __IO_APU_OP_FLTS
`#define' `__IO_APU_OP_FLTD'  __IO_APU_OP_FLTD
`#define' `__IO_APU_OP_CHSS'  __IO_APU_OP_CHSS
`#define' `__IO_APU_OP_CHSD'  __IO_APU_OP_CHSD
`#define' `__IO_APU_OP_CHSF'  __IO_APU_OP_CHSF
`#define' `__IO_APU_OP_PTOS'  __IO_APU_OP_PTOS
`#define' `__IO_APU_OP_PTOD'  __IO_APU_OP_PTOD
`#define' `__IO_APU_OP_PTOF'  __IO_APU_OP_PTOF
`#define' `__IO_APU_OP_POPS'  __IO_APU_OP_POPS
`#define' `__IO_APU_OP_POPD'  __IO_APU_OP_POPD
`#define' `__IO_APU_OP_POPF'  __IO_APU_OP_POPF
`#define' `__IO_APU_OP_XCHS'  __IO_APU_OP_XCHS
`#define' `__IO_APU_OP_XCHD'  __IO_APU_OP_XCHD
`#define' `__IO_APU_OP_XCHF'  __IO_APU_OP_XCHF
`#define' `__IO_APU_OP_PUPI'  __IO_APU_OP_PUPI
')
