divert(-1)

###############################################################
# AUDIO USER CONFIGURATION
# rebuild the library if changes are made
#

# The zx next has 3xAY chips, the beeper and four 8-bit DACs
# for generating audio.  The audio from these sources is
# directed through left and right channels to form stereo
# sound.

# 1. Beeper - 1 bit DAC, mono (delivered to left and right)
#
# A bit connected to port 0xfe drives the speaker to full
# on position or full off position under cpu control.   This
# can be used to generate one volume square wave tones but
# more sophisticated drivers dependent on cpu control can
# flutter the speaker diaphragm at intermediate positions
# to effectively increase the number of volume levels or
# multiple channels can be played by either time-sharing
# channels or adding them together modulo 2.

# PORT 0xFE: Border and Sound
#
# define(`__IO_FE', 0xfe)
# define(`__IO_FE_EAR', 0x10)     # 1-bit sound output, write to tape
# define(`__IO_FE_MIC', 0x08)     # read from tape
# define(`__IO_FE_BMASK', 0x07)   # border colour in bottom three bits
                                  #   (passes through RGB333 palette lookup)

# 2. Four 8-bit DACs - specdrum, soundrive 1.05
#
# Internally the zx next has four 8-bit DAC channels
# named A,B,C,D.  DACs A,B are directed to the left channel
# and DACs C,D are directed to the right channel.

# The ports assigned to these DACs correspond to ports
# used by existing peripherals.

# Specdrum is a single 8-bit DAC listening on port 0xdf;
# OUTs to port 0xdf write to DACs A,C so that the output
# is mono and is heard on both the left and right channels.

# PROFI Covox has an 8-bit left channel on port 0x3f and
# an 8-bit right channel on port 0x5f.  It is assigned to
# to the Next's DACs A,D respectively.

# STEREO Covox has an 8-bit left channel on port 0x0f and an
# 8-bit right channel on port 0x4f.  It is assigned to the
# the Next's DACs A,C.

# Soundrive 1.05 amalgamates these standards into four 8-bit
# channels: two on the left and two on the right.

# No one cares what channel comes from which peripheral
# so ports are named according to stereo assignment.

# PORT 0x0F 0x1F 0x4F 0x5F: Stereo DACs

