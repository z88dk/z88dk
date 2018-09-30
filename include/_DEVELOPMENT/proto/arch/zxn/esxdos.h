include(__link__.m4)

#ifndef __NEXTOS_ESXDOS_H__
#define __NEXTOS_ESXDOS_H__

#include <arch.h>
#include <stdint.h>
#include <stddef.h>
#include <time.h>

// extended sna load
// call first thing after sna loads, org >= 24576

__DPROTO(,,unsigned char,,extended_sna_load,unsigned char handle)

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
__DPROTO(,,unsigned char,,esx_disk_stream_start,const struct esx_filemap_entry *entry)
__DPROTO(,,void,*,esx_disk_stream_sectors,void *dst,uint8_t sectors)
__DPROTO(,,void,*,esx_disk_stream_bytes,void *dst,uint16_t len)
__OPROTO(,,unsigned char,,esx_disk_stream_end,void)

// TAP FILE EMULATION

__DPROTO(,,unsigned char,,esx_m_tapein_open,const char *filename)
__OPROTO(,,unsigned char,,esx_m_tapein_close,void)
__DPROTO(,,unsigned char,,esx_m_tapein_info,uint8_t *drive,const char *filename)
__DPROTO(,,unsigned char,,esx_m_tapein_setpos,uint16_t block)
__OPROTO(,,uint16_t,,esx_m_tapein_getpos,void)
__OPROTO(,,unsigned char,,esx_m_tapein_toggle_pause,void)

#define ESX_TAPEIN_FLAGS_PAUSE  1   // pause after loading blocks of size 6912 bytes (eg screen$)
#define ESX_TAPEIN_FLAGS_RETRO  2   // tape loading simulated as if from tape recorder

__DPROTO(,,unsigned char,,esx_m_tapein_flags,uint8_t flags)

// open appends to file, trunc replaces or creates

__DPROTO(,,unsigned char,,esx_m_tapeout_open,const char *appendname)
__DPROTO(,,unsigned char,,esx_m_tapeout_trunc,const char *filename)
__DPROTO(,,unsigned char,,esx_m_tapeout_info,uint8_t *drive,const char *filename)
__OPROTO(,,unsigned char,,esx_m_tapeout_close,void)

// DOT COMMANDS

// must call from within a dot command

typedef void (*esx_handler_t)(uint8_t error);

// currently registered error handler (0 = none)

extern esx_handler_t esx_errh;

__OPROTO(,,unsigned char,,esx_m_gethandle,void)
__DPROTO(,,esx_handler_t,,esx_m_errh,esx_handler_t error)

// must not call from within a dot command

// execute dot command, return value is error if not zero
// geterr with non-zero error code, write as zero-terminated string in 33-byte buffer msg

__DPROTO(,,uint16_t,,esx_m_execcmd,char *cmdline)
__DPROTO(,,void,,esx_m_geterr,uint16_t error,char *msg)

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

__DPROTO(,,unsigned char,,esx_m_drvapi,struct esx_drvapi *)

// MISCELLANEOUS

#define ESX_DOSVERSION_ESXDOS     -1
#define ESX_DOSVERSION_NEXTOS_48K  0

#define ESX_DOSVERSION_NEXTOS_MAJOR(v)  (((v)&0xff00)>>8)
#define ESX_DOSVERSION_NEXTOS_MINOR(v)  ((v)&0xff)

__OPROTO(,,uint16_t,,esx_m_dosversion,void)

__OPROTO(,,unsigned char,,esx_m_getdrv,void)
__DPROTO(,,unsigned char,,esx_m_setdrv,unsigned char drive)

#define ESX_CAPS_FAST_TRUNC  __esx_caps_fast_trunc

__DPROTO(,,unsigned char,,esx_m_setcaps,unsigned char caps)

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
   uint8_t name[ESX_FILENAME_MAX+1+8];      // <dword>  date-time
};                                          // <dword>  size

struct esx_dirent_p3
{
   uint8_t attr;
   uint8_t name[ESX_FILENAME_MAX+1+8];
   struct  esx_p3_hdr p3;
};

struct esx_dirent_lfn
{                                           // <byte>   attributes
   uint8_t attr;                            // <asciiz> name
   uint8_t name[ESX_FILENAME_LFN_MAX+1+8];  // <dword>  date-time
};                                          // <dword>  size

