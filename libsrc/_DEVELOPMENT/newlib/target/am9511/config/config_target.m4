divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Am9511A APU Definitions

IF __CLASSIC
EXTERN __IO_AM9511_BASE_PORT
defc __IO_APU_PORT_BASE = __IO_AM9511_BASE_PORT
ELSE
define(`__IO_APU_PORT_BASE', 0x42)  # Port Address for Am9511A Module
ENDIF

# Am9511A APU Multi Processor Definitions

define(`__IO_APU0_PORT_BASE', 0x42) # Base Address for Am9511A Module #0
define(`__IO_APU1_PORT_BASE', 0x62) # Base Address for Am9511A Module #1
define(`__IO_APU2_PORT_BASE', 0xC2) # Base Address for Am9511A Module #2
define(`__IO_APU3_PORT_BASE', 0xE2) # Base Address for Am9511A Module #3

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_APU_PORT_BASE'

PUBLIC `__IO_APU0_PORT_BASE'
PUBLIC `__IO_APU1_PORT_BASE'
PUBLIC `__IO_APU2_PORT_BASE'
PUBLIC `__IO_APU3_PORT_BASE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`

IF __AM9511_HELPER_FUNC
    EXTERN __am9511_out_data
    EXTERN __am9511_in_status
    EXTERN __am9511_in_data
    EXTERN __am9511_out_control
ENDIF

MACRO AM9511_IN_APU_DATA
 IF __AM9511_HELPER_FUNC
   call __am9511_in_data
 ELSE
    in a,(__IO_APU_DATA)
 ENDIF
ENDM

MACRO AM9511_IN_APU_STATUS
 IF __AM9511_HELPER_FUNC
    call __am9511_in_status
 ELSE
    in a,(__IO_APU_STATUS)
 ENDIF
ENDM

MACRO AM9511_OUT_APU_CONTROL
 IF __AM9511_HELPER_FUNC
    call __am9511_out_control
 ELSE
    out (__IO_APU_STATUS),a
 ENDIF
ENDM

MACRO AM9511_OUT_APU_DATA
 IF __AM9511_HELPER_FUNC
    call __am9511_out_data
 ELSE
    out (__IO_APU_DATA),a
 ENDIF
ENDM

defc `__IO_APU_PORT_BASE' = __IO_APU_PORT_BASE

defc `__IO_APU0_PORT_BASE' = __IO_APU0_PORT_BASE
defc `__IO_APU1_PORT_BASE' = __IO_APU1_PORT_BASE
defc `__IO_APU2_PORT_BASE' = __IO_APU2_PORT_BASE
defc `__IO_APU3_PORT_BASE' = __IO_APU3_PORT_BASE
')