define(`__IO_DAC_L0', 0x0f)
define(`__IO_DAC_L1', 0x1f)
define(`__IO_DAC_R0', 0x4f)
define(`__IO_DAC_R1', 0x5f)

# PORT 0xDF: Mono DAC

define(`__IO_DAC_M0', 0xdf)          # writes L0 and R0

# NEXTREG 45: Mono DAC
#
# define(`__REG_AUDIO_MONO_DAC', 45) # writes to L0 and R0 (for copper)

# The following port names for specific peripherals are present
# only to allow software for other targets to compile for the
# zx next.  The ports are duplicates of the above.

define(`__IO_DAC_SPECDRUM', 0xdf)    # writes L0 and R0

define(`__IO_DAC_PROFI_L', 0x3f)     # writes L0
define(`__IO_DAC_PROFI_R', 0x5f)     # writes R1

define(`__IO_DAC_COVOX_L', 0x0f)     # writes L0
define(`__IO_DAC_COVOX_R', 0x4f)     # writes R0

# soundrive mode 1

define(`__IO_SOUNDRIVE_L_A', 0x0f)
define(`__IO_SOUNDRIVE_L_B', 0x1f)
define(`__IO_SOUNDRIVE_R_C', 0x4f)
define(`__IO_SOUNDRIVE_R_D', 0x5f)

# soundrive mode 2

define(`__IO_SOUNDRIVE_L_A2', 0xf1)
define(`__IO_SOUNDRIVE_L_B2', 0xf3)
define(`__IO_SOUNDRIVE_R_C2', 0xf9)
define(`__IO_SOUNDRIVE_R_D2', 0xfb)

# 3. AY-3-8910 x 3
#
# The three AY soundchips are added in a manner that extends
# Turbosound, an existing standard for two AY chips on the
# spectrum.  All three AY chips operate in ABC or ACB stereo
# mode as determined by nextreg 0x08.

# Turbosound does not add any new ports; instead it adds
# functionality to the existing port 0xfffd.  An OUT to this
# port selects a specific AY chip and determines if the AY
# chip is enabled on the left, right or both channels.  This
# port is shared with the AY chips' register selector but
# AY registers only number 0-15 so there is no conflict.

# PORT 0xFFFD: TurboSound

define(`__IO_TURBOSOUND', 0xfffd)

define(`__IT_ENABLE_L', 0xd0)
define(`__IT_ENABLE_R', 0xb0)
define(`__IT_ENABLE_LR', 0xf0)
define(`__IT_SELECT_PSG_0', 0x0f)
define(`__IT_SELECT_PSG_1', 0x0e)
define(`__IT_SELECT_PSG_2', 0x0d)

define(`__IO_FFFD_ENABLE_L', __IT_ENABLE_L)
define(`__IO_FFFD_ENABLE_R', __IT_ENABLE_R)
define(`__IO_FFFD_ENABLE_LR', __IT_ENABLE_LR)
define(`__IO_FFFD_SELECT_PSG_0', __IT_SELECT_PSG_0)
define(`__IO_FFFD_SELECT_PSG_1', __IT_SELECT_PSG_1)
define(`__IO_FFFD_SELECT_PSG_2', __IT_SELECT_PSG_2)

# PORT 0xFFFD: AY Register Select
# PORT 0xBFFD: AY Data

define(`__IO_AY_REG', 0xfffd)
define(`__IO_AY_DAT', 0xbffd)

# NEXTREG 6: Peripheral 2 Control
#
# define(`__REG_PERIPHERAL_2', 6)
# define(`__RP2_ENABLE_TURBO', 0x80)
# define(`__RP2_DAC_I2S', 0x00)            # unknown if this affects dacs
# define(`__RP2_DAC_JAP', 0x40)            # unknown if this affects dacs
# define(`__RP2_ENABLE_LIGHTPEN', 0x20)
# define(`__RP2_ENABLE_DIVMMC', 0x10)
# define(`__RP2_ENABLE_MULTIFACE', 0x08)
# define(`__RP2_PS2_KEYBOARD', 0x00)
# define(`__RP2_PS2_MOUSE', 0x04)
# define(`__RP2_PSGMODE_AY', 0x03)         # PSGMODE may select for subtle differences
# define(`__RP2_PSGMODE_YM', 0x02)         # between AY and YM variations of the chip
# define(`__RP2_PSGMODE_DISABLE', 0x00)

# NEXTREG 8: Peripheral 3 Control
#
# define(`__REG_PERIPHERAL_3', 8)
# define(`__RP3_STEREO_ABC', 0x00)         # all AY chips use ABC stereo
# define(`__RP3_STEREO_ACB', 0x20)         # all AY chips use ACB stereo
# define(`__RP3_ENABLE_SPEAKER', 0x10)     # enable 1-bit beeper on port 0xfe
# define(`__RP3_ENABLE_SPECDRUM', 0x08)    # enable 8-bit mono dac on port 0xffdf
# define(`__RP3_ENABLE_COVOX', 0x08)       # enable 8-bit stereo dacs on ports 0x0f, 0x4f
# define(`__RP3_ENABLE_TIMEX', 0x04)
# define(`__RP3_ENABLE_TURBOSOUND', 0x02)  # enable turbosound on port 0xfffd
# define(`__RP3_UNLOCK_7FFD', 0x80)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__IO_DAC_L0'
PUBLIC `__IO_DAC_L1'
PUBLIC `__IO_DAC_R0'
PUBLIC `__IO_DAC_R1'

PUBLIC `__IO_DAC_M0'

PUBLIC `__IO_DAC_SPECDRUM'

PUBLIC `__IO_DAC_PROFI_L'
PUBLIC `__IO_DAC_PROFI_R'

PUBLIC `__IO_DAC_COVOX_L'
PUBLIC `__IO_DAC_COVOX_R'

PUBLIC `__IO_SOUNDRIVE_L_A'
PUBLIC `__IO_SOUNDRIVE_L_B'
PUBLIC `__IO_SOUNDRIVE_R_C'
PUBLIC `__IO_SOUNDRIVE_R_D'

PUBLIC `__IO_SOUNDRIVE_L_A2'
PUBLIC `__IO_SOUNDRIVE_L_B2'
PUBLIC `__IO_SOUNDRIVE_R_C2'
PUBLIC `__IO_SOUNDRIVE_R_D2'

PUBLIC `__IO_TURBOSOUND'

PUBLIC `__IT_ENABLE_L'
PUBLIC `__IT_ENABLE_R'
PUBLIC `__IT_ENABLE_LR'
PUBLIC `__IT_SELECT_PSG_0'
PUBLIC `__IT_SELECT_PSG_1'
PUBLIC `__IT_SELECT_PSG_2'

PUBLIC `__IO_FFFD_ENABLE_L'
PUBLIC `__IO_FFFD_ENABLE_R'
PUBLIC `__IO_FFFD_ENABLE_LR'
PUBLIC `__IO_FFFD_SELECT_PSG_0'
PUBLIC `__IO_FFFD_SELECT_PSG_1'
PUBLIC `__IO_FFFD_SELECT_PSG_2'

PUBLIC `__IO_AY_REG'
PUBLIC `__IO_AY_DAT'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__IO_DAC_L0' = __IO_DAC_L0
defc `__IO_DAC_L1' = __IO_DAC_L1
defc `__IO_DAC_R0' = __IO_DAC_R0
defc `__IO_DAC_R1' = __IO_DAC_R1

defc `__IO_DAC_M0' = __IO_DAC_M0

defc `__IO_DAC_SPECDRUM' = __IO_DAC_SPECDRUM

defc `__IO_DAC_PROFI_L' = __IO_DAC_PROFI_L
defc `__IO_DAC_PROFI_R' = __IO_DAC_PROFI_R

defc `__IO_DAC_COVOX_L' = __IO_DAC_COVOX_L
defc `__IO_DAC_COVOX_R' = __IO_DAC_COVOX_R

defc `__IO_SOUNDRIVE_L_A' = __IO_SOUNDRIVE_L_A
defc `__IO_SOUNDRIVE_L_B' = __IO_SOUNDRIVE_L_B
defc `__IO_SOUNDRIVE_R_C' = __IO_SOUNDRIVE_R_C
defc `__IO_SOUNDRIVE_R_D' = __IO_SOUNDRIVE_R_D

defc `__IO_SOUNDRIVE_L_A2' = __IO_SOUNDRIVE_L_A2
defc `__IO_SOUNDRIVE_L_B2' = __IO_SOUNDRIVE_L_B2
defc `__IO_SOUNDRIVE_R_C2' = __IO_SOUNDRIVE_R_C2
defc `__IO_SOUNDRIVE_R_D2' = __IO_SOUNDRIVE_R_D2

defc `__IO_TURBOSOUND' = __IO_TURBOSOUND

defc `__IT_ENABLE_L' = __IT_ENABLE_L
defc `__IT_ENABLE_R' = __IT_ENABLE_R
defc `__IT_ENABLE_LR' = __IT_ENABLE_LR
defc `__IT_SELECT_PSG_0' = __IT_SELECT_PSG_0
defc `__IT_SELECT_PSG_1' = __IT_SELECT_PSG_1
defc `__IT_SELECT_PSG_2' = __IT_SELECT_PSG_2

defc `__IO_FFFD_ENABLE_L' = __IT_ENABLE_L
defc `__IO_FFFD_ENABLE_R' = __IT_ENABLE_R
defc `__IO_FFFD_ENABLE_LR' = __IT_ENABLE_LR
defc `__IO_FFFD_SELECT_PSG_0' = __IT_SELECT_PSG_0
defc `__IO_FFFD_SELECT_PSG_1' = __IT_SELECT_PSG_1
defc `__IO_FFFD_SELECT_PSG_2' = __IT_SELECT_PSG_2

defc `__IO_AY_REG' = __IO_AY_REG
defc `__IO_AY_DAT' = __IO_AY_DAT
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__IO_DAC_L0'  __IO_DAC_L0
`#define' `__IO_DAC_L1'  __IO_DAC_L1
`#define' `__IO_DAC_R0'  __IO_DAC_R0
`#define' `__IO_DAC_R1'  __IO_DAC_R1

`#define' `__IO_DAC_M0'  __IO_DAC_M0

`#define' `__IO_DAC_SPECDRUM'  __IO_DAC_SPECDRUM

`#define' `__IO_DAC_PROFI_L'  __IO_DAC_PROFI_L
`#define' `__IO_DAC_PROFI_R'  __IO_DAC_PROFI_R

`#define' `__IO_DAC_COVOX_L'  __IO_DAC_COVOX_L
`#define' `__IO_DAC_COVOX_R'  __IO_DAC_COVOX_R

`#define' `__IO_SOUNDRIVE_L_A'  __IO_SOUNDRIVE_L_A
`#define' `__IO_SOUNDRIVE_L_B'  __IO_SOUNDRIVE_L_B
`#define' `__IO_SOUNDRIVE_R_C'  __IO_SOUNDRIVE_R_C
`#define' `__IO_SOUNDRIVE_R_D'  __IO_SOUNDRIVE_R_D

`#define' `__IO_SOUNDRIVE_L_A2'  __IO_SOUNDRIVE_L_A2
`#define' `__IO_SOUNDRIVE_L_B2'  __IO_SOUNDRIVE_L_B2
`#define' `__IO_SOUNDRIVE_R_C2'  __IO_SOUNDRIVE_R_C2
`#define' `__IO_SOUNDRIVE_R_D2'  __IO_SOUNDRIVE_R_D2

`#define' `__IO_TURBOSOUND'  __IO_TURBOSOUND

`#define' `__IT_ENABLE_L'  __IT_ENABLE_L
`#define' `__IT_ENABLE_R'  __IT_ENABLE_R
`#define' `__IT_ENABLE_LR'  __IT_ENABLE_LR
`#define' `__IT_SELECT_PSG_0'  __IT_SELECT_PSG_0
`#define' `__IT_SELECT_PSG_1'  __IT_SELECT_PSG_1
`#define' `__IT_SELECT_PSG_2'  __IT_SELECT_PSG_2

`#define' `__IO_FFFD_ENABLE_L'  __IT_ENABLE_L
`#define' `__IO_FFFD_ENABLE_R'  __IT_ENABLE_R
`#define' `__IO_FFFD_ENABLE_LR'  __IT_ENABLE_LR
`#define' `__IO_FFFD_SELECT_PSG_0'  __IT_SELECT_PSG_0
`#define' `__IO_FFFD_SELECT_PSG_1'  __IT_SELECT_PSG_1
`#define' `__IO_FFFD_SELECT_PSG_2'  __IT_SELECT_PSG_2

`#define' `__IO_AY_REG'  __IO_AY_REG
`#define' `__IO_AY_DAT'  __IO_AY_DAT
')
