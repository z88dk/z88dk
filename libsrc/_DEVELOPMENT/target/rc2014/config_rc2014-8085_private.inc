



IFNDEF __CONFIG_Z88DK_INC_
defc   __CONFIG_Z88DK_INC_ = 1

; Automatically Generated at Library Build Time













defc __Z88DK = 2300












defc __RC2014 = 1

defc __CPU_CLOCK = 7372800

defc __IO_DIO_PORT = 0x00
defc __IO_CF_8_BIT = 0x01
defc __IO_CF_PORT_BASE = 0x10
defc __IO_PIO_PORT_BASE = 0x20
defc __IO_ACIA_PORT_BASE = 0x80
defc __IO_SIO_PORT_BASE = 0x80
defc __IO_SIO_PORT_OFFSET_A = 0x00
defc __IO_SIO_PORT_OFFSET_B = 0x02
defc __IO_SIO_PORT_OFFSET_C = 0x00
defc __IO_SIO_PORT_OFFSET_D = 0x01












defc __8085 = 0x01


defc __CPU_INFO = 0x00













defc __IO_ACIA_CONTROL_REGISTER   = 0x80
defc __IO_ACIA_STATUS_REGISTER = 0x80
defc __IO_ACIA_DATA_REGISTER   = 0x81

defc __IO_ACIA_CR_CLK_DIV_01  = 0x00
defc __IO_ACIA_CR_CLK_DIV_16  = 0x01
defc __IO_ACIA_CR_CLK_DIV_64  = 0x02
defc __IO_ACIA_CR_RESET       = 0x03

defc __IO_ACIA_CR_7E2         = 0x00
defc __IO_ACIA_CR_7O2         = 0x04
defc __IO_ACIA_CR_7E1         = 0x08
defc __IO_ACIA_CR_7O1         = 0x0C
defc __IO_ACIA_CR_8N2         = 0x10
defc __IO_ACIA_CR_8N1         = 0x14
defc __IO_ACIA_CR_8E1         = 0x18
defc __IO_ACIA_CR_8O1         = 0x1C

defc __IO_ACIA_CR_TDI_RTS0    = 0x00
defc __IO_ACIA_CR_TEI_RTS0    = 0x20
defc __IO_ACIA_CR_TDI_RTS1    = 0x40
defc __IO_ACIA_CR_TDI_BRK     = 0x60
   
defc __IO_ACIA_CR_TEI_MASK    = 0x60

defc __IO_ACIA_CR_REI         = 0x80

defc __IO_ACIA_SR_RDRF        = 0x01
defc __IO_ACIA_SR_TDRE        = 0x02
defc __IO_ACIA_SR_DCD         = 0x04
defc __IO_ACIA_SR_CTS         = 0x08
defc __IO_ACIA_SR_FE          = 0x10
defc __IO_ACIA_SR_OVRN        = 0x20
defc __IO_ACIA_SR_PE          = 0x40
defc __IO_ACIA_SR_IRQ         = 0x80

defc __IO_ACIA_RX_SIZE     = 0x100
defc __IO_ACIA_RX_FULLISH  = 0xf0
defc __IO_ACIA_RX_EMPTYISH = 0x08
defc __IO_ACIA_TX_SIZE     = 0x10












defc __IO_SIOA_CONTROL_REGISTER   = 0x80
defc __IO_SIOA_DATA_REGISTER      = 0x81
defc __IO_SIOB_CONTROL_REGISTER   = 0x82
defc __IO_SIOB_DATA_REGISTER      = 0x83

defc __IO_SIO_WR0_NULL      = 0x00

defc __IO_SIO_WR0_R0      = 0x00
defc __IO_SIO_WR0_R1      = 0x01
defc __IO_SIO_WR0_R2      = 0x02
defc __IO_SIO_WR0_R3      = 0x03
defc __IO_SIO_WR0_R4      = 0x04
defc __IO_SIO_WR0_R5      = 0x05
defc __IO_SIO_WR0_R6      = 0x06
defc __IO_SIO_WR0_R7      = 0x07

