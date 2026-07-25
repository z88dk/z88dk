divert(-1)

###############################################################
# 82C55 IDE USER CONFIGURATION
# rebuild the library if changes are made
#

# 8255 PIO chip.  Change these to specify where the PIO is addressed,
# and which of the 8255's ports are connected to which IDE signals.
# The first three control which 8255 ports have the control signals,
# upper and lower data bytes.  The last two are mode setting for the
# 8255 to configure its ports, which must correspond to the way that
# the first three lines define which ports are connected.
define(`__IO_PIO_IDE_LSB',    __IO_PIO_PORT_A)    # IDE lower 8 bits
define(`__IO_PIO_IDE_MSB',    __IO_PIO_PORT_B)    # IDE upper 8 bits
define(`__IO_PIO_IDE_CTL',    __IO_PIO_PORT_C)    # IDE control lines
define(`__IO_PIO_IDE_CONFIG', __IO_PIO_CONTROL)   # PIO configuration
define(`__IO_PIO_IDE_RD',     __IO_PIO_CNTL_10)   # _IO_PIO_IDE_CTL out, _IO_PIO_IDE_LSB/MSB input
define(`__IO_PIO_IDE_WR',     __IO_PIO_CNTL_00)   # all PIO ports output

# IDE control lines for use with __IO_PIO_IDE. Change these 8
# constants to reflect where each signal of the 8255 each of the
# IDE control signals is connected.  All the control signals must
# be on the same port, but these 8 lines let you connect them to
# whichever pins on that port.
define(`__IO_PIO_IDE_A0_LINE',  0x01)  # direct from 8255 to ide interface
define(`__IO_PIO_IDE_A1_LINE',  0x02)  # direct from 8255 to ide interface
define(`__IO_PIO_IDE_A2_LINE',  0x04)  # direct from 8255 to ide interface
define(`__IO_PIO_IDE_CS0_LINE', 0x08)  # inverter between 8255 and ide interface
define(`__IO_PIO_IDE_CS1_LINE', 0x10)  # inverter between 8255 and ide interface
define(`__IO_PIO_IDE_WR_LINE',  0x20)  # inverter between 8255 and ide interface
define(`__IO_PIO_IDE_RD_LINE',  0x40)  # inverter between 8255 and ide interface
define(`__IO_PIO_IDE_RST_LINE', 0x80)  # inverter between 8255 and ide interface

# IDE I/O Register Addressing
#
# IDE control lines for use with __IO_PIO_IDE. Symbolic constants
# for the IDE registers, which makes the code more readable than
# always specifying the address pins.
define(`__IO_PIO_IDE_DATA',         __IO_PIO_IDE_CS0_LINE)
define(`__IO_PIO_IDE_ERROR',        0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A0_LINE,16))
define(`__IO_PIO_IDE_FEATURE',      0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A0_LINE,16))
define(`__IO_PIO_IDE_SEC_CNT',      0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A1_LINE,16))   #Typically 1 Sector only
define(`__IO_PIO_IDE_SECTOR',       0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A1_LINE+__IO_PIO_IDE_A0_LINE,16))  #LBA0
define(`__IO_PIO_IDE_CYL_LSB',      0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE,16))                   #LBA1
define(`__IO_PIO_IDE_CYL_MSB',      0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A0_LINE,16))  #LBA2
define(`__IO_PIO_IDE_HEAD',         0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A1_LINE,16))  #LBA3
define(`__IO_PIO_IDE_COMMAND',      0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A1_LINE+__IO_PIO_IDE_A0_LINE,16))
define(`__IO_PIO_IDE_STATUS',       0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A1_LINE+__IO_PIO_IDE_A0_LINE,16))

define(`__IO_PIO_IDE_CONTROL',      0x`'eval(__IO_PIO_IDE_CS1_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A1_LINE,16))
define(`__IO_PIO_IDE_ALT_STATUS',   0x`'eval(__IO_PIO_IDE_CS1_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A1_LINE,16))

define(`__IO_PIO_IDE_LBA0',         0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A1_LINE+__IO_PIO_IDE_A0_LINE,16)) #SECTOR
define(`__IO_PIO_IDE_LBA1',         0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE,16))                  #CYL_LSB
define(`__IO_PIO_IDE_LBA2',         0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A0_LINE,16)) #CYL_MSB
define(`__IO_PIO_IDE_LBA3',         0x`'eval(__IO_PIO_IDE_CS0_LINE+__IO_PIO_IDE_A2_LINE+__IO_PIO_IDE_A1_LINE,16)) #HEAD

#==============================================================================
#
# DEFINES SECTION

# IDE reg: A0-A2: /CS0: /CS1: Use
#
#       0x0    000    0    1     IDE Data Port
#       0x1    001    0    1     Read: Error code (also see $$)
#       0x1    001    0    1     Write: Compact Flash Feature code (also see %%)
#       0x2    010    0    1     Number Of Sectors To Transfer
#       0x3    011    0    1     Sector address LBA 0 (0:7)
#       0x4    100    0    1     Sector address LBA 1 (8:15)
#       0x5    101    0    1     Sector address LBA 2 (16:23)
#       0x6    110    0    1     Head Register, Sector address LBA 3 (24:27) (also see **)
#       0x7    111    0    1     Read: "Status", Write: Issue command (also see ##)
#       0x8    000    1    0     Not Important
#       0x9    001    1    0     Not Important
#       0xA    010    1    0     Not Important
#       0xB    011    1    0     Not Important
#       0xC    100    1    0     Not Important
#       0xD    101    1    0     Not Important
#       0xE    110    1    0     2nd Status, Interrupt, and Reset
#       0xF    111    1    0     Active Status Register 

#       $$ Bits in Error Register $1

#       Bit 7   = BBK   Bad Block Detected
#       Bit 6   = UNC   Uncorrectable Error
#       Bit 5   = MC    No media
#       Bit 4   = IDNF  Selector Id
#       Bit 3   = MCR   Media Change requested
#       Bit 2   = ABRT  Indecent Command - Doh!
#       Bit 1   = TK0NF Track 0 unavailable -> Trash
#       Bit 0   = AMNF  Address mark not found

#       %% Bits in Compact Flash Feature Register $1

#       01h             Enable 8 bit data transfers.
#       02h             Enable Write Cache.
#       03h             Set transfer mode based on value in Sector Count register.
#       05h             Enable Advanced Power Management.
#       09h             Enable Extended Power operations.
#       0Ah             Enable Power Level 1 commands.
#       44h             Product specific ECC bytes apply on Read/Write Long commands.
#       55h             Disable Read Look Ahead.
#       66h             Disable Power on Reset (POR) establishment of defaults at Soft Reset.
#       69h             NOP - Accepted for backward compatibility.
#       81h             Disable 8 bit data transfer.
#       82h             Disable Write Cache.
#       85h             Disable Advanced Power Management.
#       89h             Disable Extended Power operations.
#       8Ah             Disable Power Level 1 commands.
#       96h             NOP - Accepted for backward compatibility.
#       97h             Accepted for backward compatibility.
#       9Ah             Set the host current source capability.
#       AAh             Enable Read Look Ahead.
#       BBh             4 bytes of data apply on Read/Write Long commands.
#       CCh             Enable Power on Reset (POR) establishment of defaults at Soft Reset.

#       ** Bits in LBA 3 Register $6

#       Bit 7   = Always set to 1
#       Bit 6   = Always Set to 1 for LBA Mode Access
#       Bit 5   = Always set to 1
#       Bit 4   = Select Master (0) or Slave (1) drive
#       Bit 0:3 = LBA bits (24:27)

#       ## Bits in Status Register $7

#       Bit 7   = BSY   1=busy, 0=not busy
#       Bit 6   = RDY   1=ready for command, 0=not ready yet
#       Bit 5   = WFT   1=write fault occured
#       Bit 4   = DSC   1=seek complete
#       Bit 3   = DRQ   1=data request ready, 0=not ready to xfer yet
#       Bit 2   = ECC   1=correctable error occured
#       Bit 1   = IDX   vendor specific
#       Bit 0   = ERR   1=error occured


# IDE Command Constants.  These should never change.
#
define(`__IDE_CMD_READ',        0x20)   # read with retry
define(`__IDE_CMD_WRITE',       0x30)   # write with retry

define(`__IDE_CMD_STANDBY',     0xE0)   # immediate spindown of disk
define(`__IDE_CMD_IDLE',        0xE1)   # immediate idle of disk
define(`__IDE_CMD_SLEEP',       0xE6)   # powerdown, reset to recover
define(`__IDE_CMD_CACHE_FLUSH', 0xE7)   # flush hardware write cache
define(`__IDE_CMD_ID',          0xEC)   # identify drive
define(`__IDE_CMD_FEATURE',     0xEF)   # set feature (compact flash)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_PIO_IDE_LSB'
PUBLIC `__IO_PIO_IDE_MSB'
PUBLIC `__IO_PIO_IDE_CTL'
PUBLIC `__IO_PIO_IDE_CONFIG'
PUBLIC `__IO_PIO_IDE_RD'
PUBLIC `__IO_PIO_IDE_WR'

PUBLIC `__IO_PIO_IDE_A0_LINE'
PUBLIC `__IO_PIO_IDE_A1_LINE'
PUBLIC `__IO_PIO_IDE_A2_LINE'
PUBLIC `__IO_PIO_IDE_CS0_LINE'
PUBLIC `__IO_PIO_IDE_CS1_LINE'
PUBLIC `__IO_PIO_IDE_WR_LINE'
PUBLIC `__IO_PIO_IDE_RD_LINE'
PUBLIC `__IO_PIO_IDE_RST_LINE'

PUBLIC `__IO_PIO_IDE_DATA'
PUBLIC `__IO_PIO_IDE_ERROR'
PUBLIC `__IO_PIO_IDE_FEATURE'
PUBLIC `__IO_PIO_IDE_SEC_CNT'
PUBLIC `__IO_PIO_IDE_SECTOR'
PUBLIC `__IO_PIO_IDE_CYL_LSB'
PUBLIC `__IO_PIO_IDE_CYL_MSB'
PUBLIC `__IO_PIO_IDE_HEAD'
PUBLIC `__IO_PIO_IDE_COMMAND'
PUBLIC `__IO_PIO_IDE_STATUS'

PUBLIC `__IO_PIO_IDE_CONTROL'
PUBLIC `__IO_PIO_IDE_ALT_STATUS'

PUBLIC `__IO_PIO_IDE_LBA0'
PUBLIC `__IO_PIO_IDE_LBA1'
PUBLIC `__IO_PIO_IDE_LBA2'
PUBLIC `__IO_PIO_IDE_LBA3'

PUBLIC `__IDE_CMD_READ'
PUBLIC `__IDE_CMD_WRITE'

PUBLIC `__IDE_CMD_STANDBY'
PUBLIC `__IDE_CMD_IDLE'
PUBLIC `__IDE_CMD_SLEEP'
PUBLIC `__IDE_CMD_CACHE_FLUSH'
PUBLIC `__IDE_CMD_ID'
PUBLIC `__IDE_CMD_FEATURE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_PIO_IDE_LSB' = __IO_PIO_IDE_LSB
defc `__IO_PIO_IDE_MSB' = __IO_PIO_IDE_MSB
defc `__IO_PIO_IDE_CTL' = __IO_PIO_IDE_CTL
defc `__IO_PIO_IDE_CONFIG' = __IO_PIO_IDE_CONFIG
defc `__IO_PIO_IDE_RD' = __IO_PIO_IDE_RD
defc `__IO_PIO_IDE_WR' = __IO_PIO_IDE_WR

defc `__IO_PIO_IDE_A0_LINE' = __IO_PIO_IDE_A0_LINE
defc `__IO_PIO_IDE_A1_LINE' = __IO_PIO_IDE_A1_LINE
defc `__IO_PIO_IDE_A2_LINE' = __IO_PIO_IDE_A2_LINE
defc `__IO_PIO_IDE_CS0_LINE' = __IO_PIO_IDE_CS0_LINE
defc `__IO_PIO_IDE_CS1_LINE' = __IO_PIO_IDE_CS1_LINE
defc `__IO_PIO_IDE_WR_LINE' = __IO_PIO_IDE_WR_LINE
defc `__IO_PIO_IDE_RD_LINE' = __IO_PIO_IDE_RD_LINE
defc `__IO_PIO_IDE_RST_LINE' = __IO_PIO_IDE_RST_LINE

defc `__IO_PIO_IDE_DATA' = __IO_PIO_IDE_DATA
defc `__IO_PIO_IDE_ERROR' = __IO_PIO_IDE_ERROR
defc `__IO_PIO_IDE_FEATURE' = __IO_PIO_IDE_FEATURE
defc `__IO_PIO_IDE_SEC_CNT' = __IO_PIO_IDE_SEC_CNT
defc `__IO_PIO_IDE_SECTOR' = __IO_PIO_IDE_SECTOR
defc `__IO_PIO_IDE_CYL_LSB' = __IO_PIO_IDE_CYL_LSB
defc `__IO_PIO_IDE_CYL_MSB' = __IO_PIO_IDE_CYL_MSB
defc `__IO_PIO_IDE_HEAD' = __IO_PIO_IDE_HEAD
defc `__IO_PIO_IDE_COMMAND' = __IO_PIO_IDE_COMMAND
defc `__IO_PIO_IDE_STATUS' = __IO_PIO_IDE_STATUS

defc `__IO_PIO_IDE_CONTROL' = __IO_PIO_IDE_CONTROL
defc `__IO_PIO_IDE_ALT_STATUS' = __IO_PIO_IDE_ALT_STATUS

defc `__IO_PIO_IDE_LBA0' = __IO_PIO_IDE_LBA0
defc `__IO_PIO_IDE_LBA1' = __IO_PIO_IDE_LBA1
defc `__IO_PIO_IDE_LBA2' = __IO_PIO_IDE_LBA2
defc `__IO_PIO_IDE_LBA3' = __IO_PIO_IDE_LBA3

defc `__IDE_CMD_READ' = __IDE_CMD_READ
defc `__IDE_CMD_WRITE' = __IDE_CMD_WRITE

defc `__IDE_CMD_STANDBY' = __IDE_CMD_STANDBY
defc `__IDE_CMD_IDLE' = __IDE_CMD_IDLE
defc `__IDE_CMD_SLEEP' = __IDE_CMD_SLEEP
defc `__IDE_CMD_CACHE_FLUSH' = __IDE_CMD_CACHE_FLUSH
defc `__IDE_CMD_ID' = __IDE_CMD_ID
defc `__IDE_CMD_FEATURE' = __IDE_CMD_FEATURE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_PIO_IDE_LSB'  __IO_PIO_IDE_LSB
`#define' `__IO_PIO_IDE_MSB'  __IO_PIO_IDE_MSB
`#define' `__IO_PIO_IDE_CTL'  __IO_PIO_IDE_CTL
`#define' `__IO_PIO_IDE_CONFIG'  __IO_PIO_IDE_CONFIG
`#define' `__IO_PIO_IDE_RD'  __IO_PIO_IDE_RD
`#define' `__IO_PIO_IDE_WR'  __IO_PIO_IDE_WR

`#define' `__IO_PIO_IDE_A0_LINE'  __IO_PIO_IDE_A0_LINE
`#define' `__IO_PIO_IDE_A1_LINE'  __IO_PIO_IDE_A1_LINE
`#define' `__IO_PIO_IDE_A2_LINE'  __IO_PIO_IDE_A2_LINE
`#define' `__IO_PIO_IDE_CS0_LINE'  __IO_PIO_IDE_CS0_LINE
`#define' `__IO_PIO_IDE_CS1_LINE'  __IO_PIO_IDE_CS1_LINE
`#define' `__IO_PIO_IDE_WR_LINE'  __IO_PIO_IDE_WR_LINE
`#define' `__IO_PIO_IDE_RD_LINE'  __IO_PIO_IDE_RD_LINE
`#define' `__IO_PIO_IDE_RST_LINE'  __IO_PIO_IDE_RST_LINE

`#define' `__IO_PIO_IDE_DATA'  __IO_PIO_IDE_DATA
`#define' `__IO_PIO_IDE_ERROR'  __IO_PIO_IDE_ERROR
`#define' `__IO_PIO_IDE_FEATURE'  __IO_PIO_IDE_FEATURE
`#define' `__IO_PIO_IDE_SEC_CNT'  __IO_PIO_IDE_SEC_CNT
`#define' `__IO_PIO_IDE_SECTOR'  __IO_PIO_IDE_SECTOR
`#define' `__IO_PIO_IDE_CYL_LSB'  __IO_PIO_IDE_CYL_LSB
`#define' `__IO_PIO_IDE_CYL_MSB'  __IO_PIO_IDE_CYL_MSB
`#define' `__IO_PIO_IDE_HEAD'  __IO_PIO_IDE_HEAD
`#define' `__IO_PIO_IDE_COMMAND'  __IO_PIO_IDE_COMMAND
`#define' `__IO_PIO_IDE_STATUS'  __IO_PIO_IDE_STATUS

`#define' `__IO_PIO_IDE_CONTROL'  __IO_PIO_IDE_CONTROL
`#define' `__IO_PIO_IDE_ALT_STATUS'  __IO_PIO_IDE_ALT_STATUS

`#define' `__IO_PIO_IDE_LBA0'  __IO_PIO_IDE_LBA0
`#define' `__IO_PIO_IDE_LBA1'  __IO_PIO_IDE_LBA1
`#define' `__IO_PIO_IDE_LBA2'  __IO_PIO_IDE_LBA2
`#define' `__IO_PIO_IDE_LBA3'  __IO_PIO_IDE_LBA3

`#define' `__IDE_CMD_READ'  __IDE_CMD_READ
`#define' `__IDE_CMD_WRITE'  __IDE_CMD_WRITE

`#define' `__IDE_CMD_STANDBY'  __IDE_CMD_STANDBY
`#define' `__IDE_CMD_IDLE'  __IDE_CMD_IDLE
`#define' `__IDE_CMD_SLEEP'  __IDE_CMD_SLEEP
`#define' `__IDE_CMD_CACHE_FLUSH'  __IDE_CMD_CACHE_FLUSH
`#define' `__IDE_CMD_ID'  __IDE_CMD_ID
`#define' `__IDE_CMD_FEATURE'  __IDE_CMD_FEATURE
')

