divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

define(`__ZXNEXT', 1)

define(`__ZXNEXT_1MB', 1)
define(`__ZXNEXT_2MB', 2)

# ZX Next Runtime Configuration

# Static Environment

define(`__ENVIRONMENT_FILENAME', `"/sys/env"')
define(`__TEMP_DIRECTORY', `"/tmp"')

# Compatible Spectrum model

define(`__SPECTRUM', 2)

define(`__SPECTRUM_48', 1)
define(`__SPECTRUM_128', 2)
define(`__SPECTRUM_128_P2', 4)
define(`__SPECTRUM_128_P2A', 8)
define(`__SPECTRUM_128_P3', 16)
define(`__SPECTRUM_PENTAGON', 32)

# Second Display File
# Library functions will use display file base address 0xc000

define(`__USE_SPECTRUM_128_SECOND_DFILE', 0)

# Use System Variables
# Some globals like GLOBAL_ZX_PORT_7FFD will map to existing system variable address

define(`__USE_SYSVAR', 0)

# Use Extended Opcodes
# (not applied yet)

define(`__USE_ZXN_OPCODES', 0)

define(`__USE_ZXN_OPCODES_NEXTREG', 1)
define(`__USE_ZXN_OPCODES_MLT', 2)
define(`__USE_ZXN_OPCODES_LDIR', 4)
define(`__USE_ZXN_OPCODES_DISPLAY', 8)
define(`__USE_ZXN_OPCODES_OTHER', 16)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__ZXNEXT'

PUBLIC `__SPECTRUM'

PUBLIC `__SPECTRUM_48'
PUBLIC `__SPECTRUM_128'
PUBLIC `__SPECTRUM_128_P2'
PUBLIC `__SPECTRUM_128_P2A'
PUBLIC `__SPECTRUM_128_P3'
PUBLIC `__SPECTRUM_PENTAGON'

PUBLIC `__USE_SPECTRUM_128_SECOND_DFILE'

PUBLIC `__USE_SYSVAR'

PUBLIC `__USE_ZXN_OPCODES'

PUBLIC `__USE_ZXN_OPCODES_NEXTREG'
PUBLIC `__USE_ZXN_OPCODES_MLT'
PUBLIC `__USE_ZXN_OPCODES_LDIR'
PUBLIC `__USE_ZXN_OPCODES_DISPLAY'
PUBLIC `__USE_ZXN_OPCODES_OTHER'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__ZXNEXT' = __ZXNEXT

; `define(`__ENVIRONMENT_FILENAME',' __ENVIRONMENT_FILENAME)
; `define(`__TEMP_DIRECTORY',' __TEMP_DIRECTORY)

defc `__SPECTRUM' = __SPECTRUM

defc `__SPECTRUM_48' = __SPECTRUM_48
defc `__SPECTRUM_128' = __SPECTRUM_128
defc `__SPECTRUM_128_P2' = __SPECTRUM_128_P2
defc `__SPECTRUM_128_P2A' = __SPECTRUM_128_P2A
defc `__SPECTRUM_128_P3' = __SPECTRUM_128_P3
defc `__SPECTRUM_PENTAGON' = __SPECTRUM_PENTAGON

defc `__USE_SPECTRUM_128_SECOND_DFILE' = __USE_SPECTRUM_128_SECOND_DFILE

defc `__USE_SYSVAR' = __USE_SYSVAR

defc `__USE_ZXN_OPCODES' = __USE_ZXN_OPCODES

defc `__USE_ZXN_OPCODES_NEXTREG' = __USE_ZXN_OPCODES_NEXTREG
defc `__USE_ZXN_OPCODES_MLT' = __USE_ZXN_OPCODES_MLT
defc `__USE_ZXN_OPCODES_LDIR' = __USE_ZXN_OPCODES_LDIR
defc `__USE_ZXN_OPCODES_DISPLAY' = __USE_ZXN_OPCODES_DISPLAY
defc `__USE_ZXN_OPCODES_OTHER' = __USE_ZXN_OPCODES_OTHER
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__ZXNEXT'
`#define' `__ZXNEXT'    __ZXNEXT

`#undef'  `__SPECTRUM'
`#define' `__SPECTRUM'  __SPECTRUM

`#define' `__SPECTRUM_48'  __SPECTRUM_48
`#define' `__SPECTRUM_128'  __SPECTRUM_128
`#define' `__SPECTRUM_128_P2'  __SPECTRUM_128_P2
`#define' `__SPECTRUM_128_P2A'  __SPECTRUM_128_P2A
`#define' `__SPECTRUM_128_P3'  __SPECTRUM_128_P3
`#define' `__SPECTRUM_PENTAGON'  __SPECTRUM_PENTAGON

`#define' `__USE_SPECTRUM_128_SECOND_DFILE'  __USE_SPECTRUM_128_SECOND_DFILE

`#define' `__USE_SYSVAR'  __USE_SYSVAR

`#define' `__USE_ZXN_OPCODES'  __USE_ZXN_OPCODES

`#define' `__USE_ZXN_OPCODES_NEXTREG'  __USE_ZXN_OPCODES_NEXTREG
`#define' `__USE_ZXN_OPCODES_MLT'  __USE_ZXN_OPCODES_MLT
`#define' `__USE_ZXN_OPCODES_LDIR'  __USE_ZXN_OPCODES_LDIR
`#define' `__USE_ZXN_OPCODES_DISPLAY'  __USE_ZXN_OPCODES_DISPLAY
`#define' `__USE_ZXN_OPCODES_OTHER'  __USE_ZXN_OPCODES_OTHER
')