defc __IO_SIO_WR0_SDLC_ABORT      = 0x08
defc __IO_SIO_WR0_EXT_INT_RESET      = 0x10
defc __IO_SIO_WR0_CHANNEL_RESET      = 0x18
defc __IO_SIO_WR0_RX_INT_FIRST_REENABLE      = 0x20
defc __IO_SIO_WR0_TX_INT_PENDING_RESET      = 0x28
defc __IO_SIO_WR0_ERROR_RESET      = 0x30
defc __IO_SIO_WR0_A_INT_RETURN      = 0x38

defc __IO_SIO_WR0_RX_CRC_RESET      = 0x40
defc __IO_SIO_WR0_TX_CRC_RESET      = 0x80
defc __IO_SIO_WR0_TX_EOM_RESET      = 0xC0

defc __IO_SIO_WR1_EXT_INT_ENABLE      = 0x01
defc __IO_SIO_WR1_TX_INT_ENABLE      = 0x02
defc __IO_SIO_WR1_B_STATUS_VECTOR      = 0x04

defc __IO_SIO_WR1_RX_INT_NONE      = 0x00
defc __IO_SIO_WR1_RX_INT_FIRST      = 0x08
defc __IO_SIO_WR1_RX_INT_ALL_EXCL_SPECIAL      = 0x10
defc __IO_SIO_WR1_RX_INT_ALL      = 0x18

defc __IO_SIO_WR1_WAIT_READY_RX      = 0x20
defc __IO_SIO_WR1_WAIT_READY_READY      = 0x40
defc __IO_SIO_WR1_WAIT_READY_ENABLE      = 0x80

defc __IO_SIO_WR3_RX_ENABLE      = 0x01
defc __IO_SIO_WR3_RX_SYNC_LOAD_INHIBIT      = 0x02
defc __IO_SIO_WR3_SDLC_ADDRESS_SEARCH      = 0x04
defc __IO_SIO_WR3_SDLC_RX_CRC      = 0x08
defc __IO_SIO_WR3_HUNT_PHASE_ENABLE      = 0x10
defc __IO_SIO_WR3_AUTO_ENABLES      = 0x20

defc __IO_SIO_WR3_RX_5BIT      = 0x00
defc __IO_SIO_WR3_RX_7BIT      = 0x40
defc __IO_SIO_WR3_RX_6BIT      = 0x80
defc __IO_SIO_WR3_RX_8BIT      = 0xC0

defc __IO_SIO_WR4_PARITY_NONE      = 0x00
defc __IO_SIO_WR4_PARITY_ENABLE      = 0x01
defc __IO_SIO_WR4_PARITY_EVEN      = 0x02

defc __IO_SIO_WR4_SYNC_MODE      = 0x00
defc __IO_SIO_WR4_STOP_1      = 0x04
defc __IO_SIO_WR4_STOP_3HALF      = 0x08
defc __IO_SIO_WR4_STOP_2      = 0x0C

defc __IO_SIO_WR4_SYNC_8BIT      = 0x00
defc __IO_SIO_WR4_SYNC_16BIT      = 0x10
defc __IO_SIO_WR4_SYNC_SDLC      = 0x20
defc __IO_SIO_WR4_SYNC_EXTERN      = 0x30

defc __IO_SIO_WR4_CLK_DIV_01      = 0x00
defc __IO_SIO_WR4_CLK_DIV_16      = 0x40
defc __IO_SIO_WR4_CLK_DIV_32      = 0x80
defc __IO_SIO_WR4_CLK_DIV_64      = 0xC0

defc __IO_SIO_WR5_TX_CRC_ENABLE      = 0x01
defc __IO_SIO_WR5_RTS      = 0x02
defc __IO_SIO_WR5_SDLC_CRC_16      = 0x04
defc __IO_SIO_WR5_TX_ENABLE      = 0x08
defc __IO_SIO_WR5_TX_BREAK      = 0x10

defc __IO_SIO_WR5_TX_5BIT      = 0x00
defc __IO_SIO_WR5_TX_7BIT      = 0x20
defc __IO_SIO_WR5_TX_6BIT      = 0x40
defc __IO_SIO_WR5_TX_8BIT      = 0x60

defc __IO_SIO_WR5_TX_DTR      = 0x80

