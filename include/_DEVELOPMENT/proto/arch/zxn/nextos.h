include(__link__.m4)

#ifndef __NEXTOS_H__
#define __NEXTOS_H__

#include <arch.h>
#include <stdint.h>
#include <time.h>

// Global Variables

extern unsigned char GLOBAL_ZXN_PORT_1FFD;
extern unsigned char GLOBAL_ZXN_PORT_7FFD;
extern unsigned char GLOBAL_ZXN_PORT_DFFD;

// NEXTOS API 1.98
// https://github.com/z88dk/techdocs/blob/master/targets/zx-next/nextos/

// Error Codes - Recoverable Disk Errors

#define NEXTOS_RC_READY  __NEXTOS_RC_READY
#define NEXTOS_RC_WP  __NEXTOS_RC_WP
#define NEXTOS_RC_SEEK  __NEXTOS_RC_SEEK
#define NEXTOS_RC_CRC  __NEXTOS_RC_CRC
#define NEXTOS_RC_NODATA  __NEXTOS_RC_NODATA
#define NEXTOS_RC_MARK  __NEXTOS_RC_MARK
#define NEXTOS_RC_UNRECOG  __NEXTOS_RC_UNRECOG
#define NEXTOS_RC_UNKNOWN  __NEXTOS_RC_UNKNOWN
#define NEXTOS_RC_DISKCHG  __NEXTOS_RC_DISKCHG
#define NEXTOS_RC_UNSUIT  __NEXTOS_RC_UNSUIT

// Error Codes - Non-Recoverable Disk Errors

#define NEXTOS_RC_BADNAME  __NEXTOS_RC_BADNAME
#define NEXTOS_RC_BADPARAM  __NEXTOS_RC_BADPARAM
#define NEXTOS_RC_NODRIVE  __NEXTOS_RC_NODRIVE
#define NEXTOS_RC_NOFILE  __NEXTOS_RC_NOFILE
#define NEXTOS_RC_EXISTS  __NEXTOS_RC_EXISTS
#define NEXTOS_RC_EOF  __NEXTOS_RC_EOF
#define NEXTOS_RC_DISKFULL  __NEXTOS_RC_DISKFULL
#define NEXTOS_RC_DIRFULL  __NEXTOS_RC_DIRFULL
#define NEXTOS_RC_RO  __NEXTOS_RC_RO
#define NEXTOS_RC_NUMBER  __NEXTOS_RC_NUMBER
#define NEXTOS_RC_DENIED  __NEXTOS_RC_DENIED
#define NEXTOS_RC_NORENAME  __NEXTOS_RC_NORENAME
#define NEXTOS_RC_EXTENT  __NEXTOS_RC_EXTENT
#define NEXTOS_RC_UNCACHED  __NEXTOS_RC_UNCACHED
#define NEXTOS_RC_TOOBIG  __NEXTOS_RC_TOOBIG
#define NEXTOS_RC_NOTBOOT  __NEXTOS_RC_NOTBOOT
#define NEXTOS_RC_INUSE  __NEXTOS_RC_INUSE

#define NEXTOS_RC_INVPARTITION  __NEXTOS_RC_INVPARTITION
#define NEXTOS_RC_PARTEXIST  __NEXTOS_RC_PARTEXIST
#define NEXTOS_RC_NOTIMP  __NEXTOS_RC_NOTIMP
#define NEXTOS_RC_PARTOPEN  __NEXTOS_RC_PARTOPEN
#define NEXTOS_RC_NOHANDLE  __NEXTOS_RC_NOHANDLE
#define NEXTOS_RC_NOTSWAP  __NEXTOS_RC_NOTSWAP
#define NEXTOS_RC_MAPPED  __NEXTOS_RC_MAPPED
#define NEXTOS_RC_NOXDPB  __NEXTOS_RC_NOXDPB
#define NEXTOS_RC_NOSWAP  __NEXTOS_RC_NOSWAP
#define NEXTOS_RC_INVDEVICE  __NEXTOS_RC_INVDEVICE
#define NEXTOS_RC_CMDPHASE  __NEXTOS_RC_CMDPHASE
#define NEXTOS_RC_DATAPHASE  __NEXTOS_RC_DATAPHASE
#define NEXTOS_RC_NOTDIR  __NEXTOS_RC_NOTDIR

