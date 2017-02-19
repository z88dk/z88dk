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

# BDOS

define(`__CPM_RCON', 1)       # read console
define(`__CPM_WCON', 2)       # write console
define(`__CPM_RRDR', 3)       # read reader
define(`__CPM_WPUN', 4)       # write punch
define(`__CPM_WLST', 5)       # write list
define(`__CPM_DCIO', 6)       # direct console I/O
define(`__CPM_GIOB', 7)       # get I/O byte
define(`__CPM_SIOB', 8)       # set I/O byte
define(`__CPM_PRST', 9)       # print string
define(`__CPM_RCOB', 10)      # read console buffered
define(`__CPM_ICON', 11)      # interrogate console ready
define(`__CPM_VERS', 12)      # return version number
define(`__CPM_RDS',  13)      # reset disk system
define(`__CPM_LGIN', 14)      # log in and select disk
define(`__CPM_OPN',  15)      # open file
define(`__CPM_CLS',  16)      # close file
define(`__CPM_FFST', 17)      # find first
define(`__CPM_FNXT', 18)      # find next
define(`__CPM_DEL',  19)      # delete file
define(`__CPM_READ', 20)      # read next record
define(`__CPM_WRIT', 21)      # write next record
define(`__CPM_MAKE', 22)      # create file
define(`__CPM_REN',  23)      # rename file
define(`__CPM_ILOG', 24)      # get bit map of logged in disks
define(`__CPM_IDRV', 25)      # interrogate drive number
define(`__CPM_SDMA', 26)      # set DMA address for i/o
define(`__CPM_SUID', 32)      # set/get user id
define(`__CPM_RRAN', 33)      # read random record
define(`__CPM_WRAN', 34)      # write random record
define(`__CPM_CFS',  35)      # compute file size
define(`__CPM_DSEG', 51)      # set DMA segment

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__CPM_RCON'
PUBLIC `__CPM_WCON'
PUBLIC `__CPM_RRDR'
PUBLIC `__CPM_WPUN'
PUBLIC `__CPM_WLST'
PUBLIC `__CPM_DCIO'
PUBLIC `__CPM_GIOB'
PUBLIC `__CPM_SIOB'
PUBLIC `__CPM_PRST'
PUBLIC `__CPM_RCOB'
PUBLIC `__CPM_ICON'
PUBLIC `__CPM_VERS'
PUBLIC `__CPM_RDS'
PUBLIC `__CPM_LGIN'
PUBLIC `__CPM_OPN'
PUBLIC `__CPM_CLS'
PUBLIC `__CPM_FFST'
PUBLIC `__CPM_FNXT'
PUBLIC `__CPM_DEL'
PUBLIC `__CPM_READ'
PUBLIC `__CPM_WRIT'
PUBLIC `__CPM_MAKE'
PUBLIC `__CPM_REN'
PUBLIC `__CPM_ILOG'
PUBLIC `__CPM_IDRV'
PUBLIC `__CPM_SDMA'
PUBLIC `__CPM_SUID'
PUBLIC `__CPM_RRAN'
PUBLIC `__CPM_WRAN'
PUBLIC `__CPM_CFS'
PUBLIC `__CPM_DSEG'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__CPM_RCON' = __CPM_RCON
defc `__CPM_WCON' = __CPM_WCON
defc `__CPM_RRDR' = __CPM_RRDR
defc `__CPM_WPUN' = __CPM_WPUN
defc `__CPM_WLST' = __CPM_WLST
defc `__CPM_DCIO' = __CPM_DCIO
defc `__CPM_GIOB' = __CPM_GIOB
defc `__CPM_SIOB' = __CPM_SIOB
defc `__CPM_PRST' = __CPM_PRST
defc `__CPM_RCOB' = __CPM_RCOB
defc `__CPM_ICON' = __CPM_ICON
defc `__CPM_VERS' = __CPM_VERS
defc `__CPM_RDS'  = __CPM_RDS
defc `__CPM_LGIN' = __CPM_LGIN
defc `__CPM_OPN'  = __CPM_OPN
defc `__CPM_CLS'  = __CPM_CLS
defc `__CPM_FFST' = __CPM_FFST
defc `__CPM_FNXT' = __CPM_FNXT
defc `__CPM_DEL'  = __CPM_DEL
defc `__CPM_READ' = __CPM_READ
defc `__CPM_WRIT' = __CPM_WRIT
defc `__CPM_MAKE' = __CPM_MAKE
defc `__CPM_REN'  = __CPM_REN
defc `__CPM_ILOG' = __CPM_ILOG
defc `__CPM_IDRV' = __CPM_IDRV
defc `__CPM_SDMA' = __CPM_SDMA
defc `__CPM_SUID' = __CPM_SUID
defc `__CPM_RRAN' = __CPM_RRAN
defc `__CPM_WRAN' = __CPM_WRAN
defc `__CPM_CFS'  = __CPM_CFS
defc `__CPM_DSEG' = __CPM_DSEG
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__CPM_RCON'  __CPM_RCON
`#define' `__CPM_WCON'  __CPM_WCON
`#define' `__CPM_RRDR'  __CPM_RRDR
`#define' `__CPM_WPUN'  __CPM_WPUN
`#define' `__CPM_WLST'  __CPM_WLST
`#define' `__CPM_DCIO'  __CPM_DCIO
`#define' `__CPM_GIOB'  __CPM_GIOB
`#define' `__CPM_SIOB'  __CPM_SIOB
`#define' `__CPM_PRST'  __CPM_PRST
`#define' `__CPM_RCOB'  __CPM_RCOB
`#define' `__CPM_ICON'  __CPM_ICON
`#define' `__CPM_VERS'  __CPM_VERS
`#define' `__CPM_RDS'   __CPM_RDS
`#define' `__CPM_LGIN'  __CPM_LGIN
`#define' `__CPM_OPN'   __CPM_OPN
`#define' `__CPM_CLS'   __CPM_CLS
`#define' `__CPM_FFST'  __CPM_FFST
`#define' `__CPM_FNXT'  __CPM_FNXT
`#define' `__CPM_DEL'   __CPM_DEL
`#define' `__CPM_READ'  __CPM_READ
`#define' `__CPM_WRIT'  __CPM_WRIT
`#define' `__CPM_MAKE'  __CPM_MAKE
`#define' `__CPM_REN'   __CPM_REN
`#define' `__CPM_ILOG'  __CPM_ILOG
`#define' `__CPM_IDRV'  __CPM_IDRV
`#define' `__CPM_SDMA'  __CPM_SDMA
`#define' `__CPM_SUID'  __CPM_SUID
`#define' `__CPM_RRAN'  __CPM_RRAN
`#define' `__CPM_WRAN'  __CPM_WRAN
`#define' `__CPM_CFS'   __CPM_CFS
`#define' `__CPM_DSEG'  __CPM_DSEG
')

undefine(`__count__')
undefine(`__ECOUNT__')