defc __IO_SIO_RR0_RX_CHAR      = 0x01
defc __IO_SIO_RR0_A_INT_PENDING      = 0x02
defc __IO_SIO_RR0_TX_EMPTY      = 0x04
defc __IO_SIO_RR0_DCD      = 0x08
defc __IO_SIO_RR0_SYNC      = 0x10
defc __IO_SIO_RR0_CTS      = 0x20
defc __IO_SIO_RR0_TX_EOM      = 0x40
defc __IO_SIO_RR0_RX_BREAK      = 0x80

defc __IO_SIO_RR1_TX_ALL_SENT      = 0x01

defc __IO_SIO_RR1_SDLC_RESIDUE_CODE_0      = 0x02
defc __IO_SIO_RR1_SDLC_RESIDUE_CODE_1      = 0x04
defc __IO_SIO_RR1_SDLC_RESIDUE_CODE_2      = 0x08

defc __IO_SIO_RR1_RX_PARITY_ERROR      = 0x10
defc __IO_SIO_RR1_RX_OVERRUN      = 0x20
defc __IO_SIO_RR1_RX_FRAMING_ERROR      = 0x40
defc __IO_SIO_RR1_SDLC_EOF      = 0x80

defc __IO_SIO_RX_SIZE      = 0x80
defc __IO_SIO_RX_FULLISH      = 0x70
defc __IO_SIO_RX_EMPTYISH      = 0x08
defc __IO_SIO_TX_SIZE      = 0x10












defc __IO_PIO_PORT_A = 0x20
defc __IO_PIO_PORT_B = 0x21
defc __IO_PIO_PORT_C = 0x22
defc __IO_PIO_CONTROL = 0x23

defc __IO_PIO_CNTL_00 = 0x80
defc __IO_PIO_CNTL_01 = 0x81
defc __IO_PIO_CNTL_02 = 0x82
defc __IO_PIO_CNTL_03 = 0x83

defc __IO_PIO_CNTL_04 = 0x88
defc __IO_PIO_CNTL_05 = 0x89
defc __IO_PIO_CNTL_06 = 0x8A
defc __IO_PIO_CNTL_07 = 0x8B

defc __IO_PIO_CNTL_08 = 0x90
defc __IO_PIO_CNTL_09 = 0x91
defc __IO_PIO_CNTL_10 = 0x92
defc __IO_PIO_CNTL_11 = 0x83

defc __IO_PIO_CNTL_12 = 0x98
defc __IO_PIO_CNTL_13 = 0x99
defc __IO_PIO_CNTL_14 = 0x9A
defc __IO_PIO_CNTL_15 = 0x9B












defc __IO_CF_IDE_DATA = 0x10
defc __IO_CF_IDE_ERROR = 0x11
defc __IO_CF_IDE_FEATURE = 0x11
defc __IO_CF_IDE_SEC_CNT = 0x12
defc __IO_CF_IDE_SECTOR = 0x13
defc __IO_CF_IDE_CYL_LSB = 0x14
defc __IO_CF_IDE_CYL_MSB = 0x15
defc __IO_CF_IDE_HEAD = 0x16
defc __IO_CF_IDE_COMMAND = 0x17
defc __IO_CF_IDE_STATUS = 0x17

defc __IO_CF_IDE_CONTROL = 0x1e
defc __IO_CF_IDE_ALT_STATUS = 0x1e

defc __IO_CF_IDE_LBA0 = 0x13
defc __IO_CF_IDE_LBA1 = 0x14
defc __IO_CF_IDE_LBA2 = 0x15
defc __IO_CF_IDE_LBA3 = 0x16













defc __IO_PIO_IDE_LSB = 0x20
defc __IO_PIO_IDE_MSB = 0x21
defc __IO_PIO_IDE_CTL = 0x22
defc __IO_PIO_IDE_CONFIG = 0x23
defc __IO_PIO_IDE_RD = 0x92
defc __IO_PIO_IDE_WR = 0x80

defc __IO_PIO_IDE_A0_LINE = 0x01
defc __IO_PIO_IDE_A1_LINE = 0x02
defc __IO_PIO_IDE_A2_LINE = 0x04
defc __IO_PIO_IDE_CS0_LINE = 0x08
defc __IO_PIO_IDE_CS1_LINE = 0x10
defc __IO_PIO_IDE_WR_LINE = 0x20
defc __IO_PIO_IDE_RD_LINE = 0x40
defc __IO_PIO_IDE_RST_LINE = 0x80