/*
   NextOS ESX API

   The interface to NextOS's implementation of the esxdos api
   is kept separate from esxdos.h even though many functions
   are aliases of each other.

   This is because the NextOS api adds several functions to the
   original esxdos api and some functions in the esxdos api are
   not documented so NextOS's implementation may not be the same.

   If you're using a NextOS machine, use these functions for the
   esxdos api.  If you want to ensure things run on esxdos, use
   the esxdos api version in esxdos.h.
   
   NOTE:  To use the esxdos api, ROM3 must be present in the bottom
   16k and layer 2 write-only mode in the bottom 16k must be disabled.
*/

// FAST STREAMING DISK IO

// 1. esx_disk_filemap        : find out how the file is distributed on disk
// 2. esx_stream_start        : prepare to load from one span on disk
// 3. esx_disk_stream_sectors : load whole sectors from the span
// 4. esx_disk_stream_bytes   : load bytes from the span (only use for last access to span)
// 5. esx_disk_stream_end     : terminate streaming from span
//
// No other esxdos calls allowed between steps 2-5

struct esx_filemap_entry
{
   // describes one span on disk

   uint32_t address;
   uint16_t sectors;
};

struct esx_filemap
{
   uint8_t mapsz;
   struct esx_filemap_entry *map;
};

// the following four variables are filled in after a call to esx_disk_stream_start()

extern unsigned char esx_stream_io_port;       // 1
extern unsigned char esx_stream_protocol;      // 2

// the following two variables are updated by esx_disk_stream_sectors()
// and esx_disk_stream_bytes() but only for whole numbers of sectors read

extern uint32_t esx_stream_card_address;       // 3
extern uint16_t esx_stream_sectors_remaining;  // 4

__DPROTO(,,unsigned char,,esx_disk_filemap,uint8_t handle,struct esx_filemap *fmap)
__DPROTO(,,unsigned char,,esx_disk_stream_start,struct esx_filemap_entry *entry)
__DPROTO(,,void,*,esx_disk_stream_sectors,void *dst,uint8_t sectors)
__DPROTO(,,void,*,esx_disk_stream_bytes,void *dst,uint16_t len)
__OPROTO(,,unsigned char,,esx_disk_stream_end,void)

// TAP FILE EMULATION

__DPROTO(,,unsigned char,,esx_m_tapein_open,unsigned char *filename)
__OPROTO(,,unsigned char,,esx_m_tapein_close,void)
__DPROTO(,,unsigned char,,esx_m_tapein_info,uint8_t *drive,unsigned char *filename)
__DPROTO(,,unsigned char,,esx_m_tapein_setpos,uint16_t block)
__OPROTO(,,uint16_t,,esx_m_tapein_getpos,void)
__OPROTO(,,unsigned char,,esx_m_tapein_toggle_pause,void)

#define ESX_TAPEIN_FLAGS_PAUSE  1   // pause after loading blocks of size 6912 bytes (eg screen$)
#define ESX_TAPEIN_FLAGS_RETRO  2   // tape loading simulated as if from tape recorder

__DPROTO(,,unsigned char,,esx_m_tapein_flags,uint8_t flags)

// open appends to file, trunc replaces or creates

__DPROTO(,,unsigned char,,esx_m_tapeout_open,unsigned char *appendname)
__DPROTO(,,unsigned char,,esx_m_tapeout_trunc,unsigned char *filename)
__DPROTO(,,unsigned char,,esx_m_tapeout_info,uint8_t *drive,unsigned char *filename)
__OPROTO(,,unsigned char,,esx_m_tapeout_close,void)

