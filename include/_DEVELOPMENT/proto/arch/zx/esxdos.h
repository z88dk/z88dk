include(__link__.m4)

#ifndef __ESXDOS_H__
#define __ESXDOS_H__

#include <arch.h>
#include <stdint.h>

// Esxdos Drive Shortcuts

#define ESXDOS_DRIVE_CURRENT  __ESXDOS_DRIVE_CURRENT
#define ESXDOS_DRIVE_SYSTEM   __ESXDOS_DRIVE_SYSTEM

// Esxdos File Mode

#define ESXDOS_MODE_R   __ESXDOS_MODE_READ
#define ESXDOS_MODE_W   __ESXDOS_MODE_WRITE

#define ESXDOS_MODE_OE  __ESXDOS_MODE_OPEN_EXIST
#define ESXDOS_MODE_OC  __ESXDOS_MODE_OPEN_CREAT

#define ESXDOS_MODE_CN  __ESXDOS_MODE_CREAT_NOEXIST
#define ESXDOS_MODE_CT  __ESXDOS_MODE_CREAT_TRUNC

#define ESXDOS_MODE_P3  __ESXDOS_MODE_USE_HEADER

// Esxdos Seek Whence

#define ESXDOS_SEEK_SET  __ESXDOS_SEEK_SET   // set file pointer
#define ESXDOS_SEEK_FWD  __ESXDOS_SEEK_FWD   // forward from file pointer
#define ESXDOS_SEEK_BWD  __ESXDOS_SEEK_BWD   // backward from file pointer

// Esxdos Data Structures

struct esx_device
{
	uint8_t  path;    // bits 7..3 = major, bits 2..0 = minor
	uint8_t  flags;
	uint32_t size;    // device size in blocks
};

struct esx_p3_hdr
{
   uint8_t  type;    // 0 = program, 1 = numeric array, 2 = char array, 3 = code
   uint16_t length;
	uint8_t  data[4];
	uint8_t  unused;
};

struct esx_stat
{
   uint8_t  drive;
   uint8_t  device;
	uint8_t  attr;
	uint32_t date;
	uint32_t size;
};

// Raw Disk IO on Specific Device

__DPROTO(,,int,,esxdos_disk_info,unsigned char device,struct esx_device *ed)
__DPROTO(,,int,,esxdos_disk_read,unsigned char device,uint32_t position,void *dst)
__DPROTO(,,int,,esxdos_disk_write,unsigned char device,uint32_t position,void *src)

// Miscellaneous

__OPROTO(,,unsigned char,,esxdos_m_getdrv,void)
__DPROTO(,,unsigned char,,esxdos_m_setdrv,unsigned char drive)

__OPROTO(,,unsigned char,,esxdos_m_gethandle,void)

__OPROTO(,,uint32_t,,esxdos_m_getdate,void)

// Operations on Directories

__DPROTO(,,unsigned char,,esxdos_f_opendir,void *pathname)
__DPROTO(,,unsigned char,,esxdos_f_opendir_p3,void *pathname)
__DPROTO(,,unsigned char,,esxdos_f_readdir,unsigned char handle,void *dirent)

__DPROTO(,,int,,esxdos_f_getcwd,void *buf)

__DPROTO(,,int,,esxdos_f_chdir,void *pathname)

__DPROTO(,,int,,esxdos_f_unlink,void *filename)

// Operations on Files

__DPROTO(,,unsigned char,,esxdos_f_open,void *filename,unsigned char mode)
__DPROTO(,,unsigned char,,esxdos_f_open_p3,void *filename,unsigned char mode,struct esx_p3_hdr *h)
__DPROTO(,,int,,esxdos_f_close,unsigned char handle)

__DPROTO(,,int,,esxdos_f_sync,unsigned char handle)
__DPROTO(,,int,,esxdos_f_fstat,unsigned char handle,struct esx_stat *es)
__DPROTO(,,uint32_t,,esxdos_f_fgetpos,unsigned char handle)

__DPROTO(,,uint32_t,,esxdos_f_seek,unsigned char handle,uint32_t distance,unsigned char whence)
__DPROTO(,,int,,esxdos_f_read,unsigned char handle,void *dst,size_t nbytes)
__DPROTO(,,int,,esxdos_f_write,unsigned char handle,void *src,size_t nbytes)

#endif
