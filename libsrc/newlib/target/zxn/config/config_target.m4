divert(-1)

###############################################################
# TARGET USER CONFIGURATION
# rebuild the library if changes are made
#

define(`__ZXNEXT', 1)

define(`__ZXNEXT_1MB', 1)
define(`__ZXNEXT_2MB', 2)

define(`__ZXNEXT_LAST_PAGE', 223)
define(`__ZXNEXT_LAST_DIVMMC', 15)

# ZX Next Runtime Configuration

# Static Environment

define(`__ENV_FILENAME', `c:/sys/env.cfg')          # file containing environment variables

define(`__ENV_BUFSZ', 128)                          # size of static file buffer
define(`__ENV_GETENV_VALSZ', 64)                    # size of static value buffer for getenv

define(`__ENV_TMPDIR', `c:/tmp')                    # location of tmp files
define(`__ENV_LTMPNAM', eval(len(__ENV_TMPDIR)+1+7+1))  # TMPDIR/tmpXXXX includes terminating 0
define(`__ENV_TMPMAX', 0xffff)                      # max number of unique temp files that can be created
define(`__ENV_TMPMAX_TRY', 16)                      # max number of attempts to create unique temp file in one call

define(`__ENV_BINDIR', `c:/dot')                    # location of dot commands
define(`__ENV_SYSDIR', `c:/sys')                    # location of system files

# Compatible Spectrum model

define(`__SPECTRUM', 16)

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
# Some globals like GLOBAL_ZX_PORT_7FFD will map to existing system variable addresses

define(`__USE_SYSVAR', 0)

# Use Extended Opcodes
# (not applied yet)

define(`__USE_Z80N_OPCODES', 0xff)

define(`__USE_Z80N_OPCODES_NEXTREG', 1)
define(`__USE_Z80N_OPCODES_MLT', 2)
define(`__USE_Z80N_OPCODES_LDIR', 4)
define(`__USE_Z80N_OPCODES_DISPLAY', 8)
define(`__USE_Z80N_OPCODES_OTHER', 16)

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

PUBLIC `__ZXNEXT_1MB'
PUBLIC `__ZXNEXT_2MB'

PUBLIC `__ZXNEXT_LAST_PAGE'
PUBLIC `__ZXNEXT_LAST_DIVMMC'

PUBLIC `__ENV_BUFSZ'
PUBLIC `__ENV_GETENV_VALSZ'

PUBLIC `__ENV_LTMPNAM'
PUBLIC `__ENV_TMPMAX'
PUBLIC `__ENV_TMPMAX_TRY'

PUBLIC `__SPECTRUM'

PUBLIC `__SPECTRUM_48'
PUBLIC `__SPECTRUM_128'
PUBLIC `__SPECTRUM_128_P2'
PUBLIC `__SPECTRUM_128_P2A'
PUBLIC `__SPECTRUM_128_P3'
PUBLIC `__SPECTRUM_PENTAGON'

PUBLIC `__USE_SPECTRUM_128_SECOND_DFILE'

PUBLIC `__USE_SYSVAR'

PUBLIC `__USE_Z80N_OPCODES'

PUBLIC `__USE_Z80N_OPCODES_NEXTREG'
PUBLIC `__USE_Z80N_OPCODES_MLT'
PUBLIC `__USE_Z80N_OPCODES_LDIR'
PUBLIC `__USE_Z80N_OPCODES_DISPLAY'
PUBLIC `__USE_Z80N_OPCODES_OTHER'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__ZXNEXT' = __ZXNEXT

defc `__ZXNEXT_1MB' = __ZXNEXT_1MB
defc `__ZXNEXT_2MB' = __ZXNEXT_2MB

defc `__ZXNEXT_LAST_PAGE' = __ZXNEXT_LAST_PAGE
defc `__ZXNEXT_LAST_DIVMMC' = __ZXNEXT_LAST_DIVMMC

; `define(`__ENV_FILENAME',' __ENV_FILENAME)

defc `__ENV_BUFSZ' = __ENV_BUFSZ
defc `__ENV_GETENV_VALSZ' = __ENV_GETENV_VALSZ

; `define(`__ENV_TMPDIR',' __ENV_TMPDIR)

defc `__ENV_LTMPNAM' = __ENV_LTMPNAM
defc `__ENV_TMPMAX' = __ENV_TMPMAX
defc `__ENV_TMPMAX_TRY' = __ENV_TMPMAX_TRY

; `define(`__ENV_BINDIR',' __ENV_BINDIR)
; `define(`__ENV_SYSDIR',' __ENV_SYSDIR)

defc `__SPECTRUM' = __SPECTRUM

defc `__SPECTRUM_48' = __SPECTRUM_48
defc `__SPECTRUM_128' = __SPECTRUM_128
defc `__SPECTRUM_128_P2' = __SPECTRUM_128_P2
defc `__SPECTRUM_128_P2A' = __SPECTRUM_128_P2A
defc `__SPECTRUM_128_P3' = __SPECTRUM_128_P3
defc `__SPECTRUM_PENTAGON' = __SPECTRUM_PENTAGON

defc `__USE_SPECTRUM_128_SECOND_DFILE' = __USE_SPECTRUM_128_SECOND_DFILE

defc `__USE_SYSVAR' = __USE_SYSVAR

defc `__USE_Z80N_OPCODES' = __USE_Z80N_OPCODES

defc `__USE_Z80N_OPCODES_NEXTREG' = __USE_Z80N_OPCODES_NEXTREG
defc `__USE_Z80N_OPCODES_MLT' = __USE_Z80N_OPCODES_MLT
defc `__USE_Z80N_OPCODES_LDIR' = __USE_Z80N_OPCODES_LDIR
defc `__USE_Z80N_OPCODES_DISPLAY' = __USE_Z80N_OPCODES_DISPLAY
defc `__USE_Z80N_OPCODES_OTHER' = __USE_Z80N_OPCODES_OTHER
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#undef'  `__ZXNEXT'
`#define' `__ZXNEXT'  __ZXNEXT

`#define' `__ZXNEXT_1MB'  __ZXNEXT_1MB
`#define' `__ZXNEXT_2MB'  __ZXNEXT_2MB

`#define' `__ZXNEXT_LAST_PAGE'  __ZXNEXT_LAST_PAGE
`#define' `__ZXNEXT_LAST_DIVMMC'  __ZXNEXT_LAST_DIVMMC

`#define' `__ENV_FILENAME'  "__ENV_FILENAME"

`#define' `__ENV_BUFSZ'  __ENV_BUFSZ
`#define' `__ENV_GETENV_VALSZ'  __ENV_GETENV_VALSZ

`#define' `__ENV_TMPDIR'  "__ENV_TMPDIR"
`#define' `__ENV_LTMPNAM'  __ENV_LTMPNAM
`#define' `__ENV_TMPMAX'  __ENV_TMPMAX
`#define' `__ENV_TMPMAX_TRY'  __ENV_TMPMAX_TRY

`#define' `__ENV_BINDIR'  "__ENV_BINDIR"
`#define' `__ENV_SYSDIR'  "__ENV_SYSDIR"

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

`#define' `__USE_Z80N_OPCODES'  __USE_Z80N_OPCODES

`#define' `__USE_Z80N_OPCODES_NEXTREG'  __USE_Z80N_OPCODES_NEXTREG
`#define' `__USE_Z80N_OPCODES_MLT'  __USE_Z80N_OPCODES_MLT
`#define' `__USE_Z80N_OPCODES_LDIR'  __USE_Z80N_OPCODES_LDIR
`#define' `__USE_Z80N_OPCODES_DISPLAY'  __USE_Z80N_OPCODES_DISPLAY
`#define' `__USE_Z80N_OPCODES_OTHER'  __USE_Z80N_OPCODES_OTHER
')
