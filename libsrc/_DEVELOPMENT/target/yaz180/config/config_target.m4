divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__YAZ180', 1)

# Clock frequency in Hz

define(`__CPU_CLOCK', 36864000)

# Frequency of PRT0 if configured as per normal

define(`__CLOCKS_PER_SECOND', 256)

# Cache for SP when other banks are running

define(`__BIOS_SP', 0xFFDE)                         # location of bios SP when other banks running
define(`__BANK_SP', 0x003B)                         # location of each bank SP when not running

# All I/O drivers are passed through system buffers
# This will help when user banking is used, as all I/O is via system RAM

define(`__COMMON_AREA_1_BASE', 0xF000)              # Base address of COMMON AREA 1
define(`__COMMON_AREA_1_PHASE_DATA_SIZE', 0x05A0)   # Size allowance for COMMON AREA 1 PHASE DATA

define(`__COMMON_AREA_1_PHASE_DATA', 0x`'eval(__COMMON_AREA_1_BASE,16))    # Origin of COMMON AREA 1 Data
define(`__COMMON_AREA_1_PHASE_DRIVER', 0x`'eval(__COMMON_AREA_1_BASE+__COMMON_AREA_1_PHASE_DATA_SIZE,16))  # Origin of COMMON AREA 1 Drivers, after CA1 Data

# Z180 ASCI0 driver

define(`__ASCI0_RX_SIZE', 0x100)                    # Size of the Rx Buffer, must be 2^n >= 8
define(`__ASCI0_RX_FULLISH', 0x`'eval(__ASCI0_RX_SIZE-16,16))
                                                    # Fullness of the Rx Buffer, when NOT_RTS is signalled
define(`__ASCI0_RX_EMPTYISH', 0x08)                 # Fullness of the Rx Buffer, when RTS is signalled
define(`__ASCI0_TX_SIZE', 0x080)                    # Size of the Tx Buffer, must be 2^n >= 8

# Z180 ASCI1 driver

define(`__ASCI1_RX_SIZE', 0x100)                    # Size of the Rx Buffer, must be 2^n >= 8
define(`__ASCI1_TX_SIZE', 0x080)                    # Size of the Tx Buffer, must be 2^n >= 8

# I/O BASE ADDRESS OF INTERNAL PERIPHERALS

define(`__IO_BASE_ADDRESS', 0x00)

define(`__IO_BASE_ADDRESS', 0x`'eval(__IO_BASE_ADDRESS&0xc0,16))

# I/O BREAK for Single Step Mode

define(`__IO_BREAK', 0x2000)                        # Any value written $2000->$3FFF, halts CPU

# 82C55 PIO Definitions

define(`__IO_PIO_PORT_BASE', 0x4000)                # Base Address for 82C55

# PCA9665 I2C Definitions

define(`__IO_PCA9665_1_PORT_BASE', 0xA000)          # Base Address for PCA9665 1 I/O
define(`__IO_PCA9665_2_PORT_BASE', 0x8000)          # Base Address for PCA9665 2 I/O

# Am9511A-1 APU Definitions

define(`__APU_CMD_SIZE', 0x100)                     # Size of the CMD Buffer, 255 Commands
define(`__APU_PTR_SIZE', 0x100)                     # Size of the Data PTR Buffer, 85 Operands

define(`__IO_APU_PORT_BASE', 0xC000)                # Base Address for Am9511A

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

PUBLIC `__CPU_CLOCK'

PUBLIC `__CLOCKS_PER_SECOND'

PUBLIC `__BIOS_SP'
PUBLIC `__BANK_SP'

PUBLIC `__COMMON_AREA_1_BASE'
PUBLIC `__COMMON_AREA_1_PHASE_DATA'
PUBLIC `__COMMON_AREA_1_PHASE_DRIVER'

PUBLIC `__ASCI0_RX_SIZE'
PUBLIC `__ASCI0_RX_FULLISH'
PUBLIC `__ASCI0_RX_EMPTYISH'
PUBLIC `__ASCI0_TX_SIZE'

PUBLIC `__ASCI1_RX_SIZE'
PUBLIC `__ASCI1_TX_SIZE'

PUBLIC `__IO_BASE_ADDRESS'

PUBLIC `__IO_BREAK'

PUBLIC `__IO_PIO_PORT_BASE'

PUBLIC `__IO_PCA9665_1_PORT_BASE'
PUBLIC `__IO_PCA9665_2_PORT_BASE'

PUBLIC `__APU_CMD_SIZE'
PUBLIC `__APU_PTR_SIZE'

PUBLIC `__IO_APU_PORT_BASE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__YAZ180' = __YAZ180

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__CLOCKS_PER_SECOND' = __CLOCKS_PER_SECOND

defc `__BIOS_SP' = __BIOS_SP
defc `__BANK_SP' = __BANK_SP

defc `__COMMON_AREA_1_BASE' = __COMMON_AREA_1_BASE
defc `__COMMON_AREA_1_PHASE_DATA' = __COMMON_AREA_1_PHASE_DATA
defc `__COMMON_AREA_1_PHASE_DRIVER' = __COMMON_AREA_1_PHASE_DRIVER

defc `__ASCI0_RX_SIZE' = __ASCI0_RX_SIZE
defc `__ASCI0_RX_FULLISH' = __ASCI0_RX_FULLISH
defc `__ASCI0_RX_EMPTYISH' = __ASCI0_RX_EMPTYISH
defc `__ASCI0_TX_SIZE' = __ASCI0_TX_SIZE

defc `__ASCI1_RX_SIZE' = __ASCI1_RX_SIZE
defc `__ASCI1_TX_SIZE' = __ASCI1_TX_SIZE

defc `__IO_BASE_ADDRESS' = __IO_BASE_ADDRESS

defc `__IO_BREAK' = __IO_BREAK

defc `__IO_PIO_PORT_BASE' = __IO_PIO_PORT_BASE

defc `__IO_PCA9665_1_PORT_BASE' = __IO_PCA9665_1_PORT_BASE
defc `__IO_PCA9665_2_PORT_BASE' = __IO_PCA9665_2_PORT_BASE

defc `__APU_CMD_SIZE' = __APU_CMD_SIZE
defc `__APU_PTR_SIZE' = __APU_PTR_SIZE

defc `__IO_APU_PORT_BASE' = __IO_APU_PORT_BASE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__YAZ180'
`#define' `__YAZ180'  __YAZ180

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__CLOCKS_PER_SECOND'  __CLOCKS_PER_SECOND

`#define' `__BIOS_SP'   __BIOS_SP
`#define' `__BANK_SP'   __BANK_SP

`#define' `__COMMON_AREA_1_BASE'  __COMMON_AREA_1_BASE
`#define' `__COMMON_AREA_1_PHASE_DATA'  __COMMON_AREA_1_PHASE_DATA
`#define' `__COMMON_AREA_1_PHASE_DRIVER'  __COMMON_AREA_1_PHASE_DRIVER

`#define' `__ASCI0_RX_SIZE'  __ASCI0_RX_SIZE
`#define' `__ASCI0_RX_FULLISH'  __ASCI0_RX_FULLISH
`#define' `__ASCI0_RX_EMPTYISH'  __ASCI0_RX_EMPTYISH
`#define' `__ASCI0_TX_SIZE'  __ASCI0_TX_SIZE

`#define' `__ASCI1_RX_SIZE'  __ASCI1_RX_SIZE
`#define' `__ASCI1_TX_SIZE'  __ASCI1_TX_SIZE

`#define' `__IO_BASE_ADDRESS' __IO_BASE_ADDRESS

`#define' `__IO_BREAK'  __IO_BREAK

`#define' `__IO_PIO_PORT_BASE'  __IO_PIO_PORT_BASE

`#define' `__IO_PCA9665_1_PORT_BASE'  __IO_PCA9665_1_PORT_BASE
`#define' `__IO_PCA9665_2_PORT_BASE'  __IO_PCA9665_2_PORT_BASE

`#define' `__APU_CMD_SIZE'  __APU_CMD_SIZE
`#define' `__APU_PTR_SIZE'  __APU_PTR_SIZE

`#define' `__IO_APU_PORT_BASE'  __IO_APU_PORT_BASE
')
