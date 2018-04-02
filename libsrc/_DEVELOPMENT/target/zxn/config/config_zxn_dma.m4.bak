divert(-1)

###############################################################
# ZXN DMA CONFIGURATION
# rebuild the library if changes are made
#
# The ZXN DMA is a single channel dma device that implements a
# subset of the Z80 DMA functionality.  The subset is large
# enough to be compatible with common uses of the Datagear
# interface available for the Spectrum.

# The ZXN DMA requires one read/write io port that is the
# same as used for the Datagear.

# PORT 0x6b: ZXN DMA

define(`__IO_DMA', 0x6b)
define(`__IO_DMA_DATAGEAR', 0x6b)

# Zilog's Z80 DMA chip can be a somewhat complicated device.
#
# Datasheet here: https://github.com/z88dk/techdocs/blob/master/zilog/z80_peripherals_um81.pdf
# Be aware that there are numerous errors in Zilog's datasheet particularly with register bits in diagrams.
#
# Cheatsheet here: https://dailly.blogspot.ca/2017/07/z8410-dma-chip-for-zx-spectrum-next.html
#
# The Z80 DMA chip is a pipelined device and because of that it has numerous off-by-one idiosyncracies
# and requirements on the order that certain commands should be carried out.  These issues are not
# duplicated in the ZXN DMA.  You can continue to program the ZXN DMA as if it is a Z80 DMA device
# but it can also be programmed in a simpler manner.
#
# The single channel of the DMA chip consists of two ports named A and B.  Transfers can occur
# in either direction between ports A and B, each port can describe a target in memory or io,
# and each can be configured to autoincrement, autodecrement or stay fixed after a byte is transferred.
# A special feature of the ZXN DMA can force each byte transfer to take a fixed amount of time so
# that the ZXN DMA can be used to deliver sampled audio.
#
# The ZXN DMA can operate in either burst or continuous mode.  Continuous mode means the DMA chip
# runs to completion without allowing the CPU to run.  Burst mode nominally means the DMA lets the
# CPU run if either port is not ready.  This condition can't happen in the ZXN DMA chip except when
# operated in the special fixed time transfer mode.  In this mode, the ZXN DMA chip will let the CPU
# run while it waits for the fixed time to expire between bytes transferred.  Note that there is no
# byte transfer mode as in the Z80 DMA.
#
# Like the Z80 DMA chip, the ZXN DMA has seven write registers named WR0-WR6 that control the device.
# They are described here following the same convention used by Zilog for its DMA chip:
#
#  WR0 - Write Register Group 0
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   0   |   |   |   |   |   |   |
#       |   |   |   |   |   0   0  Do not use
#       |   |   |   |   |   0   1  Transfer (Prefer this for Z80 DMA compatibility)
#       |   |   |   |   |   1   0  Do not use (Behaves like Transfer, Search on Z80 DMA)
#       |   |   |   |   |   1   1  Do not use (Behaves like Transfer, Search/Transfer on Z80 DMA)
#       |   |   |   |   |
#       |   |   |   |   0 = Port B -> Port A (Byte transfer direction)
#       |   |   |   |   1 = Port A -> Port B
#       |   |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  PORT A STARTING ADDRESS (LOW BYTE)
#       |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  PORT A STARTING ADDRESS (HIGH BYTE)
#       |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  BLOCK LENGTH (LOW BYTE)
#       V
#  D7  D6  D5  D4  D3  D2  D1  D0  BLOCK LENGTH (HIGH BYTE)
#
# Several registers are accessible from WR0.  The first write to WR0 is to the
# base register byte.  Bits D6:D3 are optionally set to indicate that further
# registers in this group will be written next.  The order the writes come in are
# from D3 to D6 (right to left).  For example, if bits D6 and D3 are set, the
# next two writes will be directed to "PORT A STARTING ADDRESS LOW" followed by
# "BLOCK LENGTH HIGH".
#

define(`__D_WR0', 0x00)

define(`__D_WR0_TRANSFER', 0x01)
define(`__D_WR0_A_TO_B', 0x04)
define(`__D_WR0_B_TO_A', 0x00)

define(`__D_WR0_X3_A_START_L', 0x08)
define(`__D_WR0_X4_A_START_H', 0x10)
define(`__D_WR0_X34_A_START', 0x18)
define(`__D_WR0_X5_LEN_L', 0x20)
define(`__D_WR0_X6_LEN_H', 0x40)
define(`__D_WR0_X56_LEN', 0x60)

define(`__D_WR0_X3', 0x08)
define(`__D_WR0_X4', 0x10)
define(`__D_WR0_X5', 0x20)
define(`__D_WR0_X6', 0x40)
define(`__D_WR0_X34', 0x18)
define(`__D_WR0_X35', 0x28)
define(`__D_WR0_X36', 0x48)
define(`__D_WR0_X45', 0x30)
define(`__D_WR0_X46', 0x50)
define(`__D_WR0_X56', 0x60)
define(`__D_WR0_X345', 0x38)
define(`__D_WR0_X346', 0x58)
define(`__D_WR0_X356', 0x68)
define(`__D_WR0_X456', 0x70)
define(`__D_WR0_X3456', 0x78)

# Shortcuts

define(`__D_WR0_TRANSFER_A_TO_B', eval(__D_WR0 | __D_WR0_TRANSFER | __D_WR0_A_TO_B))
define(`__D_WR0_TRANSFER_B_TO_A', eval(__D_WR0 | __D_WR0_TRANSFER | __D_WR0_B_TO_A))
define(`__D_WR0_XFER_A_TO_B', __D_WR0_TRANSFER_A_TO_B)
define(`__D_WR0_XFER_B_TO_A', __D_WR0_TRANSFER_B_TO_A)

# WR1 - Write Register Group 1
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   0   |   |   |   |   1   0   0
#       |   |   |   |
#       |   |   |   0 = Port A is memory
#       |   |   |   1 = Port A is IO
#       |   |   |
#       |   0   0 = Port A address decrements
#       |   0   1 = Port A address increments
#       |   1   0 = Port A address is fixed
#       |   1   1 = Port A address is fixed
#       |
#       V
#   D7  D6  D5  D4  D3  D2  D1  D0  PORT A VARIABLE TIMING BYTE
#    0   0   0   0   0   0   |   |
#                            0   0 = Cycle Length = 4
#                            0   1 = Cycle Length = 3
#                            1   0 = Cycle Length = 2
#                            1   1 = Do not use
#
# The cycle length is the number of cycles used in a read or write operation.
# The first cycle asserts signals and the last cycle releases them.  There is
# no half cycle timing for the control signals.
#

define(`__D_WR1', 0x04)

define(`__D_WR1_A_IS_MEM', 0x00)
define(`__D_WR1_A_IS_IO', 0x08)
define(`__D_WR1_A_DEC', 0x00)
define(`__D_WR1_A_INC', 0x10)
define(`__D_WR1_A_FIX', 0x20)

define(`__D_WR1_X6', 0x40)
define(`__D_WR1_X6_A_TIMING', 0x40)

#

define(`__D_WR1X6_A_CLEN_2', 0x02)
define(`__D_WR1X6_A_CLEN_3', 0x01)
define(`__D_WR1X6_A_CLEN_4', 0x00)

# Shortcuts

define(`__D_WR1_A_IS_MEM_DEC', eval(__D_WR1 | __D_WR1_A_IS_MEM | __D_WR1_A_DEC))
define(`__D_WR1_A_IS_MEM_INC', eval(__D_WR1 | __D_WR1_A_IS_MEM | __D_WR1_A_INC))
define(`__D_WR1_A_IS_MEM_FIX', eval(__D_WR1 | __D_WR1_A_IS_MEM | __D_WR1_A_FIX))
define(`__D_WR1_A_IS_IO_DEC', eval(__D_WR1 | __D_WR1_A_IS_IO | __D_WR1_A_DEC))
define(`__D_WR1_A_IS_IO_INC', eval(__D_WR1 | __D_WR1_A_IS_IO | __D_WR1_A_INC))
define(`__D_WR1_A_IS_IO_FIX', eval(__D_WR1 | __D_WR1_A_IS_IO | __D_WR1_A_FIX))

# WR2 - Write Register Group 2
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   0   |   |   |   |   0   0   0
#       |   |   |   |
#       |   |   |   0 = Port B is memory
#       |   |   |   1 = Port B is IO
#       |   |   |
#       |   0   0 = Port B address decrements
#       |   0   1 = Port B address increments
#       |   1   0 = Port B address is fixed
#       |   1   1 = Port B address is fixed
#       |
#       V
#  D7  D6  D5  D4  D3  D2  D1  D0  PORT B VARIABLE TIMING BYTE
#   0   0   |   0   0   0   |   |
#           |               0   0 = Cycle Length = 4
#           |               0   1 = Cycle Length = 3
#           |               1   0 = Cycle Length = 2
#           |               1   1 = Do not use
#           |
#           V
#  D7  D6  D5  D4  D3  D2  D1  D0  ZXN PRESCALAR (FIXED TIME TRANSFER)
#
# The ZXN PRESCALAR is a feature of the ZXN DMA implementation.
# If non-zero, a delay will be inserted after each byte is transferred
# such that the total time needed for the transfer is at least the number
# of cycles indicated by the prescalar.  This works in both the continuous
# mode and the burst mode.
#
# The ZXN DMA's speed matches the current CPU speed so it can operate
# at 3.5MHz, 7MHz or 14MHz.  Since the prescalar delay is a cycle count,
# the actual duration depends on the speed of the DMA.  A prescalar
# delay set to N cycles will result in a real time transfer taking N/fCPU
# seconds.  For example, if the DMA is operating at 3.5MHz and the max
# prescalar of 255 is set, the transfer time for each byte will be
# 255/3.5MHz = 72.9us.  If the DMA is used to send sampled audio, the
# sample rate would be 13.7kHz and this is the lowest sample rate possible
# using the prescalar.
#
# If the DMA is operated in burst mode, the DMA will give up any waiting
# time to the CPU so that the CPU can run while the DMA is idle.
#

define(`__D_WR2', 0x00)

define(`__D_WR2_B_IS_MEM', 0x00)
define(`__D_WR2_B_IS_IO', 0x08)
define(`__D_WR2_B_DEC', 0x00)
define(`__D_WR2_B_INC', 0x10)
define(`__D_WR2_B_FIX', 0x20)

define(`__D_WR2_X6', 0x40)
define(`__D_WR2_X6_B_TIMING', 0x40)

#

define(`__D_WR2X6_B_CLEN_2', 0x02)
define(`__D_WR2X6_B_CLEN_3', 0x01)
define(`__D_WR2X6_B_CLEN_4', 0x00)

define(`__D_WR2X6_X5', 0x20)
define(`__D_WR2X6_X5_PRESCALAR', 0x20)

# Shortcuts

define(`__D_WR2_B_IS_MEM_DEC', eval(__D_WR2 | __D_WR2_B_IS_MEM | __D_WR2_B_DEC))
define(`__D_WR2_B_IS_MEM_INC', eval(__D_WR2 | __D_WR2_B_IS_MEM | __D_WR2_B_INC))
define(`__D_WR2_B_IS_MEM_FIX', eval(__D_WR2 | __D_WR2_B_IS_MEM | __D_WR2_B_FIX))
define(`__D_WR2_B_IS_IO_DEC', eval(__D_WR2 | __D_WR2_B_IS_IO | __D_WR2_B_DEC))
define(`__D_WR2_B_IS_IO_INC', eval(__D_WR2 | __D_WR2_B_IS_IO | __D_WR2_B_INC))
define(`__D_WR2_B_IS_IO_FIX', eval(__D_WR2 | __D_WR2_B_IS_IO | __D_WR2_B_FIX))

# WR3 - Write Register Group 3
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   1   |   0   0   0   0   0   0
#       |
#       1 = DMA Enable
#
# The Z80 DMA defines more fields but they are ignored by the ZXN DMA.
# The two other registers defined by the Z80 DMA in this group on D4 and D3
# are implemented by the ZXN DMA but they do nothing.
#
# It's preferred to enable the DMA by writing an "Enable DMA" command to WR6.
#

define(`__D_WR3', 0x80)

define(`__D_WR3_ENABLE_DMA', 0x40)

# WR4 - Write Register Group 4
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   1   |   |   0   |   |   0   1
#       |   |       |   |
#       0   0 = Do not use (Behaves like Continuous mode, Byte mode on Z80 DMA)
#       0   1 = Continuous mode
#       1   0 = Burst mode
#       1   1 = Do not use
#                   |   |
#                   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  PORT B STARTING ADDRESS (LOW BYTE)
#                   |
#                   V
#  D7  D6  D5  D4  D3  D2  D1  D0  PORT B STARTING ADDRESS (HIGH BYTE)
#
# The Z80 DMA defines three more registers in this group through D4 that
# define interrupt behaviour.  Interrups and pulse generation are not
# implemented in the ZXN DMA nor are these registers available for writing.
#

define(`__D_WR4', 0x81)

define(`__D_WR4_CONT', 0x20)
define(`__D_WR4_BURST', 0x40)

define(`__D_WR4_X2', 0x04)
define(`__D_WR4_X3', 0x08)
define(`__D_WR4_X23', 0x0c)

define(`__D_WR4_X2_B_START_L', 0x04)
define(`__D_WR4_X3_B_START_H', 0x08)
define(`__D_WR4_X23_B_START', 0x0c)

# WR5 - Write Register Group 5
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   1   0   |   |   0   0   1   0
#           |   |
#           |   0 = /ce only
#           |   1 = /ce & /wait multiplexed
#           |
#           0 = Stop on end of block
#           1 = Auto restart on end of block
#
# The /ce & /wait mode is implemented in the ZXN DMA but its use is not clear.
# This mode has an external device using the DMA's /ce pin to insert wait states
# during the DMA's transfer.  This behaviour is present but it's unknown what
# hardware on the fpga might be connected to this.
#
# The auto restart feature causes the dma to automatically reload its source and
# destination addresses and reset its byte counter to zero to repeat the last
# transfer when a previous one is finished.
#

define(`__D_WR5', 0x82)

define(`__D_WR5_CE', 0x00)
define(`__D_WR5_CE_WAIT', 0x10)

define(`__D_WR5_RESTART', 0x20)
define(`__D_WR5_STOP', 0x00)

# WR6 - Command Register
#
#  D7  D6  D5  D4  D3  D2  D1  D0  BASE REGISTER BYTE
#   1   ?   ?   ?   ?   ?   1   1
#       |   |   |   |   |
#       1   0   0   1   1 = 0xCF = Load
#       1   0   1   0   0 = 0xD3 = Continue
#       0   0   0   0   1 = 0x87 = Enable DMA
#       0   0   0   0   0 = 0x83 = Disable DMA
#   +-- 0   1   1   1   0 = 0xBB = Read Mask Follows
#   |
#  D7  D6  D5  D4  D3  D2  D1  D0  READ MASK
#   0   |   |   |   |   |   |   |
#       |   |   |   |   |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  Status Byte (ZXN DMA not currently implemented)
#       |   |   |   |   |   |
#       |   |   |   |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  Byte Counter Low
#       |   |   |   |   |
#       |   |   |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  Byte Counter High
#       |   |   |   |
#       |   |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  Port A Address Low
#       |   |   |
#       |   |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  Port A Address High
#       |   |
#       |   V
#  D7  D6  D5  D4  D3  D2  D1  D0  Port B Address Low
#       |
#       V
#  D7  D6  D5  D4  D3  D2  D1  D0  Port B Address High
#
# There are far fewer commands implemented than on the Z80 DMA.  This means DMA
# programs can be shorter and simpler.
#
# Prior to starting the DMA, a LOAD command must be issued to copy the Port A and
# Port B addresses into the DMA's internal pointers.  Then an "Enable DMA" command
# is issued to start the DMA.
#
# The "Continue" command resets the DMA's byte counter so that a following "Enable DMA"
# allows the DMA to repeat the last transfer but using the current internal address
# pointers.  Ie it continues from where the last copy operation left off.
#
# Registers can be read via an io read from the dma port after setting the read mask.
# (At power up the read mask is set to 0x7f).  Register values are the current internal
# dma counter values.  So "Port Address A Low" is the lower 8-bits of Port A's next
# transfer address.  Once the end of the read mask is reached, further reads loop around
# to the first one.
#
# Z80 DMA commands not implemented in the ZXN DMA are simply ignored. 
#

define(`__D_LOAD', 0xcf)
define(`__D_CONTINUE', 0xd3)
define(`__D_ENABLE_DMA', 0x87)
define(`__D_DISABLE_DMA', 0x83)
define(`__D_READ_MASK', 0xbb)

#

define(`__D_RM_STATUS', 0x01)
define(`__D_RM_COUNTER_L', 0x02)
define(`__D_RM_COUNTER_H', 0x04)
define(`__D_RM_COUNTER', 0x06)
define(`__D_RM_A_ADDR_L', 0x08)
define(`__D_RM_A_ADDR_H', 0x10)
define(`__D_RM_A_ADDR', 0x18)
define(`__D_RM_B_ADDR_L', 0x20)
define(`__D_RM_B_ADDR_H', 0x40)
define(`__D_RM_B_ADDR', 0x60)

# OPERATING SPEED
#
# The ZXN DMA operates at the same speed as the CPU, that is 3.5MHz, 7MHz or 14MHz.
# This is a contended clock that is modified by the ULA and the auto-slowdown by layer 2.
# Because of this the cycle lengths for Ports A and B can be set to their minimum
# values without ill effects.  However this may change so the following paragraph
# is kept for informational purposes.
#
# The cycle lengths specified for Ports A and B are intended to selectively slow down
# read or write cycles for hardware that cannot operate at the DMA's full speed.  This
# is the case, for example, with layer 2 which can only tolerate a two cycle write
# at 7MHz speed.  Reads from layer 2 may be able to go as fast as two cycles at 14MHz.
# The required timings are not clear at this time.
#
# Cycle Length      Description
#
#   4 @ 14MHz       Layer 2 write while active display is generated
#   2               Everything else

# z88dk/z80asm adds instructions to help with programming the dma:
#
#   dma.wr0
#   dma.wr1
#   dma.wr2
#   dma.wr3
#   dma.wr4
#   dma.wr5
#   dma.wr6 / dma.cmd
#
# These opcodes generate dma programs in z80 asm code and error
# check dma parameters.
#
# See https://github.com/z88dk/z88dk/issues/312#issuecomment-373608766
#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_DMA'
PUBLIC `__IO_DMA_DATAGEAR'

PUBLIC `__D_WR0'

PUBLIC `__D_WR0_TRANSFER'
PUBLIC `__D_WR0_A_TO_B'
PUBLIC `__D_WR0_B_TO_A'

PUBLIC `__D_WR0_X3_A_START_L'
PUBLIC `__D_WR0_X4_A_START_H'
PUBLIC `__D_WR0_X34_A_START'
PUBLIC `__D_WR0_X5_LEN_L'
PUBLIC `__D_WR0_X6_LEN_H'
PUBLIC `__D_WR0_X56_LEN'

PUBLIC `__D_WR0_X3'
PUBLIC `__D_WR0_X4'
PUBLIC `__D_WR0_X5'
PUBLIC `__D_WR0_X6'
PUBLIC `__D_WR0_X34'
PUBLIC `__D_WR0_X35'
PUBLIC `__D_WR0_X36'
PUBLIC `__D_WR0_X45'
PUBLIC `__D_WR0_X46'
PUBLIC `__D_WR0_X56'
PUBLIC `__D_WR0_X345'
PUBLIC `__D_WR0_X346'
PUBLIC `__D_WR0_X356'
PUBLIC `__D_WR0_X456'
PUBLIC `__D_WR0_X3456'

PUBLIC `__D_WR0_TRANSFER_A_TO_B'
PUBLIC `__D_WR0_TRANSFER_B_TO_A'
PUBLIC `__D_WR0_XFER_A_TO_B'
PUBLIC `__D_WR0_XFER_B_TO_A'

PUBLIC `__D_WR1'

PUBLIC `__D_WR1_A_IS_MEM'
PUBLIC `__D_WR1_A_IS_IO'
PUBLIC `__D_WR1_A_DEC'
PUBLIC `__D_WR1_A_INC'
PUBLIC `__D_WR1_A_FIX'

PUBLIC `__D_WR1_X6'
PUBLIC `__D_WR1_X6_A_TIMING'

PUBLIC `__D_WR1X6_A_CLEN_2'
PUBLIC `__D_WR1X6_A_CLEN_3'
PUBLIC `__D_WR1X6_A_CLEN_4'

PUBLIC `__D_WR1_A_IS_MEM_DEC'
PUBLIC `__D_WR1_A_IS_MEM_INC'
PUBLIC `__D_WR1_A_IS_MEM_FIX'
PUBLIC `__D_WR1_A_IS_IO_DEC'
PUBLIC `__D_WR1_A_IS_IO_INC'
PUBLIC `__D_WR1_A_IS_IO_FIX'

PUBLIC `__D_WR2'

PUBLIC `__D_WR2_B_IS_MEM'
PUBLIC `__D_WR2_B_IS_IO'
PUBLIC `__D_WR2_B_DEC'
PUBLIC `__D_WR2_B_INC'
PUBLIC `__D_WR2_B_FIX'

PUBLIC `__D_WR2_X6'
PUBLIC `__D_WR2_X6_B_TIMING'

PUBLIC `__D_WR2X6_B_CLEN_2'
PUBLIC `__D_WR2X6_B_CLEN_3'
PUBLIC `__D_WR2X6_B_CLEN_4'

PUBLIC `__D_WR2X6_X5'
PUBLIC `__D_WR2X6_X5_PRESCALAR'

PUBLIC `__D_WR2_B_IS_MEM_DEC'
PUBLIC `__D_WR2_B_IS_MEM_INC'
PUBLIC `__D_WR2_B_IS_MEM_FIX'
PUBLIC `__D_WR2_B_IS_IO_DEC'
PUBLIC `__D_WR2_B_IS_IO_INC'
PUBLIC `__D_WR2_B_IS_IO_FIX'

PUBLIC `__D_WR3'
PUBLIC `__D_WR3_ENABLE_DMA'

PUBLIC `__D_WR4'

PUBLIC `__D_WR4_CONT'
PUBLIC `__D_WR4_BURST'

PUBLIC `__D_WR4_X2'
PUBLIC `__D_WR4_X3'
PUBLIC `__D_WR4_X23'

PUBLIC `__D_WR4_X2_B_START_L'
PUBLIC `__D_WR4_X3_B_START_H'
PUBLIC `__D_WR4_X23_B_START'

PUBLIC `__D_WR5'

PUBLIC `__D_WR5_CE'
PUBLIC `__D_WR5_CE_WAIT'

PUBLIC `__D_WR5_STOP'
PUBLIC `__D_WR5_RESTART'

PUBLIC `__D_LOAD'
PUBLIC `__D_CONTINUE'
PUBLIC `__D_ENABLE_DMA'
PUBLIC `__D_DISABLE_DMA'
PUBLIC `__D_READ_MASK'

PUBLIC `__D_RM_STATUS'
PUBLIC `__D_RM_COUNTER_L'
PUBLIC `__D_RM_COUNTER_H'
PUBLIC `__D_RM_COUNTER'
PUBLIC `__D_RM_A_ADDR_L'
PUBLIC `__D_RM_A_ADDR_H'
PUBLIC `__D_RM_A_ADDR'
PUBLIC `__D_RM_B_ADDR_L'
PUBLIC `__D_RM_B_ADDR_H'
PUBLIC `__D_RM_B_ADDR'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
IFNDEF __ZXN_INC_DMA
DEFINE __ZXN_INC_DMA

defc `__IO_DMA' = __IO_DMA
defc `__IO_DMA_DATAGEAR' = __IO_DMA_DATAGEAR

defc `__D_WR0' = __D_WR0

defc `__D_WR0_TRANSFER' = __D_WR0_TRANSFER
defc `__D_WR0_A_TO_B' = __D_WR0_A_TO_B
defc `__D_WR0_B_TO_A' = __D_WR0_B_TO_A

defc `__D_WR0_X3_A_START_L' = __D_WR0_X3_A_START_L
defc `__D_WR0_X4_A_START_H' = __D_WR0_X4_A_START_H
defc `__D_WR0_X34_A_START' = __D_WR0_X34_A_START
defc `__D_WR0_X5_LEN_L' = __D_WR0_X5_LEN_L
defc `__D_WR0_X6_LEN_H' = __D_WR0_X6_LEN_H
defc `__D_WR0_X56_LEN' = __D_WR0_X56_LEN

defc `__D_WR0_X3' = __D_WR0_X3
defc `__D_WR0_X4' = __D_WR0_X4
defc `__D_WR0_X5' = __D_WR0_X5
defc `__D_WR0_X6' = __D_WR0_X6
defc `__D_WR0_X34' = __D_WR0_X34
defc `__D_WR0_X35' = __D_WR0_X35
defc `__D_WR0_X36' = __D_WR0_X36
defc `__D_WR0_X45' = __D_WR0_X45
defc `__D_WR0_X46' = __D_WR0_X46
defc `__D_WR0_X56' = __D_WR0_X56
defc `__D_WR0_X345' = __D_WR0_X345
defc `__D_WR0_X346' = __D_WR0_X346
defc `__D_WR0_X356' = __D_WR0_X356
defc `__D_WR0_X456' = __D_WR0_X456
defc `__D_WR0_X3456' = __D_WR0_X3456

defc `__D_WR0_TRANSFER_A_TO_B' = __D_WR0_TRANSFER_A_TO_B
defc `__D_WR0_TRANSFER_B_TO_A' = __D_WR0_TRANSFER_B_TO_A
defc `__D_WR0_XFER_A_TO_B' = __D_WR0_XFER_A_TO_B
defc `__D_WR0_XFER_B_TO_A' = __D_WR0_XFER_B_TO_A

defc `__D_WR1' = __D_WR1

defc `__D_WR1_A_IS_MEM' = __D_WR1_A_IS_MEM
defc `__D_WR1_A_IS_IO' = __D_WR1_A_IS_IO
defc `__D_WR1_A_DEC' = __D_WR1_A_DEC
defc `__D_WR1_A_INC' = __D_WR1_A_INC
defc `__D_WR1_A_FIX' = __D_WR1_A_FIX

defc `__D_WR1_X6' = __D_WR1_X6
defc `__D_WR1_X6_A_TIMING' = __D_WR1_X6_A_TIMING

defc `__D_WR1X6_A_CLEN_2' = __D_WR1X6_A_CLEN_2
defc `__D_WR1X6_A_CLEN_3' = __D_WR1X6_A_CLEN_3
defc `__D_WR1X6_A_CLEN_4' = __D_WR1X6_A_CLEN_4

defc `__D_WR1_A_IS_MEM_DEC' = __D_WR1_A_IS_MEM_DEC
defc `__D_WR1_A_IS_MEM_INC' = __D_WR1_A_IS_MEM_INC
defc `__D_WR1_A_IS_MEM_FIX' = __D_WR1_A_IS_MEM_FIX
defc `__D_WR1_A_IS_IO_DEC' = __D_WR1_A_IS_IO_DEC
defc `__D_WR1_A_IS_IO_INC' = __D_WR1_A_IS_IO_INC
defc `__D_WR1_A_IS_IO_FIX' = __D_WR1_A_IS_IO_FIX

defc `__D_WR2' = __D_WR2

defc `__D_WR2_B_IS_MEM' = __D_WR2_B_IS_MEM
defc `__D_WR2_B_IS_IO' = __D_WR2_B_IS_IO
defc `__D_WR2_B_DEC' = __D_WR2_B_DEC
defc `__D_WR2_B_INC' = __D_WR2_B_INC
defc `__D_WR2_B_FIX' = __D_WR2_B_FIX

defc `__D_WR2_X6' = __D_WR2_X6
defc `__D_WR2_X6_B_TIMING' = __D_WR2_X6_B_TIMING

defc `__D_WR2X6_B_CLEN_2' = __D_WR2X6_B_CLEN_2
defc `__D_WR2X6_B_CLEN_3' = __D_WR2X6_B_CLEN_3
defc `__D_WR2X6_B_CLEN_4' = __D_WR2X6_B_CLEN_4

defc `__D_WR2X6_X5' = __D_WR2X6_X5
defc `__D_WR2X6_X5_PRESCALAR' = __D_WR2X6_X5_PRESCALAR

defc `__D_WR2_B_IS_MEM_DEC' = __D_WR2_B_IS_MEM_DEC
defc `__D_WR2_B_IS_MEM_INC' = __D_WR2_B_IS_MEM_INC
defc `__D_WR2_B_IS_MEM_FIX' = __D_WR2_B_IS_MEM_FIX
defc `__D_WR2_B_IS_IO_DEC' = __D_WR2_B_IS_IO_DEC
defc `__D_WR2_B_IS_IO_INC' = __D_WR2_B_IS_IO_INC
defc `__D_WR2_B_IS_IO_FIX' = __D_WR2_B_IS_IO_FIX

defc `__D_WR3' = __D_WR3
defc `__D_WR3_ENABLE_DMA' = __D_WR3_ENABLE_DMA

defc `__D_WR4' = __D_WR4

defc `__D_WR4_CONT' = __D_WR4_CONT
defc `__D_WR4_BURST' = __D_WR4_BURST

defc `__D_WR4_X2' = __D_WR4_X2
defc `__D_WR4_X3' = __D_WR4_X3
defc `__D_WR4_X23' = __D_WR4_X23

defc `__D_WR4_X2_B_START_L' = __D_WR4_X2_B_START_L
defc `__D_WR4_X3_B_START_H' = __D_WR4_X3_B_START_H
defc `__D_WR4_X23_B_START' = __D_WR4_X23_B_START

defc `__D_WR5' = __D_WR5

defc `__D_WR5_CE' = __D_WR5_CE
defc `__D_WR5_CE_WAIT' = __D_WR5_CE_WAIT

defc `__D_WR5_STOP' = __D_WR5_STOP
defc `__D_WR5_RESTART' = __D_WR5_RESTART

defc `__D_LOAD' = __D_LOAD
defc `__D_CONTINUE' = __D_CONTINUE
defc `__D_ENABLE_DMA' = __D_ENABLE_DMA
defc `__D_DISABLE_DMA' = __D_DISABLE_DMA
defc `__D_READ_MASK' = __D_READ_MASK

defc `__D_RM_STATUS' = __D_RM_STATUS
defc `__D_RM_COUNTER_L' = __D_RM_COUNTER_L
defc `__D_RM_COUNTER_H' = __D_RM_COUNTER_H
defc `__D_RM_COUNTER' = __D_RM_COUNTER
defc `__D_RM_A_ADDR_L' = __D_RM_A_ADDR_L
defc `__D_RM_A_ADDR_H' = __D_RM_A_ADDR_H
defc `__D_RM_A_ADDR' = __D_RM_A_ADDR
defc `__D_RM_B_ADDR_L' = __D_RM_B_ADDR_L
defc `__D_RM_B_ADDR_H' = __D_RM_B_ADDR_H
defc `__D_RM_B_ADDR' = __D_RM_B_ADDR

ENDIF
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_DMA'  __IO_DMA
`#define' `__IO_DMA_DATAGEAR'  __IO_DMA_DATAGEAR

`#define' `__D_WR0'  __D_WR0

`#define' `__D_WR0_TRANSFER'  __D_WR0_TRANSFER
`#define' `__D_WR0_A_TO_B'  __D_WR0_A_TO_B
`#define' `__D_WR0_B_TO_A'  __D_WR0_B_TO_A

`#define' `__D_WR0_X3_A_START_L'  __D_WR0_X3_A_START_L
`#define' `__D_WR0_X4_A_START_H'  __D_WR0_X4_A_START_H
`#define' `__D_WR0_X34_A_START'  __D_WR0_X34_A_START
`#define' `__D_WR0_X5_LEN_L'  __D_WR0_X5_LEN_L
`#define' `__D_WR0_X6_LEN_H'  __D_WR0_X6_LEN_H
`#define' `__D_WR0_X56_LEN'  __D_WR0_X56_LEN

`#define' `__D_WR0_X3'  __D_WR0_X3
`#define' `__D_WR0_X4'  __D_WR0_X4
`#define' `__D_WR0_X5'  __D_WR0_X5
`#define' `__D_WR0_X6'  __D_WR0_X6
`#define' `__D_WR0_X34'  __D_WR0_X34
`#define' `__D_WR0_X35'  __D_WR0_X35
`#define' `__D_WR0_X36'  __D_WR0_X36
`#define' `__D_WR0_X45'  __D_WR0_X45
`#define' `__D_WR0_X46'  __D_WR0_X46
`#define' `__D_WR0_X56'  __D_WR0_X56
`#define' `__D_WR0_X345'  __D_WR0_X345
`#define' `__D_WR0_X346'  __D_WR0_X346
`#define' `__D_WR0_X356'  __D_WR0_X356
`#define' `__D_WR0_X456'  __D_WR0_X456
`#define' `__D_WR0_X3456'  __D_WR0_X3456

`#define' `__D_WR0_TRANSFER_A_TO_B'  __D_WR0_TRANSFER_A_TO_B
`#define' `__D_WR0_TRANSFER_B_TO_A'  __D_WR0_TRANSFER_B_TO_A
`#define' `__D_WR0_XFER_A_TO_B'  __D_WR0_XFER_A_TO_B
`#define' `__D_WR0_XFER_B_TO_A'  __D_WR0_XFER_B_TO_A

`#define' `__D_WR1'  __D_WR1

`#define' `__D_WR1_A_IS_MEM'  __D_WR1_A_IS_MEM
`#define' `__D_WR1_A_IS_IO'  __D_WR1_A_IS_IO
`#define' `__D_WR1_A_DEC'  __D_WR1_A_DEC
`#define' `__D_WR1_A_INC'  __D_WR1_A_INC
`#define' `__D_WR1_A_FIX'  __D_WR1_A_FIX

`#define' `__D_WR1_X6'  __D_WR1_X6
`#define' `__D_WR1_X6_A_TIMING'  __D_WR1_X6_A_TIMING

`#define' `__D_WR1X6_A_CLEN_2'  __D_WR1X6_A_CLEN_2
`#define' `__D_WR1X6_A_CLEN_3'  __D_WR1X6_A_CLEN_3
`#define' `__D_WR1X6_A_CLEN_4'  __D_WR1X6_A_CLEN_4

`#define' `__D_WR1_A_IS_MEM_DEC'  __D_WR1_A_IS_MEM_DEC
`#define' `__D_WR1_A_IS_MEM_INC'  __D_WR1_A_IS_MEM_INC
`#define' `__D_WR1_A_IS_MEM_FIX'  __D_WR1_A_IS_MEM_FIX
`#define' `__D_WR1_A_IS_IO_DEC'  __D_WR1_A_IS_IO_DEC
`#define' `__D_WR1_A_IS_IO_INC'  __D_WR1_A_IS_IO_INC
`#define' `__D_WR1_A_IS_IO_FIX'  __D_WR1_A_IS_IO_FIX

`#define' `__D_WR2'  __D_WR2

`#define' `__D_WR2_B_IS_MEM'  __D_WR2_B_IS_MEM
`#define' `__D_WR2_B_IS_IO'  __D_WR2_B_IS_IO
`#define' `__D_WR2_B_DEC'  __D_WR2_B_DEC
`#define' `__D_WR2_B_INC'  __D_WR2_B_INC
`#define' `__D_WR2_B_FIX'  __D_WR2_B_FIX

`#define' `__D_WR2_X6'  __D_WR2_X6
`#define' `__D_WR2_X6_B_TIMING'  __D_WR2_X6_B_TIMING

`#define' `__D_WR2X6_B_CLEN_2'  __D_WR2X6_B_CLEN_2
`#define' `__D_WR2X6_B_CLEN_3'  __D_WR2X6_B_CLEN_3
`#define' `__D_WR2X6_B_CLEN_4'  __D_WR2X6_B_CLEN_4

`#define' `__D_WR2X6_X5'  __D_WR2X6_X5
`#define' `__D_WR2X6_X5_PRESCALAR'  __D_WR2X6_X5_PRESCALAR

`#define' `__D_WR2_B_IS_MEM_DEC'  __D_WR2_B_IS_MEM_DEC
`#define' `__D_WR2_B_IS_MEM_INC'  __D_WR2_B_IS_MEM_INC
`#define' `__D_WR2_B_IS_MEM_FIX'  __D_WR2_B_IS_MEM_FIX
`#define' `__D_WR2_B_IS_IO_DEC'  __D_WR2_B_IS_IO_DEC
`#define' `__D_WR2_B_IS_IO_INC'  __D_WR2_B_IS_IO_INC
`#define' `__D_WR2_B_IS_IO_FIX'  __D_WR2_B_IS_IO_FIX

`#define' `__D_WR3'  __D_WR3
`#define' `__D_WR3_ENABLE_DMA'  __D_WR3_ENABLE_DMA

`#define' `__D_WR4'  __D_WR4

`#define' `__D_WR4_CONT'  __D_WR4_CONT
`#define' `__D_WR4_BURST'  __D_WR4_BURST

`#define' `__D_WR4_X2'  __D_WR4_X2
`#define' `__D_WR4_X3'  __D_WR4_X3
`#define' `__D_WR4_X23'  __D_WR4_X23

`#define' `__D_WR4_X2_B_START_L'  __D_WR4_X2_B_START_L
`#define' `__D_WR4_X3_B_START_H'  __D_WR4_X3_B_START_H
`#define' `__D_WR4_X23_B_START'  __D_WR4_X23_B_START

`#define' `__D_WR5'  __D_WR5

`#define' `__D_WR5_CE'  __D_WR5_CE
`#define' `__D_WR5_CE_WAIT'  __D_WR5_CE_WAIT

`#define' `__D_WR5_STOP'  __D_WR5_STOP
`#define' `__D_WR5_RESTART'  __D_WR5_RESTART

`#define' `__D_LOAD'  __D_LOAD
`#define' `__D_CONTINUE'  __D_CONTINUE
`#define' `__D_ENABLE_DMA'  __D_ENABLE_DMA
`#define' `__D_DISABLE_DMA'  __D_DISABLE_DMA
`#define' `__D_READ_MASK'  __D_READ_MASK

`#define' `__D_RM_STATUS'  __D_RM_STATUS
`#define' `__D_RM_COUNTER_L'  __D_RM_COUNTER_L
`#define' `__D_RM_COUNTER_H'  __D_RM_COUNTER_H
`#define' `__D_RM_COUNTER'  __D_RM_COUNTER
`#define' `__D_RM_A_ADDR_L'  __D_RM_A_ADDR_L
`#define' `__D_RM_A_ADDR_H'  __D_RM_A_ADDR_H
`#define' `__D_RM_A_ADDR'  __D_RM_A_ADDR
`#define' `__D_RM_B_ADDR_L'  __D_RM_B_ADDR_L
`#define' `__D_RM_B_ADDR_H'  __D_RM_B_ADDR_H
`#define' `__D_RM_B_ADDR'  __D_RM_B_ADDR
')
