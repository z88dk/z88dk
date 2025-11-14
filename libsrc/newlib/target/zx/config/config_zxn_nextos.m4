divert(-1)

###############################################################
# NEXTOS USER CONFIGURATION
# rebuild the library if changes are made
#

# User Configuration

# NEXTOS API 1.97F
# https://github.com/z88dk/techdocs/blob/master/targets/zx-next/nextos/
# https://github.com/z88dk/techdocs/blob/master/targets/zx-next/nextos/nextos_api.pdf

# This is the nextos-esdos api only.

# The functions in common with esxdos should function identically in esxdos.
# The nextos-esxdos api is completely documented with many esxdos calls
# reverse engineered from dot commands.  Because it's documented the full
# esxdos api can be implemented (with nextos extensions) but the portion
# compatible with esxdos should work on esxdos too.  The interfaces are kept
# separate pending confirmation the esxdos portion is the same.

define(`__NEXTOS_IDE_MODE', 0x01d5)

###################
# NextOS ESXDOS API
###################

# Restarts

define(`__ESX_RST_SYS', 0x08)       # system call, single byte function number follows rst
define(`__ESX_RST_ROM', 0x18)       # zx rom call, address follows rst
define(`__ESX_RST_EXITDOT', 0x20)   # jump to HL after terminating dot via rst

# Limits

define(`__ESX_PATHNAME_MAX', 256)       # max pathname length in bytes including terminating 0

define(`__ESX_FILENAME_MAX', 12)        # max filename length in bytes not including terminating 0
define(`__ESX_FILENAME_LFN_MAX', 260)   # max lfn filename length in bytes not including terminating 0

# Functions

define(`__ESX_DISK_FILEMAP', 0x85)
define(`__ESX_DISK_STRMSTART', 0x86)
define(`__ESX_DISK_STRMEND', 0x87)

define(`__ESX_M_DOSVERSION', 0x88)
define(`__ESX_M_GETSETDRV', 0x89)

define(`__ESX_M_TAPEIN', 0x8b)
define(`__esx_tapein_open', 0)
define(`__esx_tapein_close', 1)
define(`__esx_tapein_info', 2)
define(`__esx_tapein_setpos', 3)
define(`__esx_tapein_getpos', 4)
define(`__esx_tapein_pause', 5)
define(`__esx_tapein_flags', 6)

define(`__ESX_M_TAPEOUT', 0x8c)
define(`__esx_tapeout_open', 0)
define(`__esx_tapeout_close', 1)
define(`__esx_tapeout_info', 2)
define(`__esx_tapeout_trunc', 3)

define(`__ESX_M_GETHANDLE', 0x8d)
define(`__ESX_M_GETDATE', 0x8e)
define(`__ESX_M_EXECCMD', 0x8f)

define(`__ESX_M_SETCAPS', 0x91)
define(`__esx_caps_fast_trunc', 0x80)

define(`__ESX_M_DRVAPI', 0x92)
define(`__ESX_M_GETERR', 0x93)
define(`__ESX_M_P3DOS', 0x94)
define(`__ESX_M_ERRH', 0x95)

define(`__ESX_F_OPEN', 0x9a)
define(`__esx_mode_read', 0x01)
define(`__esx_mode_write', 0x02)
define(`__esx_mode_use_header', 0x40)
define(`__esx_mode_open_exist', 0x00)
define(`__esx_mode_open_creat', 0x08)
define(`__esx_mode_creat_noexist', 0x04)
define(`__esx_mode_creat_trunc', 0x0c)

define(`__ESX_F_CLOSE', 0x9b)
define(`__ESX_F_SYNC', 0x9c)
define(`__ESX_F_READ', 0x9d)
define(`__ESX_F_WRITE', 0x9e)

define(`__ESX_F_SEEK', 0x9f)
define(`__esx_seek_set', 0x00)
define(`__esx_seek_fwd', 0x01)
define(`__esx_seek_bwd', 0x02)

define(`__ESX_F_FGETPOS', 0xa0)
define(`__ESX_F_FSTAT', 0xa1)
define(`__ESX_F_FTRUNCATE', 0xa2)

define(`__ESX_F_OPENDIR', 0xa3)
define(`__esx_dir_use_lfn', 0x10)
define(`__esx_dir_use_header', 0x40)

define(`__ESX_F_READDIR', 0xa4)
define(`__esx_dir_a_rdo', 0x01)           # read only
define(`__esx_dir_a_hid', 0x02)           # hide in normal dir listings
define(`__esx_dir_a_sys', 0x04)           # file must not be physically moved
define(`__esx_dir_a_vol', 0x08)           # filename is a volume label
define(`__esx_dir_a_dir', 0x10)           # directory
define(`__esx_dir_a_arch', 0x20)          # file has been modified since last backup
define(`__esx_dir_a_dev', 0x40)           # device
define(`__esx_dir_a_res', 0x80)           # reserved

define(`__ESX_F_TELLDIR', 0xa5)
define(`__ESX_F_SEEKDIR', 0xa6)
define(`__ESX_F_REWINDDIR', 0xa7)
define(`__ESX_F_GETCWD', 0xa8)
define(`__ESX_F_CHDIR', 0xa9)
define(`__ESX_F_MKDIR', 0xaa)
define(`__ESX_F_RMDIR', 0xab)
define(`__ESX_F_STAT', 0xac)
define(`__ESX_F_UNLINK', 0xad)
define(`__ESX_F_TRUNCATE', 0xae)

define(`__ESX_F_CHMOD', 0xaf)
define(`__esx_a_write', 0x01)
define(`__esx_a_read', 0x80)
define(`__esx_a_rdwr', 0x81)
define(`__esx_a_hidden', 0x02)
define(`__esx_a_system', 0x04)
define(`__esx_a_arch', 0x20)
define(`__esx_a_exec', 0x40)
define(`__esx_a_all', 0xe7)

define(`__ESX_F_RENAME', 0xb0)
define(`__ESX_F_GETFREE', 0xb1)

# Errors

define(`__ESX_OK', 0)                    # 0 OK 0:1
define(`__ESX_EOK', 1)                   # O.K. ESXDOS, 0:1
define(`__ESX_ENONSENSE', 2)             # Nonsense in ESXDOS, 0:1
define(`__ESX_ESTEND', 3)                # Statement END error, 0:1
define(`__ESX_EWRTYPE', 4)               # Wrong file TYPE, 0:1
define(`__ESX_ENOENT', 5)                # No such FILE or DIR, 0:1
define(`__ESX_EIO', 6)                   # I/O ERROR, 0:1
define(`__ESX_EINVAL', 7)                # Invalid FILENAME, 0:1
define(`__ESX_EACCES', 8)                # Access DENIED, 0:1
define(`__ESX_ENOSPC', 9)                # Drive FULL, 0:1
define(`__ESX_ENXIO', 10)                # Invalid I/O REQUEST, 0:1
define(`__ESX_ENODRV', 11)               # No such DRIVE, 0:1
define(`__ESX_ENFILE', 12)               # Too many OPEN FILES, 0:1
define(`__ESX_EBADF', 13)                # Bad file DESCRIPTOR, 0:1
define(`__ESX_ENODEV', 14)               # No such DEVICE, 0:1
define(`__ESX_EOVERFLOW', 15)            # File pointer OVERFLOW, 0:1
define(`__ESX_EISDIR', 16)               # Is a DIRECTORY, 0:1
define(`__ESX_ENOTDIR', 17)              # Not a DIRECTORY, 0:1
define(`__ESX_EEXIST', 18)               # File already EXISTS, 0:1
define(`__ESX_EPATH', 19)                # Invalid PATH, 0:1
define(`__ESX_ENOSYS', 20)               # No SYS, 0:1
define(`__ESX_ENAMETOOLONG', 21)         # Path too LONG, 0:1
define(`__ESX_ENOCMD', 22)               # No such COMMAND, 0:1
define(`__ESX_EINUSE', 23)               # File in USE, 0:1
define(`__ESX_ERDONLY', 24)              # File is READ ONLY, 0:1
define(`__ESX_EVERIFY', 25)              # Verify FAILED, 0:1
define(`__ESX_ELOADINGKO', 26)           # Loading .KO FAILED, 0:1
define(`__ESX_EDIRINUSE', 27)            # Directory NOT EMPTY, 0:1
define(`__ESX_EMAPRAMACTIVE', 28)        # MAPRAM is ACTIVE, 0:1
define(`__ESX_EDRIVEBUSY', 29)           # Drive is BUSY, 0:1
define(`__ESX_EFSUNKNOWN', 30)           # Unknown FILESYSTEM, 0:1
define(`__ESX_EDEVICEBUSY', 31)          # Device is BUSY, 0:1

define(`__ESX_EMAXCODE', 31)             # Largest valid error code

#
# END OF USER CONFIGURATION
###############################################################

divert(0)

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_PUB',
`
PUBLIC `__NEXTOS_IDE_MODE'

PUBLIC `__ESX_RST_SYS'
PUBLIC `__ESX_RST_ROM'
PUBLIC `__ESX_RST_EXITDOT'

PUBLIC `__ESX_PATHNAME_MAX'
PUBLIC `__ESX_FILENAME_MAX'
PUBLIC `__ESX_FILENAME_LFN_MAX'

PUBLIC `__ESX_DISK_FILEMAP'
PUBLIC `__ESX_DISK_STRMSTART'
PUBLIC `__ESX_DISK_STRMEND'

PUBLIC `__ESX_M_DOSVERSION'
PUBLIC `__ESX_M_GETSETDRV'

PUBLIC `__ESX_M_TAPEIN'
PUBLIC `__esx_tapein_open'
PUBLIC `__esx_tapein_close'
PUBLIC `__esx_tapein_info'
PUBLIC `__esx_tapein_setpos'
PUBLIC `__esx_tapein_getpos'
PUBLIC `__esx_tapein_pause'
PUBLIC `__esx_tapein_flags'

PUBLIC `__ESX_M_TAPEOUT'
PUBLIC `__esx_tapeout_open'
PUBLIC `__esx_tapeout_close'
PUBLIC `__esx_tapeout_info'
PUBLIC `__esx_tapeout_trunc'

PUBLIC `__ESX_M_GETHANDLE'
PUBLIC `__ESX_M_GETDATE'
PUBLIC `__ESX_M_EXECCMD'

PUBLIC `__ESX_M_SETCAPS'
PUBLIC `__esx_caps_fast_trunc'

PUBLIC `__ESX_M_DRVAPI'
PUBLIC `__ESX_M_GETERR'
PUBLIC `__ESX_M_P3DOS'
PUBLIC `__ESX_M_ERRH'

PUBLIC `__ESX_F_OPEN'
PUBLIC `__esx_mode_read'
PUBLIC `__esx_mode_write'
PUBLIC `__esx_mode_use_header'
PUBLIC `__esx_mode_open_exist'
PUBLIC `__esx_mode_open_creat'
PUBLIC `__esx_mode_creat_noexist'
PUBLIC `__esx_mode_creat_trunc'

PUBLIC `__ESX_F_CLOSE'
PUBLIC `__ESX_F_SYNC'
PUBLIC `__ESX_F_READ'
PUBLIC `__ESX_F_WRITE'

PUBLIC `__ESX_F_SEEK'
PUBLIC `__esx_seek_set'
PUBLIC `__esx_seek_fwd'
PUBLIC `__esx_seek_bwd'

PUBLIC `__ESX_F_FGETPOS'
PUBLIC `__ESX_F_FSTAT'
PUBLIC `__ESX_F_FTRUNCATE'

PUBLIC `__ESX_F_OPENDIR'
PUBLIC `__esx_dir_use_lfn'
PUBLIC `__esx_dir_use_header'

PUBLIC `__ESX_F_READDIR'
PUBLIC `__esx_dir_a_rdo'
PUBLIC `__esx_dir_a_hid'
PUBLIC `__esx_dir_a_sys'
PUBLIC `__esx_dir_a_vol'
PUBLIC `__esx_dir_a_dir'
PUBLIC `__esx_dir_a_arch'
PUBLIC `__esx_dir_a_dev'
PUBLIC `__esx_dir_a_res'

PUBLIC `__ESX_F_TELLDIR'
PUBLIC `__ESX_F_SEEKDIR'
PUBLIC `__ESX_F_REWINDDIR'
PUBLIC `__ESX_F_GETCWD'
PUBLIC `__ESX_F_CHDIR'
PUBLIC `__ESX_F_MKDIR'
PUBLIC `__ESX_F_RMDIR'
PUBLIC `__ESX_F_STAT'
PUBLIC `__ESX_F_UNLINK'
PUBLIC `__ESX_F_TRUNCATE'

PUBLIC `__ESX_F_CHMOD'
PUBLIC `__esx_a_write'
PUBLIC `__esx_a_read'
PUBLIC `__esx_a_rdwr'
PUBLIC `__esx_a_hidden'
PUBLIC `__esx_a_system'
PUBLIC `__esx_a_arch'
PUBLIC `__esx_a_exec'
PUBLIC `__esx_a_all'

PUBLIC `__ESX_F_RENAME'
PUBLIC `__ESX_F_GETFREE'

PUBLIC `__ESX_OK'
PUBLIC `__ESX_EOK'
PUBLIC `__ESX_ENONSENSE'
PUBLIC `__ESX_ESTEND'
PUBLIC `__ESX_EWRTYPE'
PUBLIC `__ESX_ENOENT'
PUBLIC `__ESX_EIO'
PUBLIC `__ESX_EINVAL'
PUBLIC `__ESX_EACCES'
PUBLIC `__ESX_ENOSPC'
PUBLIC `__ESX_ENXIO'
PUBLIC `__ESX_ENODRV'
PUBLIC `__ESX_ENFILE'
PUBLIC `__ESX_EBADF'
PUBLIC `__ESX_ENODEV'
PUBLIC `__ESX_EOVERFLOW'
PUBLIC `__ESX_EISDIR'
PUBLIC `__ESX_ENOTDIR'
PUBLIC `__ESX_EEXIST'
PUBLIC `__ESX_EPATH'
PUBLIC `__ESX_ENOSYS'
PUBLIC `__ESX_ENAMETOOLONG'
PUBLIC `__ESX_ENOCMD'
PUBLIC `__ESX_EINUSE'
PUBLIC `__ESX_ERDONLY'
PUBLIC `__ESX_EVERIFY'
PUBLIC `__ESX_ELOADINGKO'
PUBLIC `__ESX_EDIRINUSE'
PUBLIC `__ESX_EMAPRAMACTIVE'
PUBLIC `__ESX_EDRIVEBUSY'
PUBLIC `__ESX_EFSUNKNOWN'
PUBLIC `__ESX_EDEVICEBUSY'

PUBLIC `__ESX_EMAXCODE'
')

dnl#
dnl# LIBRARY BUILD TIME CONFIG FOR ASSEMBLY LANGUAGE
dnl#

ifdef(`CFG_ASM_DEF',
`
defc `__NEXTOS_IDE_MODE' = __NEXTOS_IDE_MODE

defc `__ESX_RST_SYS' = __ESX_RST_SYS
defc `__ESX_RST_ROM' = __ESX_RST_ROM
defc `__ESX_RST_EXITDOT' = __ESX_RST_EXITDOT

defc `__ESX_PATHNAME_MAX' = __ESX_PATHNAME_MAX
defc `__ESX_FILENAME_MAX' = __ESX_FILENAME_MAX
defc `__ESX_FILENAME_LFN_MAX' = __ESX_FILENAME_LFN_MAX

defc `__ESX_DISK_FILEMAP' = __ESX_DISK_FILEMAP
defc `__ESX_DISK_STRMSTART' = __ESX_DISK_STRMSTART
defc `__ESX_DISK_STRMEND' = __ESX_DISK_STRMEND

defc `__ESX_M_DOSVERSION' = __ESX_M_DOSVERSION
defc `__ESX_M_GETSETDRV' = __ESX_M_GETSETDRV

defc `__ESX_M_TAPEIN' = __ESX_M_TAPEIN
defc `__esx_tapein_open' = __esx_tapein_open
defc `__esx_tapein_close' = __esx_tapein_close
defc `__esx_tapein_info' = __esx_tapein_info
defc `__esx_tapein_setpos' = __esx_tapein_setpos
defc `__esx_tapein_getpos' = __esx_tapein_getpos
defc `__esx_tapein_pause' = __esx_tapein_pause
defc `__esx_tapein_flags' = __esx_tapein_flags

defc `__ESX_M_TAPEOUT' = __ESX_M_TAPEOUT
defc `__esx_tapeout_open' = __esx_tapeout_open
defc `__esx_tapeout_close' = __esx_tapeout_close
defc `__esx_tapeout_info' = __esx_tapeout_info
defc `__esx_tapeout_trunc' = __esx_tapeout_trunc

defc `__ESX_M_GETHANDLE' = __ESX_M_GETHANDLE
defc `__ESX_M_GETDATE' = __ESX_M_GETDATE
defc `__ESX_M_EXECCMD' = __ESX_M_EXECCMD

defc `__ESX_M_SETCAPS' = __ESX_M_SETCAPS
defc `__esx_caps_fast_trunc' = __esx_caps_fast_trunc

defc `__ESX_M_DRVAPI' = __ESX_M_DRVAPI
defc `__ESX_M_GETERR' = __ESX_M_GETERR
defc `__ESX_M_P3DOS' = __ESX_M_P3DOS
defc `__ESX_M_ERRH' = __ESX_M_ERRH

defc `__ESX_F_OPEN' = __ESX_F_OPEN
defc `__esx_mode_read' = __esx_mode_read
defc `__esx_mode_write' = __esx_mode_write
defc `__esx_mode_use_header' = __esx_mode_use_header
defc `__esx_mode_open_exist' = __esx_mode_open_exist
defc `__esx_mode_open_creat' = __esx_mode_open_creat
defc `__esx_mode_creat_noexist' = __esx_mode_creat_noexist
defc `__esx_mode_creat_trunc' = __esx_mode_creat_trunc

defc `__ESX_F_CLOSE' = __ESX_F_CLOSE
defc `__ESX_F_SYNC' = __ESX_F_SYNC
defc `__ESX_F_READ' = __ESX_F_READ
defc `__ESX_F_WRITE' = __ESX_F_WRITE

defc `__ESX_F_SEEK' = __ESX_F_SEEK
defc `__esx_seek_set' = __esx_seek_set
defc `__esx_seek_fwd' = __esx_seek_fwd
defc `__esx_seek_bwd' = __esx_seek_bwd

defc `__ESX_F_FGETPOS' = __ESX_F_FGETPOS
defc `__ESX_F_FSTAT' = __ESX_F_FSTAT
defc `__ESX_F_FTRUNCATE' = __ESX_F_FTRUNCATE

defc `__ESX_F_OPENDIR' = __ESX_F_OPENDIR
defc `__esx_dir_use_lfn' = __esx_dir_use_lfn
defc `__esx_dir_use_header' = __esx_dir_use_header

defc `__ESX_F_READDIR' = __ESX_F_READDIR
defc `__esx_dir_a_rdo' = __esx_dir_a_rdo
defc `__esx_dir_a_hid' = __esx_dir_a_hid
defc `__esx_dir_a_sys' = __esx_dir_a_sys
defc `__esx_dir_a_vol' = __esx_dir_a_vol
defc `__esx_dir_a_dir' = __esx_dir_a_dir
defc `__esx_dir_a_arch' = __esx_dir_a_arch
defc `__esx_dir_a_dev' = __esx_dir_a_dev
defc `__esx_dir_a_res' = __esx_dir_a_res

defc `__ESX_F_TELLDIR' = __ESX_F_TELLDIR
defc `__ESX_F_SEEKDIR' = __ESX_F_SEEKDIR
defc `__ESX_F_REWINDDIR' = __ESX_F_REWINDDIR
defc `__ESX_F_GETCWD' = __ESX_F_GETCWD
defc `__ESX_F_CHDIR' = __ESX_F_CHDIR
defc `__ESX_F_MKDIR' = __ESX_F_MKDIR
defc `__ESX_F_RMDIR' = __ESX_F_RMDIR
defc `__ESX_F_STAT' = __ESX_F_STAT
defc `__ESX_F_UNLINK' = __ESX_F_UNLINK
defc `__ESX_F_TRUNCATE' = __ESX_F_TRUNCATE

defc `__ESX_F_CHMOD' = __ESX_F_CHMOD
defc `__esx_a_write' = __esx_a_write
defc `__esx_a_read' = __esx_a_read
defc `__esx_a_rdwr' = __esx_a_rdwr
defc `__esx_a_hidden' = __esx_a_hidden
defc `__esx_a_system' = __esx_a_system
defc `__esx_a_arch' = __esx_a_arch
defc `__esx_a_exec' = __esx_a_exec
defc `__esx_a_all' = __esx_a_all

defc `__ESX_F_RENAME' = __ESX_F_RENAME
defc `__ESX_F_GETFREE' = __ESX_F_GETFREE

defc `__ESX_OK' = __ESX_OK
defc `__ESX_EOK' = __ESX_EOK
defc `__ESX_ENONSENSE' = __ESX_ENONSENSE
defc `__ESX_ESTEND' = __ESX_ESTEND
defc `__ESX_EWRTYPE' = __ESX_EWRTYPE
defc `__ESX_ENOENT' = __ESX_ENOENT
defc `__ESX_EIO' = __ESX_EIO
defc `__ESX_EINVAL' = __ESX_EINVAL
defc `__ESX_EACCES' = __ESX_EACCES
defc `__ESX_ENOSPC' = __ESX_ENOSPC
defc `__ESX_ENXIO' = __ESX_ENXIO
defc `__ESX_ENODRV' = __ESX_ENODRV
defc `__ESX_ENFILE' = __ESX_ENFILE
defc `__ESX_EBADF' = __ESX_EBADF
defc `__ESX_ENODEV' = __ESX_ENODEV
defc `__ESX_EOVERFLOW' = __ESX_EOVERFLOW
defc `__ESX_EISDIR' = __ESX_EISDIR
defc `__ESX_ENOTDIR' = __ESX_ENOTDIR
defc `__ESX_EEXIST' = __ESX_EEXIST
defc `__ESX_EPATH' = __ESX_EPATH
defc `__ESX_ENOSYS' = __ESX_ENOSYS
defc `__ESX_ENAMETOOLONG' = __ESX_ENAMETOOLONG
defc `__ESX_ENOCMD' = __ESX_ENOCMD
defc `__ESX_EINUSE' = __ESX_EINUSE
defc `__ESX_ERDONLY' = __ESX_ERDONLY
defc `__ESX_EVERIFY' = __ESX_EVERIFY
defc `__ESX_ELOADINGKO' = __ESX_ELOADINGKO
defc `__ESX_EDIRINUSE' = __ESX_EDIRINUSE
defc `__ESX_EMAPRAMACTIVE' = __ESX_EMAPRAMACTIVE
defc `__ESX_EDRIVEBUSY' = __ESX_EDRIVEBUSY
defc `__ESX_EFSUNKNOWN' = __ESX_EFSUNKNOWN
defc `__ESX_EDEVICEBUSY' = __ESX_EDEVICEBUSY

defc `__ESX_EMAXCODE' = __ESX_EMAXCODE
')

dnl#
dnl# COMPILE TIME CONFIG EXPORT FOR C
dnl#

ifdef(`CFG_C_DEF',
`
`#define' `__NEXTOS_IDE_MODE'  __NEXTOS_IDE_MODE

`#define' `__ESX_RST_SYS'  __ESX_RST_SYS
`#define' `__ESX_RST_ROM'  __ESX_RST_ROM
`#define' `__ESX_RST_EXITDOT'  __ESX_RST_EXITDOT

`#define' `__ESX_PATHNAME_MAX'  __ESX_PATHNAME_MAX
`#define' `__ESX_FILENAME_MAX'  __ESX_FILENAME_MAX
`#define' `__ESX_FILENAME_LFN_MAX'  __ESX_FILENAME_LFN_MAX

`#define' `__ESX_DISK_FILEMAP'  __ESX_DISK_FILEMAP
`#define' `__ESX_DISK_STRMSTART'  __ESX_DISK_STRMSTART
`#define' `__ESX_DISK_STRMEND'  __ESX_DISK_STRMEND

`#define' `__ESX_M_DOSVERSION'  __ESX_M_DOSVERSION
`#define' `__ESX_M_GETSETDRV'  __ESX_M_GETSETDRV

`#define' `__ESX_M_TAPEIN'  __ESX_M_TAPEIN
`#define' `__esx_tapein_open'  __esx_tapein_open
`#define' `__esx_tapein_close'  __esx_tapein_close
`#define' `__esx_tapein_info'  __esx_tapein_info
`#define' `__esx_tapein_setpos'  __esx_tapein_setpos
`#define' `__esx_tapein_getpos'  __esx_tapein_getpos
`#define' `__esx_tapein_pause'  __esx_tapein_pause
`#define' `__esx_tapein_flags'  __esx_tapein_flags

`#define' `__ESX_M_TAPEOUT'  __ESX_M_TAPEOUT
`#define' `__esx_tapeout_open'  __esx_tapeout_open
`#define' `__esx_tapeout_close'  __esx_tapeout_close
`#define' `__esx_tapeout_info'  __esx_tapeout_info
`#define' `__esx_tapeout_trunc'  __esx_tapeout_trunc

`#define' `__ESX_M_GETHANDLE'  __ESX_M_GETHANDLE
`#define' `__ESX_M_GETDATE'  __ESX_M_GETDATE
`#define' `__ESX_M_EXECCMD'  __ESX_M_EXECCMD

`#define' `__ESX_M_SETCAPS'  __ESX_M_SETCAPS
`#define' `__esx_caps_fast_trunc'  __esx_caps_fast_trunc

`#define' `__ESX_M_DRVAPI'  __ESX_M_DRVAPI
`#define' `__ESX_M_GETERR'  __ESX_M_GETERR
`#define' `__ESX_M_P3DOS'  __ESX_M_P3DOS
`#define' `__ESX_M_ERRH'  __ESX_M_ERRH

`#define' `__ESX_F_OPEN'  __ESX_F_OPEN
`#define' `__esx_mode_read'  __esx_mode_read
`#define' `__esx_mode_write'  __esx_mode_write
`#define' `__esx_mode_use_header'  __esx_mode_use_header
`#define' `__esx_mode_open_exist'  __esx_mode_open_exist
`#define' `__esx_mode_open_creat'  __esx_mode_open_creat
`#define' `__esx_mode_creat_noexist'  __esx_mode_creat_noexist
`#define' `__esx_mode_creat_trunc'  __esx_mode_creat_trunc

`#define' `__ESX_F_CLOSE'  __ESX_F_CLOSE
`#define' `__ESX_F_SYNC'  __ESX_F_SYNC
`#define' `__ESX_F_READ'  __ESX_F_READ
`#define' `__ESX_F_WRITE'  __ESX_F_WRITE

`#define' `__ESX_F_SEEK'  __ESX_F_SEEK
`#define' `__esx_seek_set'  __esx_seek_set
`#define' `__esx_seek_fwd'  __esx_seek_fwd
`#define' `__esx_seek_bwd'  __esx_seek_bwd

`#define' `__ESX_F_FGETPOS'  __ESX_F_FGETPOS
`#define' `__ESX_F_FSTAT'  __ESX_F_FSTAT
`#define' `__ESX_F_FTRUNCATE'  __ESX_F_FTRUNCATE

`#define' `__ESX_F_OPENDIR'  __ESX_F_OPENDIR
`#define' `__esx_dir_use_lfn'  __esx_dir_use_lfn
`#define' `__esx_dir_use_header'  __esx_dir_use_header

`#define' `__ESX_F_READDIR'  __ESX_F_READDIR
`#define' `__esx_dir_a_rdo'  __esx_dir_a_rdo
`#define' `__esx_dir_a_hid'  __esx_dir_a_hid
`#define' `__esx_dir_a_sys'  __esx_dir_a_sys
`#define' `__esx_dir_a_vol'  __esx_dir_a_vol
`#define' `__esx_dir_a_dir'  __esx_dir_a_dir
`#define' `__esx_dir_a_arch'  __esx_dir_a_arch
`#define' `__esx_dir_a_dev'  __esx_dir_a_dev
`#define' `__esx_dir_a_res'  __esx_dir_a_res

`#define' `__ESX_F_TELLDIR'  __ESX_F_TELLDIR
`#define' `__ESX_F_SEEKDIR'  __ESX_F_SEEKDIR
`#define' `__ESX_F_REWINDDIR'  __ESX_F_REWINDDIR
`#define' `__ESX_F_GETCWD'  __ESX_F_GETCWD
`#define' `__ESX_F_CHDIR'  __ESX_F_CHDIR
`#define' `__ESX_F_MKDIR'  __ESX_F_MKDIR
`#define' `__ESX_F_RMDIR'  __ESX_F_RMDIR
`#define' `__ESX_F_STAT'  __ESX_F_STAT
`#define' `__ESX_F_UNLINK'  __ESX_F_UNLINK
`#define' `__ESX_F_TRUNCATE'  __ESX_F_TRUNCATE

`#define' `__ESX_F_CHMOD'  __ESX_F_CHMOD
`#define' `__esx_a_write'  __esx_a_write
`#define' `__esx_a_read'  __esx_a_read
`#define' `__esx_a_rdwr'  __esx_a_rdwr
`#define' `__esx_a_hidden'  __esx_a_hidden
`#define' `__esx_a_system'  __esx_a_system
`#define' `__esx_a_arch'  __esx_a_arch
`#define' `__esx_a_exec'  __esx_a_exec
`#define' `__esx_a_all'  __esx_a_all

`#define' `__ESX_F_RENAME'  __ESX_F_RENAME
`#define' `__ESX_F_GETFREE'  __ESX_F_GETFREE

`#define' `__ESX_OK'  __ESX_OK
`#define' `__ESX_EOK'  __ESX_EOK
`#define' `__ESX_ENONSENSE'  __ESX_ENONSENSE
`#define' `__ESX_ESTEND'  __ESX_ESTEND
`#define' `__ESX_EWRTYPE'  __ESX_EWRTYPE
`#define' `__ESX_ENOENT'  __ESX_ENOENT
`#define' `__ESX_EIO'  __ESX_EIO
`#define' `__ESX_EINVAL'  __ESX_EINVAL
`#define' `__ESX_EACCES'  __ESX_EACCES
`#define' `__ESX_ENOSPC'  __ESX_ENOSPC
`#define' `__ESX_ENXIO'  __ESX_ENXIO
`#define' `__ESX_ENODRV'  __ESX_ENODRV
`#define' `__ESX_ENFILE'  __ESX_ENFILE
`#define' `__ESX_EBADF'  __ESX_EBADF
`#define' `__ESX_ENODEV'  __ESX_ENODEV
`#define' `__ESX_EOVERFLOW'  __ESX_EOVERFLOW
`#define' `__ESX_EISDIR'  __ESX_EISDIR
`#define' `__ESX_ENOTDIR'  __ESX_ENOTDIR
`#define' `__ESX_EEXIST'  __ESX_EEXIST
`#define' `__ESX_EPATH'  __ESX_EPATH
`#define' `__ESX_ENOSYS'  __ESX_ENOSYS
`#define' `__ESX_ENAMETOOLONG'  __ESX_ENAMETOOLONG
`#define' `__ESX_ENOCMD'  __ESX_ENOCMD
`#define' `__ESX_EINUSE'  __ESX_EINUSE
`#define' `__ESX_ERDONLY'  __ESX_ERDONLY
`#define' `__ESX_EVERIFY'  __ESX_EVERIFY
`#define' `__ESX_ELOADINGKO'  __ESX_ELOADINGKO
`#define' `__ESX_EDIRINUSE'  __ESX_EDIRINUSE
`#define' `__ESX_EMAPRAMACTIVE'  __ESX_EMAPRAMACTIVE
`#define' `__ESX_EDRIVEBUSY'  __ESX_EDRIVEBUSY
`#define' `__ESX_EFSUNKNOWN'  __ESX_EFSUNKNOWN
`#define' `__ESX_EDEVICEBUSY'  __ESX_EDEVICEBUSY

`#define' `__ESX_EMAXCODE'  __ESX_EMAXCODE
')
