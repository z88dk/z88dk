divert(-1)

###############################################################
# Z180 CPU CONFIGURATION
# rebuild the library if changes are made
#

# Class of Z180 being targeted

define(`__Z180', 0x04)

define(`__Z180_Z80180', 0x01)
define(`__Z180_Z8L180', 0x02)
define(`__Z180_Z8S180', 0x04)

# CPU info

define(`__CPU_INFO', 0x00)

define(`__CPU_INFO_ENABLE_SLL', 0x01)

define(`__CPU_TIMER_SCALE', 20)

ifelse(eval((__Z180 & __Z180_Z80180) != 0), 1,
`
   # Z80180 CLASS
   # I/O Addresses for Internal Peripherals

   # ASCI

   define(`__IO_CNTLA0', 0x`'eval(__IO_BASE_ADDRESS + 0x00,16))
   define(`__IO_CNTLA1', 0x`'eval(__IO_BASE_ADDRESS + 0x01,16))
   define(`__IO_CNTLB0', 0x`'eval(__IO_BASE_ADDRESS + 0x02,16))
   define(`__IO_CNTLB1', 0x`'eval(__IO_BASE_ADDRESS + 0x03,16))
   define(`__IO_STAT0', 0x`'eval(__IO_BASE_ADDRESS + 0x04,16))
   define(`__IO_STAT1', 0x`'eval(__IO_BASE_ADDRESS + 0x05,16))
   define(`__IO_TDR0', 0x`'eval(__IO_BASE_ADDRESS + 0x06,16))
   define(`__IO_TDR1', 0x`'eval(__IO_BASE_ADDRESS + 0x07,16))
   define(`__IO_RDR0', 0x`'eval(__IO_BASE_ADDRESS + 0x08,16))
   define(`__IO_RDR1', 0x`'eval(__IO_BASE_ADDRESS + 0x09,16))

   # CSI/O

   define(`__IO_CNTR', 0x`'eval(__IO_BASE_ADDRESS + 0x0a,16))
   define(`__IO_TRDR', 0x`'eval(__IO_BASE_ADDRESS + 0x0b,16))

   # Timer

   define(`__IO_TMDR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x0c,16))
   define(`__IO_TMDR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x0d,16))
   define(`__IO_RLDR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x0e,16))
   define(`__IO_RLDR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x0f,16))
   define(`__IO_TCR', 0x`'eval(__IO_BASE_ADDRESS + 0x10,16))
   define(`__IO_TMDR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x14,16))
   define(`__IO_TMDR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x15,16))
   define(`__IO_RLDR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x16,16))
   define(`__IO_RLDR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x17,16))

   # Others

   define(`__IO_FRC', 0x`'eval(__IO_BASE_ADDRESS + 0x18,16))

   # DMA

   define(`__IO_SAR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x20,16))
   define(`__IO_SAR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x21,16))
   define(`__IO_SAR0B', 0x`'eval(__IO_BASE_ADDRESS + 0x22,16))
   define(`__IO_DAR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x23,16))
   define(`__IO_DAR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x24,16))
   define(`__IO_DAR0B', 0x`'eval(__IO_BASE_ADDRESS + 0x25,16))
   define(`__IO_BCR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x26,16))
   define(`__IO_BCR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x27,16))
   define(`__IO_MAR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x28,16))
   define(`__IO_MAR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x29,16))
   define(`__IO_MAR1B', 0x`'eval(__IO_BASE_ADDRESS + 0x2a,16))
   define(`__IO_IAR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x2b,16))
   define(`__IO_IAR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x2c,16))
   define(`__IO_BCR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x2e,16))
   define(`__IO_BCR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x2f,16))
   define(`__IO_DSTAT', 0x`'eval(__IO_BASE_ADDRESS + 0x30,16))
   define(`__IO_DMODE', 0x`'eval(__IO_BASE_ADDRESS + 0x31,16))
   define(`__IO_DCNTL', 0x`'eval(__IO_BASE_ADDRESS + 0x32,16))

   # INT

   define(`__IO_IL', 0x`'eval(__IO_BASE_ADDRESS + 0x33,16))
   define(`__IO_ITC', 0x`'eval(__IO_BASE_ADDRESS + 0x34,16))

   # Refresh

   define(`__IO_RCR', 0x`'eval(__IO_BASE_ADDRESS + 0x36,16))

   # MMU

   define(`__IO_CBR', 0x`'eval(__IO_BASE_ADDRESS + 0x38,16))
   define(`__IO_BBR', 0x`'eval(__IO_BASE_ADDRESS + 0x39,16))
   define(`__IO_CBAR', 0x`'eval(__IO_BASE_ADDRESS + 0x3a,16))

   # I/O

   define(`__IO_OMCR', 0x`'eval(__IO_BASE_ADDRESS + 0x3e,16))
   define(`__IO_ICR', 0x`'eval(0x3f,16))
',
`
   # Z8S180 / Z8L180 CLASS
   # I/O Addresses for Internal Peripherals

   # ASCI

   define(`__IO_CNTLA0', 0x`'eval(__IO_BASE_ADDRESS + 0x00,16))
   define(`__IO_CNTLA1', 0x`'eval(__IO_BASE_ADDRESS + 0x01,16))
   define(`__IO_CNTLB0', 0x`'eval(__IO_BASE_ADDRESS + 0x02,16))
   define(`__IO_CNTLB1', 0x`'eval(__IO_BASE_ADDRESS + 0x03,16))
   define(`__IO_STAT0', 0x`'eval(__IO_BASE_ADDRESS + 0x04,16))
   define(`__IO_STAT1', 0x`'eval(__IO_BASE_ADDRESS + 0x05,16))
   define(`__IO_TDR0', 0x`'eval(__IO_BASE_ADDRESS + 0x06,16))
   define(`__IO_TDR1', 0x`'eval(__IO_BASE_ADDRESS + 0x07,16))
   define(`__IO_RDR0', 0x`'eval(__IO_BASE_ADDRESS + 0x08,16))
   define(`__IO_RDR1', 0x`'eval(__IO_BASE_ADDRESS + 0x09,16))
   define(`__IO_ASEXT0', 0x`'eval(__IO_BASE_ADDRESS + 0x12,16))
   define(`__IO_ASEXT1', 0x`'eval(__IO_BASE_ADDRESS + 0x13,16))
   define(`__IO_ASTC0L', 0x`'eval(__IO_BASE_ADDRESS + 0x1a,16))
   define(`__IO_ASTC0H', 0x`'eval(__IO_BASE_ADDRESS + 0x1b,16))
   define(`__IO_ASTC1L', 0x`'eval(__IO_BASE_ADDRESS + 0x1c,16))
   define(`__IO_ASTC1H', 0x`'eval(__IO_BASE_ADDRESS + 0x1d,16))

   # CSI/O

   define(`__IO_CNTR', 0x`'eval(__IO_BASE_ADDRESS + 0x0a,16))
   define(`__IO_TRDR', 0x`'eval(__IO_BASE_ADDRESS + 0x0b,16))

   # Timer

   define(`__IO_TMDR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x0c,16))
   define(`__IO_TMDR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x0d,16))
   define(`__IO_RLDR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x0e,16))
   define(`__IO_RLDR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x0f,16))
   define(`__IO_TCR', 0x`'eval(__IO_BASE_ADDRESS + 0x10,16))
   define(`__IO_TMDR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x14,16))
   define(`__IO_TMDR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x15,16))
   define(`__IO_RLDR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x16,16))
   define(`__IO_RLDR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x17,16))

   # Others

   define(`__IO_FRC', 0x`'eval(__IO_BASE_ADDRESS + 0x18,16))
   define(`__IO_CMR', 0x`'eval(__IO_BASE_ADDRESS + 0x1e,16))
   define(`__IO_CCR', 0x`'eval(__IO_BASE_ADDRESS + 0x1f,16))

   # DMA

   define(`__IO_SAR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x20,16))
   define(`__IO_SAR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x21,16))
   define(`__IO_SAR0B', 0x`'eval(__IO_BASE_ADDRESS + 0x22,16))
   define(`__IO_DAR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x23,16))
   define(`__IO_DAR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x24,16))
   define(`__IO_DAR0B', 0x`'eval(__IO_BASE_ADDRESS + 0x25,16))
   define(`__IO_BCR0L', 0x`'eval(__IO_BASE_ADDRESS + 0x26,16))
   define(`__IO_BCR0H', 0x`'eval(__IO_BASE_ADDRESS + 0x27,16))
   define(`__IO_MAR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x28,16))
   define(`__IO_MAR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x29,16))
   define(`__IO_MAR1B', 0x`'eval(__IO_BASE_ADDRESS + 0x2a,16))
   define(`__IO_IAR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x2b,16))
   define(`__IO_IAR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x2c,16))
   define(`__IO_IAR1B', 0x`'eval(__IO_BASE_ADDRESS + 0x2d,16))
   define(`__IO_BCR1L', 0x`'eval(__IO_BASE_ADDRESS + 0x2e,16))
   define(`__IO_BCR1H', 0x`'eval(__IO_BASE_ADDRESS + 0x2f,16))
   define(`__IO_DSTAT', 0x`'eval(__IO_BASE_ADDRESS + 0x30,16))
   define(`__IO_DMODE', 0x`'eval(__IO_BASE_ADDRESS + 0x31,16))
   define(`__IO_DCNTL', 0x`'eval(__IO_BASE_ADDRESS + 0x32,16))

   # INT

   define(`__IO_IL', 0x`'eval(__IO_BASE_ADDRESS + 0x33,16))
   define(`__IO_ITC', 0x`'eval(__IO_BASE_ADDRESS + 0x34,16))

   # Refresh

   define(`__IO_RCR', 0x`'eval(__IO_BASE_ADDRESS + 0x36,16))

   # MMU

   define(`__IO_CBR', 0x`'eval(__IO_BASE_ADDRESS + 0x38,16))
   define(`__IO_BBR', 0x`'eval(__IO_BASE_ADDRESS + 0x39,16))
   define(`__IO_CBAR', 0x`'eval(__IO_BASE_ADDRESS + 0x3a,16))

   # I/O

   define(`__IO_OMCR', 0x`'eval(__IO_BASE_ADDRESS + 0x3e,16))
   define(`__IO_ICR', 0x3f)
')

# I/O REGISTER BIT FIELDS

define(`__IO_CNTLA0_MPE',       0x80)
define(`__IO_CNTLA0_RE',        0x40)
define(`__IO_CNTLA0_TE',        0x20)
define(`__IO_CNTLA0_RTS0',      0x10)
define(`__IO_CNTLA0_MPBR',      0x08)
define(`__IO_CNTLA0_EFR',       0x08)
define(`__IO_CNTLA0_MODE_MASK', 0x07)
define(`__IO_CNTLA0_MODE_8P2',  0x07)
define(`__IO_CNTLA0_MODE_8P1',  0x06)
define(`__IO_CNTLA0_MODE_8N2',  0x05)
define(`__IO_CNTLA0_MODE_8N1',  0x04)
define(`__IO_CNTLA0_MODE_7P2',  0x03)
define(`__IO_CNTLA0_MODE_7P1',  0x02)
define(`__IO_CNTLA0_MODE_7N2',  0x01)
define(`__IO_CNTLA0_MODE_7N1',  0x00)

define(`__IO_CNTLA1_MPE',       0x80)
define(`__IO_CNTLA1_RE',        0x40)
define(`__IO_CNTLA1_TE',        0x20)
define(`__IO_CNTLA1_CKA1D',     0x10)
define(`__IO_CNTLA1_MPBR',      0x08)
define(`__IO_CNTLA1_EFR',       0x08)
define(`__IO_CNTLA1_MODE_MASK', 0x07)
define(`__IO_CNTLA1_MODE_8P2',  0x07)
define(`__IO_CNTLA1_MODE_8P1',  0x06)
define(`__IO_CNTLA1_MODE_8N2',  0x05)
define(`__IO_CNTLA1_MODE_8N1',  0x04)
define(`__IO_CNTLA1_MODE_7P2',  0x03)
define(`__IO_CNTLA1_MODE_7P1',  0x02)
define(`__IO_CNTLA1_MODE_7N2',  0x01)
define(`__IO_CNTLA1_MODE_7N1',  0x00)

define(`__IO_CNTLB0_MPBT',      0x80)
define(`__IO_CNTLB0_MP',        0x40)
define(`__IO_CNTLB0_CTS',       0x20)
define(`__IO_CNTLB0_PS',        0x20)
define(`__IO_CNTLB0_PEO',       0x10)
define(`__IO_CNTLB0_DR',        0x08)
define(`__IO_CNTLB0_SS_MASK',   0x07)
define(`__IO_CNTLB0_SS_EXT',    0x07)
define(`__IO_CNTLB0_SS_DIV_64', 0x06)
define(`__IO_CNTLB0_SS_DIV_32', 0x05)
define(`__IO_CNTLB0_SS_DIV_16', 0x04)
define(`__IO_CNTLB0_SS_DIV_8',  0x03)
define(`__IO_CNTLB0_SS_DIV_4',  0x02)
define(`__IO_CNTLB0_SS_DIV_2',  0x01)
define(`__IO_CNTLB0_SS_DIV_1',  0x00)

define(`__IO_CNTLB1_MPBT',      0x80)
define(`__IO_CNTLB1_MP',        0x40)
define(`__IO_CNTLB1_CTS',       0x20)
define(`__IO_CNTLB1_PS',        0x20)
define(`__IO_CNTLB1_PEO',       0x10)
define(`__IO_CNTLB1_DR',        0x08)
define(`__IO_CNTLB1_SS_MASK',   0x07)
define(`__IO_CNTLB1_SS_EXT',    0x07)
define(`__IO_CNTLB1_SS_DIV_64', 0x06)
define(`__IO_CNTLB1_SS_DIV_32', 0x05)
define(`__IO_CNTLB1_SS_DIV_16', 0x04)
define(`__IO_CNTLB1_SS_DIV_8',  0x03)
define(`__IO_CNTLB1_SS_DIV_4',  0x02)
define(`__IO_CNTLB1_SS_DIV_2',  0x01)
define(`__IO_CNTLB1_SS_DIV_1',  0x00)

define(`__IO_STAT0_RDRF',       0x80)
define(`__IO_STAT0_OVRN',       0x40)
define(`__IO_STAT0_PE',         0x20)
define(`__IO_STAT0_FE',         0x10)
define(`__IO_STAT0_RIE',        0x08)
define(`__IO_STAT0_DCD0',       0x04)
define(`__IO_STAT0_TDRE',       0x02)
define(`__IO_STAT0_TIE',        0x01)

define(`__IO_STAT1_RDRF',       0x80)
define(`__IO_STAT1_OVRN',       0x40)
define(`__IO_STAT1_PE',         0x20)
define(`__IO_STAT1_FE',         0x10)
define(`__IO_STAT1_RIE',        0x08)
define(`__IO_STAT1_CTS1E',      0x04)
define(`__IO_STAT1_TDRE',       0x02)
define(`__IO_STAT1_TIE',        0x01)

define(`__IO_CNTR_EF',          0x80)
define(`__IO_CNTR_EIE',         0x40)
define(`__IO_CNTR_RE',          0x20)
define(`__IO_CNTR_TE',          0x10)
define(`__IO_CNTR_SS_MASK',     0x07)
define(`__IO_CNTR_SS_EXT',      0x07)
define(`__IO_CNTR_SS_DIV_1280', 0x06)
define(`__IO_CNTR_SS_DIV_640',  0x05)
define(`__IO_CNTR_SS_DIV_320',  0x04)
define(`__IO_CNTR_SS_DIV_160',  0x03)
define(`__IO_CNTR_SS_DIV_80',   0x02)
define(`__IO_CNTR_SS_DIV_40',   0x01)
define(`__IO_CNTR_SS_DIV_20',   0x00)

# PRT REGISTER BIT FIELDS

define(`__IO_TCR_TIF1',       0x80)
define(`__IO_TCR_TIF0',       0x40)
define(`__IO_TCR_TIE1',       0x20)
define(`__IO_TCR_TIE0',       0x10)
define(`__IO_TCR_TOC1',       0x08)
define(`__IO_TCR_TOC0',       0x04)
define(`__IO_TCR_TDE1',       0x02)
define(`__IO_TCR_TDE0',       0x01)

# DMA REGISTER BIT FIELDS

define(`__IO_DSTAT_DE1',        0x80)
define(`__IO_DSTAT_DE0',        0x40)
define(`__IO_DSTAT_DWE1',       0x20)
define(`__IO_DSTAT_DWE0',       0x10)
define(`__IO_DSTAT_DIE1',       0x08)
define(`__IO_DSTAT_DIE0',       0x04)
define(`__IO_DSTAT_DME',        0x01)

define(`__IO_DMODE_DM1',        0x20)
define(`__IO_DMODE_DM0',        0x10)
define(`__IO_DMODE_SM1',        0x08)
define(`__IO_DMODE_SM0',        0x04)
define(`__IO_DMODE_MMOD',       0x02)

define(`__IO_DCNTL_MWI1',       0x80)
define(`__IO_DCNTL_MWI0',       0x40)
define(`__IO_DCNTL_IWI1',       0x20)
define(`__IO_DCNTL_IWI0',       0x10)
define(`__IO_DCNTL_DMS1',       0x08)
define(`__IO_DCNTL_DMS0',       0x04)
define(`__IO_DCNTL_DIM1',       0x02)
define(`__IO_DCNTL_DIM0',       0x01)

# INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

define(`__IO_ITC_TRAP',         0x80)
define(`__IO_ITC_UFO',          0x40)
define(`__IO_ITC_ITE2',         0x04)
define(`__IO_ITC_ITE1',         0x02)
define(`__IO_ITC_ITE0',         0x01)

#   Refresh CONTROL REGISTER (RCR) BIT FIELDS

define(`__IO_RCR_REFE',         0x80)
define(`__IO_RCR_REFW',         0x40)
define(`__IO_RCR_CYC1',         0x02)
define(`__IO_RCR_CYC0',         0x01)

#   Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

define(`__IO_OMCR_M1E',         0x80)
define(`__IO_OMCR_M1TE',        0x40)
define(`__IO_OMCR_IOC',         0x20)

# CPU CLOCK MULTIPLIER REGISTER (CMR) BIT FIELDS (Z8S180 & higher Only)

define(`__IO_CMR_X2',           0x80)
define(`__IO_CMR_LN_XTAL',      0x40)

# CPU CONTROL REGISTER (CCR) BIT FIELDS (Z8S180 & higher Only)

define(`__IO_CCR_XTAL_X2',      0x80)
define(`__IO_CCR_STANDBY',      0x40)
define(`__IO_CCR_BREXT',        0x20)
define(`__IO_CCR_LNPHI',        0x10)
define(`__IO_CCR_IDLE',         0x08)
define(`__IO_CCR_LNIO',         0x04)
define(`__IO_CCR_LNCPUCTL',     0x02)
define(`__IO_CCR_LNAD',         0x01)

#
# END OF CONFIGURATION
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

PUBLIC `__CPU_INFO'

PUBLIC `__CPU_INFO_ENABLE_SLL'

PUBLIC `__CPU_TIMER_SCALE'

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
   PUBLIC `TRDR'

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

   ; I/O REGISTER BIT FIELDS

   PUBLIC `CNTLA0_MPE'
   PUBLIC `CNTLA0_RE'
   PUBLIC `CNTLA0_TE'
   PUBLIC `CNTLA0_RTS0'
   PUBLIC `CNTLA0_MPBR'
   PUBLIC `CNTLA0_EFR'
   PUBLIC `CNTLA0_MODE_MASK'
   PUBLIC `CNTLA0_MODE_8P2'
   PUBLIC `CNTLA0_MODE_8P1'
   PUBLIC `CNTLA0_MODE_8N2'
   PUBLIC `CNTLA0_MODE_8N1'
   PUBLIC `CNTLA0_MODE_7P2'
   PUBLIC `CNTLA0_MODE_7P1'
   PUBLIC `CNTLA0_MODE_7N2'
   PUBLIC `CNTLA0_MODE_7N1'

   PUBLIC `CNTLA1_MPE'
   PUBLIC `CNTLA1_RE'
   PUBLIC `CNTLA1_TE'
   PUBLIC `CNTLA1_CKA1D'
   PUBLIC `CNTLA1_MPBR'
   PUBLIC `CNTLA1_EFR'
   PUBLIC `CNTLA1_MODE_MASK'
   PUBLIC `CNTLA1_MODE_8P2'
   PUBLIC `CNTLA1_MODE_8P1'
   PUBLIC `CNTLA1_MODE_8N2'
   PUBLIC `CNTLA1_MODE_8N1'
   PUBLIC `CNTLA1_MODE_7P2'
   PUBLIC `CNTLA1_MODE_7P1'
   PUBLIC `CNTLA1_MODE_7N2'
   PUBLIC `CNTLA1_MODE_7N1'

   PUBLIC `CNTLB0_MPBT'
   PUBLIC `CNTLB0_MP'
   PUBLIC `CNTLB0_CTS'
   PUBLIC `CNTLB0_PS'
   PUBLIC `CNTLB0_PEO'
   PUBLIC `CNTLB0_DR'
   PUBLIC `CNTLB0_SS_MASK'
   PUBLIC `CNTLB0_SS_EXT'
   PUBLIC `CNTLB0_SS_DIV_64'
   PUBLIC `CNTLB0_SS_DIV_32'
   PUBLIC `CNTLB0_SS_DIV_16'
   PUBLIC `CNTLB0_SS_DIV_8'
   PUBLIC `CNTLB0_SS_DIV_4'
   PUBLIC `CNTLB0_SS_DIV_2'
   PUBLIC `CNTLB0_SS_DIV_1'

   PUBLIC `CNTLB1_MPBT'
   PUBLIC `CNTLB1_MP'
   PUBLIC `CNTLB1_CTS'
   PUBLIC `CNTLB1_PS'
   PUBLIC `CNTLB1_PEO'
   PUBLIC `CNTLB1_DR'
   PUBLIC `CNTLB1_SS_MASK'
   PUBLIC `CNTLB1_SS_EXT'
   PUBLIC `CNTLB1_SS_DIV_64'
   PUBLIC `CNTLB1_SS_DIV_32'
   PUBLIC `CNTLB1_SS_DIV_16'
   PUBLIC `CNTLB1_SS_DIV_8'
   PUBLIC `CNTLB1_SS_DIV_4'
   PUBLIC `CNTLB1_SS_DIV_2'
   PUBLIC `CNTLB1_SS_DIV_1'

   PUBLIC `STAT0_RDRF'
   PUBLIC `STAT0_OVRN'
   PUBLIC `STAT0_PE'
   PUBLIC `STAT0_FE'
   PUBLIC `STAT0_RIE'
   PUBLIC `STAT0_DCD0'
   PUBLIC `STAT0_TDRE'
   PUBLIC `STAT0_TIE'

   PUBLIC `STAT1_RDRF'
   PUBLIC `STAT1_OVRN'
   PUBLIC `STAT1_PE'
   PUBLIC `STAT1_FE'
   PUBLIC `STAT1_RIE'
   PUBLIC `STAT1_CTS1E'
   PUBLIC `STAT1_TDRE'
   PUBLIC `STAT1_TIE'

   PUBLIC `CNTR_EF'
   PUBLIC `CNTR_EIE'
   PUBLIC `CNTR_RE'
   PUBLIC `CNTR_TE'
   PUBLIC `CNTR_SS_MASK'
   PUBLIC `CNTR_SS_EXT'
   PUBLIC `CNTR_SS_DIV_1280'
   PUBLIC `CNTR_SS_DIV_640'
   PUBLIC `CNTR_SS_DIV_320'
   PUBLIC `CNTR_SS_DIV_160'
   PUBLIC `CNTR_SS_DIV_80'
   PUBLIC `CNTR_SS_DIV_40'
   PUBLIC `CNTR_SS_DIV_20'

   ; PRT REGISTER BIT FIELDS

   PUBLIC `TCR_TIF1'
   PUBLIC `TCR_TIF0'
   PUBLIC `TCR_TIE1'
   PUBLIC `TCR_TIE0'
   PUBLIC `TCR_TOC1'
   PUBLIC `TCR_TOC0'
   PUBLIC `TCR_TDE1'
   PUBLIC `TCR_TDE0'

   ; DMA REGISTER BIT FIELDS

   PUBLIC `DSTAT_DE1'
   PUBLIC `DSTAT_DE0'
   PUBLIC `DSTAT_DWE1'
   PUBLIC `DSTAT_DWE0'
   PUBLIC `DSTAT_DIE1'
   PUBLIC `DSTAT_DIE0'
   PUBLIC `DSTAT_DME'

   PUBLIC `DMODE_DM1'
   PUBLIC `DMODE_DM0'
   PUBLIC `DMODE_SM1'
   PUBLIC `DMODE_SM0'
   PUBLIC `DMODE_MMOD'

   PUBLIC `DCNTL_MWI1'
   PUBLIC `DCNTL_MWI0'
   PUBLIC `DCNTL_IWI1'
   PUBLIC `DCNTL_IWI0'
   PUBLIC `DCNTL_DMS1'
   PUBLIC `DCNTL_DMS0'
   PUBLIC `DCNTL_DIM1'
   PUBLIC `DCNTL_DIM0'

   ; INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   PUBLIC `ITC_TRAP'
   PUBLIC `ITC_UFO'
   PUBLIC `ITC_ITE2'
   PUBLIC `ITC_ITE1'
   PUBLIC `ITC_ITE0'

   ; Refresh CONTROL REGISTER (RCR) BIT FIELDS

   PUBLIC `RCR_REFE'
   PUBLIC `RCR_REFW'
   PUBLIC `RCR_CYC1'
   PUBLIC `RCR_CYC0'

   ; Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   PUBLIC `OMCR_M1E'
   PUBLIC `OMCR_M1TE'
   PUBLIC `OMCR_IOC'
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
   PUBLIC `TRDR'

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
   
   ; I/O REGISTER BIT FIELDS

   PUBLIC `CNTLA0_MPE'
   PUBLIC `CNTLA0_RE'
   PUBLIC `CNTLA0_TE'
   PUBLIC `CNTLA0_RTS0'
   PUBLIC `CNTLA0_MPBR'
   PUBLIC `CNTLA0_EFR'
   PUBLIC `CNTLA0_MODE_MASK'
   PUBLIC `CNTLA0_MODE_8P2'
   PUBLIC `CNTLA0_MODE_8P1'
   PUBLIC `CNTLA0_MODE_8N2'
   PUBLIC `CNTLA0_MODE_8N1'
   PUBLIC `CNTLA0_MODE_7P2'
   PUBLIC `CNTLA0_MODE_7P1'
   PUBLIC `CNTLA0_MODE_7N2'
   PUBLIC `CNTLA0_MODE_7N1'

   PUBLIC `CNTLA1_MPE'
   PUBLIC `CNTLA1_RE'
   PUBLIC `CNTLA1_TE'
   PUBLIC `CNTLA1_CKA1D'
   PUBLIC `CNTLA1_MPBR'
   PUBLIC `CNTLA1_EFR'
   PUBLIC `CNTLA1_MODE_MASK'
   PUBLIC `CNTLA1_MODE_8P2'
   PUBLIC `CNTLA1_MODE_8P1'
   PUBLIC `CNTLA1_MODE_8N2'
   PUBLIC `CNTLA1_MODE_8N1'
   PUBLIC `CNTLA1_MODE_7P2'
   PUBLIC `CNTLA1_MODE_7P1'
   PUBLIC `CNTLA1_MODE_7N2'
   PUBLIC `CNTLA1_MODE_7N1'

   PUBLIC `CNTLB0_MPBT'
   PUBLIC `CNTLB0_MP'
   PUBLIC `CNTLB0_CTS'
   PUBLIC `CNTLB0_PS'
   PUBLIC `CNTLB0_PEO'
   PUBLIC `CNTLB0_DR'
   PUBLIC `CNTLB0_SS_MASK'
   PUBLIC `CNTLB0_SS_EXT'
   PUBLIC `CNTLB0_SS_DIV_64'
   PUBLIC `CNTLB0_SS_DIV_32'
   PUBLIC `CNTLB0_SS_DIV_16'
   PUBLIC `CNTLB0_SS_DIV_8'
   PUBLIC `CNTLB0_SS_DIV_4'
   PUBLIC `CNTLB0_SS_DIV_2'
   PUBLIC `CNTLB0_SS_DIV_1'

   PUBLIC `CNTLB1_MPBT'
   PUBLIC `CNTLB1_MP'
   PUBLIC `CNTLB1_CTS'
   PUBLIC `CNTLB1_PS'
   PUBLIC `CNTLB1_PEO'
   PUBLIC `CNTLB1_DR'
   PUBLIC `CNTLB1_SS_MASK'
   PUBLIC `CNTLB1_SS_EXT'
   PUBLIC `CNTLB1_SS_DIV_64'
   PUBLIC `CNTLB1_SS_DIV_32'
   PUBLIC `CNTLB1_SS_DIV_16'
   PUBLIC `CNTLB1_SS_DIV_8'
   PUBLIC `CNTLB1_SS_DIV_4'
   PUBLIC `CNTLB1_SS_DIV_2'
   PUBLIC `CNTLB1_SS_DIV_1'

   PUBLIC `STAT0_RDRF'
   PUBLIC `STAT0_OVRN'
   PUBLIC `STAT0_PE'
   PUBLIC `STAT0_FE'
   PUBLIC `STAT0_RIE'
   PUBLIC `STAT0_DCD0'
   PUBLIC `STAT0_TDRE'
   PUBLIC `STAT0_TIE'

   PUBLIC `STAT1_RDRF'
   PUBLIC `STAT1_OVRN'
   PUBLIC `STAT1_PE'
   PUBLIC `STAT1_FE'
   PUBLIC `STAT1_RIE'
   PUBLIC `STAT1_CTS1E'
   PUBLIC `STAT1_TDRE'
   PUBLIC `STAT1_TIE'

   PUBLIC `CNTR_EF'
   PUBLIC `CNTR_EIE'
   PUBLIC `CNTR_RE'
   PUBLIC `CNTR_TE'
   PUBLIC `CNTR_SS_MASK'
   PUBLIC `CNTR_SS_EXT'
   PUBLIC `CNTR_SS_DIV_1280'
   PUBLIC `CNTR_SS_DIV_640'
   PUBLIC `CNTR_SS_DIV_320'
   PUBLIC `CNTR_SS_DIV_160'
   PUBLIC `CNTR_SS_DIV_80'
   PUBLIC `CNTR_SS_DIV_40'
   PUBLIC `CNTR_SS_DIV_20'

   ; PRT REGISTER BIT FIELDS

   PUBLIC `TCR_TIF1'
   PUBLIC `TCR_TIF0'
   PUBLIC `TCR_TIE1'
   PUBLIC `TCR_TIE0'
   PUBLIC `TCR_TOC1'
   PUBLIC `TCR_TOC0'
   PUBLIC `TCR_TDE1'
   PUBLIC `TCR_TDE0'

   ; DMA REGISTER BIT FIELDS

   PUBLIC `DCNTL_MWI1'
   PUBLIC `DCNTL_MWI0'
   PUBLIC `DCNTL_IWI1'
   PUBLIC `DCNTL_IWI0'
   PUBLIC `DCNTL_DMS1'
   PUBLIC `DCNTL_DMS0'
   PUBLIC `DCNTL_DIM1'
   PUBLIC `DCNTL_DIM0'

   ; INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   PUBLIC `ITC_TRAP'
   PUBLIC `ITC_UFO'
   PUBLIC `ITC_ITE2'
   PUBLIC `ITC_ITE1'
   PUBLIC `ITC_ITE0'

   ; Refresh CONTROL REGISTER (RCR) BIT FIELDS

   PUBLIC `RCR_REFE'
   PUBLIC `RCR_REFW'
   PUBLIC `RCR_CYC1'
   PUBLIC `RCR_CYC0'

   ; Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   PUBLIC `OMCR_M1E'
   PUBLIC `OMCR_M1TE'
   PUBLIC `OMCR_IOC'

   ; CPU CLOCK MULTIPLIER REGISTER (CMR) BIT FIELDS (Z8S180 & higher Only)

   PUBLIC `CMR_X2'
   PUBLIC `CMR_LN_XTAL'

   ; CPU CONTROL REGISTER (CCR) BIT FIELDS (Z8S180 & higher Only)

   PUBLIC `CCR_XTAL_X2'
   PUBLIC `CCR_STANDBY'
   PUBLIC `CCR_BREXT'
   PUBLIC `CCR_LNPHI'
   PUBLIC `CCR_IDLE'
   PUBLIC `CCR_LNIO'
   PUBLIC `CCR_LNCPUCTL'
   PUBLIC `CCR_LNAD'
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

defc `__CPU_INFO' = __CPU_INFO

defc `__CPU_INFO_ENABLE_SLL' = __CPU_INFO_ENABLE_SLL

defc `__CPU_TIMER_SCALE' = __CPU_TIMER_SCALE

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
   defc `TRDR' = __IO_TRDR

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

   ; I/O REGISTER BIT FIELDS

   defc `CNTLA0_MPE' = __IO_CNTLA0_MPE
   defc `CNTLA0_RE' = __IO_CNTLA0_RE
   defc `CNTLA0_TE' = __IO_CNTLA0_TE
   defc `CNTLA0_RTS0' = __IO_CNTLA0_RTS0
   defc `CNTLA0_MPBR' = __IO_CNTLA0_MPBR
   defc `CNTLA0_EFR' = __IO_CNTLA0_EFR
   defc `CNTLA0_MODE_MASK' = __IO_CNTLA0_MODE_MASK
   defc `CNTLA0_MODE_8P2' = __IO_CNTLA0_MODE_8P2
   defc `CNTLA0_MODE_8P1' = __IO_CNTLA0_MODE_8P1
   defc `CNTLA0_MODE_8N2' = __IO_CNTLA0_MODE_8N2
   defc `CNTLA0_MODE_8N1' = __IO_CNTLA0_MODE_8N1
   defc `CNTLA0_MODE_7P2' = __IO_CNTLA0_MODE_7P2
   defc `CNTLA0_MODE_7P1' = __IO_CNTLA0_MODE_7P1
   defc `CNTLA0_MODE_7N2' = __IO_CNTLA0_MODE_7N2
   defc `CNTLA0_MODE_7N1' = __IO_CNTLA0_MODE_7N1

   defc `CNTLA1_MPE' = __IO_CNTLA1_MPE
   defc `CNTLA1_RE' = __IO_CNTLA1_RE
   defc `CNTLA1_TE' = __IO_CNTLA1_TE
   defc `CNTLA1_CKA1D' = __IO_CNTLA1_CKA1D
   defc `CNTLA1_MPBR' = __IO_CNTLA1_MPBR
   defc `CNTLA1_EFR' = __IO_CNTLA1_EFR
   defc `CNTLA1_MODE_MASK' = __IO_CNTLA1_MODE_MASK
   defc `CNTLA1_MODE_8P2' = __IO_CNTLA1_MODE_8P2
   defc `CNTLA1_MODE_8P1' = __IO_CNTLA1_MODE_8P1
   defc `CNTLA1_MODE_8N2' = __IO_CNTLA1_MODE_8N2
   defc `CNTLA1_MODE_8N1' = __IO_CNTLA1_MODE_8N1
   defc `CNTLA1_MODE_7P2' = __IO_CNTLA1_MODE_7P2
   defc `CNTLA1_MODE_7P1' = __IO_CNTLA1_MODE_7P1
   defc `CNTLA1_MODE_7N2' = __IO_CNTLA1_MODE_7N2
   defc `CNTLA1_MODE_7N1' = __IO_CNTLA1_MODE_7N1

   defc `CNTLB0_MPBT' = __IO_CNTLB0_MPBT
   defc `CNTLB0_MP' = __IO_CNTLB0_MP
   defc `CNTLB0_CTS' = __IO_CNTLB0_CTS
   defc `CNTLB0_PS' = __IO_CNTLB0_PS
   defc `CNTLB0_PEO' = __IO_CNTLB0_PEO
   defc `CNTLB0_DR' = __IO_CNTLB0_DR
   defc `CNTLB0_SS_MASK' = __IO_CNTLB0_SS_MASK
   defc `CNTLB0_SS_EXT' = __IO_CNTLB0_SS_EXT
   defc `CNTLB0_SS_DIV_64' = __IO_CNTLB0_SS_DIV_64
   defc `CNTLB0_SS_DIV_32' = __IO_CNTLB0_SS_DIV_32
   defc `CNTLB0_SS_DIV_16' = __IO_CNTLB0_SS_DIV_16
   defc `CNTLB0_SS_DIV_8' = __IO_CNTLB0_SS_DIV_8
   defc `CNTLB0_SS_DIV_4' = __IO_CNTLB0_SS_DIV_4
   defc `CNTLB0_SS_DIV_2' = __IO_CNTLB0_SS_DIV_2
   defc `CNTLB0_SS_DIV_1' = __IO_CNTLB0_SS_DIV_1

   defc `CNTLB1_MPBT' = __IO_CNTLB1_MPBT
   defc `CNTLB1_MP' = __IO_CNTLB1_MP
   defc `CNTLB1_CTS' = __IO_CNTLB1_CTS
   defc `CNTLB1_PS' = __IO_CNTLB1_PS
   defc `CNTLB1_PEO' = __IO_CNTLB1_PEO
   defc `CNTLB1_DR' = __IO_CNTLB1_DR
   defc `CNTLB1_SS_MASK' = __IO_CNTLB1_SS_MASK
   defc `CNTLB1_SS_EXT' = __IO_CNTLB1_SS_EXT
   defc `CNTLB1_SS_DIV_64' = __IO_CNTLB1_SS_DIV_64
   defc `CNTLB1_SS_DIV_32' = __IO_CNTLB1_SS_DIV_32
   defc `CNTLB1_SS_DIV_16' = __IO_CNTLB1_SS_DIV_16
   defc `CNTLB1_SS_DIV_8' = __IO_CNTLB1_SS_DIV_8
   defc `CNTLB1_SS_DIV_4' = __IO_CNTLB1_SS_DIV_4
   defc `CNTLB1_SS_DIV_2' = __IO_CNTLB1_SS_DIV_2
   defc `CNTLB1_SS_DIV_1' = __IO_CNTLB1_SS_DIV_1

   defc `STAT0_RDRF' = __IO_STAT0_RDRF
   defc `STAT0_OVRN' = __IO_STAT0_OVRN
   defc `STAT0_PE' = __IO_STAT0_PE
   defc `STAT0_FE' = __IO_STAT0_FE
   defc `STAT0_RIE' = __IO_STAT0_RIE
   defc `STAT0_DCD0' = __IO_STAT0_DCD0
   defc `STAT0_TDRE' = __IO_STAT0_TDRE
   defc `STAT0_TIE' = __IO_STAT0_TIE

   defc `STAT1_RDRF' = __IO_STAT1_RDRF
   defc `STAT1_OVRN' = __IO_STAT1_OVRN
   defc `STAT1_PE' = __IO_STAT1_PE
   defc `STAT1_FE' = __IO_STAT1_FE
   defc `STAT1_RIE' = __IO_STAT1_RIE
   defc `STAT1_CTS1E' = __IO_STAT1_CTS1E
   defc `STAT1_TDRE' = __IO_STAT1_TDRE
   defc `STAT1_TIE' = __IO_STAT1_TIE

   defc `CNTR_EF' = __IO_CNTR_EF
   defc `CNTR_EIE' = __IO_CNTR_EIE
   defc `CNTR_RE' = __IO_CNTR_RE
   defc `CNTR_TE' = __IO_CNTR_TE
   defc `CNTR_SS_MASK' = __IO_CNTR_SS_MASK
   defc `CNTR_SS_EXT' = __IO_CNTR_SS_EXT
   defc `CNTR_SS_DIV_1280' = __IO_CNTR_SS_DIV_1280
   defc `CNTR_SS_DIV_640' = __IO_CNTR_SS_DIV_640
   defc `CNTR_SS_DIV_320' = __IO_CNTR_SS_DIV_320
   defc `CNTR_SS_DIV_160' = __IO_CNTR_SS_DIV_160
   defc `CNTR_SS_DIV_80' = __IO_CNTR_SS_DIV_80
   defc `CNTR_SS_DIV_40' = __IO_CNTR_SS_DIV_40
   defc `CNTR_SS_DIV_20' = __IO_CNTR_SS_DIV_20

   ; PRT REGISTER BIT FIELDS

   defc `TCR_TIF1' = __IO_TCR_TIF1
   defc `TCR_TIF0' = __IO_TCR_TIF0
   defc `TCR_TIE1' = __IO_TCR_TIE1
   defc `TCR_TIE0' = __IO_TCR_TIE0
   defc `TCR_TOC1' = __IO_TCR_TOC1
   defc `TCR_TOC0' = __IO_TCR_TOC0
   defc `TCR_TDE1' = __IO_TCR_TDE1
   defc `TCR_TDE0' = __IO_TCR_TDE0

   ; DMA REGISTER BIT FIELDS

   defc `DSTAT_DE1' = __IO_DSTAT_DE1
   defc `DSTAT_DE0' = __IO_DSTAT_DE0
   defc `DSTAT_DWE1' = __IO_DSTAT_DWE1
   defc `DSTAT_DWE0' = __IO_DSTAT_DWE0
   defc `DSTAT_DIE1' = __IO_DSTAT_DIE1
   defc `DSTAT_DIE0' = __IO_DSTAT_DIE0
   defc `DSTAT_DME' = __IO_DSTAT_DME

   defc `DMODE_DM1' = __IO_DMODE_DM1
   defc `DMODE_DM0' = __IO_DMODE_DM0
   defc `DMODE_SM1' = __IO_DMODE_SM1
   defc `DMODE_SM0' = __IO_DMODE_SM0
   defc `DMODE_MMOD' = __IO_DMODE_MMOD

   defc `DCNTL_MWI1' = __IO_DCNTL_MWI1
   defc `DCNTL_MWI0' = __IO_DCNTL_MWI0
   defc `DCNTL_IWI1' = __IO_DCNTL_IWI1
   defc `DCNTL_IWI0' = __IO_DCNTL_IWI0
   defc `DCNTL_DMS1' = __IO_DCNTL_DMS1
   defc `DCNTL_DMS0' = __IO_DCNTL_DMS0
   defc `DCNTL_DIM1' = __IO_DCNTL_DIM1
   defc `DCNTL_DIM0' = __IO_DCNTL_DIM0

   ; INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   defc `ITC_TRAP' = __IO_ITC_TRAP
   defc `ITC_UFO' = __IO_ITC_UFO
   defc `ITC_ITE2' = __IO_ITC_ITE2
   defc `ITC_ITE1' = __IO_ITC_ITE1
   defc `ITC_ITE0' = __IO_ITC_ITE0

   ; Refresh CONTROL REGISTER (RCR) BIT FIELDS

   defc `RCR_REFE' = __IO_RCR_REFE
   defc `RCR_REFW' = __IO_RCR_REFW
   defc `RCR_CYC1' = __IO_RCR_CYC1
   defc `RCR_CYC0' = __IO_RCR_CYC0

   ; Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   defc `OMCR_M1E' = __IO_OMCR_M1E
   defc `OMCR_M1TE' = __IO_OMCR_M1TE
   defc `OMCR_IOC' = __IO_OMCR_IOC
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
   defc `TRDR' = __IO_TRDR

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

   ; I/O REGISTER BIT FIELDS

   defc `CNTLA0_MPE' = __IO_CNTLA0_MPE
   defc `CNTLA0_RE' = __IO_CNTLA0_RE
   defc `CNTLA0_TE' = __IO_CNTLA0_TE
   defc `CNTLA0_RTS0' = __IO_CNTLA0_RTS0
   defc `CNTLA0_MPBR' = __IO_CNTLA0_MPBR
   defc `CNTLA0_EFR' = __IO_CNTLA0_EFR
   defc `CNTLA0_MODE_MASK' = __IO_CNTLA0_MODE_MASK
   defc `CNTLA0_MODE_8P2' = __IO_CNTLA0_MODE_8P2
   defc `CNTLA0_MODE_8P1' = __IO_CNTLA0_MODE_8P1
   defc `CNTLA0_MODE_8N2' = __IO_CNTLA0_MODE_8N2
   defc `CNTLA0_MODE_8N1' = __IO_CNTLA0_MODE_8N1
   defc `CNTLA0_MODE_7P2' = __IO_CNTLA0_MODE_7P2
   defc `CNTLA0_MODE_7P1' = __IO_CNTLA0_MODE_7P1
   defc `CNTLA0_MODE_7N2' = __IO_CNTLA0_MODE_7N2
   defc `CNTLA0_MODE_7N1' = __IO_CNTLA0_MODE_7N1

   defc `CNTLA1_MPE' = __IO_CNTLA1_MPE
   defc `CNTLA1_RE' = __IO_CNTLA1_RE
   defc `CNTLA1_TE' = __IO_CNTLA1_TE
   defc `CNTLA1_CKA1D' = __IO_CNTLA1_CKA1D
   defc `CNTLA1_MPBR' = __IO_CNTLA1_MPBR
   defc `CNTLA1_EFR' = __IO_CNTLA1_EFR
   defc `CNTLA1_MODE_MASK' = __IO_CNTLA1_MODE_MASK
   defc `CNTLA1_MODE_8P2' = __IO_CNTLA1_MODE_8P2
   defc `CNTLA1_MODE_8P1' = __IO_CNTLA1_MODE_8P1
   defc `CNTLA1_MODE_8N2' = __IO_CNTLA1_MODE_8N2
   defc `CNTLA1_MODE_8N1' = __IO_CNTLA1_MODE_8N1
   defc `CNTLA1_MODE_7P2' = __IO_CNTLA1_MODE_7P2
   defc `CNTLA1_MODE_7P1' = __IO_CNTLA1_MODE_7P1
   defc `CNTLA1_MODE_7N2' = __IO_CNTLA1_MODE_7N2
   defc `CNTLA1_MODE_7N1' = __IO_CNTLA1_MODE_7N1

   defc `CNTLB0_MPBT' = __IO_CNTLB0_MPBT
   defc `CNTLB0_MP' = __IO_CNTLB0_MP
   defc `CNTLB0_CTS' = __IO_CNTLB0_CTS
   defc `CNTLB0_PS' = __IO_CNTLB0_PS
   defc `CNTLB0_PEO' = __IO_CNTLB0_PEO
   defc `CNTLB0_DR' = __IO_CNTLB0_DR
   defc `CNTLB0_SS_MASK' = __IO_CNTLB0_SS_MASK
   defc `CNTLB0_SS_EXT' = __IO_CNTLB0_SS_EXT
   defc `CNTLB0_SS_DIV_64' = __IO_CNTLB0_SS_DIV_64
   defc `CNTLB0_SS_DIV_32' = __IO_CNTLB0_SS_DIV_32
   defc `CNTLB0_SS_DIV_16' = __IO_CNTLB0_SS_DIV_16
   defc `CNTLB0_SS_DIV_8' = __IO_CNTLB0_SS_DIV_8
   defc `CNTLB0_SS_DIV_4' = __IO_CNTLB0_SS_DIV_4
   defc `CNTLB0_SS_DIV_2' = __IO_CNTLB0_SS_DIV_2
   defc `CNTLB0_SS_DIV_1' = __IO_CNTLB0_SS_DIV_1

   defc `CNTLB1_MPBT' = __IO_CNTLB1_MPBT
   defc `CNTLB1_MP' = __IO_CNTLB1_MP
   defc `CNTLB1_CTS' = __IO_CNTLB1_CTS
   defc `CNTLB1_PS' = __IO_CNTLB1_PS
   defc `CNTLB1_PEO' = __IO_CNTLB1_PEO
   defc `CNTLB1_DR' = __IO_CNTLB1_DR
   defc `CNTLB1_SS_MASK' = __IO_CNTLB1_SS_MASK
   defc `CNTLB1_SS_EXT' = __IO_CNTLB1_SS_EXT
   defc `CNTLB1_SS_DIV_64' = __IO_CNTLB1_SS_DIV_64
   defc `CNTLB1_SS_DIV_32' = __IO_CNTLB1_SS_DIV_32
   defc `CNTLB1_SS_DIV_16' = __IO_CNTLB1_SS_DIV_16
   defc `CNTLB1_SS_DIV_8' = __IO_CNTLB1_SS_DIV_8
   defc `CNTLB1_SS_DIV_4' = __IO_CNTLB1_SS_DIV_4
   defc `CNTLB1_SS_DIV_2' = __IO_CNTLB1_SS_DIV_2
   defc `CNTLB1_SS_DIV_1' = __IO_CNTLB1_SS_DIV_1

   defc `STAT0_RDRF' = __IO_STAT0_RDRF
   defc `STAT0_OVRN' = __IO_STAT0_OVRN
   defc `STAT0_PE' = __IO_STAT0_PE
   defc `STAT0_FE' = __IO_STAT0_FE
   defc `STAT0_RIE' = __IO_STAT0_RIE
   defc `STAT0_DCD0' = __IO_STAT0_DCD0
   defc `STAT0_TDRE' = __IO_STAT0_TDRE
   defc `STAT0_TIE' = __IO_STAT0_TIE

   defc `STAT1_RDRF' = __IO_STAT1_RDRF
   defc `STAT1_OVRN' = __IO_STAT1_OVRN
   defc `STAT1_PE' = __IO_STAT1_PE
   defc `STAT1_FE' = __IO_STAT1_FE
   defc `STAT1_RIE' = __IO_STAT1_RIE
   defc `STAT1_CTS1E' = __IO_STAT1_CTS1E
   defc `STAT1_TDRE' = __IO_STAT1_TDRE
   defc `STAT1_TIE' = __IO_STAT1_TIE

   defc `CNTR_EF' = __IO_CNTR_EF
   defc `CNTR_EIE' = __IO_CNTR_EIE
   defc `CNTR_RE' = __IO_CNTR_RE
   defc `CNTR_TE' = __IO_CNTR_TE
   defc `CNTR_SS_MASK' = __IO_CNTR_SS_MASK
   defc `CNTR_SS_EXT' = __IO_CNTR_SS_EXT
   defc `CNTR_SS_DIV_1280' = __IO_CNTR_SS_DIV_1280
   defc `CNTR_SS_DIV_640' = __IO_CNTR_SS_DIV_640
   defc `CNTR_SS_DIV_320' = __IO_CNTR_SS_DIV_320
   defc `CNTR_SS_DIV_160' = __IO_CNTR_SS_DIV_160
   defc `CNTR_SS_DIV_80' = __IO_CNTR_SS_DIV_80
   defc `CNTR_SS_DIV_40' = __IO_CNTR_SS_DIV_40
   defc `CNTR_SS_DIV_20' = __IO_CNTR_SS_DIV_20

   ; PRT REGISTER BIT FIELDS

   defc `TCR_TIF1' = __IO_TCR_TIF1
   defc `TCR_TIF0' = __IO_TCR_TIF0
   defc `TCR_TIE1' = __IO_TCR_TIE1
   defc `TCR_TIE0' = __IO_TCR_TIE0
   defc `TCR_TOC1' = __IO_TCR_TOC1
   defc `TCR_TOC0' = __IO_TCR_TOC0
   defc `TCR_TDE1' = __IO_TCR_TDE1
   defc `TCR_TDE0' = __IO_TCR_TDE0

   ; DMA REGISTER BIT FIELDS

   defc `DSTAT_DE1' = __IO_DSTAT_DE1
   defc `DSTAT_DE0' = __IO_DSTAT_DE0
   defc `DSTAT_DWE1' = __IO_DSTAT_DWE1
   defc `DSTAT_DWE0' = __IO_DSTAT_DWE0
   defc `DSTAT_DIE1' = __IO_DSTAT_DIE1
   defc `DSTAT_DIE0' = __IO_DSTAT_DIE0
   defc `DSTAT_DME' = __IO_DSTAT_DME

   defc `DMODE_DM1' = __IO_DMODE_DM1
   defc `DMODE_DM0' = __IO_DMODE_DM0
   defc `DMODE_SM1' = __IO_DMODE_SM1
   defc `DMODE_SM0' = __IO_DMODE_SM0
   defc `DMODE_MMOD' = __IO_DMODE_MMOD

   defc `DCNTL_MWI1' = __IO_DCNTL_MWI1
   defc `DCNTL_MWI0' = __IO_DCNTL_MWI0
   defc `DCNTL_IWI1' = __IO_DCNTL_IWI1
   defc `DCNTL_IWI0' = __IO_DCNTL_IWI0
   defc `DCNTL_DMS1' = __IO_DCNTL_DMS1
   defc `DCNTL_DMS0' = __IO_DCNTL_DMS0
   defc `DCNTL_DIM1' = __IO_DCNTL_DIM1
   defc `DCNTL_DIM0' = __IO_DCNTL_DIM0

   ; INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   defc `ITC_TRAP' = __IO_ITC_TRAP
   defc `ITC_UFO' = __IO_ITC_UFO
   defc `ITC_ITE2' = __IO_ITC_ITE2
   defc `ITC_ITE1' = __IO_ITC_ITE1
   defc `ITC_ITE0' = __IO_ITC_ITE0

   ; Refresh CONTROL REGISTER (RCR) BIT FIELDS

   defc `RCR_REFE' = __IO_RCR_REFE
   defc `RCR_REFW' = __IO_RCR_REFW
   defc `RCR_CYC1' = __IO_RCR_CYC1
   defc `RCR_CYC0' = __IO_RCR_CYC0

   ; Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   defc `OMCR_M1E' = __IO_OMCR_M1E
   defc `OMCR_M1TE' = __IO_OMCR_M1TE
   defc `OMCR_IOC' = __IO_OMCR_IOC

   ; CPU CLOCK MULTIPLIER REGISTER (CMR) BIT FIELDS (Z8S180 & higher Only)

   defc `CMR_X2' = __IO_CMR_X2
   defc `CMR_LN_XTAL' = __IO_CMR_LN_XTAL

   ; CPU CONTROL REGISTER (CCR) BIT FIELDS (Z8S180 & higher Only)

   defc `CCR_XTAL_X2' = __IO_CCR_XTAL_X2
   defc `CCR_STANDBY' = __IO_CCR_STANDBY
   defc `CCR_BREXT' = __IO_CCR_BREXT
   defc `CCR_LNPHI' = __IO_CCR_LNPHI
   defc `CCR_IDLE' = __IO_CCR_IDLE
   defc `CCR_LNIO' = __IO_CCR_LNIO
   defc `CCR_LNCPUCTL' = __IO_CCR_LNCPUCTL
   defc `CCR_LNAD' = __IO_CCR_LNAD
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

`#define' `__CPU_INFO'  __CPU_INFO

`#define' `__CPU_INFO_ENABLE_SLL'  __CPU_INFO_ENABLE_SLL

`#define' `__CPU_TIMER_SCALE'  __CPU_TIMER_SCALE

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
   `#define' `__IO_TRDR'  __IO_TRDR

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

   // I/O REGISTER BIT FIELDS

   `#define' `__IO_CNTLA0_MPE'   __IO_CNTLA0_MPE
   `#define' `__IO_CNTLA0_RE'   __IO_CNTLA0_RE
   `#define' `__IO_CNTLA0_TE'   __IO_CNTLA0_TE
   `#define' `__IO_CNTLA0_RTS0'   __IO_CNTLA0_RTS0
   `#define' `__IO_CNTLA0_MPBR'   __IO_CNTLA0_MPBR
   `#define' `__IO_CNTLA0_EFR'   __IO_CNTLA0_EFR
   `#define' `__IO_CNTLA0_MODE_MASK'   __IO_CNTLA0_MODE_MASK
   `#define' `__IO_CNTLA0_MODE_8P2'   __IO_CNTLA0_MODE_8P2
   `#define' `__IO_CNTLA0_MODE_8P1'   __IO_CNTLA0_MODE_8P1
   `#define' `__IO_CNTLA0_MODE_8N2'   __IO_CNTLA0_MODE_8N2
   `#define' `__IO_CNTLA0_MODE_8N1'   __IO_CNTLA0_MODE_8N1
   `#define' `__IO_CNTLA0_MODE_7P2'   __IO_CNTLA0_MODE_7P2
   `#define' `__IO_CNTLA0_MODE_7P1'   __IO_CNTLA0_MODE_7P1
   `#define' `__IO_CNTLA0_MODE_7N2'   __IO_CNTLA0_MODE_7N2
   `#define' `__IO_CNTLA0_MODE_7N1'   __IO_CNTLA0_MODE_7N1

   `#define' `__IO_CNTLA1_MPE'   __IO_CNTLA1_MPE
   `#define' `__IO_CNTLA1_RE'   __IO_CNTLA1_RE
   `#define' `__IO_CNTLA1_TE'   __IO_CNTLA1_TE
   `#define' `__IO_CNTLA1_CKA1D'   __IO_CNTLA1_CKA1D
   `#define' `__IO_CNTLA1_MPBR'   __IO_CNTLA1_MPBR
   `#define' `__IO_CNTLA1_EFR'   __IO_CNTLA1_EFR
   `#define' `__IO_CNTLA1_MODE_MASK'   __IO_CNTLA1_MODE_MASK
   `#define' `__IO_CNTLA1_MODE_8P2'   __IO_CNTLA1_MODE_8P2
   `#define' `__IO_CNTLA1_MODE_8P1'   __IO_CNTLA1_MODE_8P1
   `#define' `__IO_CNTLA1_MODE_8N2'   __IO_CNTLA1_MODE_8N2
   `#define' `__IO_CNTLA1_MODE_8N1'   __IO_CNTLA1_MODE_8N1
   `#define' `__IO_CNTLA1_MODE_7P2'   __IO_CNTLA1_MODE_7P2
   `#define' `__IO_CNTLA1_MODE_7P1'   __IO_CNTLA1_MODE_7P1
   `#define' `__IO_CNTLA1_MODE_7N2'   __IO_CNTLA1_MODE_7N2
   `#define' `__IO_CNTLA1_MODE_7N1'   __IO_CNTLA1_MODE_7N1

   `#define' `__IO_CNTLB0_MPBT'   __IO_CNTLB0_MPBT
   `#define' `__IO_CNTLB0_MP'   __IO_CNTLB0_MP
   `#define' `__IO_CNTLB0_CTS'   __IO_CNTLB0_CTS
   `#define' `__IO_CNTLB0_PS'   __IO_CNTLB0_PS
   `#define' `__IO_CNTLB0_PEO'   __IO_CNTLB0_PEO
   `#define' `__IO_CNTLB0_DR'   __IO_CNTLB0_DR
   `#define' `__IO_CNTLB0_SS_MASK'   __IO_CNTLB0_SS_MASK
   `#define' `__IO_CNTLB0_SS_EXT'   __IO_CNTLB0_SS_EXT
   `#define' `__IO_CNTLB0_SS_DIV_64'   __IO_CNTLB0_SS_DIV_64
   `#define' `__IO_CNTLB0_SS_DIV_32'   __IO_CNTLB0_SS_DIV_32
   `#define' `__IO_CNTLB0_SS_DIV_16'   __IO_CNTLB0_SS_DIV_16
   `#define' `__IO_CNTLB0_SS_DIV_8'   __IO_CNTLB0_SS_DIV_8
   `#define' `__IO_CNTLB0_SS_DIV_4'   __IO_CNTLB0_SS_DIV_4
   `#define' `__IO_CNTLB0_SS_DIV_2'   __IO_CNTLB0_SS_DIV_2
   `#define' `__IO_CNTLB0_SS_DIV_1'   __IO_CNTLB0_SS_DIV_1

   `#define' `__IO_CNTLB1_MPBT'   __IO_CNTLB1_MPBT
   `#define' `__IO_CNTLB1_MP'   __IO_CNTLB1_MP
   `#define' `__IO_CNTLB1_CTS'   __IO_CNTLB1_CTS
   `#define' `__IO_CNTLB1_PS'   __IO_CNTLB1_PS
   `#define' `__IO_CNTLB1_PEO'   __IO_CNTLB1_PEO
   `#define' `__IO_CNTLB1_DR'   __IO_CNTLB1_DR
   `#define' `__IO_CNTLB1_SS_MASK'   __IO_CNTLB1_SS_MASK
   `#define' `__IO_CNTLB1_SS_EXT'   __IO_CNTLB1_SS_EXT
   `#define' `__IO_CNTLB1_SS_DIV_64'   __IO_CNTLB1_SS_DIV_64
   `#define' `__IO_CNTLB1_SS_DIV_32'   __IO_CNTLB1_SS_DIV_32
   `#define' `__IO_CNTLB1_SS_DIV_16'   __IO_CNTLB1_SS_DIV_16
   `#define' `__IO_CNTLB1_SS_DIV_8'   __IO_CNTLB1_SS_DIV_8
   `#define' `__IO_CNTLB1_SS_DIV_4'   __IO_CNTLB1_SS_DIV_4
   `#define' `__IO_CNTLB1_SS_DIV_2'   __IO_CNTLB1_SS_DIV_2
   `#define' `__IO_CNTLB1_SS_DIV_1'   __IO_CNTLB1_SS_DIV_1

   `#define' `__IO_STAT0_RDRF'   __IO_STAT0_RDRF
   `#define' `__IO_STAT0_OVRN'   __IO_STAT0_OVRN
   `#define' `__IO_STAT0_PE'   __IO_STAT0_PE
   `#define' `__IO_STAT0_FE'   __IO_STAT0_FE
   `#define' `__IO_STAT0_RIE'   __IO_STAT0_RIE
   `#define' `__IO_STAT0_DCD0'   __IO_STAT0_DCD0
   `#define' `__IO_STAT0_TDRE'   __IO_STAT0_TDRE
   `#define' `__IO_STAT0_TIE'   __IO_STAT0_TIE

   `#define' `__IO_STAT1_RDRF'   __IO_STAT1_RDRF
   `#define' `__IO_STAT1_OVRN'   __IO_STAT1_OVRN
   `#define' `__IO_STAT1_PE'   __IO_STAT1_PE
   `#define' `__IO_STAT1_FE'   __IO_STAT1_FE
   `#define' `__IO_STAT1_RIE'   __IO_STAT1_RIE
   `#define' `__IO_STAT1_CTS1E'   __IO_STAT1_CTS1E
   `#define' `__IO_STAT1_TDRE'   __IO_STAT1_TDRE
   `#define' `__IO_STAT1_TIE'   __IO_STAT1_TIE

   `#define' `__IO_CNTR_EF'   __IO_CNTR_EF
   `#define' `__IO_CNTR_EIE'   __IO_CNTR_EIE
   `#define' `__IO_CNTR_RE'   __IO_CNTR_RE
   `#define' `__IO_CNTR_TE'   __IO_CNTR_TE
   `#define' `__IO_CNTR_SS_MASK'   __IO_CNTR_SS_MASK
   `#define' `__IO_CNTR_SS_EXT'   __IO_CNTR_SS_EXT
   `#define' `__IO_CNTR_SS_DIV_1280'   __IO_CNTR_SS_DIV_1280
   `#define' `__IO_CNTR_SS_DIV_640'   __IO_CNTR_SS_DIV_640
   `#define' `__IO_CNTR_SS_DIV_320'   __IO_CNTR_SS_DIV_320
   `#define' `__IO_CNTR_SS_DIV_160'   __IO_CNTR_SS_DIV_160
   `#define' `__IO_CNTR_SS_DIV_80'   __IO_CNTR_SS_DIV_80
   `#define' `__IO_CNTR_SS_DIV_40'   __IO_CNTR_SS_DIV_40
   `#define' `__IO_CNTR_SS_DIV_20'   __IO_CNTR_SS_DIV_20

   // PRT REGISTER BIT FIELDS

   `#define' `__IO_TCR_TIF1'    __IO_TCR_TIF1
   `#define' `__IO_TCR_TIF0'    __IO_TCR_TIF0
   `#define' `__IO_TCR_TIE1'    __IO_TCR_TIE1
   `#define' `__IO_TCR_TIE0'    __IO_TCR_TIE0
   `#define' `__IO_TCR_TOC1'    __IO_TCR_TOC1
   `#define' `__IO_TCR_TOC0'    __IO_TCR_TOC0
   `#define' `__IO_TCR_TDE1'    __IO_TCR_TDE1
   `#define' `__IO_TCR_TDE0'    __IO_TCR_TDE0

   // DMA REGISTER BIT FIELDS
   
   `#define' `__IO_DSTAT_DE1'    __IO_DSTAT_DE1
   `#define' `__IO_DSTAT_DE0'    __IO_DSTAT_DE0
   `#define' `__IO_DSTAT_DWE1'   __IO_DSTAT_DWE1
   `#define' `__IO_DSTAT_DWE0'   __IO_DSTAT_DWE0
   `#define' `__IO_DSTAT_DIE1'   __IO_DSTAT_DIE1
   `#define' `__IO_DSTAT_DIE0'   __IO_DSTAT_DIE0
   `#define' `__IO_DSTAT_DME'    __IO_DSTAT_DME

   `#define' `__IO_DMODE_DM1'    __IO_DMODE_DM1
   `#define' `__IO_DMODE_DM0'    __IO_DMODE_DM0
   `#define' `__IO_DMODE_SM1'    __IO_DMODE_SM1
   `#define' `__IO_DMODE_SM0'    __IO_DMODE_SM0
   `#define' `__IO_DMODE_MMOD'   __IO_DMODE_MMOD

   `#define' `__IO_DCNTL_MWI1'   __IO_DCNTL_MWI1
   `#define' `__IO_DCNTL_MWI0'   __IO_DCNTL_MWI0
   `#define' `__IO_DCNTL_IWI1'   __IO_DCNTL_IWI1
   `#define' `__IO_DCNTL_IWI0'   __IO_DCNTL_IWI0
   `#define' `__IO_DCNTL_DMS1'   __IO_DCNTL_DMS1
   `#define' `__IO_DCNTL_DMS0'   __IO_DCNTL_DMS0
   `#define' `__IO_DCNTL_DIM1'   __IO_DCNTL_DIM1
   `#define' `__IO_DCNTL_DIM0'   __IO_DCNTL_DIM0

   // INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   `#define' `__IO_ITC_TRAP'   __IO_ITC_TRAP
   `#define' `__IO_ITC_UFO'   __IO_ITC_UFO
   `#define' `__IO_ITC_ITE2'   __IO_ITC_ITE2
   `#define' `__IO_ITC_ITE1'   __IO_ITC_ITE1
   `#define' `__IO_ITC_ITE0'   __IO_ITC_ITE0

   // Refresh CONTROL REGISTER (RCR) BIT FIELDS

   `#define' `__IO_RCR_REFE'   __IO_RCR_REFE
   `#define' `__IO_RCR_REFW'   __IO_RCR_REFW
   `#define' `__IO_RCR_CYC1'   __IO_RCR_CYC1
   `#define' `__IO_RCR_CYC0'   __IO_RCR_CYC0

   // Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   `#define' `__IO_OMCR_M1E'   __IO_OMCR_M1E
   `#define' `__IO_OMCR_M1TE'   __IO_OMCR_M1TE
   `#define' `__IO_OMCR_IOC'   __IO_OMCR_IOC
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
   `#define' `__IO_TRDR'  __IO_TRDR

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

   // I/O REGISTER BIT FIELDS

   `#define' `__IO_CNTLA0_MPE'   __IO_CNTLA0_MPE
   `#define' `__IO_CNTLA0_RE'   __IO_CNTLA0_RE
   `#define' `__IO_CNTLA0_TE'   __IO_CNTLA0_TE
   `#define' `__IO_CNTLA0_RTS0'   __IO_CNTLA0_RTS0
   `#define' `__IO_CNTLA0_MPBR'   __IO_CNTLA0_MPBR
   `#define' `__IO_CNTLA0_EFR'   __IO_CNTLA0_EFR
   `#define' `__IO_CNTLA0_MODE_MASK'   __IO_CNTLA0_MODE_MASK
   `#define' `__IO_CNTLA0_MODE_8P2'   __IO_CNTLA0_MODE_8P2
   `#define' `__IO_CNTLA0_MODE_8P1'   __IO_CNTLA0_MODE_8P1
   `#define' `__IO_CNTLA0_MODE_8N2'   __IO_CNTLA0_MODE_8N2
   `#define' `__IO_CNTLA0_MODE_8N1'   __IO_CNTLA0_MODE_8N1
   `#define' `__IO_CNTLA0_MODE_7P2'   __IO_CNTLA0_MODE_7P2
   `#define' `__IO_CNTLA0_MODE_7P1'   __IO_CNTLA0_MODE_7P1
   `#define' `__IO_CNTLA0_MODE_7N2'   __IO_CNTLA0_MODE_7N2
   `#define' `__IO_CNTLA0_MODE_7N1'   __IO_CNTLA0_MODE_7N1

   `#define' `__IO_CNTLA1_MPE'   __IO_CNTLA1_MPE
   `#define' `__IO_CNTLA1_RE'   __IO_CNTLA1_RE
   `#define' `__IO_CNTLA1_TE'   __IO_CNTLA1_TE
   `#define' `__IO_CNTLA1_CKA1D'   __IO_CNTLA1_CKA1D
   `#define' `__IO_CNTLA1_MPBR'   __IO_CNTLA1_MPBR
   `#define' `__IO_CNTLA1_EFR'   __IO_CNTLA1_EFR
   `#define' `__IO_CNTLA1_MODE_MASK'   __IO_CNTLA1_MODE_MASK
   `#define' `__IO_CNTLA1_MODE_8P2'   __IO_CNTLA1_MODE_8P2
   `#define' `__IO_CNTLA1_MODE_8P1'   __IO_CNTLA1_MODE_8P1
   `#define' `__IO_CNTLA1_MODE_8N2'   __IO_CNTLA1_MODE_8N2
   `#define' `__IO_CNTLA1_MODE_8N1'   __IO_CNTLA1_MODE_8N1
   `#define' `__IO_CNTLA1_MODE_7P2'   __IO_CNTLA1_MODE_7P2
   `#define' `__IO_CNTLA1_MODE_7P1'   __IO_CNTLA1_MODE_7P1
   `#define' `__IO_CNTLA1_MODE_7N2'   __IO_CNTLA1_MODE_7N2
   `#define' `__IO_CNTLA1_MODE_7N1'   __IO_CNTLA1_MODE_7N1

   `#define' `__IO_CNTLB0_MPBT'   __IO_CNTLB0_MPBT
   `#define' `__IO_CNTLB0_MP'   __IO_CNTLB0_MP
   `#define' `__IO_CNTLB0_CTS'   __IO_CNTLB0_CTS
   `#define' `__IO_CNTLB0_PS'   __IO_CNTLB0_PS
   `#define' `__IO_CNTLB0_PEO'   __IO_CNTLB0_PEO
   `#define' `__IO_CNTLB0_DR'   __IO_CNTLB0_DR
   `#define' `__IO_CNTLB0_SS_MASK'   __IO_CNTLB0_SS_MASK
   `#define' `__IO_CNTLB0_SS_EXT'   __IO_CNTLB0_SS_EXT
   `#define' `__IO_CNTLB0_SS_DIV_64'   __IO_CNTLB0_SS_DIV_64
   `#define' `__IO_CNTLB0_SS_DIV_32'   __IO_CNTLB0_SS_DIV_32
   `#define' `__IO_CNTLB0_SS_DIV_16'   __IO_CNTLB0_SS_DIV_16
   `#define' `__IO_CNTLB0_SS_DIV_8'   __IO_CNTLB0_SS_DIV_8
   `#define' `__IO_CNTLB0_SS_DIV_4'   __IO_CNTLB0_SS_DIV_4
   `#define' `__IO_CNTLB0_SS_DIV_2'   __IO_CNTLB0_SS_DIV_2
   `#define' `__IO_CNTLB0_SS_DIV_1'   __IO_CNTLB0_SS_DIV_1

   `#define' `__IO_CNTLB1_MPBT'   __IO_CNTLB1_MPBT
   `#define' `__IO_CNTLB1_MP'   __IO_CNTLB1_MP
   `#define' `__IO_CNTLB1_CTS'   __IO_CNTLB1_CTS
   `#define' `__IO_CNTLB1_PS'   __IO_CNTLB1_PS
   `#define' `__IO_CNTLB1_PEO'   __IO_CNTLB1_PEO
   `#define' `__IO_CNTLB1_DR'   __IO_CNTLB1_DR
   `#define' `__IO_CNTLB1_SS_MASK'   __IO_CNTLB1_SS_MASK
   `#define' `__IO_CNTLB1_SS_EXT'   __IO_CNTLB1_SS_EXT
   `#define' `__IO_CNTLB1_SS_DIV_64'   __IO_CNTLB1_SS_DIV_64
   `#define' `__IO_CNTLB1_SS_DIV_32'   __IO_CNTLB1_SS_DIV_32
   `#define' `__IO_CNTLB1_SS_DIV_16'   __IO_CNTLB1_SS_DIV_16
   `#define' `__IO_CNTLB1_SS_DIV_8'   __IO_CNTLB1_SS_DIV_8
   `#define' `__IO_CNTLB1_SS_DIV_4'   __IO_CNTLB1_SS_DIV_4
   `#define' `__IO_CNTLB1_SS_DIV_2'   __IO_CNTLB1_SS_DIV_2
   `#define' `__IO_CNTLB1_SS_DIV_1'   __IO_CNTLB1_SS_DIV_1

   `#define' `__IO_STAT0_RDRF'   __IO_STAT0_RDRF
   `#define' `__IO_STAT0_OVRN'   __IO_STAT0_OVRN
   `#define' `__IO_STAT0_PE'   __IO_STAT0_PE
   `#define' `__IO_STAT0_FE'   __IO_STAT0_FE
   `#define' `__IO_STAT0_RIE'   __IO_STAT0_RIE
   `#define' `__IO_STAT0_DCD0'   __IO_STAT0_DCD0
   `#define' `__IO_STAT0_TDRE'   __IO_STAT0_TDRE
   `#define' `__IO_STAT0_TIE'   __IO_STAT0_TIE

   `#define' `__IO_STAT1_RDRF'   __IO_STAT1_RDRF
   `#define' `__IO_STAT1_OVRN'   __IO_STAT1_OVRN
   `#define' `__IO_STAT1_PE'   __IO_STAT1_PE
   `#define' `__IO_STAT1_FE'   __IO_STAT1_FE
   `#define' `__IO_STAT1_RIE'   __IO_STAT1_RIE
   `#define' `__IO_STAT1_CTS1E'   __IO_STAT1_CTS1E
   `#define' `__IO_STAT1_TDRE'   __IO_STAT1_TDRE
   `#define' `__IO_STAT1_TIE'   __IO_STAT1_TIE

   `#define' `__IO_CNTR_EF'   __IO_CNTR_EF
   `#define' `__IO_CNTR_EIE'   __IO_CNTR_EIE
   `#define' `__IO_CNTR_RE'   __IO_CNTR_RE
   `#define' `__IO_CNTR_TE'   __IO_CNTR_TE
   `#define' `__IO_CNTR_SS_MASK'   __IO_CNTR_SS_MASK
   `#define' `__IO_CNTR_SS_EXT'   __IO_CNTR_SS_EXT
   `#define' `__IO_CNTR_SS_DIV_1280'   __IO_CNTR_SS_DIV_1280
   `#define' `__IO_CNTR_SS_DIV_640'   __IO_CNTR_SS_DIV_640
   `#define' `__IO_CNTR_SS_DIV_320'   __IO_CNTR_SS_DIV_320
   `#define' `__IO_CNTR_SS_DIV_160'   __IO_CNTR_SS_DIV_160
   `#define' `__IO_CNTR_SS_DIV_80'   __IO_CNTR_SS_DIV_80
   `#define' `__IO_CNTR_SS_DIV_40'   __IO_CNTR_SS_DIV_40
   `#define' `__IO_CNTR_SS_DIV_20'   __IO_CNTR_SS_DIV_20

   // PRT REGISTER BIT FIELDS

   `#define' `__IO_TCR_TIF1'    __IO_TCR_TIF1
   `#define' `__IO_TCR_TIF0'    __IO_TCR_TIF0
   `#define' `__IO_TCR_TIE1'    __IO_TCR_TIE1
   `#define' `__IO_TCR_TIE0'    __IO_TCR_TIE0
   `#define' `__IO_TCR_TOC1'    __IO_TCR_TOC1
   `#define' `__IO_TCR_TOC0'    __IO_TCR_TOC0
   `#define' `__IO_TCR_TDE1'    __IO_TCR_TDE1
   `#define' `__IO_TCR_TDE0'    __IO_TCR_TDE0

   // DMA REGISTER BIT FIELDS

   `#define' `__IO_DSTAT_DE1'    __IO_DSTAT_DE1
   `#define' `__IO_DSTAT_DE0'    __IO_DSTAT_DE0
   `#define' `__IO_DSTAT_DWE1'   __IO_DSTAT_DWE1
   `#define' `__IO_DSTAT_DWE0'   __IO_DSTAT_DWE0
   `#define' `__IO_DSTAT_DIE1'   __IO_DSTAT_DIE1
   `#define' `__IO_DSTAT_DIE0'   __IO_DSTAT_DIE0
   `#define' `__IO_DSTAT_DME'    __IO_DSTAT_DME

   `#define' `__IO_DMODE_DM1'    __IO_DMODE_DM1
   `#define' `__IO_DMODE_DM0'    __IO_DMODE_DM0
   `#define' `__IO_DMODE_SM1'    __IO_DMODE_SM1
   `#define' `__IO_DMODE_SM0'    __IO_DMODE_SM0
   `#define' `__IO_DMODE_MMOD'   __IO_DMODE_MMOD

   `#define' `__IO_DCNTL_MWI1'   __IO_DCNTL_MWI1
   `#define' `__IO_DCNTL_MWI0'   __IO_DCNTL_MWI0
   `#define' `__IO_DCNTL_IWI1'   __IO_DCNTL_IWI1
   `#define' `__IO_DCNTL_IWI0'   __IO_DCNTL_IWI0
   `#define' `__IO_DCNTL_DMS1'   __IO_DCNTL_DMS1
   `#define' `__IO_DCNTL_DMS0'   __IO_DCNTL_DMS0
   `#define' `__IO_DCNTL_DIM1'   __IO_DCNTL_DIM1
   `#define' `__IO_DCNTL_DIM0'   __IO_DCNTL_DIM0

   // INT/TRAP CONTROL REGISTER (ITC) BIT FIELDS

   `#define' `__IO_ITC_TRAP'   __IO_ITC_TRAP
   `#define' `__IO_ITC_UFO'   __IO_ITC_UFO
   `#define' `__IO_ITC_ITE2'   __IO_ITC_ITE2
   `#define' `__IO_ITC_ITE1'   __IO_ITC_ITE1
   `#define' `__IO_ITC_ITE0'   __IO_ITC_ITE0

   // Refresh CONTROL REGISTER (RCR) BIT FIELDS

   `#define' `__IO_RCR_REFE'   __IO_RCR_REFE
   `#define' `__IO_RCR_REFW'   __IO_RCR_REFW
   `#define' `__IO_RCR_CYC1'   __IO_RCR_CYC1
   `#define' `__IO_RCR_CYC0'   __IO_RCR_CYC0

   // Operation Mode CONTROL REGISTER (OMCR) BIT FIELDS

   `#define' `__IO_OMCR_M1E'   __IO_OMCR_M1E
   `#define' `__IO_OMCR_M1TE'   __IO_OMCR_M1TE
   `#define' `__IO_OMCR_IOC'   __IO_OMCR_IOC

   // CPU CLOCK MULTIPLIER REGISTER (CMR) BIT FIELDS (Z8S180 & higher Only)

   `#define' `__IO_CMR_X2'   __IO_CMR_X2
   `#define' `__IO_CMR_LN_XTAL'   __IO_CMR_LN_XTAL

   // CPU CONTROL REGISTER (CCR) BIT FIELDS (Z8S180 & higher Only)

   `#define' `__IO_CCR_XTAL_X2'   __IO_CCR_XTAL_X2
   `#define' `__IO_CCR_STANDBY'   __IO_CCR_STANDBY
   `#define' `__IO_CCR_BREXT'   __IO_CCR_BREXT
   `#define' `__IO_CCR_LNPHI'   __IO_CCR_LNPHI
   `#define' `__IO_CCR_IDLE'   __IO_CCR_IDLE
   `#define' `__IO_CCR_LNIO'   __IO_CCR_LNIO
   `#define' `__IO_CCR_LNCPUCTL'   __IO_CCR_LNCPUCTL
   `#define' `__IO_CCR_LNAD'   __IO_CCR_LNAD
')
')