defc __IO_PIO_IDE_DATA = 0x08
defc __IO_PIO_IDE_ERROR = 0x9
defc __IO_PIO_IDE_FEATURE = 0x9
defc __IO_PIO_IDE_SEC_CNT = 0xa
defc __IO_PIO_IDE_SECTOR = 0xb
defc __IO_PIO_IDE_CYL_LSB = 0xc
defc __IO_PIO_IDE_CYL_MSB = 0xd
defc __IO_PIO_IDE_HEAD = 0xe
defc __IO_PIO_IDE_COMMAND = 0xf
defc __IO_PIO_IDE_STATUS = 0xf

defc __IO_PIO_IDE_CONTROL = 0x16
defc __IO_PIO_IDE_ALT_STATUS = 0x16

defc __IO_PIO_IDE_LBA0 = 0xb
defc __IO_PIO_IDE_LBA1 = 0xc
defc __IO_PIO_IDE_LBA2 = 0xd
defc __IO_PIO_IDE_LBA3 = 0xe

defc __IDE_CMD_READ = 0x20
defc __IDE_CMD_WRITE = 0x30

defc __IDE_CMD_STANDBY = 0xE0
defc __IDE_CMD_IDLE = 0xE1
defc __IDE_CMD_SLEEP = 0xE6
defc __IDE_CMD_CACHE_FLUSH = 0xE7
defc __IDE_CMD_ID = 0xEC
defc __IDE_CMD_FEATURE = 0xEF













defc __IO_RAM_TOGGLE = 0x30
defc __IO_ROM_TOGGLE = 0x38
defc __IO_RAM_SHADOW_BASE  = 0x58

defc __IO_RAM_SHADOW_AVAILABLE  = 0x00













defc __BF_CIO = 0x00
defc __BF_CIOIN = 0x0
defc __BF_CIOOUT = 0x1
defc __BF_CIOIST = 0x2
defc __BF_CIOOST = 0x3
defc __BF_CIOINIT = 0x4
defc __BF_CIOQUERY = 0x5
defc __BF_CIODEVICE = 0x6

defc __BF_DIO = 0x10
defc __BF_DIOSTATUS = 0x10
defc __BF_DIORESET = 0x11
defc __BF_DIOSEEK = 0x12
defc __BF_DIOREAD = 0x13
defc __BF_DIOWRITE = 0x14
defc __BF_DIOVERIFY = 0x15
defc __BF_DIOFORMAT = 0x16
defc __BF_DIODEVICE = 0x17
defc __BF_DIOMEDIA = 0x18
defc __BF_DIODEFMED = 0x19
defc __BF_DIOCAP = 0x1a
defc __BF_DIOGEOM = 0x1b

defc __BF_RTC = 0x20
defc __BF_RTCGETTIM = 0x20
defc __BF_RTCSETTIM = 0x21
defc __BF_RTCGETBYT = 0x22
defc __BF_RTCSETBYT = 0x23
defc __BF_RTCGETBLK = 0x24
defc __BF_RTCSETBLK = 0x25

defc __BF_EMU = 0x30

defc __BF_VDA = 0x40
defc __BF_VDAINI = 0x40
defc __BF_VDAQRY = 0x41
defc __BF_VDARES = 0x42
defc __BF_VDADEV = 0x43
defc __BF_VDASCS = 0x44
defc __BF_VDASCP = 0x45
defc __BF_VDASAT = 0x46
defc __BF_VDASCO = 0x47
defc __BF_VDAWRC = 0x48
defc __BF_VDAFIL = 0x49
defc __BF_VDACPY = 0x4a
defc __BF_VDASCR = 0x4b
defc __BF_VDAKST = 0x4c
defc __BF_VDAKFL = 0x4d
defc __BF_VDAKRD = 0x4e

defc __BF_SYS = 0xF0
defc __BF_SYSRESET = 0xf0
defc __BF_SYSVER = 0xf1
defc __BF_SYSSETBNK = 0xf2
defc __BF_SYSGETBNK = 0xf3
defc __BF_SYSSETCPY = 0xf4
defc __BF_SYSBNKCPY = 0xf5
defc __BF_SYSALLOC = 0xf6
defc __BF_SYSFREE = 0xf7
defc __BF_SYSGET = 0xf8
defc __BF_SYSSET = 0xf9
defc __BF_SYSPEEK = 0xfa
defc __BF_SYSPOKE = 0xfb
defc __BF_SYSINT = 0xfc

