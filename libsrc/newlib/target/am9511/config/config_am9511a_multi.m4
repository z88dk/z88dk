divert(-1)

###############################################################
# AM9511A MULTI PROCESSOR DEVICE CONFIGURATION
# rebuild the library if changes are made
#

define(`__IO_APU0_DATA',    0x`'eval(__IO_APU0_PORT_BASE+0x00,16))  # APU0 Data Port
define(`__IO_APU0_CONTROL', 0x`'eval(__IO_APU0_PORT_BASE+0x01,16))  # APU0 Control Port
define(`__IO_APU0_STATUS',  0x`'eval(__IO_APU0_PORT_BASE+0x01,16))  # APU0 Status Port == Control Port

define(`__IO_APU1_DATA',    0x`'eval(__IO_APU1_PORT_BASE+0x00,16))  # APU1 Data Port
define(`__IO_APU1_CONTROL', 0x`'eval(__IO_APU1_PORT_BASE+0x01,16))  # APU1 Control Port
define(`__IO_APU1_STATUS',  0x`'eval(__IO_APU1_PORT_BASE+0x01,16))  # APU1 Status Port == Control Port

define(`__IO_APU2_DATA',    0x`'eval(__IO_APU2_PORT_BASE+0x00,16))  # APU2 Data Port
define(`__IO_APU2_CONTROL', 0x`'eval(__IO_APU2_PORT_BASE+0x01,16))  # APU2 Control Port
define(`__IO_APU2_STATUS',  0x`'eval(__IO_APU2_PORT_BASE+0x01,16))  # APU2 Status Port == Control Port

define(`__IO_APU3_DATA',    0x`'eval(__IO_APU3_PORT_BASE+0x00,16))  # APU3 Data Port
define(`__IO_APU3_CONTROL', 0x`'eval(__IO_APU3_PORT_BASE+0x01,16))  # APU3 Control Port
define(`__IO_APU3_STATUS',  0x`'eval(__IO_APU3_PORT_BASE+0x01,16))  # APU3 Status Port == Control Port

#
# END OF CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_APU0_DATA'
PUBLIC `__IO_APU0_CONTROL'
PUBLIC `__IO_APU0_STATUS'

PUBLIC `__IO_APU1_DATA'
PUBLIC `__IO_APU1_CONTROL'
PUBLIC `__IO_APU1_STATUS'

PUBLIC `__IO_APU2_DATA'
PUBLIC `__IO_APU2_CONTROL'
PUBLIC `__IO_APU2_STATUS'

PUBLIC `__IO_APU3_DATA'
PUBLIC `__IO_APU3_CONTROL'
PUBLIC `__IO_APU3_STATUS'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_APU0_DATA' = __IO_APU0_DATA
defc `__IO_APU0_CONTROL' = __IO_APU0_CONTROL
defc `__IO_APU0_STATUS' = __IO_APU0_STATUS

defc `__IO_APU1_DATA' = __IO_APU1_DATA
defc `__IO_APU1_CONTROL' = __IO_APU1_CONTROL
defc `__IO_APU1_STATUS' = __IO_APU1_STATUS

defc `__IO_APU2_DATA' = __IO_APU2_DATA
defc `__IO_APU2_CONTROL' = __IO_APU2_CONTROL
defc `__IO_APU2_STATUS' = __IO_APU2_STATUS

defc `__IO_APU3_DATA' = __IO_APU3_DATA
defc `__IO_APU3_CONTROL' = __IO_APU3_CONTROL
defc `__IO_APU3_STATUS' = __IO_APU3_STATUS
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_APU0_DATA'  __IO_APU0_DATA
`#define' `__IO_APU0_CONTROL'  __IO_APU0_CONTROL
`#define' `__IO_APU0_STATUS'  __IO_APU0_STATUS

`#define' `__IO_APU1_DATA'  __IO_APU1_DATA
`#define' `__IO_APU1_CONTROL'  __IO_APU1_CONTROL
`#define' `__IO_APU1_STATUS'  __IO_APU1_STATUS

`#define' `__IO_APU2_DATA'  __IO_APU2_DATA
`#define' `__IO_APU2_CONTROL'  __IO_APU2_CONTROL
`#define' `__IO_APU2_STATUS'  __IO_APU2_STATUS

`#define' `__IO_APU3_DATA'  __IO_APU3_DATA
`#define' `__IO_APU3_CONTROL'  __IO_APU3_CONTROL
`#define' `__IO_APU3_STATUS'  __IO_APU3_STATUS
')