struct esx_dirent_lfn_p3
{
   uint8_t attr;
   uint8_t name[ESX_FILENAME_LFN_MAX+1+8];
   struct  esx_p3_hdr p3;
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

__DPROTO(,,unsigned char,,esx_f_opendir,const char *dirname)
__DPROTO(,,unsigned char,,esx_f_opendir_ex,const char *dirname,uint8_t diruse)
__DPROTO(,,unsigned char,,esx_f_closedir,unsigned char handle)

// file attributes

#define ESX_DIR_A_RDO   __esx_dir_a_rdo     // read only
#define ESX_DIR_A_HID   __esx_dir_a_hid     // hide in normal dir listings
#define ESX_DIR_A_SYS   __esx_dir_a_sys     // system file (must not be physically moved)
#define ESX_DIR_A_VOL   __esx_dir_a_vol     // filename is a volume label
#define ESX_DIR_A_DIR   __esx_dir_a_dir     // directory
#define ESX_DIR_A_ARCH  __esx_dir_a_arch    // file has been modified since last backup
#define ESX_DIR_A_DEV   __esx_dir_a_dev     // device
#define ESX_DIR_A_RES   __esx_dir_a_res     // reserved

__DPROTO(,,unsigned char,,esx_f_readdir,unsigned char handle,void *esx_dirent)
__DPROTO(`d,e,iyl,iyh',`d,e,iyl,iyh',void,*,esx_slice_dirent,void *esx_dirent)

__DPROTO(,,uint32_t,,esx_f_telldir,unsigned char handle)
__DPROTO(,,unsigned char,,esx_f_seekdir,unsigned char handle,uint32_t pos)
__OPROTO(,,unsigned char,,esx_f_rewinddir,unsigned char handle)

__DPROTO(,,unsigned char,,esx_f_getcwd,char *pathname)
__DPROTO(,,unsigned char,,esx_f_getcwd_drive,unsigned char drive, char *pathname)

__DPROTO(,,unsigned char,,esx_f_get_canonical_path,char *pathname,char *canonical)

__DPROTO(,,unsigned char,,esx_f_chdir,const char *pathname)

__DPROTO(,,unsigned char,,esx_f_mkdir,const char *pathname)
__DPROTO(,,unsigned char,,esx_f_rmdir,const char *pathname)

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

#define ESX_MODE_R  __esx_mode_read
#define ESX_MODE_W  __esx_mode_write
#define ESX_MODE_RW  (__esx_mode_read | __esx_mode_write)

// one of:

#define ESX_MODE_OPEN_EXIST  __esx_mode_open_exist
#define ESX_MODE_OPEN_CREAT  __esx_mode_open_creat
#define ESX_MODE_OPEN_CREAT_NOEXIST  __esx_mode_creat_noexist
#define ESX_MODE_OPEN_CREAT_TRUNC  __esx_mode_creat_trunc

#define ESX_MODE_USE_HEADER  __esx_mode_use_header

__DPROTO(,,unsigned char,,esx_f_open,const char *filename,unsigned char mode)
__DPROTO(,,unsigned char,,esx_f_open_p3,const char *filename,unsigned char mode,struct esx_p3_hdr *h)
__DPROTO(,,unsigned char,,esx_f_close,unsigned char handle)

__DPROTO(,,unsigned char,,esx_f_sync,unsigned char handle)
__DPROTO(,,unsigned char,,esx_f_fstat,unsigned char handle,struct esx_stat *es)
__DPROTO(,,uint32_t,,esx_f_fgetpos,unsigned char handle)

#define ESX_SEEK_SET  __esx_seek_set
#define ESX_SEEK_FWD  __esx_seek_fwd
#define ESX_SEEK_BWD  __esx_seek_bwd

__DPROTO(,,uint32_t,,esx_f_seek,unsigned char handle,uint32_t distance,unsigned char whence)
__DPROTO(,,uint16_t,,esx_f_read,unsigned char handle,void *dst,size_t nbytes)
__DPROTO(,,uint16_t,,esx_f_write,unsigned char handle,void *src,size_t nbytes)

__DPROTO(,,unsigned char,,esx_f_ftrunc,unsigned char handle,uint32_t size)

// DIRECT OPERATIONS ON FILES BY FILENAME

// chmod attr

#define ESX_A_WRITE  __esx_a_write
#define ESX_A_READ  __esx_a_read
#define ESX_A_RDWR  __esx_a_rdwr
#define ESX_A_HIDDEN  __esx_a_hidden
#define ESX_A_SYSTEM  __esx_a_system
#define ESX_A_ARCH  __esx_a_arch
#define ESX_A_EXEC  __esx_a_exec
#define ESX_A_ALL  __esx_a_all

__DPROTO(,,unsigned char,,esx_f_chmod,const char *filename,uint8_t attr_mask,uint8_t attr)
__DPROTO(,,unsigned char,,esx_f_rename,const char *old,const char *new)
__DPROTO(,,unsigned char,,esx_f_stat,const char *filename,struct esx_stat *es)
__DPROTO(,,unsigned char,,esx_f_trunc,const char *filename,uint32_t size)
__DPROTO(,,unsigned char,,esx_f_unlink,const char *filename)


// FUNCTIONS IMPORTED FROM NEXTZXOS
// require nextzxos 128k mode; this comes with some obligations
//
// 1. items in memory must be in main memory 0x4000 - 0xbfe0
// 2. the stack must be in main memory 0x4000 - 0xbfe0
// 3. page 10 must be present in mmu2 so that the system vars are present

// IDE_SET_DRIVE

// drive letter is character 'A'..'P'

__OPROTO(,,unsigned char,,esx_dos_get_drive,void)
__DPROTO(,,unsigned char,,esx_dos_set_drive,uint8_t drive)

// IDE_MODE

struct esx_mode
{
   union
   {
      uint16_t mode;
      struct
      {
         uint8_t submode;      // 0=lores,1=ula,2=hires,3=hicol
         uint8_t layer;        // 0,1,2
      }
      mode8;
   };
   
   union
   {
      uint8_t attr;            // layer0,ula,hires,hicol
      uint8_t ink;             // lores,layer2
   };
   
   uint8_t paper;              // lores,layer2
   
   uint8_t flags;
   uint8_t width;              // width of char in pixels 3-8
   
   uint8_t cols;               // printable columns
   uint8_t rows;               // printable rows
};

#define ESX_MODE_FLAG_REDUCED_HEIGHT  __nextos_mode_flag_reduced_height
#define ESX_MODE_FLAG_DOUBLE_WIDTH  __nextos_mode_flag_double_width
#define ESX_MODE_FLAG_DOUBLE_HEIGHT  __nextos_mode_flag_double_height

#define ESX_MODE_SET_LAYER_0  __nextos_mode_set_layer_0
#define ESX_MODE_SET_LAYER_1_LORES  __nextos_mode_set_layer_1_lores
#define ESX_MODE_SET_LAYER_1_ULA  __nextos_mode_set_layer_1_ula
#define ESX_MODE_SET_LAYER_1_HIRES  __nextos_mode_set_layer_1_hires
#define ESX_MODE_SET_LAYER_1_HICOL  __nextos_mode_set_layer_1_hicol
#define ESX_MODE_SET_LAYER_2  __nextos_mode_set_layer_2

// esx_mode structure does not have to be in main memory

__DPROTO(,,unsigned char,,esx_ide_mode_get,struct esx_mode *mode)
__DPROTO(,,unsigned char,,esx_ide_mode_set,struct esx_mode *mode)

// IDE_BANK
// you must ensure allocated pages are returned before program exit

#define ESX_BANKTYPE_RAM     __nextos_rc_banktype_zx
#define ESX_BANKTYPE_DIVMMC  __nextos_rc_banktype_mmc

__DPROTO(,,unsigned char,,esx_ide_bank_total,unsigned char banktype)
__DPROTO(,,unsigned char,,esx_ide_bank_avail,unsigned char banktype)

__DPROTO(,,unsigned char,,esx_ide_bank_alloc,unsigned char banktype)
__DPROTO(,,unsigned char,,esx_ide_bank_reserve,unsigned char banktype, unsigned char page)

__DPROTO(,,unsigned char,,esx_ide_bank_free,unsigned char banktype, unsigned char page)

// DOS_CATALOG

struct esx_cat_entry
{
   char filename[8];           // left justified space filled
   char extension[3];          // left justified space filled
   uint16_t size;              // disk space in kB not file size
};

struct esx_cat
{
   uint8_t filter;             // (init) filter applied (set bits enable)
   char *filename;             // (init) catalog match string 0xff terminated

   uint16_t dir_handle;        // (dos_catalog) for IDE_GET_LFN
   uint8_t completed_sz;       // (dos_catalog) number of matched entries written in indices 1+ (0 = none)

   uint8_t cat_sz;             // (init) actual size of cat[] >= 2
   struct esx_cat_entry cat[2];
};

// filter bits indicate directory details included in catalog

#define ESX_CAT_FILTER_SYSTEM  __nextos_cat_filter_system
#define ESX_CAT_FILTER_LFN  __nextos_cat_filter_lfn
#define ESX_CAT_FILTER_DIR  __nextos_cat_filter_dir

// esx_cat structure must be in main memory

__DPROTO(,,unsigned char,,esx_dos_catalog,struct esx_cat *cat)
__DPROTO(,,unsigned char,,esx_dos_catalog_next,struct esx_cat *cat)

// IDE_GET_LFN (tightly coupled to dos_catalog)

struct esx_lfn
{
   struct esx_cat *cat;        // (init) associated dos_catalog structure
   
   char filename[ESX_FILENAME_LFN_MAX + 1];  // (get_lfn) long filename zero terminated
   
   struct dos_tm time;         // (get_lfn) time.h contains functions dealing with dos time
   uint32_t size;              // (get_lfn) file size in bytes
};

// esx_lfn structure must be in main memory

__DPROTO(,,unsigned char,,esx_ide_get_lfn,struct esx_lfn *dir,struct esx_cat_entry *query)

// IDE_BROWSER (system file dialog)
// Data in memory must lie below 0xc000
// ESX_BROWSERCAP_SYSCFG is reserved for the system

#define ESX_BROWSERCAP_COPY  __nextos_browsercaps_copy
#define ESX_BROWSERCAP_RENAME  __nextos_browsercaps_rename
#define ESX_BROWSERCAP_MKDIR  __nextos_browsercaps_mkdir
#define ESX_BROWSERCAP_ERASE  __nextos_browsercaps_erase
#define ESX_BROWSERCAP_REMOUNT  __nextos_browsercaps_remount
#define ESX_BROWSERCAP_UNMOUNT  __nextos_browsercaps_unmount
#define ESX_BROWSERCAP_SYSCFG  __nextos_browsercaps_syscfg

#define ESX_BROWSERCAP_NONE  __nextos_browsercaps_none
#define ESX_BROWSERCAP_ALL  __nextos_browsercaps_all

__DPROTO(,,unsigned char,,esx_ide_browser,uint8_t browsercaps,void *filetypes,char *help,char *dst_sfn,char *dst_lfn)

// PLUS 3 DOS UTILITIES (MAY BE MOVED LATER)

// change string termination

__DPROTO(`d,e,h,l,iyl,iyh',`d,e,iyl,iyh',char,*,p3dos_cstr_to_pstr,char *s)
__DPROTO(`d,e,h,l,iyl,iyh',`d,e,iyl,iyh',char,*,p3dos_pstr_to_cstr,char *s)

__DPROTO(,,unsigned char,*,p3dos_copy_cstr_to_pstr,char *pdst, const char *csrc)
__DPROTO(,,unsigned char,*,p3dos_copy_pstr_to_cstr,char *cdst, const char *psrc)

// convert cat name to 8.3 dos name

__DPROTO(,,char,*,p3dos_dosname_from_catname,char *dosname,const char *catname)

// convert between esx drive numbers and p3dos drive letters

__DPROTO(`b,c,d,e,h',`b,c,d,e',unsigned char,,p3dos_edrv_from_pdrv,unsigned char prdv)
__DPROTO(`b,c,d,e,h',`b,c,d,e',unsigned char,,p3dos_pdrv_from_edrv,unsigned char erdv)


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

// original esxdos api

#include <arch/zx/esxdos.h>

#endif