// DOT COMMANDS

// call from within a dot command

typedef void (*esx_handler_t)(uint8_t error);

// currently registered error handler (0 = none)

extern esx_handler_t esx_errh;

__OPROTO(,,unsigned char,,esx_m_gethandle,void)
__DPROTO(,,esx_handler_t,,esx_m_errh,esx_handler_t error)

// do not call from within a dot command

// execute dot command, return value is error if not zero
// geterr with non-zero error code, write as zero-terminated string in 33-byte buffer msg

__DPROTO(,,uint16_t,,esx_m_execcmd,unsigned char *cmdline)
__DPROTO(,,void,,esx_m_geterr,uint16_t error,unsigned char *msg)

// DRIVER API

struct esx_drvapi
{
   union
   {
      uint16_t bc;
      struct
      {
         uint8_t driver;
         uint8_t function;
      }
      call;
   };
   
   uint16_t de;
   uint16_t hl;
};

__DPROTO(,,unsigned char,,esx_m_drvapi,struct esx_drvapi *)   // return -1 if no error, 0 if driver not found, else canned esxdos error code

// MISCELLANEOUS

#define ESX_DOSVERSION_ESXDOS     -1
#define ESX_DOSVERSION_NEXTOS_48K  0

#define ESX_DOSVERSION_NEXTOS_MAJOR(v)  (((v)&0xff00)>>8)
#define ESX_DOSVERSION_NEXTOS_MINOR(v)  ((v)&0xff)

__OPROTO(,,uint16_t,,esx_m_dosversion,void)

__OPROTO(,,unsigned char,,esx_m_getdrv,void)
__DPROTO(,,unsigned char,,esx_m_setdrv,unsigned char drive)

// time.h contains functions dealing with dos time

__DPROTO(,,unsigned char,,esx_m_getdate,struct dos_tm *)

__OPROTO(,,uint32_t,,esx_f_getfree,void)

// OPERATIONS ON DIRECTORIES

#define ESX_PATHNAME_MAX __ESX_PATHNAME_MAX     // max pathname length in bytes including terminating 0, ~256 bytes
#define ESX_FILENAME_MAX __ESX_FILENAME_MAX     // max filename length in bytes not including terminating 0, ~12 bytes
#define ESX_FILENAME_LFN_MAX __ESX_FILENAME_LFN_MAX   // max lfn filename length in bytes not including terminating 0, ~260 bytes

struct esx_p3_hdr
{
   uint8_t  type;    // 0 = program, 1 = numeric array, 2 = char array, 3 = code
   uint16_t length;
   uint8_t  data[4];
   uint8_t  unused;
};

struct esx_dirent
{                                           // <byte>   attributes
   uint8_t attr;                            // <asciiz> name
   uint8_t dir[ESX_FILENAME_MAX+1+8];       // <dword>  date-time
};                                          // <dword>  size

struct esx_dirent_p3
{
   uint8_t attr;
   uint8_t dir[ESX_FILENAME_MAX+1+8];
	struct esx_p3_hdr p3;
};

struct esx_dirent_lfn
{                                           // <byte>   attributes
   uint8_t attr;                            // <asciiz> name
   uint8_t dir[ESX_FILENAME_LFN_MAX+1+8];   // <dword>  date-time
};                                          // <dword>  size

struct esx_dirent_lfn_p3
{
   uint8_t attr;
   uint8_t dir[ESX_FILENAME_LFN_MAX+1+8];
	struct esx_p3_hdr p3;
};

// slice dirent to access members following filename

struct esx_dirent_slice
{
   struct dos_tm time;   // time.h contains functions dealing with dos time
   uint32_t      size;
};

struct esx_dirent_slice_p3
{
   struct dos_tm time;
   uint32_t      size;
	struct esx_p3_hdr p3;
};

// opendir_ex modes

