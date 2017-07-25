divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__YAZ180', 1)

# ASCI0 driver

define(`ASCI0_RX_SIZE', 0x100)  # Size of the Rx Buffer
define(`ASCI0_TX_SIZE', 0x100)  # Size of the Tx Buffer

# ASCI1 driver

define(`ASCI1_RX_SIZE', 0x100)  # Size of the Rx Buffer
define(`ASCI1_TX_SIZE', 0x100)  # Size of the Tx Buffer

# APU driver

define(`APU_CMD_SIZE', 0x100)   # Size of the CMD Buffer, 256 CMDs
define(`APU_PTR_SIZE', 0x100)   # Size of the DATA POINTER Buffer, 128 POINTERs

# Some definitions used with the YAZ-180 on-board peripherals

# BREAK for Single Step Mode

define(`IO_BREAK', 0x2000)  # Any value written $2000->$21FF, halts CPU

# 82C55 PIO Port Definitions

define(`PIO',    0x4000)    # Base Address for 82C55

define(`PIOA', PIO+0x00)    # Address for Port A
define(`PIOB', PIO+0x01)    # Address for Port B
define(`PIOC', PIO+0x02)    # Address for Port C
define(`PIOCNTL', PIO+0x03) # Address for Control Byte

# 82C55 PIO Mode Definitions

# PIO Mode 0 - Basic Input / Output

define(`PIOCNTL00', 0x80)   # A->, B->, CH->, CL->
define(`PIOCNTL01', 0x81)   # A->, B->, CH->, ->CL
define(`PIOCNTL02', 0x82)   # A->, ->B, CH->, CL->
define(`PIOCNTL03', 0x83)   # A->, ->B, CH->, ->CL

define(`PIOCNTL04', 0x88)   # A->, B->, ->CH, CL->
define(`PIOCNTL05', 0x89)   # A->, B->, ->CH, ->CL
define(`PIOCNTL06', 0x8A)   # A->, ->B, ->CH, CL->
define(`PIOCNTL07', 0x8B)   # A->, ->B, ->CH, ->CL

define(`PIOCNTL08', 0x90)   # ->A, B->, CH->, CL->
define(`PIOCNTL09', 0x91)   # ->A, B->, CH->, ->CL
define(`PIOCNTL10', 0x92)   # ->A, ->B, CH->, CL->
define(`PIOCNTL11', 0x83)   # ->A, ->B, CH->, ->CL

define(`PIOCNTL12', 0x98)   # ->A, B->, ->CH, CL-> (Default Setting)
define(`PIOCNTL13', 0x99)   # ->A, B->, ->CH, ->CL
define(`PIOCNTL14', 0x9A)   # ->A, ->B, ->CH, CL->
define(`PIOCNTL15', 0x9B)   # ->A, ->B, ->CH, ->CL

# PIO Mode 1 - Strobed Input / Output
# TBA Later

# PIO Mode 2 - Strobed Bidirectional Bus Input / Output
# TBA Later

# Am9511A-1 APU Port Definitions

define(`APU',  0xC000)          # Base Address for Am9511A
define(`APUDATA',  APU+0x00)    # APU Data Port
define(`APUCNTL',  APU+0x01)    # APU Control Port

define(`APU_OP_ENT',  0x40)
define(`APU_OP_REM',  0x50)
define(`APU_OP_ENT16',  0x40)
define(`APU_OP_ENT32',  0x41)
define(`APU_OP_REM16',  0x50)
define(`APU_OP_REM32',  0x51)

define(`APU_CNTL_BUSY',  0x80)
define(`APU_CNTL_SIGN',  0x40)
define(`APU_CNTL_ZERO',  0x20)
define(`APU_CNTL_DIV0',  0x10)
define(`APU_CNTL_NEGRT',  0x08)
define(`APU_CNTL_UNDFL',  0x04)
define(`APU_CNTL_OVRFL',  0x02)
define(`APU_CNTL_CARRY',  0x01)

define(`APU_CNTL_ERROR',  0x1E)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__YAZ180'

PUBLIC `ASCI0_RX_SIZE'
PUBLIC `ASCI0_TX_SIZE'

PUBLIC `ASCI1_RX_SIZE'
PUBLIC `ASCI1_TX_SIZE'

PUBLIC `APU_CMD_SIZE'
PUBLIC `APU_PTR_SIZE'

PUBLIC `IO_BREAK'

PUBLIC `PIO'

PUBLIC `PIOA'
PUBLIC `PIOB'
PUBLIC `PIOC'
PUBLIC `PIOCNTL'

PUBLIC `PIOCNTL00'
PUBLIC `PIOCNTL01'
PUBLIC `PIOCNTL02'
PUBLIC `PIOCNTL03'

PUBLIC `PIOCNTL04'
PUBLIC `PIOCNTL05'
PUBLIC `PIOCNTL06'
PUBLIC `PIOCNTL07'

PUBLIC `PIOCNTL08'
PUBLIC `PIOCNTL09'
PUBLIC `PIOCNTL10'
PUBLIC `PIOCNTL11'

PUBLIC `PIOCNTL12'
PUBLIC `PIOCNTL13'
PUBLIC `PIOCNTL14'
PUBLIC `PIOCNTL15'

PUBLIC `APU'
PUBLIC `APUDATA'
PUBLIC `APUCNTL'

PUBLIC `APU_OP_ENT'
PUBLIC `APU_OP_REM'
PUBLIC `APU_OP_ENT16'
PUBLIC `APU_OP_ENT32'
PUBLIC `APU_OP_REM16'
PUBLIC `APU_OP_REM32'

PUBLIC `APU_CNTL_BUSY'
PUBLIC `APU_CNTL_SIGN'
PUBLIC `APU_CNTL_ZERO'
PUBLIC `APU_CNTL_DIV0'
PUBLIC `APU_CNTL_NEGRT'
PUBLIC `APU_CNTL_UNDFL'
PUBLIC `APU_CNTL_OVRFL'
PUBLIC `APU_CNTL_CARRY'

PUBLIC `APU_CNTL_ERROR'

')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__YAZ180' = __YAZ180

defc `ASCI0_RX_SIZE' = ASCI0_RX_SIZE
defc `ASCI0_TX_SIZE' = ASCI0_TX_SIZE

defc `ASCI1_RX_SIZE' = ASCI1_RX_SIZE
defc `ASCI1_TX_SIZE' = ASCI1_TX_SIZE

defc `APU_CMD_SIZE' = APU_CMD_SIZE
defc `APU_PTR_SIZE' = APU_PTR_SIZE

defc `IO_BREAK' = IO_BREAK

defc `PIO' = PIO

defc `PIOA' = PIOA
defc `PIOB' = PIOB
defc `PIOC' = PIOC
defc `PIOCNTL' = PIOCNTL

defc `PIOCNTL00' = PIOCNTL00
defc `PIOCNTL01' = PIOCNTL01
defc `PIOCNTL02' = PIOCNTL02
defc `PIOCNTL03' = PIOCNTL03

defc `PIOCNTL04' = PIOCNTL04
defc `PIOCNTL05' = PIOCNTL05
defc `PIOCNTL06' = PIOCNTL06
defc `PIOCNTL07' = PIOCNTL07

defc `PIOCNTL08' = PIOCNTL08
defc `PIOCNTL09' = PIOCNTL09
defc `PIOCNTL10' = PIOCNTL10
defc `PIOCNTL11' = PIOCNTL11

defc `PIOCNTL12' = PIOCNTL12
defc `PIOCNTL13' = PIOCNTL13
defc `PIOCNTL14' = PIOCNTL14
defc `PIOCNTL15' = PIOCNTL15

defc `APU' = APU
defc `APUDATA' = APUDATA
defc `APUCNTL' = APUCNTL

defc `APU_OP_ENT' = APU_OP_ENT
defc `APU_OP_REM' = APU_OP_REM
defc `APU_OP_ENT16' = APU_OP_ENT16
defc `APU_OP_ENT32' = APU_OP_ENT32
defc `APU_OP_REM16' = APU_OP_REM16
defc `APU_OP_REM32' = APU_OP_REM32

defc `APU_CNTL_BUSY' = APU_CNTL_BUSY
defc `APU_CNTL_SIGN' = APU_CNTL_SIGN
defc `APU_CNTL_ZERO' = APU_CNTL_ZERO
defc `APU_CNTL_DIV0' = APU_CNTL_DIV0
defc `APU_CNTL_NEGRT' = APU_CNTL_NEGRT
defc `APU_CNTL_UNDFL' = APU_CNTL_UNDFL
defc `APU_CNTL_OVRFL' = APU_CNTL_OVRFL
defc `APU_CNTL_CARRY' = APU_CNTL_CARRY

defc `APU_CNTL_ERROR' = APU_CNTL_ERROR

')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`

`#undef'  `__YAZ180'
`#define' `__YAZ180'  __YAZ180

`#define' `ASCI0_RX_SIZE'  ASCI0_RX_SIZE
`#define' `ASCI0_TX_SIZE'  ASCI0_TX_SIZE

`#define' `ASCI1_RX_SIZE'  ASCI1_RX_SIZE
`#define' `ASCI1_TX_SIZE'  ASCI1_TX_SIZE

`#define' `APU_CMD_SIZE'  APU_CMD_SIZE
`#define' `APU_PTR_SIZE'  APU_PTR_SIZE

`#define' `IO_BREAK'  IO_BREAK

`#define' `PIO'  PIO

`#define' `PIOA'  PIOA
`#define' `PIOB'  PIOB
`#define' `PIOC'  PIOC
`#define' `PIOCNTL'  PIOCNTL

`#define' `PIOCNTL00'  PIOCNTL00
`#define' `PIOCNTL01'  PIOCNTL01
`#define' `PIOCNTL02'  PIOCNTL02
`#define' `PIOCNTL03'  PIOCNTL03

`#define' `PIOCNTL04'  PIOCNTL04
`#define' `PIOCNTL05'  PIOCNTL05
`#define' `PIOCNTL06'  PIOCNTL06
`#define' `PIOCNTL07'  PIOCNTL07

`#define' `PIOCNTL08'  PIOCNTL08
`#define' `PIOCNTL09'  PIOCNTL09
`#define' `PIOCNTL10'  PIOCNTL10
`#define' `PIOCNTL11'  PIOCNTL11

`#define' `PIOCNTL12'  PIOCNTL12
`#define' `PIOCNTL13'  PIOCNTL13
`#define' `PIOCNTL14'  PIOCNTL14
`#define' `PIOCNTL15'  PIOCNTL15

`#define' `APU'  APU
`#define' `APUDATA'  APUDATA
`#define' `APUCNTL'  APUCNTL

`#define' `APU_OP_ENT'  APU_OP_ENT
`#define' `APU_OP_REM'  APU_OP_REM
`#define' `APU_OP_ENT16'  APU_OP_ENT16
`#define' `APU_OP_ENT32'  APU_OP_ENT32
`#define' `APU_OP_REM16'  APU_OP_REM16
`#define' `APU_OP_REM32'  APU_OP_REM32

`#define' `APU_CNTL_BUSY'  APU_CNTL_BUSY
`#define' `APU_CNTL_SIGN'  APU_CNTL_SIGN
`#define' `APU_CNTL_ZERO'  APU_CNTL_ZERO
`#define' `APU_CNTL_DIV0'  APU_CNTL_DIV0
`#define' `APU_CNTL_NEGRT'  APU_CNTL_NEGRT
`#define' `APU_CNTL_UNDFL'  APU_CNTL_UNDFL
`#define' `APU_CNTL_OVRFL'  APU_CNTL_OVRFL
`#define' `APU_CNTL_CARRY'  APU_CNTL_CARRY

`#define' `APU_CNTL_ERROR'  APU_CNTL_ERROR

')
