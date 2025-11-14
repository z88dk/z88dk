define(`__count__', 0)
define(`__ECOUNT__', `__count__`'define(`__count__', eval(__count__+1))')

dnl############################################################
dnl# C LIBRARY CONSTANTS - MESSAGES AND IOCTL

include(`target/clib_const.m4')

dnl# NO USER CONFIGURATION, MUST APPEAR FIRST
dnl############################################################

divert(-1)

###############################################################
# TARGET CONSTANTS - MESSAGES AND IOCTL
# rebuild the library if changes are made
#

# IOCTL

# zx_01_input_kbd_inkey

define(`IOCTL_ITERM_GET_DELAY',  0x1081)
define(`IOCTL_ITERM_SET_DELAY',  0x1001)

# zx_01_input_kbd_lastk

define(`IOCTL_ITERM_LASTK',      0x1101)
   
# zx_01_output_char_32
# zx_01_output_char_64
# zx_01_output_fzx
# zx_01_output_char_32_tty_z88dk
# zx_01_output_char_64_tty_z88dk
# zx_01_output_fzx_tty_z88dk

define(`IOCTL_OTERM_FCOLOR',     0x1002)
define(`IOCTL_OTERM_FMASK',      0x1102)
define(`IOCTL_OTERM_BCOLOR',     0x1202)

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `IOCTL_ITERM_GET_DELAY'
PUBLIC `IOCTL_ITERM_SET_DELAY'

PUBLIC `IOCTL_ITERM_LASTK'

PUBLIC `IOCTL_OTERM_FCOLOR'
PUBLIC `IOCTL_OTERM_FMASK'
PUBLIC `IOCTL_OTERM_BCOLOR'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `IOCTL_ITERM_GET_DELAY' = IOCTL_ITERM_GET_DELAY
defc `IOCTL_ITERM_SET_DELAY' = IOCTL_ITERM_SET_DELAY

defc `IOCTL_ITERM_LASTK'     = IOCTL_ITERM_LASTK

defc `IOCTL_OTERM_FCOLOR'    = IOCTL_OTERM_FCOLOR
defc `IOCTL_OTERM_FMASK'     = IOCTL_OTERM_FMASK
defc `IOCTL_OTERM_BCOLOR'    = IOCTL_OTERM_BCOLOR
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `IOCTL_ITERM_GET_DELAY'  IOCTL_ITERM_GET_DELAY
`#define' `IOCTL_ITERM_SET_DELAY'  IOCTL_ITERM_SET_DELAY

`#define' `IOCTL_ITERM_LASTK'      IOCTL_ITERM_LASTK

`#define' `IOCTL_OTERM_FCOLOR'     IOCTL_OTERM_FCOLOR
`#define' `IOCTL_OTERM_FMASK'      IOCTL_OTERM_FMASK
`#define' `IOCTL_OTERM_BCOLOR'     IOCTL_OTERM_BCOLOR
')

undefine(`__count__')
undefine(`__ECOUNT__')
