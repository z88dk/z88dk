divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

# Announce target

define(`__YAZ180', 1)

# ASCI0 driver

define(`__ASCI0_RX_SIZE', 0x100)  # Size of the Rx Buffer
define(`__ASCI0_TX_SIZE', 0x100)  # Size of the Tx Buffer

# ASCI1 driver

define(`__ASCI1_RX_SIZE', 0x100)  # Size of the Rx Buffer
define(`__ASCI1_TX_SIZE', 0x100)  # Size of the Tx Buffer

# APU driver

define(`__APU_CMD_SIZE', 0x100)   # Size of the CMD Buffer, 256 CMDs
define(`__APU_PTR_SIZE', 0x100)   # Size of the DATA POINTER Buffer, 128 POINTERs


# Some definitions used with the YAZ-180 on-board peripherals


# BREAK for Single Step Mode

define(`__IO_BREAK', 0x2000)  # Any value written $2000->$21FF, halts CPU


# 82C55 PIO Port Definitions

define(`__IO_PIO_PORT_BASE', 0x4000)              # Base Address for 82C55

define(`__IO_PIO_PORT_A', eval(__IO_PIO_PORT_BASE + 0x00))    # Address for Port A
define(`__IO_PIO_PORT_B', eval(__IO_PIO_PORT_BASE + 0x01))    # Address for Port B
define(`__IO_PIO_PORT_C', eval(__IO_PIO_PORT_BASE + 0x02))    # Address for Port C
define(`__IO_PIO_CONTROL', eval(__IO_PIO_PORT_BASE + 0x03))   # Address for Control Byte

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


# PCA9665 I2C Port Definitions

define(`__IO_PCA9665_1_PORT_BASE', 0xA000)   # Base Address for PCA9665 1 I/O
define(`__IO_PCA9665_2_PORT_BASE', 0x8000)   # Base Address for PCA9665 2 I/O

# PCA9665 I2C I/O Register MSB addressing

define(`__IO_PCA1_PORT_MSB', eval(__IO_PCA9665_1_PORT_BASE / 256))  # distinguish the device address, with MSB
define(`__IO_PCA2_PORT_MSB', eval(__IO_PCA9665_2_PORT_BASE / 256))  # only 3 MSB bits are H/W decoded %111xxxxx

# PCA9665 I2C I/O Register LSB Addressing

# PCA9665 direct registers
define(`__IO_PCA_PORT_STA',  0x00)      # STATUS            Read Only
define(`__IO_PCA_PORT_INDPTR',  0x00)   # INDIRECT Pointer  Write Only
define(`__IO_PCA_PORT_DAT',  0x01)      # DATA              Read/Write
define(`__IO_PCA_PORT_IND',  0x02)      # INDIRECT          Read/Write
define(`__IO_PCA_PORT_CON',  0x03)      # CONTROL           Read/Write

# PCA9665 indirect registers
define(`__IO_PCA_PORT_ICOUNT',  0x00)   # Byte Count for buffered mode
define(`__IO_PCA_PORT_IADR',  0x01)     # OWN Address
define(`__IO_PCA_PORT_ISCLL',  0x02)    # SCL LOW period
define(`__IO_PCA_PORT_ISCLH',  0x03)    # SCL HIGH period
define(`__IO_PCA_PORT_ITO',  0x04)      # TIMEOUT
define(`__IO_PCA_PORT_IPRESET',  0x05)  # Parallel bus reset
define(`__IO_PCA_PORT_IMODE',  0x06)    # I2C Bus mode

# I2C PCA9665 Control Bits

# Bits in PCA_STA

define(`__IO_PCA_STA_ILLEGAL_START_STOP',  0x00)
define(`__IO_PCA_STA_MASTER_START_TX',  0x08)
define(`__IO_PCA_STA_MASTER_RESTART_TX',  0x10)
define(`__IO_PCA_STA_MASTER_SLA_W_ACK',  0x18)
define(`__IO_PCA_STA_MASTER_SLA_W_NAK',  0x20)
define(`__IO_PCA_STA_MASTER_DATA_W_ACK',  0x28)
define(`__IO_PCA_STA_MASTER_DATA_W_NAK',  0x30)
define(`__IO_PCA_STA_MASTER_ARB_LOST',  0x38)
define(`__IO_PCA_STA_MASTER_SLA_R_ACK',  0x40)
define(`__IO_PCA_STA_MASTER_SLA_R_NAK',  0x48)
define(`__IO_PCA_STA_MASTER_DATA_R_ACK',  0x50)
define(`__IO_PCA_STA_MASTER_DATA_R_NAK',  0x58)
define(`__IO_PCA_STA_SLAVE_AD_W',  0x60)
define(`__IO_PCA_STA_SLAVE_AL_AD_W',  0x68)
define(`__IO_PCA_STA_SDA_STUCK',  0x70)
define(`__IO_PCA_STA_SCL_STUCK',  0x78)
define(`__IO_PCA_STA_SLAVE_DATA_RX_ACK',  0x80)
define(`__IO_PCA_STA_SLAVE_DATA_RX_NAK',  0x88)
define(`__IO_PCA_STA_SLAVE_STOP_OR_RESTART',  0xA0)
define(`__IO_PCA_STA_SLAVE_AD_R',  0xA8)
define(`__IO_PCA_STA_SLAVE_AL_AD_R',  0xB0)
define(`__IO_PCA_STA_SLAVE_DATA_TX_ACK',  0xB8)
define(`__IO_PCA_STA_SLAVE_DATA_TX_NAK',  0xC0)
define(`__IO_PCA_STA_SLAVE_LST_TX_ACK',  0xC8)
define(`__IO_PCA_STA_SLAVE_GC',  0xD0)
define(`__IO_PCA_STA_SLAVE_GC_AL',  0xD8)
define(`__IO_PCA_STA_SLAVE_GC_RX_ACK',  0xE0)
define(`__IO_PCA_STA_SLAVE_GC_RX_NAK',  0xE8)
define(`__IO_PCA_STA_IDLE',  0xF8)              # __IO_PCA_STA_IDLE is unused, so
define(`__IO_PCA_STA_ILLEGAL_ICOUNT',  0xFC)    # __IO_PCA_STA_ILLEGAL_ICOUNT can be $F8 case

# Bits in PCA_CON

define(`__IO_PCA_CON_AA',  0x80)                # Assert Acknowledge
define(`__IO_PCA_CON_ENSIO',  0x40)             # Enable, change only when I2C bus idle.
define(`__IO_PCA_CON_STA',  0x20)               # Start (Restart)
define(`__IO_PCA_CON_STO',  0x10)               # Stop
define(`__IO_PCA_CON_SI',  0x08)                # Serial Interrupt
define(`__IO_PCA_CON_MODE',  0x01)              # Mode, 1 = buffered, 0 = byte

# Bits in PCA_CON Echo, for CPU control

define(`__IO_PCA_CON_ECHO_BUS_STOP',  0x10)     # We are finished the sentence
define(`__IO_PCA_CON_ECHO_SI',  0x08)           # Serial Interrupt Received
define(`__IO_PCA_CON_ECHO_BUS_RESTART',  0x04)  # Bus Restart Requested
define(`__IO_PCA_CON_ECHO_BUS_ILLEGAL',  0x02)  # Unexpected Bus Response

# Bits in PCA_ICOUNT
     
define(`__IO_PCA_ICOUNT_LB',  0x80)             # Last Byte control bit
                                                # LB bit is only used for Receiver Buffered modes

# BITS in PCA_ITO

define(`__IO_PCA_ITO_TE',  0x80)                # Time-Out Enable control bit 

# Bits in PCA_IMODE

define(`__IO_PCA_IMODE_STD',  0x00)             # Standard mode
define(`__IO_PCA_IMODE_FAST',  0x01)            # Fast mode
define(`__IO_PCA_IMODE_FASTP',  0x02)           # Fast Plus mode
define(`__IO_PCA_IMODE_TURBO',  0x03)           # Turbo mode
define(`__IO_PCA_IMODE_CR',  0x07)              # Clock Rate (MASK)


# Am9511A-1 APU Port Definitions

define(`__IO_APU_PORT_BASE',  0xC000)           # Base Address for Am9511A
define(`__IO_APU_PORT_DATA',  eval(__IO_APU_PORT_BASE + 0x00))      # APU Data Port
define(`__IO_APU_PORT_CONTROL', eval(__IO_APU_PORT_BASE + 0x01))    # APU Control Port
define(`__IO_APU_PORT_STATUS',  eval(__IO_APU_PORT_BASE + 0x01))    # APU Status Port == Control Port

define(`__IO_APU_STATUS_BUSY',  0x80)
define(`__IO_APU_STATUS_SIGN',  0x40)
define(`__IO_APU_STATUS_ZERO',  0x20)
define(`__IO_APU_STATUS_DIV0',  0x10)
define(`__IO_APU_STATUS_NEGRT',  0x08)
define(`__IO_APU_STATUS_UNDFL',  0x04)
define(`__IO_APU_STATUS_OVRFL',  0x02)
define(`__IO_APU_STATUS_CARRY',  0x01)

define(`__IO_APU_STATUS_ERROR',  0x1E)

define(`__IO_APU_COMMAND_SVREQ',  0x80)

# added APU operations for driver
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
define(`__IO_APU_OP_PTOS',  0x15)
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
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__YAZ180'

PUBLIC `__ASCI0_RX_SIZE'
PUBLIC `__ASCI0_TX_SIZE'

PUBLIC `__ASCI1_RX_SIZE'
PUBLIC `__ASCI1_TX_SIZE'

PUBLIC `__APU_CMD_SIZE'
PUBLIC `__APU_PTR_SIZE'

PUBLIC `__IO_BREAK'

PUBLIC `__IO_PIO_PORT_BASE'

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

PUBLIC `__IO_PCA9665_1_PORT_BASE'
PUBLIC `__IO_PCA9665_2_PORT_BASE'

PUBLIC `__IO_PCA1_PORT_MSB'
PUBLIC `__IO_PCA2_PORT_MSB'

PUBLIC `__IO_PCA_PORT_STA'
PUBLIC `__IO_PCA_PORT_INDPTR'
PUBLIC `__IO_PCA_PORT_DAT'
PUBLIC `__IO_PCA_PORT_IND'
PUBLIC `__IO_PCA_PORT_CON'

PUBLIC `__IO_PCA_PORT_ICOUNT'
PUBLIC `__IO_PCA_PORT_IADR'
PUBLIC `__IO_PCA_PORT_ISCLL'
PUBLIC `__IO_PCA_PORT_ISCLH'
PUBLIC `__IO_PCA_PORT_ITO'
PUBLIC `__IO_PCA_PORT_IPRESET'
PUBLIC `__IO_PCA_PORT_IMODE'

PUBLIC `__IO_PCA_STA_ILLEGAL_START_STOP'
PUBLIC `__IO_PCA_STA_MASTER_START_TX'
PUBLIC `__IO_PCA_STA_MASTER_RESTART_TX'
PUBLIC `__IO_PCA_STA_MASTER_SLA_W_ACK'
PUBLIC `__IO_PCA_STA_MASTER_SLA_W_NAK'
PUBLIC `__IO_PCA_STA_MASTER_DATA_W_ACK'
PUBLIC `__IO_PCA_STA_MASTER_DATA_W_NAK'
PUBLIC `__IO_PCA_STA_MASTER_ARB_LOST'
PUBLIC `__IO_PCA_STA_MASTER_SLA_R_ACK'
PUBLIC `__IO_PCA_STA_MASTER_SLA_R_NAK'
PUBLIC `__IO_PCA_STA_MASTER_DATA_R_ACK'
PUBLIC `__IO_PCA_STA_MASTER_DATA_R_NAK'
PUBLIC `__IO_PCA_STA_SLAVE_AD_W'
PUBLIC `__IO_PCA_STA_SLAVE_AL_AD_W'
PUBLIC `__IO_PCA_STA_SDA_STUCK'
PUBLIC `__IO_PCA_STA_SCL_STUCK'
PUBLIC `__IO_PCA_STA_SLAVE_DATA_RX_ACK'
PUBLIC `__IO_PCA_STA_SLAVE_DATA_RX_NAK'
PUBLIC `__IO_PCA_STA_SLAVE_STOP_OR_RESTART'
PUBLIC `__IO_PCA_STA_SLAVE_AD_R'
PUBLIC `__IO_PCA_STA_SLAVE_AL_AD_R'
PUBLIC `__IO_PCA_STA_SLAVE_DATA_TX_ACK'
PUBLIC `__IO_PCA_STA_SLAVE_DATA_TX_NAK'
PUBLIC `__IO_PCA_STA_SLAVE_LST_TX_ACK'
PUBLIC `__IO_PCA_STA_SLAVE_GC'
PUBLIC `__IO_PCA_STA_SLAVE_GC_AL'
PUBLIC `__IO_PCA_STA_SLAVE_GC_RX_ACK'
PUBLIC `__IO_PCA_STA_SLAVE_GC_RX_NAK'
PUBLIC `__IO_PCA_STA_IDLE'
PUBLIC `__IO_PCA_STA_ILLEGAL_ICOUNT'

PUBLIC `__IO_PCA_CON_AA'
PUBLIC `__IO_PCA_CON_ENSIO'
PUBLIC `__IO_PCA_CON_STA'
PUBLIC `__IO_PCA_CON_STO'
PUBLIC `__IO_PCA_CON_SI'
PUBLIC `__IO_PCA_CON_MODE'

PUBLIC `__IO_PCA_CON_ECHO_BUS_STOP'
PUBLIC `__IO_PCA_CON_ECHO_SI'
PUBLIC `__IO_PCA_CON_ECHO_BUS_RESTART'
PUBLIC `__IO_PCA_CON_ECHO_BUS_ILLEGAL'

PUBLIC `__IO_PCA_ICOUNT_LB'

PUBLIC `__IO_PCA_ITO_TE'

PUBLIC `__IO_PCA_IMODE_STD'
PUBLIC `__IO_PCA_IMODE_FAST'
PUBLIC `__IO_PCA_IMODE_FASTP'
PUBLIC `__IO_PCA_IMODE_TURBO'
PUBLIC `__IO_PCA_IMODE_CR'

PUBLIC `__IO_APU_PORT_BASE'
PUBLIC `__IO_APU_PORT_DATA'
PUBLIC `__IO_APU_PORT_CONTROL'
PUBLIC `__IO_APU_PORT_STATUS'

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
defc `__YAZ180' = __YAZ180

defc `__ASCI0_RX_SIZE' = __ASCI0_RX_SIZE
defc `__ASCI0_TX_SIZE' = __ASCI0_TX_SIZE

defc `__ASCI1_RX_SIZE' = __ASCI1_RX_SIZE
defc `__ASCI1_TX_SIZE' = __ASCI1_TX_SIZE

defc `__APU_CMD_SIZE' = __APU_CMD_SIZE
defc `__APU_PTR_SIZE' = __APU_PTR_SIZE

defc `__IO_BREAK' = __IO_BREAK

defc `__IO_PIO_PORT_BASE' = __IO_PIO_PORT_BASE

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

defc `__IO_PCA9665_1_PORT_BASE' = __IO_PCA9665_1_PORT_BASE
defc `__IO_PCA9665_2_PORT_BASE' = __IO_PCA9665_2_PORT_BASE

defc `__IO_PCA1_PORT_MSB' = __IO_PCA1_PORT_MSB
defc `__IO_PCA2_PORT_MSB' = __IO_PCA2_PORT_MSB

defc `__IO_PCA_PORT_STA' = __IO_PCA_PORT_STA
defc `__IO_PCA_PORT_INDPTR' = __IO_PCA_PORT_INDPTR
defc `__IO_PCA_PORT_DAT' = __IO_PCA_PORT_DAT
defc `__IO_PCA_PORT_IND' = __IO_PCA_PORT_IND
defc `__IO_PCA_PORT_CON' = __IO_PCA_PORT_CON

defc `__IO_PCA_PORT_ICOUNT' = __IO_PCA_PORT_ICOUNT
defc `__IO_PCA_PORT_IADR' = __IO_PCA_PORT_IADR
defc `__IO_PCA_PORT_ISCLL' = __IO_PCA_PORT_ISCLL
defc `__IO_PCA_PORT_ISCLH' = __IO_PCA_PORT_ISCLH
defc `__IO_PCA_PORT_ITO' = __IO_PCA_PORT_ITO
defc `__IO_PCA_PORT_IPRESET' = __IO_PCA_PORT_IPRESET
defc `__IO_PCA_PORT_IMODE' = __IO_PCA_PORT_IMODE

defc `__IO_PCA_STA_ILLEGAL_START_STOP' = __IO_PCA_STA_ILLEGAL_START_STOP
defc `__IO_PCA_STA_MASTER_START_TX' = __IO_PCA_STA_MASTER_START_TX
defc `__IO_PCA_STA_MASTER_RESTART_TX' = __IO_PCA_STA_MASTER_RESTART_TX
defc `__IO_PCA_STA_MASTER_SLA_W_ACK' = __IO_PCA_STA_MASTER_SLA_W_ACK
defc `__IO_PCA_STA_MASTER_SLA_W_NAK' = __IO_PCA_STA_MASTER_SLA_W_NAK
defc `__IO_PCA_STA_MASTER_DATA_W_ACK' = __IO_PCA_STA_MASTER_DATA_W_ACK
defc `__IO_PCA_STA_MASTER_DATA_W_NAK' = __IO_PCA_STA_MASTER_DATA_W_NAK
defc `__IO_PCA_STA_MASTER_ARB_LOST' = __IO_PCA_STA_MASTER_ARB_LOST
defc `__IO_PCA_STA_MASTER_SLA_R_ACK' = __IO_PCA_STA_MASTER_SLA_R_ACK
defc `__IO_PCA_STA_MASTER_SLA_R_NAK' = __IO_PCA_STA_MASTER_SLA_R_NAK
defc `__IO_PCA_STA_MASTER_DATA_R_ACK' = __IO_PCA_STA_MASTER_DATA_R_ACK
defc `__IO_PCA_STA_MASTER_DATA_R_NAK' = __IO_PCA_STA_MASTER_DATA_R_NAK
defc `__IO_PCA_STA_SLAVE_AD_W' = __IO_PCA_STA_SLAVE_AD_W
defc `__IO_PCA_STA_SLAVE_AL_AD_W' = __IO_PCA_STA_SLAVE_AL_AD_W
defc `__IO_PCA_STA_SDA_STUCK' = __IO_PCA_STA_SDA_STUCK
defc `__IO_PCA_STA_SCL_STUCK' = __IO_PCA_STA_SCL_STUCK
defc `__IO_PCA_STA_SLAVE_DATA_RX_ACK' = __IO_PCA_STA_SLAVE_DATA_RX_ACK
defc `__IO_PCA_STA_SLAVE_DATA_RX_NAK' = __IO_PCA_STA_SLAVE_DATA_RX_NAK
defc `__IO_PCA_STA_SLAVE_STOP_OR_RESTART' = __IO_PCA_STA_SLAVE_STOP_OR_RESTART
defc `__IO_PCA_STA_SLAVE_AD_R' = __IO_PCA_STA_SLAVE_AD_R
defc `__IO_PCA_STA_SLAVE_AL_AD_R' = __IO_PCA_STA_SLAVE_AL_AD_R
defc `__IO_PCA_STA_SLAVE_DATA_TX_ACK' = __IO_PCA_STA_SLAVE_DATA_TX_ACK
defc `__IO_PCA_STA_SLAVE_DATA_TX_NAK' = __IO_PCA_STA_SLAVE_DATA_TX_NAK
defc `__IO_PCA_STA_SLAVE_LST_TX_ACK' = __IO_PCA_STA_SLAVE_LST_TX_ACK
defc `__IO_PCA_STA_SLAVE_GC' = __IO_PCA_STA_SLAVE_GC
defc `__IO_PCA_STA_SLAVE_GC_AL' = __IO_PCA_STA_SLAVE_GC_AL
defc `__IO_PCA_STA_SLAVE_GC_RX_ACK' = __IO_PCA_STA_SLAVE_GC_RX_ACK
defc `__IO_PCA_STA_SLAVE_GC_RX_NAK' = __IO_PCA_STA_SLAVE_GC_RX_NAK
defc `__IO_PCA_STA_IDLE' = __IO_PCA_STA_IDLE
defc `__IO_PCA_STA_ILLEGAL_ICOUNT' = __IO_PCA_STA_ILLEGAL_ICOUNT

defc `__IO_PCA_CON_AA' = __IO_PCA_CON_AA
defc `__IO_PCA_CON_ENSIO' = __IO_PCA_CON_ENSIO
defc `__IO_PCA_CON_STA' = __IO_PCA_CON_STA
defc `__IO_PCA_CON_STO' = __IO_PCA_CON_STO
defc `__IO_PCA_CON_SI' = __IO_PCA_CON_SI
defc `__IO_PCA_CON_MODE' = __IO_PCA_CON_MODE

defc `__IO_PCA_CON_ECHO_BUS_STOP' = __IO_PCA_CON_ECHO_BUS_STOP
defc `__IO_PCA_CON_ECHO_SI' = __IO_PCA_CON_ECHO_SI
defc `__IO_PCA_CON_ECHO_BUS_RESTART' = __IO_PCA_CON_ECHO_BUS_RESTART
defc `__IO_PCA_CON_ECHO_BUS_ILLEGAL' = __IO_PCA_CON_ECHO_BUS_ILLEGAL

defc `__IO_PCA_ICOUNT_LB' = __IO_PCA_ICOUNT_LB

defc `__IO_PCA_ITO_TE' = __IO_PCA_ITO_TE

defc `__IO_PCA_IMODE_STD' = __IO_PCA_IMODE_STD
defc `__IO_PCA_IMODE_FAST' = __IO_PCA_IMODE_FAST
defc `__IO_PCA_IMODE_FASTP' = __IO_PCA_IMODE_FASTP
defc `__IO_PCA_IMODE_TURBO' = __IO_PCA_IMODE_TURBO
defc `__IO_PCA_IMODE_CR' = __IO_PCA_IMODE_CR

defc `__IO_APU_PORT_BASE' = __IO_APU_PORT_BASE
defc `__IO_APU_PORT_DATA' = __IO_APU_PORT_DATA
defc `__IO_APU_PORT_CONTROL' = __IO_APU_PORT_CONTROL
defc `__IO_APU_PORT_STATUS' = __IO_APU_PORT_STATUS

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

`#undef'  `__YAZ180'
`#define' `__YAZ180'  __YAZ180

`#define' `__ASCI0_RX_SIZE'  __ASCI0_RX_SIZE
`#define' `__ASCI0_TX_SIZE'  __ASCI0_TX_SIZE

`#define' `__ASCI1_RX_SIZE'  __ASCI1_RX_SIZE
`#define' `__ASCI1_TX_SIZE'  __ASCI1_TX_SIZE

`#define' `__APU_CMD_SIZE'  __APU_CMD_SIZE
`#define' `__APU_PTR_SIZE'  __APU_PTR_SIZE

`#define' `__IO_BREAK'  __IO_BREAK

`#define' `__IO_PIO_PORT_BASE'  __IO_PIO_PORT_BASE

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


`#define' `__IO_PCA9665_1_PORT_BASE'  __IO_PCA9665_1_PORT_BASE
`#define' `__IO_PCA9665_2_PORT_BASE'  __IO_PCA9665_2_PORT_BASE

`#define' `__IO_PCA1_PORT_MSB'  __IO_PCA1_PORT_MSB
`#define' `__IO_PCA2_PORT_MSB'  __IO_PCA2_PORT_MSB

`#define' `__IO_PCA_PORT_STA'  __IO_PCA_PORT_STA
`#define' `__IO_PCA_PORT_INDPTR'  __IO_PCA_PORT_INDPTR
`#define' `__IO_PCA_PORT_DAT'  __IO_PCA_PORT_DAT
`#define' `__IO_PCA_PORT_IND'  __IO_PCA_PORT_IND
`#define' `__IO_PCA_PORT_CON'  __IO_PCA_PORT_CON

`#define' `__IO_PCA_PORT_ICOUNT'  __IO_PCA_PORT_ICOUNT
`#define' `__IO_PCA_PORT_IADR'  __IO_PCA_PORT_IADR
`#define' `__IO_PCA_PORT_ISCLL'  __IO_PCA_PORT_ISCLL
`#define' `__IO_PCA_PORT_ISCLH'  __IO_PCA_PORT_ISCLH
`#define' `__IO_PCA_PORT_ITO'  __IO_PCA_PORT_ITO
`#define' `__IO_PCA_PORT_IPRESET'  __IO_PCA_PORT_IPRESET
`#define' `__IO_PCA_PORT_IMODE'  __IO_PCA_PORT_IMODE

`#define' `__IO_PCA_STA_ILLEGAL_START_STOP'  __IO_PCA_STA_ILLEGAL_START_STOP
`#define' `__IO_PCA_STA_MASTER_START_TX'  __IO_PCA_STA_MASTER_START_TX
`#define' `__IO_PCA_STA_MASTER_RESTART_TX'  __IO_PCA_STA_MASTER_RESTART_TX
`#define' `__IO_PCA_STA_MASTER_SLA_W_ACK'  __IO_PCA_STA_MASTER_SLA_W_ACK
`#define' `__IO_PCA_STA_MASTER_SLA_W_NAK'  __IO_PCA_STA_MASTER_SLA_W_NAK
`#define' `__IO_PCA_STA_MASTER_DATA_W_ACK'  __IO_PCA_STA_MASTER_DATA_W_ACK
`#define' `__IO_PCA_STA_MASTER_DATA_W_NAK'  __IO_PCA_STA_MASTER_DATA_W_NAK
`#define' `__IO_PCA_STA_MASTER_ARB_LOST'  __IO_PCA_STA_MASTER_ARB_LOST
`#define' `__IO_PCA_STA_MASTER_SLA_R_ACK'  __IO_PCA_STA_MASTER_SLA_R_ACK
`#define' `__IO_PCA_STA_MASTER_SLA_R_NAK'  __IO_PCA_STA_MASTER_SLA_R_NAK
`#define' `__IO_PCA_STA_MASTER_DATA_R_ACK'  __IO_PCA_STA_MASTER_DATA_R_ACK
`#define' `__IO_PCA_STA_MASTER_DATA_R_NAK'  __IO_PCA_STA_MASTER_DATA_R_NAK
`#define' `__IO_PCA_STA_SLAVE_AD_W'  __IO_PCA_STA_SLAVE_AD_W
`#define' `__IO_PCA_STA_SLAVE_AL_AD_W'  __IO_PCA_STA_SLAVE_AL_AD_W
`#define' `__IO_PCA_STA_SDA_STUCK'  __IO_PCA_STA_SDA_STUCK
`#define' `__IO_PCA_STA_SCL_STUCK'  __IO_PCA_STA_SCL_STUCK
`#define' `__IO_PCA_STA_SLAVE_DATA_RX_ACK'  __IO_PCA_STA_SLAVE_DATA_RX_ACK
`#define' `__IO_PCA_STA_SLAVE_DATA_RX_NAK'  __IO_PCA_STA_SLAVE_DATA_RX_NAK
`#define' `__IO_PCA_STA_SLAVE_STOP_OR_RESTART'  __IO_PCA_STA_SLAVE_STOP_OR_RESTART
`#define' `__IO_PCA_STA_SLAVE_AD_R'  __IO_PCA_STA_SLAVE_AD_R
`#define' `__IO_PCA_STA_SLAVE_AL_AD_R'  __IO_PCA_STA_SLAVE_AL_AD_R
`#define' `__IO_PCA_STA_SLAVE_DATA_TX_ACK'  __IO_PCA_STA_SLAVE_DATA_TX_ACK
`#define' `__IO_PCA_STA_SLAVE_DATA_TX_NAK'  __IO_PCA_STA_SLAVE_DATA_TX_NAK
`#define' `__IO_PCA_STA_SLAVE_LST_TX_ACK'  __IO_PCA_STA_SLAVE_LST_TX_ACK
`#define' `__IO_PCA_STA_SLAVE_GC'  __IO_PCA_STA_SLAVE_GC
`#define' `__IO_PCA_STA_SLAVE_GC_AL'  __IO_PCA_STA_SLAVE_GC_AL
`#define' `__IO_PCA_STA_SLAVE_GC_RX_ACK'  __IO_PCA_STA_SLAVE_GC_RX_ACK
`#define' `__IO_PCA_STA_SLAVE_GC_RX_NAK'  __IO_PCA_STA_SLAVE_GC_RX_NAK
`#define' `__IO_PCA_STA_IDLE'  __IO_PCA_STA_IDLE
`#define' `__IO_PCA_STA_ILLEGAL_ICOUNT'  __IO_PCA_STA_ILLEGAL_ICOUNT

`#define' `__IO_PCA_CON_AA'  __IO_PCA_CON_AA
`#define' `__IO_PCA_CON_ENSIO'  __IO_PCA_CON_ENSIO
`#define' `__IO_PCA_CON_STA'  __IO_PCA_CON_STA
`#define' `__IO_PCA_CON_STO'  __IO_PCA_CON_STO
`#define' `__IO_PCA_CON_SI'  __IO_PCA_CON_SI
`#define' `__IO_PCA_CON_MODE'  __IO_PCA_CON_MODE

`#define' `__IO_PCA_CON_ECHO_BUS_STOP'  __IO_PCA_CON_ECHO_BUS_STOP
`#define' `__IO_PCA_CON_ECHO_SI'  __IO_PCA_CON_ECHO_SI
`#define' `__IO_PCA_CON_ECHO_BUS_RESTART'  __IO_PCA_CON_ECHO_BUS_RESTART
`#define' `__IO_PCA_CON_ECHO_BUS_ILLEGAL'  __IO_PCA_CON_ECHO_BUS_ILLEGAL

`#define' `__IO_PCA_ICOUNT_LB'  __IO_PCA_ICOUNT_LB

`#define' `__IO_PCA_ITO_TE'  __IO_PCA_ITO_TE

`#define' `__IO_PCA_IMODE_STD'  __IO_PCA_IMODE_STD
`#define' `__IO_PCA_IMODE_FAST'  __IO_PCA_IMODE_FAST
`#define' `__IO_PCA_IMODE_FASTP'  __IO_PCA_IMODE_FASTP
`#define' `__IO_PCA_IMODE_TURBO'  __IO_PCA_IMODE_TURBO
`#define' `__IO_PCA_IMODE_CR'  __IO_PCA_IMODE_CR

`#define' `__IO_APU_PORT_BASE'  __IO_APU_PORT_BASE
`#define' `__IO_APU_PORT_DATA'  __IO_APU_PORT_DATA
`#define' `__IO_APU_PORT_CONTROL'  __IO_APU_PORT_CONTROL
`#define' `__IO_APU_PORT_STATUS'  __IO_APU_PORT_STATUS

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
