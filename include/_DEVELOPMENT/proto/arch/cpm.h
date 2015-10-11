include(__link__.m4)

#ifndef _ARCH_CPM_H
#define _ARCH_CPM_H

/*
 * Hitech C was used as reference for many definitions
 */

// BDOS FUNCTION NUMBERS

#define CPM_RCON 1               // read console
#define CPM_WCON 2               // write console
#define CPM_RRDR 3               // read reader
#define CPM_WPUN 4               // write punch
#define CPM_WLST 5               // write list
#define CPM_DCIO 6               // direct console I/O
#define CPM_GIOB 7               // get I/O byte
#define CPM_SIOB 8               // set I/O byte
#define CPM_RCOB 10              // read console buffered
#define CPM_ICON 11              // interrogate console ready
#define CPM_VERS 12              // return version number
#define CPM_RDS  13              // reset disk system
#define CPM_LGIN 14              // log in and select disk
#define CPM_OPN  15              // open file
#define CPM_CLS  16              // close file
#define CPM_FFST 17              // find first
#define CPM_FNXT 18              // find next
#define CPM_DEL  19              // delete file
#define CPM_READ 20              // read next record
#define CPM_WRIT 21              // write next record
#define CPM_MAKE 22              // create file
#define CPM_REN  23              // rename file
#define CPM_ILOG 24              // get bit map of logged in disks
#define CPM_IDRV 25              // interrogate drive number
#define CPM_SDMA 26              // set DMA address for i/o
#define CPM_SUID 32              // set/get user id
#define CPM_RRAN 33              // read random record
#define CPM_WRAN 34              // write random record
#define CPM_CFS  35              // compute file size
#define CPM_DSEG 51              // set DMA segment

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

__DPROTO(int,,cpm_bdos,unsigned int func,unsigned int arg)
__DPROTO(int,,cpm_bdos_hl,unsigned int func,unsigned int arg)

#define getuid()   cpm_bdos_hl(CPM_SUID, 0xFF)
#define setuid(u)  cpm_bdos(CPM_SUID, u)

__DPROTO(unsigned long,,cpm_get_offset,void *p)
__DPROTO(void,,cpm_set_offset,void *p,unsigned long offset)

#endif
