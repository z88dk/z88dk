include(__link__.m4)

#ifndef _ARCH_CPM_H
#define _ARCH_CPM_H

#include <arch.h>

/*
 * Hitech C was used as reference for many definitions
 */

// BDOS FUNCTION NUMBERS

#define CPM_RCON  __CPM_RCON               // read console
#define CPM_WCON  __CPM_WCON               // write console
#define CPM_RRDR  __CPM_RRDR               // read reader
#define CPM_WPUN  __CPM_WPUN               // write punch
#define CPM_WLST  __CPM_WLST               // write list
#define CPM_DCIO  __CPM_DCIO               // direct console I/O
#define CPM_GIOB  __CPM_GIOB               // get I/O byte
#define CPM_SIOB  __CPM_SIOB               // set I/O byte
#define CPM_RCOB  __CPM_RCOB               // read console buffered
#define CPM_ICON  __CPM_ICON               // interrogate console ready
#define CPM_VERS  __CPM_VERS               // return version number
#define CPM_RDS   __CPM_RDS 13             // reset disk system
#define CPM_LGIN  __CPM_LGIN               // log in and select disk
#define CPM_OPN   __CPM_OPN 15             // open file
#define CPM_CLS   __CPM_CLS 16             // close file
#define CPM_FFST  __CPM_FFST               // find first
#define CPM_FNXT  __CPM_FNXT               // find next
#define CPM_DEL   __CPM_DEL 19             // delete file
#define CPM_READ  __CPM_READ               // read next record
#define CPM_WRIT  __CPM_WRIT               // write next record
#define CPM_MAKE  __CPM_MAKE               // create file
#define CPM_REN   __CPM_REN 23             // rename file
#define CPM_ILOG  __CPM_ILOG               // get bit map of logged in disks
#define CPM_IDRV  __CPM_IDRV               // interrogate drive number
#define CPM_SDMA  __CPM_SDMA               // set DMA address for i/o
#define CPM_SUID  __CPM_SUID               // set/get user id
#define CPM_RRAN  __CPM_RRAN               // read random record
#define CPM_WRAN  __CPM_WRAN               // write random record
#define CPM_CFS   __CPM_CFS 35             // compute file size
#define CPM_DSEG  __CPM_DSEG               // set DMA segment

// CPM FILE CONTROL BLOCK (FCB)

struct cpm_fcb
{
    unsigned char    drive;        // drive code
    unsigned char    name[8];      // file name
    unsigned char    ext[3];       // file type
    unsigned char    extent;       // file extent
    unsigned char    filler[2];    // not used
    unsigned char    records;      // number of records in present extent
    unsigned char    discmap[16];  // CP/M disc map
    unsigned char    next_record;  // next record to read or write
    unsigned char    ranrec[3];    // random record number (24 bit no. )
    unsigned long    rwptr;        // read/write pointer in bytes
    unsigned char    use;          // use flag
    unsigned char    uid;          // user id belonging to this file
};

__DPROTO(,,int,,cpm_bdos,unsigned int func,unsigned int arg)
__DPROTO(,,int,,cpm_bdos_hl,unsigned int func,unsigned int arg)

#define getuid()   cpm_bdos_hl(CPM_SUID, 0xFF)
#define setuid(u)  cpm_bdos(CPM_SUID, u)

__DPROTO(`a,b,c',`b,c',unsigned long,,cpm_get_offset,void *p)
__DPROTO(,,void,,cpm_set_offset,void *p,unsigned long offset)

#endif