#define ESX_DIR_USE_LFN     __esx_dir_use_lfn
#define ESX_DIR_USE_HEADER  __esx_dir_use_header

__DPROTO(,,unsigned char,,esx_f_opendir,unsigned char *dirname)
__DPROTO(,,unsigned char,,esx_f_opendir_ex,unsigned char *dirname,uint8_t mode)
__DPROTO(,,unsigned char,,esx_f_closedir,unsigned char handle)

// file attributes

#define ESX_A_RDO   __esx_a_rdo     // read only
#define ESX_A_HID   __esx_a_hid     // hide in normal dir listings
#define ESX_A_SYS   __esx_a_sys     // system file (must not be physically moved)
#define ESX_A_VOL   __esx_a_vol     // filename is a volume label
#define ESX_A_DIR   __esx_a_dir     // directory
#define ESX_A_ARCH  __esx_a_arch    // file has been modified since last backup
#define ESX_A_DEV   __esx_a_dev     // device
#define ESX_A_RES   __esx_a_res     // reserved

__DPROTO(,,unsigned char,,esx_f_readdir,unsigned char handle,void *esx_dirent)
__DPROTO(,,void,*,esx_slice_dirent,void *esx_dirent)

__DPROTO(,,uint32_t,,esx_f_telldir,unsigned char handle)
__DPROTO(,,unsigned char,,esx_f_seekdir,unsigned char handle,uint32_t pos)
__OPROTO(,,unsigned char,,esx_f_rewinddir,unsigned char handle)

__DPROTO(,,unsigned char,,esx_f_getcwd,unsigned char *pathname)
__DPROTO(,,unsigned char,,esx_f_chdir,unsigned char *pathname)

__DPROTO(,,unsigned char,,esx_f_mkdir,unsigned char *pathname)
__DPROTO(,,unsigned char,,esx_f_rmdir,unsigned char *pathname)

// OPERATIONS ON FILES

struct esx_stat
{
   uint8_t       drive;
   uint8_t       device;
   uint8_t       attr;
   struct dos_tm time;   // time.h contains functions dealing with dos time
   uint32_t      size;
};

// file open mode

// at least one of:

#define ESX_MODE_READ  __esx_mode_read
#define ESX_MODE_WRITE  __esx_mode_write

// one of:

#define ESX_MODE_OPEN_EXIST  __esx_mode_open_exist
#define ESX_MODE_OPEN_CREAT  __esx_mode_open_creat
#define ESX_MODE_OPEN_CREAT_NOEXIST  __esx_mode_creat_noexist
#define ESX_MODE_OPEN_CREAT_TRUNC  __esx_mode_creat_trunc

#define ESX_MODE_USE_HEADER  __esx_mode_use_header

__DPROTO(,,unsigned char,,esx_f_open,unsigned char *filename,unsigned char mode)
__DPROTO(,,unsigned char,,esx_f_open_p3,unsigned char *filename,unsigned char mode,struct esx_p3_hdr *h)
__DPROTO(,,unsigned char,,esx_f_close,unsigned char handle)

__DPROTO(,,unsigned char,,esx_f_sync,unsigned char handle)
__DPROTO(,,unsigned char,,esx_f_fstat,unsigned char handle,struct esx_stat *es)
__DPROTO(,,uint32_t,,esx_f_fgetpos,unsigned char handle)

__DPROTO(,,uint32_t,,esx_f_seek,unsigned char handle,uint32_t distance,unsigned char whence)
__DPROTO(,,uint16_t,,esx_f_read,unsigned char handle,void *dst,size_t nbytes)
__DPROTO(,,uint16_t,,esx_f_write,unsigned char handle,void *src,size_t nbytes)

__DPROTO(,,unsigned char,,esx_f_ftrunc,unsigned char handle,uint32_t size)

// DIRECT OPERATIONS ON FILES

