divert(-1)

###############################################################
# Z180 CPU CONFIGURATION
# rebuild the library if changes are made
#

# Class of R2KA being targeted

define(`__R2KA',                0x00)

define(`__R2KA_IQ2T',           0x00)
define(`__R2KA_IQ3T',           0x01)
define(`__R2KA_IQ4T',           0x02)
define(`__R2KA_IQ5T',           0x03)

# Global Control

define(`__IO_GCSR',             0x00)

# Real Time Clock

define(`__IO_RTCCR',            0x01)
define(`__IO_RTC0R',            0x02)
define(`__IO_RTC1R',            0x03)
define(`__IO_RTC2R',            0x04)
define(`__IO_RTC3R',            0x05)
define(`__IO_RTC4R',            0x06)
define(`__IO_RTC5R',            0x07)

# Watchdog

define(`__IO_WDTCR',            0x08)
define(`__IO_WDTTR',            0x09)

# Global Control

define(`__IO_GCM0R',            0x0A)
define(`__IO_GCM1R',            0x0B)
define(`__IO_GOCR',             0x0E)
define(`__IO_GCDR',             0x0F)

# MMU

define(`__IO_MMIDR',            0x10)
define(`__IO_STACKSEG',         0x11)
define(`__IO_DATASEG',          0x12)
define(`__IO_SEGSIZE',          0x13)
define(`__IO_MB0CR',            0x14)
define(`__IO_MB1CR',            0x15)
define(`__IO_MB2CR',            0x16)
define(`__IO_MB3CR',            0x17)

define(`__IO_MTCR',             0x19)

# Slave Port

define(`__IO_SPD0R',            0x20)
define(`__IO_SPD1R',            0x21)
define(`__IO_SPD2R',            0x22)
define(`__IO_SPSR',             0x23)
define(`__IO_SPCR',             0x24)

# Global Configuration

define(`__IO_GROM',             0x2C)
define(`__IO_GRAM',             0x2D)
define(`__IO_GCPU',             0x2E)
define(`__IO_GREV',             0x2F)

# Port A

define(`__IO_PADR',             0x30)

# Port B

define(`__IO_PBDR',             0x40)
define(`__IO_PBDDR',            0x47)

# Port C

define(`__IO_PCDR',             0x50)
define(`__IO_PCFR',             0x55)

# Port D

define(`__IO_PDDR',             0x60)
define(`__IO_PDCR',             0x64)
define(`__IO_PDFR',             0x65)
define(`__IO_PDDCR',            0x66)
define(`__IO_PDDDR',            0x67)
define(`__IO_PDB0R',            0x68)
define(`__IO_PDB1R',            0x69)
define(`__IO_PDB2R',            0x6A)
define(`__IO_PDB3R',            0x6B)
define(`__IO_PDB4R',            0x6C)
define(`__IO_PDB5R',            0x6D)
define(`__IO_PDB6R',            0x6E)
define(`__IO_PDB7R',            0x6F)

# Port E

define(`__IO_PEDR',             0x70)
define(`__IO_PECR',             0x74)
define(`__IO_PEFR',             0x75)
define(`__IO_PEDCR',            0x76)
define(`__IO_PEDDR',            0x77)
define(`__IO_PEB0R',            0x78)
define(`__IO_PEB1R',            0x79)
define(`__IO_PEB2R',            0x7A)
define(`__IO_PEB3R',            0x7B)
define(`__IO_PEB4R',            0x7C)
define(`__IO_PEB5R',            0x7D)
define(`__IO_PEB6R',            0x7E)
define(`__IO_PEB7R',            0x7F)

# I/O Control

define(`__IO_IB0CR',            0x80)
define(`__IO_IB1CR',            0x81)
define(`__IO_IB2CR',            0x82)
define(`__IO_IB3CR',            0x83)
define(`__IO_IB4CR',            0x84)
define(`__IO_IB5CR',            0x85)
define(`__IO_IB6CR',            0x86)
define(`__IO_IB7CR',            0x87)

# Interrupt Control

define(`__IO_I0CR',             0x98)
define(`__IO_I1CR',             0x99)

# Timer A

define(`__IO_TACSR',            0xA0)
define(`__IO_TAPR',             0xA1)
define(`__IO_TAT1R',            0xA3)
define(`__IO_TACR',             0xA4)
define(`__IO_TAT2R',            0xA5)
define(`__IO_TAT8R',            0xA6)
define(`__IO_TAT3R',            0xA7)
define(`__IO_TAT9R',            0xA8)
define(`__IO_TAT4R',            0xA9)
define(`__IO_TAT10R',           0xAA)
define(`__IO_TAT5R',            0xAB)
define(`__IO_TAT6R',            0xAD)
define(`__IO_TAT7R',            0xAF)

# Timer B

define(`__IO_TBCSR',            0xB0)
define(`__IO_TBCR',             0xB1)
define(`__IO_TBM1R',            0xB2)
define(`__IO_TBL1R',            0xB3)
define(`__IO_TBM2R',            0xB4)
define(`__IO_TBL2R',            0xB5)
define(`__IO_TBCMR',            0xBE)
define(`__IO_TBCLR',            0xBF)

# Serial Port A

define(`__IO_SADR',             0xC0)
define(`__IO_SAAR',             0xC1)
define(`__IO_SALR',             0xC2)
define(`__IO_SASR',             0xC3)
define(`__IO_SACR',             0xC4)

# Serial Port B

define(`__IO_SBDR',             0xD0)
define(`__IO_SBAR',             0xD1)
define(`__IO_SBLR',             0xD2)
define(`__IO_SBSR',             0xD3)
define(`__IO_SBCR',             0xD4)

# Serial Port C

define(`__IO_SCDR',             0xE0)
define(`__IO_SCAR',             0xE1)
define(`__IO_SCLR',             0xE2)
define(`__IO_SCSR',             0xE3)
define(`__IO_SCCR',             0xE4)

# Serial Port D

define(`__IO_SDDR',             0xF0)
define(`__IO_SDAR',             0xF1)
define(`__IO_SDLR',             0xF2)
define(`__IO_SDSR',             0xF3)
define(`__IO_SDCR',             0xF4)

#
# END OF CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__R2KA'

PUBLIC `__R2KA_IQ2T'
PUBLIC `__R2KA_IQ3T'
PUBLIC `__R2KA_IQ4T'
PUBLIC `__R2KA_IQ5T'

PUBLIC `__IO_GCSR'

PUBLIC `__IO_RTCCR'
PUBLIC `__IO_RTC0R'
PUBLIC `__IO_RTC1R'
PUBLIC `__IO_RTC2R'
PUBLIC `__IO_RTC3R'
PUBLIC `__IO_RTC4R'
PUBLIC `__IO_RTC5R'

PUBLIC `__IO_WDTCR'
PUBLIC `__IO_WDTTR'

PUBLIC `__IO_GCM0R'
PUBLIC `__IO_GCM1R'
PUBLIC `__IO_GOCR'
PUBLIC `__IO_GCDR'

PUBLIC `__IO_MMIDR'
PUBLIC `__IO_STACKSEG'
PUBLIC `__IO_DATASEG'
PUBLIC `__IO_SEGSIZE'
PUBLIC `__IO_MB0CR'
PUBLIC `__IO_MB1CR'
PUBLIC `__IO_MB2CR'
PUBLIC `__IO_MB3CR'

PUBLIC `__IO_MTCR'

PUBLIC `__IO_SPD0R'
PUBLIC `__IO_SPD1R'
PUBLIC `__IO_SPD2R'
PUBLIC `__IO_SPSR'
PUBLIC `__IO_SPCR'

PUBLIC `__IO_GROM'
PUBLIC `__IO_GRAM'
PUBLIC `__IO_GCPU'
PUBLIC `__IO_GREV'

PUBLIC `__IO_PADR'

PUBLIC `__IO_PBDR'
PUBLIC `__IO_PBDDR'

PUBLIC `__IO_PCDR'
PUBLIC `__IO_PCFR'

PUBLIC `__IO_PDDR'
PUBLIC `__IO_PDCR'
PUBLIC `__IO_PDFR'
PUBLIC `__IO_PDDCR'
PUBLIC `__IO_PDDDR'
PUBLIC `__IO_PDB0R'
PUBLIC `__IO_PDB1R'
PUBLIC `__IO_PDB2R'
PUBLIC `__IO_PDB3R'
PUBLIC `__IO_PDB4R'
PUBLIC `__IO_PDB5R'
PUBLIC `__IO_PDB6R'
PUBLIC `__IO_PDB7R'

PUBLIC `__IO_PEDR'
PUBLIC `__IO_PECR'
PUBLIC `__IO_PEFR'
PUBLIC `__IO_PEDCR'
PUBLIC `__IO_PEDDR'
PUBLIC `__IO_PEB0R'
PUBLIC `__IO_PEB1R'
PUBLIC `__IO_PEB2R'
PUBLIC `__IO_PEB3R'
PUBLIC `__IO_PEB4R'
PUBLIC `__IO_PEB5R'
PUBLIC `__IO_PEB6R'
PUBLIC `__IO_PEB7R'

PUBLIC `__IO_IB0CR'
PUBLIC `__IO_IB1CR'
PUBLIC `__IO_IB2CR'
PUBLIC `__IO_IB3CR'
PUBLIC `__IO_IB4CR'
PUBLIC `__IO_IB5CR'
PUBLIC `__IO_IB6CR'
PUBLIC `__IO_IB7CR'

PUBLIC `__IO_I0CR'
PUBLIC `__IO_I1CR'

PUBLIC `__IO_TACSR'
PUBLIC `__IO_TAPR'
PUBLIC `__IO_TAT1R'
PUBLIC `__IO_TACR'
PUBLIC `__IO_TAT2R'
PUBLIC `__IO_TAT8R'
PUBLIC `__IO_TAT3R'
PUBLIC `__IO_TAT9R'
PUBLIC `__IO_TAT4R'
PUBLIC `__IO_TAT10R'
PUBLIC `__IO_TAT5R'
PUBLIC `__IO_TAT6R'
PUBLIC `__IO_TAT7R'

PUBLIC `__IO_TBCSR'
PUBLIC `__IO_TBCR'
PUBLIC `__IO_TBM1R'
PUBLIC `__IO_TBL1R'
PUBLIC `__IO_TBM2R'
PUBLIC `__IO_TBL2R'
PUBLIC `__IO_TBCMR'
PUBLIC `__IO_TBCLR'

PUBLIC `__IO_SADR'
PUBLIC `__IO_SAAR'
PUBLIC `__IO_SALR'
PUBLIC `__IO_SASR'
PUBLIC `__IO_SACR'

PUBLIC `__IO_SBDR'
PUBLIC `__IO_SBAR'
PUBLIC `__IO_SBLR'
PUBLIC `__IO_SBSR'
PUBLIC `__IO_SBCR'

PUBLIC `__IO_SCDR'
PUBLIC `__IO_SCAR'
PUBLIC `__IO_SCLR'
PUBLIC `__IO_SCSR'
PUBLIC `__IO_SCCR'

PUBLIC `__IO_SDDR'
PUBLIC `__IO_SDAR'
PUBLIC `__IO_SDLR'
PUBLIC `__IO_SDSR'
PUBLIC `__IO_SDCR'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__R2KA' = __R2KA

defc `__R2KA_IQ2T' = __R2KA_IQ2T
defc `__R2KA_IQ3T' = __R2KA_IQ3T
defc `__R2KA_IQ4T' = __R2KA_IQ4T
defc `__R2KA_IQ5T' = __R2KA_IQ5T

defc `__IO_GCSR' = __IO_GCSR

defc `__IO_RTCCR' = __IO_RTCCR
defc `__IO_RTC0R' = __IO_RTC0R
defc `__IO_RTC1R' = __IO_RTC1R
defc `__IO_RTC2R' = __IO_RTC2R
defc `__IO_RTC3R' = __IO_RTC3R
defc `__IO_RTC4R' = __IO_RTC4R
defc `__IO_RTC5R' = __IO_RTC5R

defc `__IO_WDTCR' = __IO_WDTCR
defc `__IO_WDTTR' = __IO_WDTTR

defc `__IO_GCM0R' = __IO_GCM0R
defc `__IO_GCM1R' = __IO_GCM1R
defc `__IO_GOCR' = __IO_GOCR
defc `__IO_GCDR' = __IO_GCDR

defc `__IO_MMIDR' = __IO_MMIDR
defc `__IO_STACKSEG' = __IO_STACKSEG
defc `__IO_DATASEG' = __IO_DATASEG
defc `__IO_SEGSIZE' = __IO_SEGSIZE
defc `__IO_MB0CR' = __IO_MB0CR
defc `__IO_MB1CR' = __IO_MB1CR
defc `__IO_MB2CR' = __IO_MB2CR
defc `__IO_MB3CR' = __IO_MB3CR

defc `__IO_MTCR' = __IO_MTCR

defc `__IO_SPD0R' = __IO_SPD0R
defc `__IO_SPD1R' = __IO_SPD1R
defc `__IO_SPD2R' = __IO_SPD2R
defc `__IO_SPSR' = __IO_SPSR
defc `__IO_SPCR' = __IO_SPCR

defc `__IO_GROM' = __IO_GROM
defc `__IO_GRAM' = __IO_GRAM
defc `__IO_GCPU' = __IO_GCPU
defc `__IO_GREV' = __IO_GREV

defc `__IO_PADR' = __IO_PADR

defc `__IO_PBDR' = __IO_PBDR
defc `__IO_PBDDR' = __IO_PBDDR

defc `__IO_PCDR' = __IO_PCDR
defc `__IO_PCFR' = __IO_PCFR

defc `__IO_PDDR' = __IO_PDDR
defc `__IO_PDCR' = __IO_PDCR
defc `__IO_PDFR' = __IO_PDFR
defc `__IO_PDDCR' = __IO_PDDCR
defc `__IO_PDDDR' = __IO_PDDDR
defc `__IO_PDB0R' = __IO_PDB0R
defc `__IO_PDB1R' = __IO_PDB1R
defc `__IO_PDB2R' = __IO_PDB2R
defc `__IO_PDB3R' = __IO_PDB3R
defc `__IO_PDB4R' = __IO_PDB4R
defc `__IO_PDB5R' = __IO_PDB5R
defc `__IO_PDB6R' = __IO_PDB6R
defc `__IO_PDB7R' = __IO_PDB7R

defc `__IO_PEDR' = __IO_PEDR
defc `__IO_PECR' = __IO_PECR
defc `__IO_PEFR' = __IO_PEFR
defc `__IO_PEDCR' = __IO_PEDCR
defc `__IO_PEDDR' = __IO_PEDDR
defc `__IO_PEB0R' = __IO_PEB0R
defc `__IO_PEB1R' = __IO_PEB1R
defc `__IO_PEB2R' = __IO_PEB2R
defc `__IO_PEB3R' = __IO_PEB3R
defc `__IO_PEB4R' = __IO_PEB4R
defc `__IO_PEB5R' = __IO_PEB5R
defc `__IO_PEB6R' = __IO_PEB6R
defc `__IO_PEB7R' = __IO_PEB7R

defc `__IO_IB0CR' = __IO_IB0CR
defc `__IO_IB1CR' = __IO_IB1CR
defc `__IO_IB2CR' = __IO_IB2CR
defc `__IO_IB3CR' = __IO_IB3CR
defc `__IO_IB4CR' = __IO_IB4CR
defc `__IO_IB5CR' = __IO_IB5CR
defc `__IO_IB6CR' = __IO_IB6CR
defc `__IO_IB7CR' = __IO_IB7CR

defc `__IO_I0CR' = __IO_I0CR
defc `__IO_I1CR' = __IO_I1CR

defc `__IO_TACSR' = __IO_TACSR
defc `__IO_TAPR' = __IO_TAPR
defc `__IO_TAT1R' = __IO_TAT1R
defc `__IO_TACR' = __IO_TACR
defc `__IO_TAT2R' = __IO_TAT2R
defc `__IO_TAT8R' = __IO_TAT8R
defc `__IO_TAT3R' = __IO_TAT3R
defc `__IO_TAT9R' = __IO_TAT9R
defc `__IO_TAT4R' = __IO_TAT4R
defc `__IO_TAT10R' = __IO_TAT10R
defc `__IO_TAT5R' = __IO_TAT5R
defc `__IO_TAT6R' = __IO_TAT6R
defc `__IO_TAT7R' = __IO_TAT7R

defc `__IO_TBCSR' = __IO_TBCSR
defc `__IO_TBCR' = __IO_TBCR
defc `__IO_TBM1R' = __IO_TBM1R
defc `__IO_TBL1R' = __IO_TBL1R
defc `__IO_TBM2R' = __IO_TBM2R
defc `__IO_TBL2R' = __IO_TBL2R
defc `__IO_TBCMR' = __IO_TBCMR
defc `__IO_TBCLR' = __IO_TBCLR

defc `__IO_SADR' = __IO_SADR
defc `__IO_SAAR' = __IO_SAAR
defc `__IO_SALR' = __IO_SALR
defc `__IO_SASR' = __IO_SASR
defc `__IO_SACR' = __IO_SACR

defc `__IO_SBDR' = __IO_SBDR
defc `__IO_SBAR' = __IO_SBAR
defc `__IO_SBLR' = __IO_SBLR
defc `__IO_SBSR' = __IO_SBSR
defc `__IO_SBCR' = __IO_SBCR

defc `__IO_SCDR' = __IO_SCDR
defc `__IO_SCAR' = __IO_SCAR
defc `__IO_SCLR' = __IO_SCLR
defc `__IO_SCSR' = __IO_SCSR
defc `__IO_SCCR' = __IO_SCCR

defc `__IO_SDDR' = __IO_SDDR
defc `__IO_SDAR' = __IO_SDAR
defc `__IO_SDLR' = __IO_SDLR
defc `__IO_SDSR' = __IO_SDSR
defc `__IO_SDCR' = __IO_SDCR
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__R2KA'
`#define' `__R2KA'  __R2KA

`#define' `__R2KA_IQ2T'  __R2KA_IQ2T
`#define' `__R2KA_IQ3T'  __R2KA_IQ3T
`#define' `__R2KA_IQ4T'  __R2KA_IQ4T
`#define' `__R2KA_IQ5T'  __R2KA_IQ5T

`#define' `__IO_GCSR'  __IO_GCSR

`#define' `__IO_RTCCR'  __IO_RTCCR
`#define' `__IO_RTC0R'  __IO_RTC0R
`#define' `__IO_RTC1R'  __IO_RTC1R
`#define' `__IO_RTC2R'  __IO_RTC2R
`#define' `__IO_RTC3R'  __IO_RTC3R
`#define' `__IO_RTC4R'  __IO_RTC4R
`#define' `__IO_RTC5R'  __IO_RTC5R

`#define' `__IO_WDTCR'  __IO_WDTCR
`#define' `__IO_WDTTR'  __IO_WDTTR

`#define' `__IO_GCM0R'  __IO_GCM0R
`#define' `__IO_GCM1R'  __IO_GCM1R
`#define' `__IO_GOCR'  __IO_GOCR
`#define' `__IO_GCDR'  __IO_GCDR

`#define' `__IO_MMIDR'  __IO_MMIDR
`#define' `__IO_STACKSEG'  __IO_STACKSEG
`#define' `__IO_DATASEG'  __IO_DATASEG
`#define' `__IO_SEGSIZE'  __IO_SEGSIZE
`#define' `__IO_MB0CR'  __IO_MB0CR
`#define' `__IO_MB1CR'  __IO_MB1CR
`#define' `__IO_MB2CR'  __IO_MB2CR
`#define' `__IO_MB3CR'  __IO_MB3CR

`#define' `__IO_MTCR'  __IO_MTCR

`#define' `__IO_SPD0R'  __IO_SPD0R
`#define' `__IO_SPD1R'  __IO_SPD1R
`#define' `__IO_SPD2R'  __IO_SPD2R
`#define' `__IO_SPSR'  __IO_SPSR
`#define' `__IO_SPCR'  __IO_SPCR

`#define' `__IO_GROM'  __IO_GROM
`#define' `__IO_GRAM'  __IO_GRAM
`#define' `__IO_GCPU'  __IO_GCPU
`#define' `__IO_GREV'  __IO_GREV

`#define' `__IO_PADR'  __IO_PADR

`#define' `__IO_PBDR'  __IO_PBDR
`#define' `__IO_PBDDR'  __IO_PBDDR

`#define' `__IO_PCDR'  __IO_PCDR
`#define' `__IO_PCFR'  __IO_PCFR

`#define' `__IO_PDDR'  __IO_PDDR
`#define' `__IO_PDCR'  __IO_PDCR
`#define' `__IO_PDFR'  __IO_PDFR
`#define' `__IO_PDDCR'  __IO_PDDCR
`#define' `__IO_PDDDR'  __IO_PDDDR
`#define' `__IO_PDB0R'  __IO_PDB0R
`#define' `__IO_PDB1R'  __IO_PDB1R
`#define' `__IO_PDB2R'  __IO_PDB2R
`#define' `__IO_PDB3R'  __IO_PDB3R
`#define' `__IO_PDB4R'  __IO_PDB4R
`#define' `__IO_PDB5R'  __IO_PDB5R
`#define' `__IO_PDB6R'  __IO_PDB6R
`#define' `__IO_PDB7R'  __IO_PDB7R

`#define' `__IO_PEDR'  __IO_PEDR
`#define' `__IO_PECR'  __IO_PECR
`#define' `__IO_PEFR'  __IO_PEFR
`#define' `__IO_PEDCR'  __IO_PEDCR
`#define' `__IO_PEDDR'  __IO_PEDDR
`#define' `__IO_PEB0R'  __IO_PEB0R
`#define' `__IO_PEB1R'  __IO_PEB1R
`#define' `__IO_PEB2R'  __IO_PEB2R
`#define' `__IO_PEB3R'  __IO_PEB3R
`#define' `__IO_PEB4R'  __IO_PEB4R
`#define' `__IO_PEB5R'  __IO_PEB5R
`#define' `__IO_PEB6R'  __IO_PEB6R
`#define' `__IO_PEB7R'  __IO_PEB7R

`#define' `__IO_IB0CR'  __IO_IB0CR
`#define' `__IO_IB1CR'  __IO_IB1CR
`#define' `__IO_IB2CR'  __IO_IB2CR
`#define' `__IO_IB3CR'  __IO_IB3CR
`#define' `__IO_IB4CR'  __IO_IB4CR
`#define' `__IO_IB5CR'  __IO_IB5CR
`#define' `__IO_IB6CR'  __IO_IB6CR
`#define' `__IO_IB7CR'  __IO_IB7CR

`#define' `__IO_I0CR'  __IO_I0CR
`#define' `__IO_I1CR'  __IO_I1CR

`#define' `__IO_TACSR'  __IO_TACSR
`#define' `__IO_TAPR'  __IO_TAPR
`#define' `__IO_TAT1R'  __IO_TAT1R
`#define' `__IO_TACR'  __IO_TACR
`#define' `__IO_TAT2R'  __IO_TAT2R
`#define' `__IO_TAT8R'  __IO_TAT8R
`#define' `__IO_TAT3R'  __IO_TAT3R
`#define' `__IO_TAT9R'  __IO_TAT9R
`#define' `__IO_TAT4R'  __IO_TAT4R
`#define' `__IO_TAT10R'  __IO_TAT10R
`#define' `__IO_TAT5R'  __IO_TAT5R
`#define' `__IO_TAT6R'  __IO_TAT6R
`#define' `__IO_TAT7R'  __IO_TAT7R

`#define' `__IO_TBCSR'  __IO_TBCSR
`#define' `__IO_TBCR'  __IO_TBCR
`#define' `__IO_TBM1R'  __IO_TBM1R
`#define' `__IO_TBL1R'  __IO_TBL1R
`#define' `__IO_TBM2R'  __IO_TBM2R
`#define' `__IO_TBL2R'  __IO_TBL2R
`#define' `__IO_TBCMR'  __IO_TBCMR
`#define' `__IO_TBCLR'  __IO_TBCLR

`#define' `__IO_SADR'  __IO_SADR
`#define' `__IO_SAAR'  __IO_SAAR
`#define' `__IO_SALR'  __IO_SALR
`#define' `__IO_SASR'  __IO_SASR
`#define' `__IO_SACR'  __IO_SACR

`#define' `__IO_SBDR'  __IO_SBDR
`#define' `__IO_SBAR'  __IO_SBAR
`#define' `__IO_SBLR'  __IO_SBLR
`#define' `__IO_SBSR'  __IO_SBSR
`#define' `__IO_SBCR'  __IO_SBCR

`#define' `__IO_SCDR'  __IO_SCDR
`#define' `__IO_SCAR'  __IO_SCAR
`#define' `__IO_SCLR'  __IO_SCLR
`#define' `__IO_SCSR'  __IO_SCSR
`#define' `__IO_SCCR'  __IO_SCCR

`#define' `__IO_SDDR'  __IO_SDDR
`#define' `__IO_SDAR'  __IO_SDAR
`#define' `__IO_SDLR'  __IO_SDLR
`#define' `__IO_SDSR'  __IO_SDSR
`#define' `__IO_SDCR'  __IO_SDCR
')
