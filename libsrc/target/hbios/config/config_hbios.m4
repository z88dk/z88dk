divert(-1)

###############################################################
# TARGET CONSTANTS - MESSAGES AND IOCTL
# rebuild the library if changes are made
#

# HBIOS FUNCTIONS

define(`__BF_CIO',        0x00)
define(`__BF_CIOIN',      0x`'eval(__BF_CIO + 0 ,16))   # CHARACTER INPUT
define(`__BF_CIOOUT',     0x`'eval(__BF_CIO + 1 ,16))   # CHARACTER OUTPUT
define(`__BF_CIOIST',     0x`'eval(__BF_CIO + 2 ,16))   # CHARACTER INPUT STATUS
define(`__BF_CIOOST',     0x`'eval(__BF_CIO + 3 ,16))   # CHARACTER OUTPUT STATUS
define(`__BF_CIOINIT',    0x`'eval(__BF_CIO + 4 ,16))   # INIT/RESET DEVICE/LINE CONFIG
define(`__BF_CIOQUERY',   0x`'eval(__BF_CIO + 5 ,16))   # REPORT DEVICE/LINE CONFIG
define(`__BF_CIODEVICE',  0x`'eval(__BF_CIO + 6 ,16))   # REPORT DEVICE INFO

define(`__BF_DIO',        0x10)
define(`__BF_DIOSTATUS',  0x`'eval(__BF_DIO + 0 ,16))   # DISK STATUS
define(`__BF_DIORESET',   0x`'eval(__BF_DIO + 1 ,16))   # DISK RESET
define(`__BF_DIOSEEK',    0x`'eval(__BF_DIO + 2 ,16))   # DISK SEEK
define(`__BF_DIOREAD',    0x`'eval(__BF_DIO + 3 ,16))   # DISK READ SECTORS
define(`__BF_DIOWRITE',   0x`'eval(__BF_DIO + 4 ,16))   # DISK WRITE SECTORS
define(`__BF_DIOVERIFY',  0x`'eval(__BF_DIO + 5 ,16))   # DISK VERIFY SECTORS
define(`__BF_DIOFORMAT',  0x`'eval(__BF_DIO + 6 ,16))   # DISK FORMAT TRACK
define(`__BF_DIODEVICE',  0x`'eval(__BF_DIO + 7 ,16))   # DISK DEVICE INFO REPORT
define(`__BF_DIOMEDIA',   0x`'eval(__BF_DIO + 8 ,16))   # DISK MEDIA REPORT
define(`__BF_DIODEFMED',  0x`'eval(__BF_DIO + 9 ,16))   # DEFINE DISK MEDIA
define(`__BF_DIOCAP',     0x`'eval(__BF_DIO + 10,16))   # DISK CAPACITY REPORT
define(`__BF_DIOGEOM',    0x`'eval(__BF_DIO + 11,16))   # DISK GEOMETRY REPORT

define(`__BF_RTC',        0x20)
define(`__BF_RTCGETTIM',  0x`'eval(__BF_RTC + 0 ,16))   # GET TIME
define(`__BF_RTCSETTIM',  0x`'eval(__BF_RTC + 1 ,16))   # SET TIME
define(`__BF_RTCGETBYT',  0x`'eval(__BF_RTC + 2 ,16))   # GET NVRAM BYTE BY INDEX
define(`__BF_RTCSETBYT',  0x`'eval(__BF_RTC + 3 ,16))   # SET NVRAM BYTE BY INDEX
define(`__BF_RTCGETBLK',  0x`'eval(__BF_RTC + 4 ,16))   # GET NVRAM DATA BLOCK
define(`__BF_RTCSETBLK',  0x`'eval(__BF_RTC + 5 ,16))   # SET NVRAM DATA BLOCK

define(`__BF_EMU',        0x30)                       # DEPRECATED

define(`__BF_VDA',        0x40)
define(`__BF_VDAINI',     0x`'eval(__BF_VDA + 0 ,16))   # INITIALIZE VDU
define(`__BF_VDAQRY',     0x`'eval(__BF_VDA + 1 ,16))   # QUERY VDU STATUS
define(`__BF_VDARES',     0x`'eval(__BF_VDA + 2 ,16))   # SOFT RESET VDU
define(`__BF_VDADEV',     0x`'eval(__BF_VDA + 3 ,16))   # DEVICE INFO
define(`__BF_VDASCS',     0x`'eval(__BF_VDA + 4 ,16))   # SET CURSOR STYLE
define(`__BF_VDASCP',     0x`'eval(__BF_VDA + 5 ,16))   # SET CURSOR POSITION
define(`__BF_VDASAT',     0x`'eval(__BF_VDA + 6 ,16))   # SET CHARACTER ATTRIBUTE
define(`__BF_VDASCO',     0x`'eval(__BF_VDA + 7 ,16))   # SET CHARACTER COLOR
define(`__BF_VDAWRC',     0x`'eval(__BF_VDA + 8 ,16))   # WRITE CHARACTER
define(`__BF_VDAFIL',     0x`'eval(__BF_VDA + 9 ,16))   # FILL
define(`__BF_VDACPY',     0x`'eval(__BF_VDA + 10,16))   # COPY
define(`__BF_VDASCR',     0x`'eval(__BF_VDA + 11,16))   # SCROLL
define(`__BF_VDAKST',     0x`'eval(__BF_VDA + 12,16))   # GET KEYBOARD STATUS
define(`__BF_VDAKFL',     0x`'eval(__BF_VDA + 13,16))   # FLUSH KEYBOARD BUFFER
define(`__BF_VDAKRD',     0x`'eval(__BF_VDA + 14,16))   # READ KEYBOARD

define(`__BF_SYS',        0xF0)
define(`__BF_SYSRESET',   0x`'eval(__BF_SYS + 0 ,16))   # SOFT RESET HBIOS
define(`__BF_SYSVER',     0x`'eval(__BF_SYS + 1 ,16))   # GET HBIOS VERSION
define(`__BF_SYSSETBNK',  0x`'eval(__BF_SYS + 2 ,16))   # SET CURRENT BANK
define(`__BF_SYSGETBNK',  0x`'eval(__BF_SYS + 3 ,16))   # GET CURRENT BANK
define(`__BF_SYSSETCPY',  0x`'eval(__BF_SYS + 4 ,16))   # BANK MEMORY COPY SETUP
define(`__BF_SYSBNKCPY',  0x`'eval(__BF_SYS + 5 ,16))   # BANK MEMORY COPY
define(`__BF_SYSALLOC',   0x`'eval(__BF_SYS + 6 ,16))   # ALLOC HBIOS HEAP MEMORY
define(`__BF_SYSFREE',    0x`'eval(__BF_SYS + 7 ,16))   # FREE HBIOS HEAP MEMORY
define(`__BF_SYSGET',     0x`'eval(__BF_SYS + 8 ,16))   # GET HBIOS INFO
define(`__BF_SYSSET',     0x`'eval(__BF_SYS + 9 ,16))   # SET HBIOS PARAMETERS
define(`__BF_SYSPEEK',    0x`'eval(__BF_SYS + 10,16))   # GET A BYTE VALUE FROM ALT BANK
define(`__BF_SYSPOKE',    0x`'eval(__BF_SYS + 11,16))   # SET A BYTE VALUE IN ALT BANK
define(`__BF_SYSINT',     0x`'eval(__BF_SYS + 12,16))   # MANAGE INTERRUPT VECTORS

define(`__BF_SYSGET_CIOCNT',      0x00)   # GET CHAR UNIT COUNT
define(`__BF_SYSGET_DIOCNT',      0x10)   # GET DISK UNIT COUNT
define(`__BF_SYSGET_VDACNT',      0x40)   # GET VDA UNIT COUNT
define(`__BF_SYSGET_TIMER',       0xD0)   # GET CURRENT TIMER VALUE
define(`__BF_SYSGET_SECS',        0xD1)   # GET CURRENT SECONDS VALUE
define(`__BF_SYSGET_BOOTINFO',    0xE0)   # GET BOOT INFORMATION
define(`__BF_SYSGET_CPUINFO',     0xF0)   # GET CPU INFORMATION
define(`__BF_SYSGET_MEMINFO',     0xF1)   # GET MEMORY CAPACTITY INFO
define(`__BF_SYSGET_BNKINFO',     0xF2)   # GET BANK ASSIGNMENT INFO

define(`__BF_SYSSET_TIMER',       0xD0)   # SET TIMER VALUE
define(`__BF_SYSSET_SECS',        0xD1)   # SET SECONDS VALUE
define(`__BF_SYSSET_BOOTINFO',    0xE0)   # SET BOOT INFORMATION

define(`__BF_SYSINT_INFO',        0x00)   # GET INTERRUPT SYSTEM INFO
define(`__BF_SYSINT_GET',         0x10)   # GET INT VECTOR ADDRESS
define(`__BF_SYSINT_SET',         0x20)   # SET INT VECTOR ADDRESS

# CHAR DEVICE IDS

define(`__CIODEV_UART',           0x00)
define(`__CIODEV_ASCI',           0x10)
define(`__CIODEV_TERM',           0x20)
define(`__CIODEV_PRPCON',         0x30)
define(`__CIODEV_PPPCON',         0x40)
define(`__CIODEV_SIO',            0x50)
define(`__CIODEV_ACIA',           0x60)
define(`__CIODEV_PIO',            0x70)
define(`__CIODEV_UF',             0x80)
define(`__CIODEV_CONSOLE',        0xD0)

# SUB TYPES OF CHAR DEVICES

#00 RS-232
#01 TERMINAL
#02 PARALLEL PORT
#03 UNUSED

# DISK DEVICE IDS

define(`__DIODEV_MD',             0x00)
define(`__DIODEV_FD',             0x10)
define(`__DIODEV_RF',             0x20)
define(`__DIODEV_IDE',            0x30)
define(`__DIODEV_ATAPI',          0x40)
define(`__DIODEV_PPIDE',          0x50)
define(`__DIODEV_SD',             0x60)
define(`__DIODEV_PRPSD',          0x70)
define(`__DIODEV_PPPSD',          0x80)
define(`__DIODEV_HDSK',           0x90)

# VIDEO DEVICE IDS

define(`__VDADEV_VDU',            0x00)   # ECB VDU - MOTOROLA 6545
define(`__VDADEV_CVDU',           0x10)   # ECB COLOR VDU - MOS 8563
define(`__VDADEV_NEC',            0x20)   # ECB UPD7220 - NEC UPD7220
define(`__VDADEV_TMS',            0x30)   # N8 ONBOARD VDA SUBSYSTEM - TMS 9918
define(`__VDADEV_VGA',            0x40)   # VGA

# EMULATION TYPES

define(`__EMUTYP_NONE',           0x00)   # NONE
define(`__EMUTYP_TTY',            0x01)   # TTY
define(`__EMUTYP_ANSI',           0x02)   # ANSI

# HBIOS PROXY COMMON DATA BLOCK
# EXACTLY 32 BYTES AT $FFE0-$FFFF

define(`__HBX_XFC',       0x`'eval(0x10000 - 0x20     ,16)) # HBIOS PROXY INTERFACE AREA, 32 BYTES FIXED

define(`__HBX_XFCDAT',    0x`'eval(__HBX_XFC          ,16)) # DATA PORTION OF HBIOS PROXY INTERFACE AREA
define(`__HB_CURBNK',     0x`'eval(__HBX_XFCDAT + 0   ,16)) # CURRENTLY ACTIVE LOW MEMORY BANK ID
define(`__HB_INVBNK',     0x`'eval(__HBX_XFCDAT + 1   ,16)) # BANK ACTIVE AT TIME OF HBIOS CALL INVOCATION
define(`__HB_SRCADR',     0x`'eval(__HBX_XFCDAT + 2   ,16)) # BNKCPY: DESTINATION BANK ID
define(`__HB_SRCBNK',     0x`'eval(__HBX_XFCDAT + 4   ,16)) # BNKCPY: SOURCE BANK ID
define(`__HB_DSTADR',     0x`'eval(__HBX_XFCDAT + 5   ,16)) # BNKCPY: DESTINATION ADDRESS
define(`__HB_DSTBNK',     0x`'eval(__HBX_XFCDAT + 7   ,16)) # BNKCPY: SOURCE ADDRESS
define(`__HB_CPYLEN',     0x`'eval(__HBX_XFCDAT + 8   ,16)) # BNKCPY: COPY LENGTH

define(`__HBX_XFCFNS',    0x`'eval(__HBX_XFC + 0x10   ,16)) # JUMP TABLE PORTION OF HBIOS PROXY INTERFACE AREA
define(`__HB_INVOKE',     0x`'eval(__HBX_XFCFNS       ,16)) # INVOKE HBIOS FUNCTION
define(`__HB_BNKSEL',     0x`'eval(__HBX_XFCFNS +  3  ,16)) # SELECT LOW MEMORY BANK ID
define(`__HB_BNKCPY',     0x`'eval(__HBX_XFCFNS +  6  ,16)) # INTERBANK MEMORY COPY
define(`__HB_BNKCALL',    0x`'eval(__HBX_XFCFNS +  9  ,16)) # INTERBANK FUNCTION CALL
define(`__HB_IDENT',      0x`'eval(__HBX_XFCFNS + 14  ,16)) # POINTER TO HBIOS IDENT DATA BLOCK

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__BF_CIO'
PUBLIC `__BF_CIOIN'
PUBLIC `__BF_CIOOUT'
PUBLIC `__BF_CIOIST'
PUBLIC `__BF_CIOOST'
PUBLIC `__BF_CIOINIT'
PUBLIC `__BF_CIOQUERY'
PUBLIC `__BF_CIODEVICE'

PUBLIC `__BF_DIO'
PUBLIC `__BF_DIOSTATUS'
PUBLIC `__BF_DIORESET'
PUBLIC `__BF_DIOSEEK'
PUBLIC `__BF_DIOREAD'
PUBLIC `__BF_DIOWRITE'
PUBLIC `__BF_DIOVERIFY'
PUBLIC `__BF_DIOFORMAT'
PUBLIC `__BF_DIODEVICE'
PUBLIC `__BF_DIOMEDIA'
PUBLIC `__BF_DIODEFMED'
PUBLIC `__BF_DIOCAP'
PUBLIC `__BF_DIOGEOM'

PUBLIC `__BF_RTC'
PUBLIC `__BF_RTCGETTIM'
PUBLIC `__BF_RTCSETTIM'
PUBLIC `__BF_RTCGETBYT'
PUBLIC `__BF_RTCSETBYT'
PUBLIC `__BF_RTCGETBLK'
PUBLIC `__BF_RTCSETBLK'

PUBLIC `__BF_EMU'

PUBLIC `__BF_VDA'
PUBLIC `__BF_VDAINI'
PUBLIC `__BF_VDAQRY'
PUBLIC `__BF_VDARES'
PUBLIC `__BF_VDADEV'
PUBLIC `__BF_VDASCS'
PUBLIC `__BF_VDASCP'
PUBLIC `__BF_VDASAT'
PUBLIC `__BF_VDASCO'
PUBLIC `__BF_VDAWRC'
PUBLIC `__BF_VDAFIL'
PUBLIC `__BF_VDACPY'
PUBLIC `__BF_VDASCR'
PUBLIC `__BF_VDAKST'
PUBLIC `__BF_VDAKFL'
PUBLIC `__BF_VDAKRD'

PUBLIC `__BF_SYS'
PUBLIC `__BF_SYSRESET'
PUBLIC `__BF_SYSVER'
PUBLIC `__BF_SYSSETBNK'
PUBLIC `__BF_SYSGETBNK'
PUBLIC `__BF_SYSSETCPY'
PUBLIC `__BF_SYSBNKCPY'
PUBLIC `__BF_SYSALLOC'
PUBLIC `__BF_SYSFREE'
PUBLIC `__BF_SYSGET'
PUBLIC `__BF_SYSSET'
PUBLIC `__BF_SYSPEEK'
PUBLIC `__BF_SYSPOKE'
PUBLIC `__BF_SYSINT'

PUBLIC `__BF_SYSGET_CIOCNT'
PUBLIC `__BF_SYSGET_DIOCNT'
PUBLIC `__BF_SYSGET_VDACNT'
PUBLIC `__BF_SYSGET_TIMER'
PUBLIC `__BF_SYSGET_SECS'
PUBLIC `__BF_SYSGET_BOOTINFO'
PUBLIC `__BF_SYSGET_CPUINFO'
PUBLIC `__BF_SYSGET_MEMINFO'
PUBLIC `__BF_SYSGET_BNKINFO'

PUBLIC `__BF_SYSSET_TIMER'
PUBLIC `__BF_SYSSET_SECS'
PUBLIC `__BF_SYSSET_BOOTINFO'

PUBLIC `__BF_SYSINT_INFO'
PUBLIC `__BF_SYSINT_GET'
PUBLIC `__BF_SYSINT_SET'

PUBLIC `__CIODEV_UART'
PUBLIC `__CIODEV_ASCI'
PUBLIC `__CIODEV_TERM'
PUBLIC `__CIODEV_PRPCON'
PUBLIC `__CIODEV_PPPCON'
PUBLIC `__CIODEV_SIO'
PUBLIC `__CIODEV_ACIA'
PUBLIC `__CIODEV_PIO'
PUBLIC `__CIODEV_UF'
PUBLIC `__CIODEV_CONSOLE'

PUBLIC `__DIODEV_MD'
PUBLIC `__DIODEV_FD'
PUBLIC `__DIODEV_RF'
PUBLIC `__DIODEV_IDE'
PUBLIC `__DIODEV_ATAPI'
PUBLIC `__DIODEV_PPIDE'
PUBLIC `__DIODEV_SD'
PUBLIC `__DIODEV_PRPSD'
PUBLIC `__DIODEV_PPPSD'
PUBLIC `__DIODEV_HDSK'

PUBLIC `__VDADEV_VDU'
PUBLIC `__VDADEV_CVDU'
PUBLIC `__VDADEV_NEC'
PUBLIC `__VDADEV_TMS'
PUBLIC `__VDADEV_VGA'

PUBLIC `__EMUTYP_NONE'
PUBLIC `__EMUTYP_TTY'
PUBLIC `__EMUTYP_ANSI'

PUBLIC `__HB_CURBNK'
PUBLIC `__HB_INVBNK'
PUBLIC `__HB_SRCADR'
PUBLIC `__HB_SRCBNK'
PUBLIC `__HB_DSTADR'
PUBLIC `__HB_DSTBNK'
PUBLIC `__HB_CPYLEN'

PUBLIC `__HB_INVOKE'
PUBLIC `__HB_BNKSEL'
PUBLIC `__HB_BNKCPY'
PUBLIC `__HB_BNKCALL'
PUBLIC `__HB_IDENT'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__BF_CIO' = __BF_CIO
defc `__BF_CIOIN' = __BF_CIOIN
defc `__BF_CIOOUT' = __BF_CIOOUT
defc `__BF_CIOIST' = __BF_CIOIST
defc `__BF_CIOOST' = __BF_CIOOST
defc `__BF_CIOINIT' = __BF_CIOINIT
defc `__BF_CIOQUERY' = __BF_CIOQUERY
defc `__BF_CIODEVICE' = __BF_CIODEVICE

defc `__BF_DIO' = __BF_DIO
defc `__BF_DIOSTATUS' = __BF_DIOSTATUS
defc `__BF_DIORESET' = __BF_DIORESET
defc `__BF_DIOSEEK' = __BF_DIOSEEK
defc `__BF_DIOREAD' = __BF_DIOREAD
defc `__BF_DIOWRITE' = __BF_DIOWRITE
defc `__BF_DIOVERIFY' = __BF_DIOVERIFY
defc `__BF_DIOFORMAT' = __BF_DIOFORMAT
defc `__BF_DIODEVICE' = __BF_DIODEVICE
defc `__BF_DIOMEDIA' = __BF_DIOMEDIA
defc `__BF_DIODEFMED' = __BF_DIODEFMED
defc `__BF_DIOCAP' = __BF_DIOCAP
defc `__BF_DIOGEOM' = __BF_DIOGEOM

defc `__BF_RTC' = __BF_RTC
defc `__BF_RTCGETTIM' = __BF_RTCGETTIM
defc `__BF_RTCSETTIM' = __BF_RTCSETTIM
defc `__BF_RTCGETBYT' = __BF_RTCGETBYT
defc `__BF_RTCSETBYT' = __BF_RTCSETBYT
defc `__BF_RTCGETBLK' = __BF_RTCGETBLK
defc `__BF_RTCSETBLK' = __BF_RTCSETBLK

defc `__BF_EMU' = __BF_EMU

defc `__BF_VDA' = __BF_VDA
defc `__BF_VDAINI' = __BF_VDAINI
defc `__BF_VDAQRY' = __BF_VDAQRY
defc `__BF_VDARES' = __BF_VDARES
defc `__BF_VDADEV' = __BF_VDADEV
defc `__BF_VDASCS' = __BF_VDASCS
defc `__BF_VDASCP' = __BF_VDASCP
defc `__BF_VDASAT' = __BF_VDASAT
defc `__BF_VDASCO' = __BF_VDASCO
defc `__BF_VDAWRC' = __BF_VDAWRC
defc `__BF_VDAFIL' = __BF_VDAFIL
defc `__BF_VDACPY' = __BF_VDACPY
defc `__BF_VDASCR' = __BF_VDASCR
defc `__BF_VDAKST' = __BF_VDAKST
defc `__BF_VDAKFL' = __BF_VDAKFL
defc `__BF_VDAKRD' = __BF_VDAKRD

defc `__BF_SYS' = __BF_SYS
defc `__BF_SYSRESET' = __BF_SYSRESET
defc `__BF_SYSVER' = __BF_SYSVER
defc `__BF_SYSSETBNK' = __BF_SYSSETBNK
defc `__BF_SYSGETBNK' = __BF_SYSGETBNK
defc `__BF_SYSSETCPY' = __BF_SYSSETCPY
defc `__BF_SYSBNKCPY' = __BF_SYSBNKCPY
defc `__BF_SYSALLOC' = __BF_SYSALLOC
defc `__BF_SYSFREE' = __BF_SYSFREE
defc `__BF_SYSGET' = __BF_SYSGET
defc `__BF_SYSSET' = __BF_SYSSET
defc `__BF_SYSPEEK' = __BF_SYSPEEK
defc `__BF_SYSPOKE' = __BF_SYSPOKE
defc `__BF_SYSINT' = __BF_SYSINT

defc `__BF_SYSGET_CIOCNT' = __BF_SYSGET_CIOCNT
defc `__BF_SYSGET_DIOCNT' = __BF_SYSGET_DIOCNT
defc `__BF_SYSGET_VDACNT' = __BF_SYSGET_VDACNT
defc `__BF_SYSGET_TIMER' = __BF_SYSGET_TIMER
defc `__BF_SYSGET_SECS' = __BF_SYSGET_SECS
defc `__BF_SYSGET_BOOTINFO' = __BF_SYSGET_BOOTINFO
defc `__BF_SYSGET_CPUINFO' = __BF_SYSGET_CPUINFO
defc `__BF_SYSGET_MEMINFO' = __BF_SYSGET_MEMINFO
defc `__BF_SYSGET_BNKINFO' = __BF_SYSGET_BNKINFO

defc `__BF_SYSSET_TIMER' = __BF_SYSSET_TIMER
defc `__BF_SYSSET_SECS' = __BF_SYSSET_SECS
defc `__BF_SYSSET_BOOTINFO' = __BF_SYSSET_BOOTINFO

defc `__BF_SYSINT_INFO' = __BF_SYSINT_INFO
defc `__BF_SYSINT_GET' = __BF_SYSINT_GET
defc `__BF_SYSINT_SET' = __BF_SYSINT_SET

defc `__CIODEV_UART' = __CIODEV_UART
defc `__CIODEV_ASCI' = __CIODEV_ASCI
defc `__CIODEV_TERM' = __CIODEV_TERM
defc `__CIODEV_PRPCON' = __CIODEV_PRPCON
defc `__CIODEV_PPPCON' = __CIODEV_PPPCON
defc `__CIODEV_SIO' = __CIODEV_SIO
defc `__CIODEV_ACIA' = __CIODEV_ACIA
defc `__CIODEV_PIO' = __CIODEV_PIO
defc `__CIODEV_UF' = __CIODEV_UF
defc `__CIODEV_CONSOLE' = __CIODEV_CONSOLE

defc `__DIODEV_MD' = __DIODEV_MD
defc `__DIODEV_FD' = __DIODEV_FD
defc `__DIODEV_RF' = __DIODEV_RF
defc `__DIODEV_IDE' = __DIODEV_IDE
defc `__DIODEV_ATAPI' = __DIODEV_ATAPI
defc `__DIODEV_PPIDE' = __DIODEV_PPIDE
defc `__DIODEV_SD' = __DIODEV_SD
defc `__DIODEV_PRPSD' = __DIODEV_PRPSD
defc `__DIODEV_PPPSD' = __DIODEV_PPPSD
defc `__DIODEV_HDSK' = __DIODEV_HDSK

defc `__VDADEV_VDU' = __VDADEV_VDU
defc `__VDADEV_CVDU' = __VDADEV_CVDU
defc `__VDADEV_NEC' = __VDADEV_NEC
defc `__VDADEV_TMS' = __VDADEV_TMS
defc `__VDADEV_VGA' = __VDADEV_VGA

defc `__EMUTYP_NONE' = __EMUTYP_NONE
defc `__EMUTYP_TTY' = __EMUTYP_TTY
defc `__EMUTYP_ANSI' = __EMUTYP_ANSI

defc `__HBX_XFCDAT' = __HBX_XFCDAT
defc `__HB_CURBNK' = __HB_CURBNK
defc `__HB_INVBNK' = __HB_INVBNK
defc `__HB_SRCADR' = __HB_SRCADR
defc `__HB_SRCBNK' = __HB_SRCBNK
defc `__HB_DSTADR' = __HB_DSTADR
defc `__HB_DSTBNK' = __HB_DSTBNK
defc `__HB_CPYLEN' = __HB_CPYLEN

defc `__HBX_XFCFNS' = __HBX_XFCFNS
defc `__HB_INVOKE' = __HB_INVOKE
defc `__HB_BNKSEL' = __HB_BNKSEL
defc `__HB_BNKCPY' = __HB_BNKCPY
defc `__HB_BNKCALL' = __HB_BNKCALL
defc `__HB_IDENT' = __HB_IDENT
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__BF_CIO'  __BF_CIO
`#define' `__BF_CIOIN'  __BF_CIOIN
`#define' `__BF_CIOOUT'  __BF_CIOOUT
`#define' `__BF_CIOIST'  __BF_CIOIST
`#define' `__BF_CIOOST'  __BF_CIOOST
`#define' `__BF_CIOINIT'  __BF_CIOINIT
`#define' `__BF_CIOQUERY'  __BF_CIOQUERY
`#define' `__BF_CIODEVICE'  __BF_CIODEVICE

`#define' `__BF_DIO'  __BF_DIO
`#define' `__BF_DIOSTATUS'  __BF_DIOSTATUS
`#define' `__BF_DIORESET'  __BF_DIORESET
`#define' `__BF_DIOSEEK'  __BF_DIOSEEK
`#define' `__BF_DIOREAD'  __BF_DIOREAD
`#define' `__BF_DIOWRITE'  __BF_DIOWRITE
`#define' `__BF_DIOVERIFY'  __BF_DIOVERIFY
`#define' `__BF_DIOFORMAT'  __BF_DIOFORMAT
`#define' `__BF_DIODEVICE'  __BF_DIODEVICE
`#define' `__BF_DIOMEDIA'  __BF_DIOMEDIA
`#define' `__BF_DIODEFMED'  __BF_DIODEFMED
`#define' `__BF_DIOCAP'  __BF_DIOCAP
`#define' `__BF_DIOGEOM'  __BF_DIOGEOM

`#define' `__BF_RTC'  __BF_RTC
`#define' `__BF_RTCGETTIM'  __BF_RTCGETTIM
`#define' `__BF_RTCSETTIM'  __BF_RTCSETTIM
`#define' `__BF_RTCGETBYT'  __BF_RTCGETBYT
`#define' `__BF_RTCSETBYT'  __BF_RTCSETBYT
`#define' `__BF_RTCGETBLK'  __BF_RTCGETBLK
`#define' `__BF_RTCSETBLK'  __BF_RTCSETBLK

`#define' `__BF_EMU'  __BF_EMU

`#define' `__BF_VDA'  __BF_VDA
`#define' `__BF_VDAINI'  __BF_VDAINI
`#define' `__BF_VDAQRY'  __BF_VDAQRY
`#define' `__BF_VDARES'  __BF_VDARES
`#define' `__BF_VDADEV'  __BF_VDADEV
`#define' `__BF_VDASCS'  __BF_VDASCS
`#define' `__BF_VDASCP'  __BF_VDASCP
`#define' `__BF_VDASAT'  __BF_VDASAT
`#define' `__BF_VDASCO'  __BF_VDASCO
`#define' `__BF_VDAWRC'  __BF_VDAWRC
`#define' `__BF_VDAFIL'  __BF_VDAFIL
`#define' `__BF_VDACPY'  __BF_VDACPY
`#define' `__BF_VDASCR'  __BF_VDASCR
`#define' `__BF_VDAKST'  __BF_VDAKST
`#define' `__BF_VDAKFL'  __BF_VDAKFL
`#define' `__BF_VDAKRD'  __BF_VDAKRD

`#define' `__BF_SYS'  __BF_SYS
`#define' `__BF_SYSRESET'  __BF_SYSRESET
`#define' `__BF_SYSVER'  __BF_SYSVER
`#define' `__BF_SYSSETBNK'  __BF_SYSSETBNK
`#define' `__BF_SYSGETBNK'  __BF_SYSGETBNK
`#define' `__BF_SYSSETCPY'  __BF_SYSSETCPY
`#define' `__BF_SYSBNKCPY'  __BF_SYSBNKCPY
`#define' `__BF_SYSALLOC'  __BF_SYSALLOC
`#define' `__BF_SYSFREE'  __BF_SYSFREE
`#define' `__BF_SYSGET'  __BF_SYSGET
`#define' `__BF_SYSSET'  __BF_SYSSET
`#define' `__BF_SYSPEEK'  __BF_SYSPEEK
`#define' `__BF_SYSPOKE'  __BF_SYSPOKE
`#define' `__BF_SYSINT'  __BF_SYSINT

`#define' `__BF_SYSGET_CIOCNT'  __BF_SYSGET_CIOCNT
`#define' `__BF_SYSGET_DIOCNT'  __BF_SYSGET_DIOCNT
`#define' `__BF_SYSGET_VDACNT'  __BF_SYSGET_VDACNT
`#define' `__BF_SYSGET_TIMER'  __BF_SYSGET_TIMER
`#define' `__BF_SYSGET_SECS'  __BF_SYSGET_SECS
`#define' `__BF_SYSGET_BOOTINFO'  __BF_SYSGET_BOOTINFO
`#define' `__BF_SYSGET_CPUINFO'  __BF_SYSGET_CPUINFO
`#define' `__BF_SYSGET_MEMINFO'  __BF_SYSGET_MEMINFO
`#define' `__BF_SYSGET_BNKINFO'  __BF_SYSGET_BNKINFO

`#define' `__BF_SYSSET_TIMER'  __BF_SYSSET_TIMER
`#define' `__BF_SYSSET_SECS'  __BF_SYSSET_SECS
`#define' `__BF_SYSSET_BOOTINFO'  __BF_SYSSET_BOOTINFO

`#define' `__BF_SYSINT_INFO'  __BF_SYSINT_INFO
`#define' `__BF_SYSINT_GET'  __BF_SYSINT_GET
`#define' `__BF_SYSINT_SET'  __BF_SYSINT_SET

`#define' `__CIODEV_UART'  __CIODEV_UART
`#define' `__CIODEV_ASCI'  __CIODEV_ASCI
`#define' `__CIODEV_TERM'  __CIODEV_TERM
`#define' `__CIODEV_PRPCON'  __CIODEV_PRPCON
`#define' `__CIODEV_PPPCON'  __CIODEV_PPPCON
`#define' `__CIODEV_SIO'  __CIODEV_SIO
`#define' `__CIODEV_ACIA'  __CIODEV_ACIA
`#define' `__CIODEV_PIO'  __CIODEV_PIO
`#define' `__CIODEV_UF'  __CIODEV_UF
`#define' `__CIODEV_CONSOLE'  __CIODEV_CONSOLE

`#define' `__DIODEV_MD'  __DIODEV_MD
`#define' `__DIODEV_FD'  __DIODEV_FD
`#define' `__DIODEV_RF'  __DIODEV_RF
`#define' `__DIODEV_IDE'  __DIODEV_IDE
`#define' `__DIODEV_ATAPI'  __DIODEV_ATAPI
`#define' `__DIODEV_PPIDE'  __DIODEV_PPIDE
`#define' `__DIODEV_SD'  __DIODEV_SD
`#define' `__DIODEV_PRPSD'  __DIODEV_PRPSD
`#define' `__DIODEV_PPPSD'  __DIODEV_PPPSD
`#define' `__DIODEV_HDSK'  __DIODEV_HDSK

`#define' `__VDADEV_VDU'  __VDADEV_VDU
`#define' `__VDADEV_CVDU'  __VDADEV_CVDU
`#define' `__VDADEV_NEC'  __VDADEV_NEC
`#define' `__VDADEV_TMS'  __VDADEV_TMS
`#define' `__VDADEV_VGA'  __VDADEV_VGA

`#define' `__EMUTYP_NONE'  __EMUTYP_NONE
`#define' `__EMUTYP_TTY'  __EMUTYP_TTY
`#define' `__EMUTYP_ANSI'  __EMUTYP_ANSI

`#define' `__HBX_XFCDAT'  __HBX_XFCDAT
`#define' `__HB_CURBNK'  __HB_CURBNK
`#define' `__HB_INVBNK'  __HB_INVBNK
`#define' `__HB_SRCADR'  __HB_SRCADR
`#define' `__HB_SRCBNK'  __HB_SRCBNK
`#define' `__HB_DSTADR'  __HB_DSTADR
`#define' `__HB_DSTBNK'  __HB_DSTBNK
`#define' `__HB_CPYLEN'  __HB_CPYLEN

`#define' `__HBX_XFCFNS'  __HBX_XFCFNS
`#define' `__HB_INVOKE'  __HB_INVOKE
`#define' `__HB_BNKSEL'  __HB_BNKSEL
`#define' `__HB_BNKCPY'  __HB_BNKCPY
`#define' `__HB_BNKCALL'  __HB_BNKCALL
`#define' `__HB_IDENT'  __HB_IDENT
')