__DPROTO(,,unsigned char,,esx_f_chmod,unsigned char *filename,uint8_t attr_mask,uint8_t attr)
__DPROTO(,,unsigned char,,esx_f_rename,unsigned char *old,unsigned char *new)
__DPROTO(,,unsigned char,,esx_f_stat,unsigned char *filename,struct esx_stat *es)
__DPROTO(,,unsigned char,,esx_f_trunc,unsigned char *filename,uint32_t size)
__DPROTO(,,unsigned char,,esx_f_unlink,unsigned char *filename)

// ESX ERROR CODES

#define ESX_OK  __ESX_OK                       // 0 OK 0:1
#define ESX_EOK  __ESX_EOK                     // O.K. ESXDOS, 0:1
#define ESX_ENONSENSE  __ESX_ENONSENSE         // Nonsense in ESXDOS, 0:1
#define ESX_ESTEND  __ESX_ESTEND               // Statement END error, 0:1
#define ESX_EWRTYPE  __ESX_EWRTYPE             // Wrong file TYPE, 0:1
#define ESX_ENOENT  __ESX_ENOENT               // No such FILE or DIR, 0:1
#define ESX_EIO  __ESX_EIO                     // I/O ERROR, 0:1
#define ESX_EINVAL  __ESX_EINVAL               // Invalid FILENAME, 0:1
#define ESX_EACCES  __ESX_EACCES               // Access DENIED, 0:1
#define ESX_ENOSPC  __ESX_ENOSPC               // Drive FULL, 0:1
#define ESX_ENXIO  __ESX_ENXIO                 // Invalid I/O REQUEST, 0:1
#define ESX_ENODRV  __ESX_ENODRV               // No such DRIVE, 0:1
#define ESX_ENFILE  __ESX_ENFILE               // Too many OPEN FILES, 0:1
#define ESX_EBADF  __ESX_EBADF                 // Bad file DESCRIPTOR, 0:1
#define ESX_ENODEV  __ESX_ENODEV               // No such DEVICE, 0:1
#define ESX_EOVERFLOW  __ESX_EOVERFLOW         // File pointer OVERFLOW, 0:1
#define ESX_EISDIR  __ESX_EISDIR               // Is a DIRECTORY, 0:1
#define ESX_ENOTDIR  __ESX_ENOTDIR             // Not a DIRECTORY, 0:1
#define ESX_EEXIST  __ESX_EEXIST               // File already EXISTS, 0:1
#define ESX_EPATH  __ESX_EPATH                 // Invalid PATH, 0:1
#define ESX_ENOSYS  __ESX_ENOSYS               // No SYS, 0:1
#define ESX_ENAMETOOLONG  __ESX_ENAMETOOLONG   // Path too LONG, 0:1
#define ESX_ENOCMD  __ESX_ENOCMD               // No such COMMAND, 0:1
#define ESX_EINUSE  __ESX_EINUSE               // File in USE, 0:1
#define ESX_ERDONLY  __ESX_ERDONLY             // File is READ ONLY, 0:1
#define ESX_EVERIFY  __ESX_EVERIFY             // Verify FAILED, 0:1
#define ESX_ELOADINGKO  __ESX_ELOADINGKO       // Loading .KO FAILED, 0:1
#define ESX_EDIRINUSE  __ESX_EDIRINUSE         // Directory NOT EMPTY, 0:1
#define ESX_EMAPRAMACTIVE  __ESX_EMAPRAMACTIVE // MAPRAM is ACTIVE, 0:1
#define ESX_EDRIVEBUSY  __ESX_EDRIVEBUSY       // Drive is BUSY, 0:1
#define ESX_EFSUNKNOWN  __ESX_EFSUNKNOWN       // Unknown FILESYSTEM, 0:1
#define ESX_EDEVICEBUSY  __ESX_EDEVICEBUSY     // Device is BUSY, 0:1

#define ESX_EMAXCODE  __ESX_EMAXCODE           // Largest valid error code

//endif
