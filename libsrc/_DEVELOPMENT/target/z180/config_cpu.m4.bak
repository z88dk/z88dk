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

   define(`__CNTLA0', eval(__IO_BASE_ADDRESS + 0x00))
   define(`__CNTLA1', eval(__IO_BASE_ADDRESS + 0x01))
   define(`__CNTLB0', eval(__IO_BASE_ADDRESS + 0x02))
   define(`__CNTLB1', eval(__IO_BASE_ADDRESS + 0x03))
   define(`__STAT0', eval(__IO_BASE_ADDRESS + 0x04))
   define(`__STAT1', eval(__IO_BASE_ADDRESS + 0x05))
   define(`__TDR0', eval(__IO_BASE_ADDRESS + 0x06))
   define(`__TDR1', eval(__IO_BASE_ADDRESS + 0x07))
   define(`__RDR0', eval(__IO_BASE_ADDRESS + 0x08))
   define(`__RDR1', eval(__IO_BASE_ADDRESS + 0x09))

   # CSI/O

   define(`__CNTR', eval(__IO_BASE_ADDRESS + 0x0a))
   define(`__TRD', eval(__IO_BASE_ADDRESS + 0x0b))

   # Timer

   define(`__TMDR0L', eval(__IO_BASE_ADDRESS + 0x0c))
   define(`__TMDR0H', eval(__IO_BASE_ADDRESS + 0x0d))
   define(`__RLDR0L', eval(__IO_BASE_ADDRESS + 0x0e))
   define(`__RLDR0H', eval(__IO_BASE_ADDRESS + 0x0f))
   define(`__TCR', eval(__IO_BASE_ADDRESS + 0x10))
   define(`__TMDR1L', eval(__IO_BASE_ADDRESS + 0x14))
   define(`__TMDR1H', eval(__IO_BASE_ADDRESS + 0x15))
   define(`__RLDR1L', eval(__IO_BASE_ADDRESS + 0x16))
   define(`__RLDR1H', eval(__IO_BASE_ADDRESS + 0x17))

   # Others

   define(`__FRC', eval(__IO_BASE_ADDRESS + 0x18))

   # DMA

   define(`__SAR0L', eval(__IO_BASE_ADDRESS + 0x20))
   define(`__SAR0H', eval(__IO_BASE_ADDRESS + 0x21))
   define(`__SAR0B', eval(__IO_BASE_ADDRESS + 0x22))
   define(`__DAR0L', eval(__IO_BASE_ADDRESS + 0x23))
   define(`__DAR0H', eval(__IO_BASE_ADDRESS + 0x24))
   define(`__DAR0B', eval(__IO_BASE_ADDRESS + 0x25))
   define(`__BCR0L', eval(__IO_BASE_ADDRESS + 0x26))
   define(`__BCR0H', eval(__IO_BASE_ADDRESS + 0x27))
   define(`__MAR1L', eval(__IO_BASE_ADDRESS + 0x28))
   define(`__MAR1H', eval(__IO_BASE_ADDRESS + 0x29))
   define(`__MAR1B', eval(__IO_BASE_ADDRESS + 0x2a))
   define(`__IAR1L', eval(__IO_BASE_ADDRESS + 0x2b))
   define(`__IAR1H', eval(__IO_BASE_ADDRESS + 0x2c))
   define(`__BCR1L', eval(__IO_BASE_ADDRESS + 0x2e))
   define(`__BCR1H', eval(__IO_BASE_ADDRESS + 0x2f))
   define(`__DSTAT', eval(__IO_BASE_ADDRESS + 0x30))
   define(`__DMODE', eval(__IO_BASE_ADDRESS + 0x31))
   define(`__DCNTL', eval(__IO_BASE_ADDRESS + 0x32))

   # INT

   define(`__IL', eval(__IO_BASE_ADDRESS + 0x33))
   define(`__ITC', eval(__IO_BASE_ADDRESS + 0x34))

   # Refresh

   define(`__RCR', eval(__IO_BASE_ADDRESS + 0x36))

   # MMU

   define(`__CBR', eval(__IO_BASE_ADDRESS + 0x38))
   define(`__BBR', eval(__IO_BASE_ADDRESS + 0x39))
   define(`__CBAR', eval(__IO_BASE_ADDRESS + 0x3a))

   # I/O

   define(`__OMCR', eval(__IO_BASE_ADDRESS + 0x3e))
   define(`__ICR', eval(__IO_BASE_ADDRESS + 0x3f))
',
`
   # Z8S180 / Z8L180 CLASS
   # I/O Addresses for Internal Peripherals

   # ASCI

   define(`__CNTLA0', eval(__IO_BASE_ADDRESS + 0x00))
   define(`__CNTLA1', eval(__IO_BASE_ADDRESS + 0x01))
   define(`__CNTLB0', eval(__IO_BASE_ADDRESS + 0x02))
   define(`__CNTLB1', eval(__IO_BASE_ADDRESS + 0x03))
   define(`__STAT0', eval(__IO_BASE_ADDRESS + 0x04))
   define(`__STAT1', eval(__IO_BASE_ADDRESS + 0x05))
   define(`__TDR0', eval(__IO_BASE_ADDRESS + 0x06))
   define(`__TDR1', eval(__IO_BASE_ADDRESS + 0x07))
   define(`__RDR0', eval(__IO_BASE_ADDRESS + 0x08))
   define(`__RDR1', eval(__IO_BASE_ADDRESS + 0x09))
   define(`__ASEXT0', eval(__IO_BASE_ADDRESS + 0x12))
   define(`__ASEXT1', eval(__IO_BASE_ADDRESS + 0x13))
   define(`__ASTC0L', eval(__IO_BASE_ADDRESS + 0x1a))
   define(`__ASTC0H', eval(__IO_BASE_ADDRESS + 0x1b))
   define(`__ASTC1L', eval(__IO_BASE_ADDRESS + 0x1c))
   define(`__ASTC1H', eval(__IO_BASE_ADDRESS + 0x1d))

   # CSI/O

   define(`__CNTR', eval(__IO_BASE_ADDRESS + 0x0a))
   define(`__TRD', eval(__IO_BASE_ADDRESS + 0x0b))

   # Timer

   define(`__TMDR0L', eval(__IO_BASE_ADDRESS + 0x0c))
   define(`__TMDR0H', eval(__IO_BASE_ADDRESS + 0x0d))
   define(`__RLDR0L', eval(__IO_BASE_ADDRESS + 0x0e))
   define(`__RLDR0H', eval(__IO_BASE_ADDRESS + 0x0f))
   define(`__TCR', eval(__IO_BASE_ADDRESS + 0x10))
   define(`__TMDR1L', eval(__IO_BASE_ADDRESS + 0x14))
   define(`__TMDR1H', eval(__IO_BASE_ADDRESS + 0x15))
   define(`__RLDR1L', eval(__IO_BASE_ADDRESS + 0x16))
   define(`__RLDR1H', eval(__IO_BASE_ADDRESS + 0x17))

   # Others

   define(`__FRC', eval(__IO_BASE_ADDRESS + 0x18))
   define(`__CMR', eval(__IO_BASE_ADDRESS + 0x1e))
   define(`__CCR', eval(__IO_BASE_ADDRESS + 0x1f))

   # DMA

   define(`__SAR0L', eval(__IO_BASE_ADDRESS + 0x20))
   define(`__SAR0H', eval(__IO_BASE_ADDRESS + 0x21))
   define(`__SAR0B', eval(__IO_BASE_ADDRESS + 0x22))
   define(`__DAR0L', eval(__IO_BASE_ADDRESS + 0x23))
   define(`__DAR0H', eval(__IO_BASE_ADDRESS + 0x24))
   define(`__DAR0B', eval(__IO_BASE_ADDRESS + 0x25))
   define(`__BCR0L', eval(__IO_BASE_ADDRESS + 0x26))
   define(`__BCR0H', eval(__IO_BASE_ADDRESS + 0x27))
   define(`__MAR1L', eval(__IO_BASE_ADDRESS + 0x28))
   define(`__MAR1H', eval(__IO_BASE_ADDRESS + 0x29))
   define(`__MAR1B', eval(__IO_BASE_ADDRESS + 0x2a))
   define(`__IAR1L', eval(__IO_BASE_ADDRESS + 0x2b))
   define(`__IAR1H', eval(__IO_BASE_ADDRESS + 0x2c))
   define(`__IAR1B', eval(__IO_BASE_ADDRESS + 0x2d))
   define(`__BCR1L', eval(__IO_BASE_ADDRESS + 0x2e))
   define(`__BCR1H', eval(__IO_BASE_ADDRESS + 0x2f))
   define(`__DSTAT', eval(__IO_BASE_ADDRESS + 0x30))
   define(`__DMODE', eval(__IO_BASE_ADDRESS + 0x31))
   define(`__DCNTL', eval(__IO_BASE_ADDRESS + 0x32))

   # INT

   define(`__IL', eval(__IO_BASE_ADDRESS + 0x33))
   define(`__ITC', eval(__IO_BASE_ADDRESS + 0x34))

   # Refresh

   define(`__RCR', eval(__IO_BASE_ADDRESS + 0x36))

   # MMU

   define(`__CBR', eval(__IO_BASE_ADDRESS + 0x38))
   define(`__BBR', eval(__IO_BASE_ADDRESS + 0x39))
   define(`__CBAR', eval(__IO_BASE_ADDRESS + 0x3a))

   # I/O

   define(`__OMCR', eval(__IO_BASE_ADDRESS + 0x3e))
   define(`__ICR', eval(__IO_BASE_ADDRESS + 0x3f))
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

   defc `CNTLA0' = __CNTLA0
   defc `CNTLA1' = __CNTLA1
   defc `CNTLB0' = __CNTLB0
   defc `CNTLB1' = __CNTLB1
   defc `STAT0' = __STAT0
   defc `STAT1' = __STAT1
   defc `TDR0' = __TDR0
   defc `TDR1' = __TDR1
   defc `RDR0' = __RDR0
   defc `RDR1' = __RDR1

   defc `CNTR' = __CNTR
   defc `TRD' = __TRD

   defc `TMDR0L' = __TMDR0L
   defc `TMDR0H' = __TMDR0H
   defc `RLDR0L' = __RLDR0L
   defc `RLDR0H' = __RLDR0H
   defc `TCR' = __TCR
   defc `TMDR1L' = __TMDR1L
   defc `TMDR1H' = __TMDR1H
   defc `RLDR1L' = __RLDR1L
   defc `RLDR1H' = __RLDR1H

   defc `FRC' = __FRC

   defc `SAR0L' = __SAR0L
   defc `SAR0H' = __SAR0H
   defc `SAR0B' = __SAR0B
   defc `DAR0L' = __DAR0L
   defc `DAR0H' = __DAR0H
   defc `DAR0B' = __DAR0B
   defc `BCR0L' = __BCR0L
   defc `BCR0H' = __BCR0H
   defc `MAR1L' = __MAR1L
   defc `MAR1H' = __MAR1H
   defc `MAR1B' = __MAR1B
   defc `IAR1L' = __IAR1L
   defc `IAR1H' = __IAR1H
   defc `BCR1L' = __BCR1L
   defc `BCR1H' = __BCR1H
   defc `DSTAT' = __DSTAT
   defc `DMODE' = __DMODE
   defc `DCNTL' = __DCNTL

   defc `IL' = __IL
   defc `ITC' = __ITC

   defc `RCR' = __RCR

   defc `CBR' = __CBR
   defc `BBR' = __BBR
   defc `CBAR' = __CBAR

   defc `OMCR' = __OMCR
   defc `ICR' = __ICR
',
`
   ; Z8S180 / Z8L180 CLASS

   defc `CNTLA0' = __CNTLA0
   defc `CNTLA1' = __CNTLA1
   defc `CNTLB0' = __CNTLB0
   defc `CNTLB1' = __CNTLB1
   defc `STAT0' = __STAT0
   defc `STAT1' = __STAT1
   defc `TDR0' = __TDR0
   defc `TDR1' = __TDR1
   defc `RDR0' = __RDR0
   defc `RDR1' = __RDR1
   defc `ASEXT0' = __ASEXT0
   defc `ASEXT1' = __ASEXT1
   defc `ASTC0L' = __ASTC0L
   defc `ASTC0H' = __ASTC0H
   defc `ASTC1L' = __ASTC1L
   defc `ASTC1H' = __ASTC1H

   defc `CNTR' = __CNTR
   defc `TRD' = __TRD

   defc `TMDR0L' = __TMDR0L
   defc `TMDR0H' = __TMDR0H
   defc `RLDR0L' = __RLDR0L
   defc `RLDR0H' = __RLDR0H
   defc `TCR' = __TCR
   defc `TMDR1L' = __TMDR1L
   defc `TMDR1H' = __TMDR1H
   defc `RLDR1L' = __RLDR1L
   defc `RLDR1H' = __RLDR1H

   defc `FRC' = __FRC
   defc `CMR' = __CMR
   defc `CCR' = __CCR

   defc `SAR0L' = __SAR0L
   defc `SAR0H' = __SAR0H
   defc `SAR0B' = __SAR0B
   defc `DAR0L' = __DAR0L
   defc `DAR0H' = __DAR0H
   defc `DAR0B' = __DAR0B
   defc `BCR0L' = __BCR0L
   defc `BCR0H' = __BCR0H
   defc `MAR1L' = __MAR1L
   defc `MAR1H' = __MAR1H
   defc `MAR1B' = __MAR1B
   defc `IAR1L' = __IAR1L
   defc `IAR1H' = __IAR1H
   defc `IAR1B' = __IAR1B
   defc `BCR1L' = __BCR1L
   defc `BCR1H' = __BCR1H
   defc `DSTAT' = __DSTAT
   defc `DMODE' = __DMODE
   defc `DCNTL' = __DCNTL

   defc `IL' = __IL
   defc `ITC' = __ITC

   defc `RCR' = __RCR

   defc `CBR' = __CBR
   defc `BBR' = __BBR
   defc `CBAR' = __CBAR

   defc `OMCR' = __OMCR
   defc `ICR' = __ICR
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

#ifdef __SCCZ80

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   ; Z80180 CLASS

   `#define' `CNTLA0'  __CNTLA0
   `#define' `CNTLA1'  __CNTLA1
   `#define' `CNTLB0'  __CNTLB0
   `#define' `CNTLB1'  __CNTLB1
   `#define' `STAT0'  __STAT0
   `#define' `STAT1'  __STAT1
   `#define' `TDR0'  __TDR0
   `#define' `TDR1'  __TDR1
   `#define' `RDR0'  __RDR0
   `#define' `RDR1'  __RDR1

   `#define' `CNTR'  __CNTR
   `#define' `TRD'  __TRD

   `#define' `TMDR0L'  __TMDR0L
   `#define' `TMDR0H'  __TMDR0H
   `#define' `RLDR0L'  __RLDR0L
   `#define' `RLDR0H'  __RLDR0H
   `#define' `TCR'  __TCR
   `#define' `TMDR1L'  __TMDR1L
   `#define' `TMDR1H'  __TMDR1H
   `#define' `RLDR1L'  __RLDR1L
   `#define' `RLDR1H'  __RLDR1H

   `#define' `FRC'  __FRC

   `#define' `SAR0L'  __SAR0L
   `#define' `SAR0H'  __SAR0H
   `#define' `SAR0B'  __SAR0B
   `#define' `DAR0L'  __DAR0L
   `#define' `DAR0H'  __DAR0H
   `#define' `DAR0B'  __DAR0B
   `#define' `BCR0L'  __BCR0L
   `#define' `BCR0H'  __BCR0H
   `#define' `MAR1L'  __MAR1L
   `#define' `MAR1H'  __MAR1H
   `#define' `MAR1B'  __MAR1B
   `#define' `IAR1L'  __IAR1L
   `#define' `IAR1H'  __IAR1H
   `#define' `BCR1L'  __BCR1L
   `#define' `BCR1H'  __BCR1H
   `#define' `DSTAT'  __DSTAT
   `#define' `DMODE'  __DMODE
   `#define' `DCNTL'  __DCNTL

   `#define' `IL'  __IL
   `#define' `ITC'  __ITC

   `#define' `RCR'  __RCR

   `#define' `CBR'  __CBR
   `#define' `BBR'  __BBR
   `#define' `CBAR'  __CBAR

   `#define' `OMCR'  __OMCR
   `#define' `ICR'  __ICR
',
`
   ; Z8S180 / Z8L180 CLASS

   `#define' `CNTLA0'  __CNTLA0
   `#define' `CNTLA1'  __CNTLA1
   `#define' `CNTLB0'  __CNTLB0
   `#define' `CNTLB1'  __CNTLB1
   `#define' `STAT0'  __STAT0
   `#define' `STAT1'  __STAT1
   `#define' `TDR0'  __TDR0
   `#define' `TDR1'  __TDR1
   `#define' `RDR0'  __RDR0
   `#define' `RDR1'  __RDR1
   `#define' `ASEXT0'  __ASEXT0
   `#define' `ASEXT1'  __ASEXT1
   `#define' `ASTC0L'  __ASTC0L
   `#define' `ASTC0H'  __ASTC0H
   `#define' `ASTC1L'  __ASTC1L
   `#define' `ASTC1H'  __ASTC1H

   `#define' `CNTR'  __CNTR
   `#define' `TRD'  __TRD

   `#define' `TMDR0L'  __TMDR0L
   `#define' `TMDR0H'  __TMDR0H
   `#define' `RLDR0L'  __RLDR0L
   `#define' `RLDR0H'  __RLDR0H
   `#define' `TCR'  __TCR
   `#define' `TMDR1L'  __TMDR1L
   `#define' `TMDR1H'  __TMDR1H
   `#define' `RLDR1L'  __RLDR1L
   `#define' `RLDR1H'  __RLDR1H

   `#define' `FRC'  __FRC
   `#define' `CMR'  __CMR
   `#define' `CCR'  __CCR

   `#define' `SAR0L'  __SAR0L
   `#define' `SAR0H'  __SAR0H
   `#define' `SAR0B'  __SAR0B
   `#define' `DAR0L'  __DAR0L
   `#define' `DAR0H'  __DAR0H
   `#define' `DAR0B'  __DAR0B
   `#define' `BCR0L'  __BCR0L
   `#define' `BCR0H'  __BCR0H
   `#define' `MAR1L'  __MAR1L
   `#define' `MAR1H'  __MAR1H
   `#define' `MAR1B'  __MAR1B
   `#define' `IAR1L'  __IAR1L
   `#define' `IAR1H'  __IAR1H
   `#define' `IAR1B'  __IAR1B
   `#define' `BCR1L'  __BCR1L
   `#define' `BCR1H'  __BCR1H
   `#define' `DSTAT'  __DSTAT
   `#define' `DMODE'  __DMODE
   `#define' `DCNTL'  __DCNTL

   `#define' `IL'  __IL
   `#define' `ITC'  __ITC

   `#define' `RCR'  __RCR

   `#define' `CBR'  __CBR
   `#define' `BBR'  __BBR
   `#define' `CBAR'  __CBAR

   `#define' `OMCR'  __OMCR
   `#define' `ICR'  __ICR
')

ENDIF

IFDEF __SDCC

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   ; Z80180 CLASS

   __sfr __at __CNTLA0 `CNTLA0';
   __sfr __at __CNTLA1 `CNTLA1';
   __sfr __at __CNTLB0 `CNTLB0';
   __sfr __at __CNTLB1 `CNTLB1';
   __sfr __at __STAT0 `STAT0';
   __sfr __at __STAT1 `STAT1';
   __sfr __at __TDR0 `TDR0';
   __sfr __at __TDR1 `TDR1';
   __sfr __at __RDR0 `RDR0';
   __sfr __at __RDR1 `RDR1';

   __sfr __at __CNTR `CNTR';
   __sfr __at __TRD `TRD';

   __sfr __at __TMDR0L `TMDR0L';
   __sfr __at __TMDR0H `TMDR0H';
   __sfr __at __RLDR0L `RLDR0L';
   __sfr __at __RLDR0H `RLDR0H';
   __sfr __at __TCR `TCR';
   __sfr __at __TMDR1L `TMDR1L';
   __sfr __at __TMDR1H `TMDR1H';
   __sfr __at __RLDR1L `RLDR1L';
   __sfr __at __RLDR1H `RLDR1H';

   __sfr __at __FRC `FRC';

   __sfr __at __SAR0L `SAR0L';
   __sfr __at __SAR0H `SAR0H';
   __sfr __at __SAR0B `SAR0B';
   __sfr __at __DAR0L `DAR0L';
   __sfr __at __DAR0H `DAR0H';
   __sfr __at __DAR0B `DAR0B';
   __sfr __at __BCR0L `BCR0L';
   __sfr __at __BCR0H `BCR0H';
   __sfr __at __MAR1L `MAR1L';
   __sfr __at __MAR1H `MAR1H';
   __sfr __at __MAR1B `MAR1B';
   __sfr __at __IAR1L `IAR1L';
   __sfr __at __IAR1H `IAR1H';
   __sfr __at __BCR1L `BCR1L';
   __sfr __at __BCR1H `BCR1H';
   __sfr __at __DSTAT `DSTAT';
   __sfr __at __DMODE `DMODE';
   __sfr __at __DCNTL `DCNTL';

   __sfr __at __IL `IL';
   __sfr __at __ITC `ITC';

   __sfr __at __RCR `RCR';

   __sfr __at __CBR `CBR';
   __sfr __at __BBR `BBR';
   __sfr __at __CBAR `CBAR';

   __sfr __at __OMCR `OMCR';
   __sfr __at __ICR `ICR';
',
`
   ; Z8S180 / Z8L180 CLASS

   __sfr __at __CNTLA0 `CNTLA0';
   __sfr __at __CNTLA1 `CNTLA1';
   __sfr __at __CNTLB0 `CNTLB0';
   __sfr __at __CNTLB1 `CNTLB1';
   __sfr __at __STAT0 `STAT0';
   __sfr __at __STAT1 `STAT1';
   __sfr __at __TDR0 `TDR0';
   __sfr __at __TDR1 `TDR1';
   __sfr __at __RDR0 `RDR0';
   __sfr __at __RDR1 `RDR1';
   __sfr __at __ASEXT0 `ASEXT0';
   __sfr __at __ASEXT1 `ASEXT1';
   __sfr __at __ASTC0L `ASTC0L';
   __sfr __at __ASTC0H `ASTC0H';
   __sfr __at __ASTC1L `ASTC1L';
   __sfr __at __ASTC1H `ASTC1H';

   __sfr __at __CNTR `CNTR';
   __sfr __at __TRD `TRD';

   __sfr __at __TMDR0L `TMDR0L';
   __sfr __at __TMDR0H `TMDR0H';
   __sfr __at __RLDR0L `RLDR0L';
   __sfr __at __RLDR0H `RLDR0H';
   __sfr __at __TCR `TCR';
   __sfr __at __TMDR1L `TMDR1L';
   __sfr __at __TMDR1H `TMDR1H';
   __sfr __at __RLDR1L `RLDR1L';
   __sfr __at __RLDR1H `RLDR1H';

   __sfr __at __FRC `FRC';
   __sfr __at __CMR `CMR';
   __sfr __at __CCR `CCR';

   __sfr __at __SAR0L `SAR0L';
   __sfr __at __SAR0H `SAR0H';
   __sfr __at __SAR0B `SAR0B';
   __sfr __at __DAR0L `DAR0L';
   __sfr __at __DAR0H `DAR0H';
   __sfr __at __DAR0B `DAR0B';
   __sfr __at __BCR0L `BCR0L';
   __sfr __at __BCR0H `BCR0H';
   __sfr __at __MAR1L `MAR1L';
   __sfr __at __MAR1H `MAR1H';
   __sfr __at __MAR1B `MAR1B';
   __sfr __at __IAR1L `IAR1L';
   __sfr __at __IAR1H `IAR1H';
   __sfr __at __IAR1B `IAR1B';
   __sfr __at __BCR1L `BCR1L';
   __sfr __at __BCR1H `BCR1H';
   __sfr __at __DSTAT `DSTAT';
   __sfr __at __DMODE `DMODE';
   __sfr __at __DCNTL `DCNTL';

   __sfr __at __IL `IL';
   __sfr __at __ITC `ITC';

   __sfr __at __RCR `RCR';

   __sfr __at __CBR `CBR';
   __sfr __at __BBR `BBR';
   __sfr __at __CBAR `CBAR';

   __sfr __at __OMCR `OMCR';
   __sfr __at __ICR `ICR';
')

ENDIF
')
