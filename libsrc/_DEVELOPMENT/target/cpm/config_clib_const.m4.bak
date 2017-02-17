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

define(`CPM_RCON', 1)       # read console
define(`CPM_WCON', 2)       # write console
define(`CPM_RRDR', 3)       # read reader
define(`CPM_WPUN', 4)       # write punch
define(`CPM_WLST', 5)       # write list
define(`CPM_DCIO', 6)       # direct console I/O
define(`CPM_GIOB', 7)       # get I/O byte
define(`CPM_SIOB', 8)       # set I/O byte
define(`CPM_PRST', 9)       # print string
define(`CPM_RCOB', 10)      # read console buffered
define(`CPM_ICON', 11)      # interrogate console ready
define(`CPM_VERS', 12)      # return version number
define(`CPM_RDS',  13)      # reset disk system
define(`CPM_LGIN', 14)      # log in and select disk
define(`CPM_OPN',  15)      # open file
define(`CPM_CLS',  16)      # close file
define(`CPM_FFST', 17)      # find first
define(`CPM_FNXT', 18)      # find next
define(`CPM_DEL',  19)      # delete file
define(`CPM_READ', 20)      # read next record
define(`CPM_WRIT', 21)      # write next record
define(`CPM_MAKE', 22)      # create file
define(`CPM_REN',  23)      # rename file
define(`CPM_ILOG', 24)      # get bit map of logged in disks
define(`CPM_IDRV', 25)      # interrogate drive number
define(`CPM_SDMA', 26)      # set DMA address for i/o
define(`CPM_SUID', 32)      # set/get user id
define(`CPM_RRAN', 33)      # read random record
define(`CPM_WRAN', 34)      # write random record
define(`CPM_CFS',  35)      # compute file size
define(`CPM_DSEG', 51)      # set DMA segment

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `CPM_RCON'
PUBLIC `CPM_WCON'
PUBLIC `CPM_RRDR'
PUBLIC `CPM_WPUN'
PUBLIC `CPM_WLST'
PUBLIC `CPM_DCIO'
PUBLIC `CPM_GIOB'
PUBLIC `CPM_SIOB'
PUBLIC `CPM_PRST'
PUBLIC `CPM_RCOB'
PUBLIC `CPM_ICON'
PUBLIC `CPM_VERS'
PUBLIC `CPM_RDS'
PUBLIC `CPM_LGIN'
PUBLIC `CPM_OPN'
PUBLIC `CPM_CLS'
PUBLIC `CPM_FFST'
PUBLIC `CPM_FNXT'
PUBLIC `CPM_DEL'
PUBLIC `CPM_READ'
PUBLIC `CPM_WRIT'
PUBLIC `CPM_MAKE'
PUBLIC `CPM_REN'
PUBLIC `CPM_ILOG'
PUBLIC `CPM_IDRV'
PUBLIC `CPM_SDMA'
PUBLIC `CPM_SUID'
PUBLIC `CPM_RRAN'
PUBLIC `CPM_WRAN'
PUBLIC `CPM_CFS'
PUBLIC `CPM_DSEG'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `CPM_RCON' = CPM_RCON
defc `CPM_WCON' = CPM_WCON
defc `CPM_RRDR' = CPM_RRDR
defc `CPM_WPUN' = CPM_WPUN
defc `CPM_WLST' = CPM_WLST
defc `CPM_DCIO' = CPM_DCIO
defc `CPM_GIOB' = CPM_GIOB
defc `CPM_SIOB' = CPM_SIOB
defc `CPM_PRST' = CPM_PRST
defc `CPM_RCOB' = CPM_RCOB
defc `CPM_ICON' = CPM_ICON
defc `CPM_VERS' = CPM_VERS
defc `CPM_RDS'  = CPM_RDS
defc `CPM_LGIN' = CPM_LGIN
defc `CPM_OPN'  = CPM_OPN
defc `CPM_CLS'  = CPM_CLS
defc `CPM_FFST' = CPM_FFST
defc `CPM_FNXT' = CPM_FNXT
defc `CPM_DEL'  = CPM_DEL
defc `CPM_READ' = CPM_READ
defc `CPM_WRIT' = CPM_WRIT
defc `CPM_MAKE' = CPM_MAKE
defc `CPM_REN'  = CPM_REN
defc `CPM_ILOG' = CPM_ILOG
defc `CPM_IDRV' = CPM_IDRV
defc `CPM_SDMA' = CPM_SDMA
defc `CPM_SUID' = CPM_SUID
defc `CPM_RRAN' = CPM_RRAN
defc `CPM_WRAN' = CPM_WRAN
defc `CPM_CFS'  = CPM_CFS
defc `CPM_DSEG' = CPM_DSEG
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `CPM_RCON'  CPM_RCON
`#define' `CPM_WCON'  CPM_WCON
`#define' `CPM_RRDR'  CPM_RRDR
`#define' `CPM_WPUN'  CPM_WPUN
`#define' `CPM_WLST'  CPM_WLST
`#define' `CPM_DCIO'  CPM_DCIO
`#define' `CPM_GIOB'  CPM_GIOB
`#define' `CPM_SIOB'  CPM_SIOB
`#define' `CPM_PRST'  CPM_PRST
`#define' `CPM_RCOB'  CPM_RCOB
`#define' `CPM_ICON'  CPM_ICON
`#define' `CPM_VERS'  CPM_VERS
`#define' `CPM_RDS'   CPM_RDS
`#define' `CPM_LGIN'  CPM_LGIN
`#define' `CPM_OPN'   CPM_OPN
`#define' `CPM_CLS'   CPM_CLS
`#define' `CPM_FFST'  CPM_FFST
`#define' `CPM_FNXT'  CPM_FNXT
`#define' `CPM_DEL'   CPM_DEL
`#define' `CPM_READ'  CPM_READ
`#define' `CPM_WRIT'  CPM_WRIT
`#define' `CPM_MAKE'  CPM_MAKE
`#define' `CPM_REN'   CPM_REN
`#define' `CPM_ILOG'  CPM_ILOG
`#define' `CPM_IDRV'  CPM_IDRV
`#define' `CPM_SDMA'  CPM_SDMA
`#define' `CPM_SUID'  CPM_SUID
`#define' `CPM_RRAN'  CPM_RRAN
`#define' `CPM_WRAN'  CPM_WRAN
`#define' `CPM_CFS'   CPM_CFS
`#define' `CPM_DSEG'  CPM_DSEG
')

undefine(`__count__')
undefine(`__ECOUNT__')
