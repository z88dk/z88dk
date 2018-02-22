divert(-1)

###############################################################
# ZXN DMA CONFIGURATION
# rebuild the library if changes are made
#
# The ZXN DMA is a single port dma device that implements a
# subset of the Z80 DMA functionality.  The subset is large
# enough to be compatible with common uses of the MB02 and
# Datagear interfaces available for the Spectrum.

# The ZXN DMA requires one read/write io port but it is
# mapped to two io ports to be compatible with both the
# MB02 and Datagear.

# PORT 0x0b, 0x6b: ZXN DMA

define(`__IO_DMA', 0x6b)       # preferred port

define(`__IO_DMA_MB02', 0x0b)
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
#       |   |   |   |   |   1   1  Do not use (Bheaves like Transfer, Search/Transfer on Z80 DMA)
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
# pointers.  Ie it continues where the last copy operation left off.
#
# Registers can be read via an io read from the dma port after setting the read mask.
# (At power up the read mask is set to 0x7f).  Register values are the current internal
# dma counter values.  So "Port Address A Low" is the lower 8-bits of Port A's next
# transfer address.  Once the end of the read mask is reached, further reads loop around
# to the first one.

# OPERATING SPEED
#
# The ZXN DMA operates at the same speed as the CPU, that is 3.5MHz, 7MHz or 14MHz.
# The cycle lengths specified for Ports A and B are intended to selectively slow down
# read or write cycles for hardware that cannot operate at the DMA's full speed.  This
# is the case, for example, with layer 2 which can only tolerate a two cycle read/write
# at 7MHz speed.
#
# Cycle Length      Description
#
#   4 @ 14MHz       Layer 2 r/w while active display is generated
#   2               Everything else

# SYMBOLIC DEFINES
#
#

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

PUBLIC `__IO_DMA_MB02'
PUBLIC `__IO_DMA_DATAGEAR'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_DMA' = __IO_DMA

defc `__IO_DMA_MB02' = __IO_DMA_MB02
defc `__IO_DMA_DATAGEAR' = __IO_DMA_DATAGEAR
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_DMA'  __IO_DMA

`#define' `__IO_DMA_MB02'  __IO_DMA_MB02
`#define' `__IO_DMA_DATAGEAR'  __IO_DMA_DATAGEAR
')
