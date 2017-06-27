divert(-1)

###############################################################
# Z180 CPU USER CONFIGURATION
# rebuild the library if changes are made
#

# Class of Z180 being targeted

define(`__Z180', 0x04)

define(`__Z180_Z80180', 0x01)
define(`__Z180_Z8L180', 0x02)
define(`__Z180_Z8S180', 0x04)

# Clock frequency in Hz

define(`__CPU_CLOCK', 33000000)

# CPU info

define(`__CPU_INFO', 0x00)

define(`__CPU_INFO_ENABLE_SLL', 0x01)

# INTERRUPT VECTOR TABLE BASE ADDRESS

define(`__IO_VECTOR_BASE', 0x80)
define(`__IO_VECTOR_BASE', eval(__IO_VECTOR_BASE & 0xe0))

# I/O BASE ADDRESS OF INTERNAL PERIPHERALS

define(`__IO_BASE_ADDRESS', 0x00)
define(`__IO_BASE_ADDRESS', eval(__IO_BASE_ADDRESS & 0xc0))

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   # Z80180 CLASS
   # I/O Addresses for Internal Peripherals

   # ASCI

   define(`__IO_CNTLA0', eval(__IO_BASE_ADDRESS + 0x00))
   define(`__IO_CNTLA1', eval(__IO_BASE_ADDRESS + 0x01))
   define(`__IO_CNTLB0', eval(__IO_BASE_ADDRESS + 0x02))
   define(`__IO_CNTLB1', eval(__IO_BASE_ADDRESS + 0x03))
   define(`__IO_STAT0', eval(__IO_BASE_ADDRESS + 0x04))
   define(`__IO_STAT1', eval(__IO_BASE_ADDRESS + 0x05))
   define(`__IO_TDR0', eval(__IO_BASE_ADDRESS + 0x06))
   define(`__IO_TDR1', eval(__IO_BASE_ADDRESS + 0x07))
   define(`__IO_RDR0', eval(__IO_BASE_ADDRESS + 0x08))
   define(`__IO_RDR1', eval(__IO_BASE_ADDRESS + 0x09))

   # CSI/O

   define(`__IO_CNTR', eval(__IO_BASE_ADDRESS + 0x0a))
   define(`__IO_TRD', eval(__IO_BASE_ADDRESS + 0x0b))

   # Timer

   define(`__IO_TMDR0L', eval(__IO_BASE_ADDRESS + 0x0c))
   define(`__IO_TMDR0H', eval(__IO_BASE_ADDRESS + 0x0d))
   define(`__IO_RLDR0L', eval(__IO_BASE_ADDRESS + 0x0e))
   define(`__IO_RLDR0H', eval(__IO_BASE_ADDRESS + 0x0f))
   define(`__IO_TCR', eval(__IO_BASE_ADDRESS + 0x10))
   define(`__IO_TMDR1L', eval(__IO_BASE_ADDRESS + 0x14))
   define(`__IO_TMDR1H', eval(__IO_BASE_ADDRESS + 0x15))
   define(`__IO_RLDR1L', eval(__IO_BASE_ADDRESS + 0x16))
   define(`__IO_RLDR1H', eval(__IO_BASE_ADDRESS + 0x17))

   # Others

   define(`__IO_FRC', eval(__IO_BASE_ADDRESS + 0x18))

   # DMA

   define(`__IO_SAR0L', eval(__IO_BASE_ADDRESS + 0x20))
   define(`__IO_SAR0H', eval(__IO_BASE_ADDRESS + 0x21))
   define(`__IO_SAR0B', eval(__IO_BASE_ADDRESS + 0x22))
   define(`__IO_DAR0L', eval(__IO_BASE_ADDRESS + 0x23))
   define(`__IO_DAR0H', eval(__IO_BASE_ADDRESS + 0x24))
   define(`__IO_DAR0B', eval(__IO_BASE_ADDRESS + 0x25))
   define(`__IO_BCR0L', eval(__IO_BASE_ADDRESS + 0x26))
   define(`__IO_BCR0H', eval(__IO_BASE_ADDRESS + 0x27))
   define(`__IO_MAR1L', eval(__IO_BASE_ADDRESS + 0x28))
   define(`__IO_MAR1H', eval(__IO_BASE_ADDRESS + 0x29))
   define(`__IO_MAR1B', eval(__IO_BASE_ADDRESS + 0x2a))
   define(`__IO_IAR1L', eval(__IO_BASE_ADDRESS + 0x2b))
   define(`__IO_IAR1H', eval(__IO_BASE_ADDRESS + 0x2c))
   define(`__IO_BCR1L', eval(__IO_BASE_ADDRESS + 0x2e))
   define(`__IO_BCR1H', eval(__IO_BASE_ADDRESS + 0x2f))
   define(`__IO_DSTAT', eval(__IO_BASE_ADDRESS + 0x30))
   define(`__IO_DMODE', eval(__IO_BASE_ADDRESS + 0x31))
   define(`__IO_DCNTL', eval(__IO_BASE_ADDRESS + 0x32))

   # INT

   define(`__IO_IL', eval(__IO_BASE_ADDRESS + 0x33))
   define(`__IO_ITC', eval(__IO_BASE_ADDRESS + 0x34))

   # Refresh

   define(`__IO_RCR', eval(__IO_BASE_ADDRESS + 0x36))

   # MMU

   define(`__IO_CBR', eval(__IO_BASE_ADDRESS + 0x38))
   define(`__IO_BBR', eval(__IO_BASE_ADDRESS + 0x39))
   define(`__IO_CBAR', eval(__IO_BASE_ADDRESS + 0x3a))

   # I/O

   define(`__IO_OMCR', eval(__IO_BASE_ADDRESS + 0x3e))
   define(`__IO_ICR', eval(__IO_BASE_ADDRESS + 0x3f))
',
`
   # Z8S180 / Z8L180 CLASS
   # I/O Addresses for Internal Peripherals

   # ASCI

   define(`__IO_CNTLA0', eval(__IO_BASE_ADDRESS + 0x00))
   define(`__IO_CNTLA1', eval(__IO_BASE_ADDRESS + 0x01))
   define(`__IO_CNTLB0', eval(__IO_BASE_ADDRESS + 0x02))
   define(`__IO_CNTLB1', eval(__IO_BASE_ADDRESS + 0x03))
   define(`__IO_STAT0', eval(__IO_BASE_ADDRESS + 0x04))
   define(`__IO_STAT1', eval(__IO_BASE_ADDRESS + 0x05))
   define(`__IO_TDR0', eval(__IO_BASE_ADDRESS + 0x06))
   define(`__IO_TDR1', eval(__IO_BASE_ADDRESS + 0x07))
   define(`__IO_RDR0', eval(__IO_BASE_ADDRESS + 0x08))
   define(`__IO_RDR1', eval(__IO_BASE_ADDRESS + 0x09))
   define(`__IO_ASEXT0', eval(__IO_BASE_ADDRESS + 0x12))
   define(`__IO_ASEXT1', eval(__IO_BASE_ADDRESS + 0x13))
   define(`__IO_ASTC0L', eval(__IO_BASE_ADDRESS + 0x1a))
   define(`__IO_ASTC0H', eval(__IO_BASE_ADDRESS + 0x1b))
   define(`__IO_ASTC1L', eval(__IO_BASE_ADDRESS + 0x1c))
   define(`__IO_ASTC1H', eval(__IO_BASE_ADDRESS + 0x1d))

   # CSI/O

   define(`__IO_CNTR', eval(__IO_BASE_ADDRESS + 0x0a))
   define(`__IO_TRD', eval(__IO_BASE_ADDRESS + 0x0b))

   # Timer

   define(`__IO_TMDR0L', eval(__IO_BASE_ADDRESS + 0x0c))
   define(`__IO_TMDR0H', eval(__IO_BASE_ADDRESS + 0x0d))
   define(`__IO_RLDR0L', eval(__IO_BASE_ADDRESS + 0x0e))
   define(`__IO_RLDR0H', eval(__IO_BASE_ADDRESS + 0x0f))
   define(`__IO_TCR', eval(__IO_BASE_ADDRESS + 0x10))
   define(`__IO_TMDR1L', eval(__IO_BASE_ADDRESS + 0x14))
   define(`__IO_TMDR1H', eval(__IO_BASE_ADDRESS + 0x15))
   define(`__IO_RLDR1L', eval(__IO_BASE_ADDRESS + 0x16))
   define(`__IO_RLDR1H', eval(__IO_BASE_ADDRESS + 0x17))

   # Others

   define(`__IO_FRC', eval(__IO_BASE_ADDRESS + 0x18))
   define(`__IO_CMR', eval(__IO_BASE_ADDRESS + 0x1e))
   define(`__IO_CCR', eval(__IO_BASE_ADDRESS + 0x1f))

   # DMA

   define(`__IO_SAR0L', eval(__IO_BASE_ADDRESS + 0x20))
   define(`__IO_SAR0H', eval(__IO_BASE_ADDRESS + 0x21))
   define(`__IO_SAR0B', eval(__IO_BASE_ADDRESS + 0x22))
   define(`__IO_DAR0L', eval(__IO_BASE_ADDRESS + 0x23))
   define(`__IO_DAR0H', eval(__IO_BASE_ADDRESS + 0x24))
   define(`__IO_DAR0B', eval(__IO_BASE_ADDRESS + 0x25))
   define(`__IO_BCR0L', eval(__IO_BASE_ADDRESS + 0x26))
   define(`__IO_BCR0H', eval(__IO_BASE_ADDRESS + 0x27))
   define(`__IO_MAR1L', eval(__IO_BASE_ADDRESS + 0x28))
   define(`__IO_MAR1H', eval(__IO_BASE_ADDRESS + 0x29))
   define(`__IO_MAR1B', eval(__IO_BASE_ADDRESS + 0x2a))
   define(`__IO_IAR1L', eval(__IO_BASE_ADDRESS + 0x2b))
   define(`__IO_IAR1H', eval(__IO_BASE_ADDRESS + 0x2c))
   define(`__IO_IAR1B', eval(__IO_BASE_ADDRESS + 0x2d))
   define(`__IO_BCR1L', eval(__IO_BASE_ADDRESS + 0x2e))
   define(`__IO_BCR1H', eval(__IO_BASE_ADDRESS + 0x2f))
   define(`__IO_DSTAT', eval(__IO_BASE_ADDRESS + 0x30))
   define(`__IO_DMODE', eval(__IO_BASE_ADDRESS + 0x31))
   define(`__IO_DCNTL', eval(__IO_BASE_ADDRESS + 0x32))

   # INT

   define(`__IO_IL', eval(__IO_BASE_ADDRESS + 0x33))
   define(`__IO_ITC', eval(__IO_BASE_ADDRESS + 0x34))

   # Refresh

   define(`__IO_RCR', eval(__IO_BASE_ADDRESS + 0x36))

   # MMU

   define(`__IO_CBR', eval(__IO_BASE_ADDRESS + 0x38))
   define(`__IO_BBR', eval(__IO_BASE_ADDRESS + 0x39))
   define(`__IO_CBAR', eval(__IO_BASE_ADDRESS + 0x3a))

   # I/O

   define(`__IO_OMCR', eval(__IO_BASE_ADDRESS + 0x3e))
   define(`__IO_ICR', eval(__IO_BASE_ADDRESS + 0x3f))
')

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__Z180'

PUBLIC `__Z180_Z80180'
PUBLIC `__Z180_Z8L180'
PUBLIC `__Z180_Z8S180'

PUBLIC `__CPU_CLOCK'

PUBLIC `__CPU_INFO'

PUBLIC `__CPU_INFO_ENABLE_SLL'

PUBLIC `__IO_VECTOR_BASE'

PUBLIC `__IO_BASE_ADDRESS'

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   ; Z80180 CLASS

   PUBLIC `CNTLA0'
   PUBLIC `CNTLA1'
   PUBLIC `CNTLB0'
   PUBLIC `CNTLB1'
   PUBLIC `STAT0'
   PUBLIC `STAT1'
   PUBLIC `TDR0'
   PUBLIC `TDR1'
   PUBLIC `RDR0'
   PUBLIC `RDR1'

   PUBLIC `CNTR'
   PUBLIC `TRD'

   PUBLIC `TMDR0L'
   PUBLIC `TMDR0H'
   PUBLIC `RLDR0L'
   PUBLIC `RLDR0H'
   PUBLIC `TCR'
   PUBLIC `TMDR1L'
   PUBLIC `TMDR1H'
   PUBLIC `RLDR1L'
   PUBLIC `RLDR1H'

   PUBLIC `FRC'

   PUBLIC `SAR0L'
   PUBLIC `SAR0H'
   PUBLIC `SAR0B'
   PUBLIC `DAR0L'
   PUBLIC `DAR0H'
   PUBLIC `DAR0B'
   PUBLIC `BCR0L'
   PUBLIC `BCR0H'
   PUBLIC `MAR1L'
   PUBLIC `MAR1H'
   PUBLIC `MAR1B'
   PUBLIC `IAR1L'
   PUBLIC `IAR1H'
   PUBLIC `BCR1L'
   PUBLIC `BCR1H'
   PUBLIC `DSTAT'
   PUBLIC `DMODE'
   PUBLIC `DCNTL'

   PUBLIC `IL'
   PUBLIC `ITC'

   PUBLIC `RCR'

   PUBLIC `CBR'
   PUBLIC `BBR'
   PUBLIC `CBAR'

   PUBLIC `OMCR'
   PUBLIC `ICR'
',
`
   ; Z8S180 / Z8L180 CLASS

   PUBLIC `CNTLA0'
   PUBLIC `CNTLA1'
   PUBLIC `CNTLB0'
   PUBLIC `CNTLB1'
   PUBLIC `STAT0'
   PUBLIC `STAT1'
   PUBLIC `TDR0'
   PUBLIC `TDR1'
   PUBLIC `RDR0'
   PUBLIC `RDR1'
   PUBLIC `ASEXT0'
   PUBLIC `ASEXT1'
   PUBLIC `ASTC0L'
   PUBLIC `ASTC0H'
   PUBLIC `ASTC1L'
   PUBLIC `ASTC1H'

   PUBLIC `CNTR'
   PUBLIC `TRD'

   PUBLIC `TMDR0L'
   PUBLIC `TMDR0H'
   PUBLIC `RLDR0L'
   PUBLIC `RLDR0H'
   PUBLIC `TCR'
   PUBLIC `TMDR1L'
   PUBLIC `TMDR1H'
   PUBLIC `RLDR1L'
   PUBLIC `RLDR1H'

   PUBLIC `FRC'
   PUBLIC `CMR'
   PUBLIC `CCR'

   PUBLIC `SAR0L'
   PUBLIC `SAR0H'
   PUBLIC `SAR0B'
   PUBLIC `DAR0L'
   PUBLIC `DAR0H'
   PUBLIC `DAR0B'
   PUBLIC `BCR0L'
   PUBLIC `BCR0H'
   PUBLIC `MAR1L'
   PUBLIC `MAR1H'
   PUBLIC `MAR1B'
   PUBLIC `IAR1L'
   PUBLIC `IAR1H'
   PUBLIC `IAR1B'
   PUBLIC `BCR1L'
   PUBLIC `BCR1H'
   PUBLIC `DSTAT'
   PUBLIC `DMODE'
   PUBLIC `DCNTL'

   PUBLIC `IL'
   PUBLIC `ITC'

   PUBLIC `RCR'

   PUBLIC `CBR'
   PUBLIC `BBR'
   PUBLIC `CBAR'

   PUBLIC `OMCR'
   PUBLIC `ICR'
')
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__Z180' = __Z180

defc `__Z180_Z80180' = __Z180_Z80180
defc `__Z180_Z8L180' = __Z180_Z8L180
defc `__Z180_Z8S180' = __Z180_Z8S180

defc `__CPU_CLOCK' = __CPU_CLOCK

defc `__CPU_INFO' = __CPU_INFO

defc `__CPU_INFO_ENABLE_SLL' = __CPU_INFO_ENABLE_SLL

defc `__IO_VECTOR_BASE' = __IO_VECTOR_BASE

defc `__IO_BASE_ADDRESS' = __IO_BASE_ADDRESS

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   ; Z80180 CLASS

   defc `CNTLA0' = __IO_CNTLA0
   defc `CNTLA1' = __IO_CNTLA1
   defc `CNTLB0' = __IO_CNTLB0
   defc `CNTLB1' = __IO_CNTLB1
   defc `STAT0' = __IO_STAT0
   defc `STAT1' = __IO_STAT1
   defc `TDR0' = __IO_TDR0
   defc `TDR1' = __IO_TDR1
   defc `RDR0' = __IO_RDR0
   defc `RDR1' = __IO_RDR1

   defc `CNTR' = __IO_CNTR
   defc `TRD' = __IO_TRD

   defc `TMDR0L' = __IO_TMDR0L
   defc `TMDR0H' = __IO_TMDR0H
   defc `RLDR0L' = __IO_RLDR0L
   defc `RLDR0H' = __IO_RLDR0H
   defc `TCR' = __IO_TCR
   defc `TMDR1L' = __IO_TMDR1L
   defc `TMDR1H' = __IO_TMDR1H
   defc `RLDR1L' = __IO_RLDR1L
   defc `RLDR1H' = __IO_RLDR1H

   defc `FRC' = __IO_FRC

   defc `SAR0L' = __IO_SAR0L
   defc `SAR0H' = __IO_SAR0H
   defc `SAR0B' = __IO_SAR0B
   defc `DAR0L' = __IO_DAR0L
   defc `DAR0H' = __IO_DAR0H
   defc `DAR0B' = __IO_DAR0B
   defc `BCR0L' = __IO_BCR0L
   defc `BCR0H' = __IO_BCR0H
   defc `MAR1L' = __IO_MAR1L
   defc `MAR1H' = __IO_MAR1H
   defc `MAR1B' = __IO_MAR1B
   defc `IAR1L' = __IO_IAR1L
   defc `IAR1H' = __IO_IAR1H
   defc `BCR1L' = __IO_BCR1L
   defc `BCR1H' = __IO_BCR1H
   defc `DSTAT' = __IO_DSTAT
   defc `DMODE' = __IO_DMODE
   defc `DCNTL' = __IO_DCNTL

   defc `IL' = __IO_IL
   defc `ITC' = __IO_ITC

   defc `RCR' = __IO_RCR

   defc `CBR' = __IO_CBR
   defc `BBR' = __IO_BBR
   defc `CBAR' = __IO_CBAR

   defc `OMCR' = __IO_OMCR
   defc `ICR' = __IO_ICR
',
`
   ; Z8S180 / Z8L180 CLASS

   defc `CNTLA0' = __IO_CNTLA0
   defc `CNTLA1' = __IO_CNTLA1
   defc `CNTLB0' = __IO_CNTLB0
   defc `CNTLB1' = __IO_CNTLB1
   defc `STAT0' = __IO_STAT0
   defc `STAT1' = __IO_STAT1
   defc `TDR0' = __IO_TDR0
   defc `TDR1' = __IO_TDR1
   defc `RDR0' = __IO_RDR0
   defc `RDR1' = __IO_RDR1
   defc `ASEXT0' = __IO_ASEXT0
   defc `ASEXT1' = __IO_ASEXT1
   defc `ASTC0L' = __IO_ASTC0L
   defc `ASTC0H' = __IO_ASTC0H
   defc `ASTC1L' = __IO_ASTC1L
   defc `ASTC1H' = __IO_ASTC1H

   defc `CNTR' = __IO_CNTR
   defc `TRD' = __IO_TRD

   defc `TMDR0L' = __IO_TMDR0L
   defc `TMDR0H' = __IO_TMDR0H
   defc `RLDR0L' = __IO_RLDR0L
   defc `RLDR0H' = __IO_RLDR0H
   defc `TCR' = __IO_TCR
   defc `TMDR1L' = __IO_TMDR1L
   defc `TMDR1H' = __IO_TMDR1H
   defc `RLDR1L' = __IO_RLDR1L
   defc `RLDR1H' = __IO_RLDR1H

   defc `FRC' = __IO_FRC
   defc `CMR' = __IO_CMR
   defc `CCR' = __IO_CCR

   defc `SAR0L' = __IO_SAR0L
   defc `SAR0H' = __IO_SAR0H
   defc `SAR0B' = __IO_SAR0B
   defc `DAR0L' = __IO_DAR0L
   defc `DAR0H' = __IO_DAR0H
   defc `DAR0B' = __IO_DAR0B
   defc `BCR0L' = __IO_BCR0L
   defc `BCR0H' = __IO_BCR0H
   defc `MAR1L' = __IO_MAR1L
   defc `MAR1H' = __IO_MAR1H
   defc `MAR1B' = __IO_MAR1B
   defc `IAR1L' = __IO_IAR1L
   defc `IAR1H' = __IO_IAR1H
   defc `IAR1B' = __IO_IAR1B
   defc `BCR1L' = __IO_BCR1L
   defc `BCR1H' = __IO_BCR1H
   defc `DSTAT' = __IO_DSTAT
   defc `DMODE' = __IO_DMODE
   defc `DCNTL' = __IO_DCNTL

   defc `IL' = __IO_IL
   defc `ITC' = __IO_ITC

   defc `RCR' = __IO_RCR

   defc `CBR' = __IO_CBR
   defc `BBR' = __IO_BBR
   defc `CBAR' = __IO_CBAR

   defc `OMCR' = __IO_OMCR
   defc `ICR' = __IO_ICR
')
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__Z180'
`#define' `__Z180'  __Z180

`#define' `__Z180_Z80180'  __Z180_Z80180
`#define' `__Z180_Z8L180'  __Z180_Z8L180
`#define' `__Z180_Z8S180'  __Z180_Z8S180

`#define' `__CPU_CLOCK'  __CPU_CLOCK

`#define' `__CPU_INFO'  __CPU_INFO

`#define' `__CPU_INFO_ENABLE_SLL'  __CPU_INFO_ENABLE_SLL

`#define' `__IO_VECTOR_BASE'  __IO_VECTOR_BASE

`#define' `__IO_BASE_ADDRESS'  __IO_BASE_ADDRESS

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   // Z80180 CLASS

   `#define' `__IO_CNTLA0'  __IO_CNTLA0
   `#define' `__IO_CNTLA1'  __IO_CNTLA1
   `#define' `__IO_CNTLB0'  __IO_CNTLB0
   `#define' `__IO_CNTLB1'  __IO_CNTLB1
   `#define' `__IO_STAT0'  __IO_STAT0
   `#define' `__IO_STAT1'  __IO_STAT1
   `#define' `__IO_TDR0'  __IO_TDR0
   `#define' `__IO_TDR1'  __IO_TDR1
   `#define' `__IO_RDR0'  __IO_RDR0
   `#define' `__IO_RDR1'  __IO_RDR1

   `#define' `__IO_CNTR'  __IO_CNTR
   `#define' `__IO_TRD'  __IO_TRD

   `#define' `__IO_TMDR0L'  __IO_TMDR0L
   `#define' `__IO_TMDR0H'  __IO_TMDR0H
   `#define' `__IO_RLDR0L'  __IO_RLDR0L
   `#define' `__IO_RLDR0H'  __IO_RLDR0H
   `#define' `__IO_TCR'  __IO_TCR
   `#define' `__IO_TMDR1L'  __IO_TMDR1L
   `#define' `__IO_TMDR1H'  __IO_TMDR1H
   `#define' `__IO_RLDR1L'  __IO_RLDR1L
   `#define' `__IO_RLDR1H'  __IO_RLDR1H

   `#define' `__IO_FRC'  __IO_FRC

   `#define' `__IO_SAR0L'  __IO_SAR0L
   `#define' `__IO_SAR0H'  __IO_SAR0H
   `#define' `__IO_SAR0B'  __IO_SAR0B
   `#define' `__IO_DAR0L'  __IO_DAR0L
   `#define' `__IO_DAR0H'  __IO_DAR0H
   `#define' `__IO_DAR0B'  __IO_DAR0B
   `#define' `__IO_BCR0L'  __IO_BCR0L
   `#define' `__IO_BCR0H'  __IO_BCR0H
   `#define' `__IO_MAR1L'  __IO_MAR1L
   `#define' `__IO_MAR1H'  __IO_MAR1H
   `#define' `__IO_MAR1B'  __IO_MAR1B
   `#define' `__IO_IAR1L'  __IO_IAR1L
   `#define' `__IO_IAR1H'  __IO_IAR1H
   `#define' `__IO_BCR1L'  __IO_BCR1L
   `#define' `__IO_BCR1H'  __IO_BCR1H
   `#define' `__IO_DSTAT'  __IO_DSTAT
   `#define' `__IO_DMODE'  __IO_DMODE
   `#define' `__IO_DCNTL'  __IO_DCNTL

   `#define' `__IO_IL'  __IO_IL
   `#define' `__IO_ITC'  __IO_ITC

   `#define' `__IO_RCR'  __IO_RCR

   `#define' `__IO_CBR'  __IO_CBR
   `#define' `__IO_BBR'  __IO_BBR
   `#define' `__IO_CBAR'  __IO_CBAR

   `#define' `__IO_OMCR'  __IO_OMCR
   `#define' `__IO_ICR'  __IO_ICR
',
`
   // Z8S180 / Z8L180 CLASS

   `#define' `__IO_CNTLA0'  __IO_CNTLA0
   `#define' `__IO_CNTLA1'  __IO_CNTLA1
   `#define' `__IO_CNTLB0'  __IO_CNTLB0
   `#define' `__IO_CNTLB1'  __IO_CNTLB1
   `#define' `__IO_STAT0'  __IO_STAT0
   `#define' `__IO_STAT1'  __IO_STAT1
   `#define' `__IO_TDR0'  __IO_TDR0
   `#define' `__IO_TDR1'  __IO_TDR1
   `#define' `__IO_RDR0'  __IO_RDR0
   `#define' `__IO_RDR1'  __IO_RDR1
   `#define' `__IO_ASEXT0'  __IO_ASEXT0
   `#define' `__IO_ASEXT1'  __IO_ASEXT1
   `#define' `__IO_ASTC0L'  __IO_ASTC0L
   `#define' `__IO_ASTC0H'  __IO_ASTC0H
   `#define' `__IO_ASTC1L'  __IO_ASTC1L
   `#define' `__IO_ASTC1H'  __IO_ASTC1H

   `#define' `__IO_CNTR'  __IO_CNTR
   `#define' `__IO_TRD'  __IO_TRD

   `#define' `__IO_TMDR0L'  __IO_TMDR0L
   `#define' `__IO_TMDR0H'  __IO_TMDR0H
   `#define' `__IO_RLDR0L'  __IO_RLDR0L
   `#define' `__IO_RLDR0H'  __IO_RLDR0H
   `#define' `__IO_TCR'  __IO_TCR
   `#define' `__IO_TMDR1L'  __IO_TMDR1L
   `#define' `__IO_TMDR1H'  __IO_TMDR1H
   `#define' `__IO_RLDR1L'  __IO_RLDR1L
   `#define' `__IO_RLDR1H'  __IO_RLDR1H

   `#define' `__IO_FRC'  __IO_FRC
   `#define' `__IO_CMR'  __IO_CMR
   `#define' `__IO_CCR'  __IO_CCR

   `#define' `__IO_SAR0L'  __IO_SAR0L
   `#define' `__IO_SAR0H'  __IO_SAR0H
   `#define' `__IO_SAR0B'  __IO_SAR0B
   `#define' `__IO_DAR0L'  __IO_DAR0L
   `#define' `__IO_DAR0H'  __IO_DAR0H
   `#define' `__IO_DAR0B'  __IO_DAR0B
   `#define' `__IO_BCR0L'  __IO_BCR0L
   `#define' `__IO_BCR0H'  __IO_BCR0H
   `#define' `__IO_MAR1L'  __IO_MAR1L
   `#define' `__IO_MAR1H'  __IO_MAR1H
   `#define' `__IO_MAR1B'  __IO_MAR1B
   `#define' `__IO_IAR1L'  __IO_IAR1L
   `#define' `__IO_IAR1H'  __IO_IAR1H
   `#define' `__IO_IAR1B'  __IO_IAR1B
   `#define' `__IO_BCR1L'  __IO_BCR1L
   `#define' `__IO_BCR1H'  __IO_BCR1H
   `#define' `__IO_DSTAT'  __IO_DSTAT
   `#define' `__IO_DMODE'  __IO_DMODE
   `#define' `__IO_DCNTL'  __IO_DCNTL

   `#define' `__IO_IL'  __IO_IL
   `#define' `__IO_ITC'  __IO_ITC

   `#define' `__IO_RCR'  __IO_RCR

   `#define' `__IO_CBR'  __IO_CBR
   `#define' `__IO_BBR'  __IO_BBR
   `#define' `__IO_CBAR'  __IO_CBAR

   `#define' `__IO_OMCR'  __IO_OMCR
   `#define' `__IO_ICR'  __IO_ICR
')
')
