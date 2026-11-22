divert(-1)

###############################################################
# 82C55 CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_PIO_PORT_A',   0x`'eval(__IO_PIO_PORT_BASE+0x00,16))  # Address for Port A
define(`__IO_PIO_PORT_B',   0x`'eval(__IO_PIO_PORT_BASE+0x01,16))  # Address for Port B
define(`__IO_PIO_PORT_C',   0x`'eval(__IO_PIO_PORT_BASE+0x02,16))  # Address for Port C
define(`__IO_PIO_CONTROL',  0x`'eval(__IO_PIO_PORT_BASE+0x03,16))  # Address for Control Byte

# 82C55 PIO Mode Definitions

# PIO Mode 0 - Basic Input / Output

define(`__IO_PIO_CNTL_00', 0x80)   # A->, B->, CH->, CL->
define(`__IO_PIO_CNTL_01', 0x81)   # A->, B->, CH->, ->CL
define(`__IO_PIO_CNTL_02', 0x82)   # A->, ->B, CH->, CL->
define(`__IO_PIO_CNTL_03', 0x83)   # A->, ->B, CH->, ->CL

define(`__IO_PIO_CNTL_04', 0x88)   # A->, B->, ->CH, CL->
define(`__IO_PIO_CNTL_05', 0x89)   # A->, B->, ->CH, ->CL
define(`__IO_PIO_CNTL_06', 0x8A)   # A->, ->B, ->CH, CL->
define(`__IO_PIO_CNTL_07', 0x8B)   # A->, ->B, ->CH, ->CL

define(`__IO_PIO_CNTL_08', 0x90)   # ->A, B->, CH->, CL->
define(`__IO_PIO_CNTL_09', 0x91)   # ->A, B->, CH->, ->CL
define(`__IO_PIO_CNTL_10', 0x92)   # ->A, ->B, CH->, CL->
define(`__IO_PIO_CNTL_11', 0x83)   # ->A, ->B, CH->, ->CL

define(`__IO_PIO_CNTL_12', 0x98)   # ->A, B->, ->CH, CL-> (Default Setting)
define(`__IO_PIO_CNTL_13', 0x99)   # ->A, B->, ->CH, ->CL
define(`__IO_PIO_CNTL_14', 0x9A)   # ->A, ->B, ->CH, CL->
define(`__IO_PIO_CNTL_15', 0x9B)   # ->A, ->B, ->CH, ->CL

# PIO Mode 1 - Strobed Input / Output
# TBA Later

# PIO Mode 2 - Strobed Bidirectional Bus Input / Output
# TBA Later

#
# END OF CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_PIO_PORT_A'
PUBLIC `__IO_PIO_PORT_B'
PUBLIC `__IO_PIO_PORT_C'
PUBLIC `__IO_PIO_CONTROL'

PUBLIC `__IO_PIO_CNTL_00'
PUBLIC `__IO_PIO_CNTL_01'
PUBLIC `__IO_PIO_CNTL_02'
PUBLIC `__IO_PIO_CNTL_03'

PUBLIC `__IO_PIO_CNTL_04'
PUBLIC `__IO_PIO_CNTL_05'
PUBLIC `__IO_PIO_CNTL_06'
PUBLIC `__IO_PIO_CNTL_07'

PUBLIC `__IO_PIO_CNTL_08'
PUBLIC `__IO_PIO_CNTL_09'
PUBLIC `__IO_PIO_CNTL_10'
PUBLIC `__IO_PIO_CNTL_11'

PUBLIC `__IO_PIO_CNTL_12'
PUBLIC `__IO_PIO_CNTL_13'
PUBLIC `__IO_PIO_CNTL_14'
PUBLIC `__IO_PIO_CNTL_15'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_PIO_PORT_A' = __IO_PIO_PORT_A
defc `__IO_PIO_PORT_B' = __IO_PIO_PORT_B
defc `__IO_PIO_PORT_C' = __IO_PIO_PORT_C
defc `__IO_PIO_CONTROL' = __IO_PIO_CONTROL

defc `__IO_PIO_CNTL_00' = __IO_PIO_CNTL_00
defc `__IO_PIO_CNTL_01' = __IO_PIO_CNTL_01
defc `__IO_PIO_CNTL_02' = __IO_PIO_CNTL_02
defc `__IO_PIO_CNTL_03' = __IO_PIO_CNTL_03

defc `__IO_PIO_CNTL_04' = __IO_PIO_CNTL_04
defc `__IO_PIO_CNTL_05' = __IO_PIO_CNTL_05
defc `__IO_PIO_CNTL_06' = __IO_PIO_CNTL_06
defc `__IO_PIO_CNTL_07' = __IO_PIO_CNTL_07

defc `__IO_PIO_CNTL_08' = __IO_PIO_CNTL_08
defc `__IO_PIO_CNTL_09' = __IO_PIO_CNTL_09
defc `__IO_PIO_CNTL_10' = __IO_PIO_CNTL_10
defc `__IO_PIO_CNTL_11' = __IO_PIO_CNTL_11

defc `__IO_PIO_CNTL_12' = __IO_PIO_CNTL_12
defc `__IO_PIO_CNTL_13' = __IO_PIO_CNTL_13
defc `__IO_PIO_CNTL_14' = __IO_PIO_CNTL_14
defc `__IO_PIO_CNTL_15' = __IO_PIO_CNTL_15
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_PIO_PORT_A'  __IO_PIO_PORT_A
`#define' `__IO_PIO_PORT_B'  __IO_PIO_PORT_B
`#define' `__IO_PIO_PORT_C'  __IO_PIO_PORT_C
`#define' `__IO_PIO_CONTROL'  __IO_PIO_CONTROL

`#define' `__IO_PIO_CNTL_00'  __IO_PIO_CNTL_00
`#define' `__IO_PIO_CNTL_01'  __IO_PIO_CNTL_01
`#define' `__IO_PIO_CNTL_02'  __IO_PIO_CNTL_02
`#define' `__IO_PIO_CNTL_03'  __IO_PIO_CNTL_03

`#define' `__IO_PIO_CNTL_04'  __IO_PIO_CNTL_04
`#define' `__IO_PIO_CNTL_05'  __IO_PIO_CNTL_05
`#define' `__IO_PIO_CNTL_06'  __IO_PIO_CNTL_06
`#define' `__IO_PIO_CNTL_07'  __IO_PIO_CNTL_07

`#define' `__IO_PIO_CNTL_08'  __IO_PIO_CNTL_08
`#define' `__IO_PIO_CNTL_09'  __IO_PIO_CNTL_09
`#define' `__IO_PIO_CNTL_10'  __IO_PIO_CNTL_10
`#define' `__IO_PIO_CNTL_11'  __IO_PIO_CNTL_11

`#define' `__IO_PIO_CNTL_12'  __IO_PIO_CNTL_12
`#define' `__IO_PIO_CNTL_13'  __IO_PIO_CNTL_13
`#define' `__IO_PIO_CNTL_14'  __IO_PIO_CNTL_14
`#define' `__IO_PIO_CNTL_15'  __IO_PIO_CNTL_15
')