defc __BF_SYSGET_CIOCNT = 0x00
defc __BF_SYSGET_DIOCNT = 0x10
defc __BF_SYSGET_VDACNT = 0x40
defc __BF_SYSGET_TIMER = 0xD0
defc __BF_SYSGET_SECS = 0xD1
defc __BF_SYSGET_BOOTINFO = 0xE0
defc __BF_SYSGET_CPUINFO = 0xF0
defc __BF_SYSGET_MEMINFO = 0xF1
defc __BF_SYSGET_BNKINFO = 0xF2

defc __BF_SYSSET_TIMER = 0xD0
defc __BF_SYSSET_SECS = 0xD1
defc __BF_SYSSET_BOOTINFO = 0xE0

defc __BF_SYSINT_INFO = 0x00
defc __BF_SYSINT_GET = 0x10
defc __BF_SYSINT_SET = 0x20

defc __CIODEV_UART = 0x00
defc __CIODEV_ASCI = 0x10
defc __CIODEV_TERM = 0x20
defc __CIODEV_PRPCON = 0x30
defc __CIODEV_PPPCON = 0x40
defc __CIODEV_SIO = 0x50
defc __CIODEV_ACIA = 0x60
defc __CIODEV_PIO = 0x70
defc __CIODEV_UF = 0x80
defc __CIODEV_CONSOLE = 0xD0

defc __DIODEV_MD = 0x00
defc __DIODEV_FD = 0x10
defc __DIODEV_RF = 0x20
defc __DIODEV_IDE = 0x30
defc __DIODEV_ATAPI = 0x40
defc __DIODEV_PPIDE = 0x50
defc __DIODEV_SD = 0x60
defc __DIODEV_PRPSD = 0x70
defc __DIODEV_PPPSD = 0x80
defc __DIODEV_HDSK = 0x90

defc __VDADEV_VDU = 0x00
defc __VDADEV_CVDU = 0x10
defc __VDADEV_NEC = 0x20
defc __VDADEV_TMS = 0x30
defc __VDADEV_VGA = 0x40

defc __EMUTYP_NONE = 0x00
defc __EMUTYP_TTY = 0x01
defc __EMUTYP_ANSI = 0x02

defc __HBX_XFCDAT = 0xffe0
defc __HB_CURBNK = 0xffe0
defc __HB_INVBNK = 0xffe1
defc __HB_SRCADR = 0xffe2
defc __HB_SRCBNK = 0xffe4
defc __HB_DSTADR = 0xffe5
defc __HB_DSTBNK = 0xffe7
defc __HB_CPYLEN = 0xffe8

defc __HBX_XFCFNS = 0xfff0
defc __HB_INVOKE = 0xfff0
defc __HB_BNKSEL = 0xfff3
defc __HB_BNKCPY = 0xfff6
defc __HB_BNKCALL = 0xfff9
defc __HB_IDENT = 0xfffe












defc __CPM_RCON = 1
defc __CPM_WCON = 2
defc __CPM_RRDR = 3
defc __CPM_WPUN = 4
defc __CPM_WLST = 5
defc __CPM_DCIO = 6
defc __CPM_GIOB = 7
defc __CPM_SIOB = 8
defc __CPM_PRST = 9
defc __CPM_RCOB = 10
defc __CPM_ICON = 11
defc __CPM_VERS = 12
defc __CPM_RDS  = 13
defc __CPM_LGIN = 14
defc __CPM_OPN  = 15
defc __CPM_CLS  = 16
defc __CPM_FFST = 17
defc __CPM_FNXT = 18
defc __CPM_DEL  = 19
defc __CPM_READ = 20
defc __CPM_WRIT = 21
defc __CPM_MAKE = 22
defc __CPM_REN  = 23
defc __CPM_ILOG = 24
defc __CPM_IDRV = 25
defc __CPM_SDMA = 26
defc __CPM_SUID = 32
defc __CPM_RRAN = 33
defc __CPM_WRAN = 34
defc __CPM_CFS  = 35
defc __CPM_DSEG = 51










ENDIF

