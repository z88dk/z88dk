include(__link__.m4)

#ifndef __ARCH_CPM_H__
#define __ARCH_CPM_H__

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
#define CPM_RDS   __CPM_RDS                // reset disk system
#define CPM_LGIN  __CPM_LGIN               // log in and select disk
#define CPM_OPN   __CPM_OPN                // open file
#define CPM_CLS   __CPM_CLS                // close file
#define CPM_FFST  __CPM_FFST               // find first
#define CPM_FNXT  __CPM_FNXT               // find next
#define CPM_DEL   __CPM_DEL                // delete file
#define CPM_READ  __CPM_READ               // read next record
#define CPM_WRIT  __CPM_WRIT               // write next record
#define CPM_MAKE  __CPM_MAKE               // create file
#define CPM_REN   __CPM_REN                // rename file
#define CPM_ILOG  __CPM_ILOG               // get bit map of logged in disks
#define CPM_IDRV  __CPM_IDRV               // interrogate drive number
#define CPM_SDMA  __CPM_SDMA               // set DMA address for i/o
#define CPM_SUID  __CPM_SUID               // set/get user id
#define CPM_RRAN  __CPM_RRAN               // read random record
#define CPM_WRAN  __CPM_WRAN               // write random record
#define CPM_CFS   __CPM_CFS                // compute file size
#define CPM_RREC  __CPM_RREC               // update random access pointer
#define CPM_SRDS  __CPM_SRDS               // selectively reset disc drives
#define CPM_WRZF  __CPM_WRZF               // write random record with zero fill
#define CPM_DSEG  __CPM_DSEG               // set DMA segment

// CPM FILE CONTROL BLOCK (FCB)

struct cpm_fcb
{
    unsigned char    drive;        // drive code
    unsigned char    name[8];      // file name
    unsigned char    ext[3];       // file type
    unsigned char    extent;       // file extent (EX)
    unsigned char    s1;           // reserved (S1)
    unsigned char    s2;           // module number, extent high byte (S2)
    unsigned char    records;      // number of records in present extent (RC)
    unsigned char    discmap[16];  // CP/M disc map
    unsigned char    current_record;  // next record to read or write (CR)
    unsigned char    ranrec[3];    // random record number (24 bit no. )  (R0, R1, R2)
    unsigned long    rwptr;        // read/write pointer in bytes
    unsigned char    use;          // use flag
    unsigned char    uid;          // user id belonging to this file
};

__DPROTO(,,int,,cpm_bdos,unsigned int func,unsigned int arg)
__DPROTO(,,int,,cpm_bdos_hl,unsigned int func,unsigned int arg)

#define getuid()   cpm_bdos_hl(CPM_SUID, 0xFF)
#define setuid(u)  cpm_bdos(CPM_SUID, u)

/* IOBYTE (page-0 $0003; BDOS get/set 7/8). BIOS maps logical → physical. */
#define CPM_IOBYTE_CON_SHIFT   0
#define CPM_IOBYTE_RDR_SHIFT   2
#define CPM_IOBYTE_PUN_SHIFT   4
#define CPM_IOBYTE_LST_SHIFT   6
#define CPM_IOBYTE_FIELD_MASK  0x03

#define CPM_IOBYTE_GET_CON(b)  (((unsigned char)(b) >> CPM_IOBYTE_CON_SHIFT) & CPM_IOBYTE_FIELD_MASK)
#define CPM_IOBYTE_GET_RDR(b)  (((unsigned char)(b) >> CPM_IOBYTE_RDR_SHIFT) & CPM_IOBYTE_FIELD_MASK)
#define CPM_IOBYTE_GET_PUN(b)  (((unsigned char)(b) >> CPM_IOBYTE_PUN_SHIFT) & CPM_IOBYTE_FIELD_MASK)
#define CPM_IOBYTE_GET_LST(b)  (((unsigned char)(b) >> CPM_IOBYTE_LST_SHIFT) & CPM_IOBYTE_FIELD_MASK)

#define CPM_IOBYTE_SET_FIELD(b, shift, val) \
   ( (unsigned char)( ((b) & ~(CPM_IOBYTE_FIELD_MASK << (shift))) | (((val) & CPM_IOBYTE_FIELD_MASK) << (shift)) ) )

/* Logical device values per physical slot (Seasip IOBYTE grid) */
#define CPM_DEV_TTY   0   /* CON/RDR/PUN/LST value 00 */
#define CPM_DEV_CRT   1   /* CON value 01; LST value 01 */
#define CPM_DEV_BAT   2   /* CON value 10 — input←RDR, output→LST */
#define CPM_DEV_UC1   3   /* CON value 11 */
#define CPM_DEV_PTR   1   /* RDR value 01 */
#define CPM_DEV_UR1   2   /* RDR value 10 */
#define CPM_DEV_UR2   3   /* RDR value 11 */
#define CPM_DEV_PTP   1   /* PUN value 01 */
#define CPM_DEV_UP1   2   /* PUN value 10 */
#define CPM_DEV_UP2   3   /* PUN value 11 */
#define CPM_DEV_LPT   2   /* LST value 10 */
#define CPM_DEV_UL1   3   /* LST value 11 */

#define cpm_get_iobyte()  ((unsigned char)cpm_bdos_hl(CPM_GIOB, 0))
#define cpm_set_iobyte(b) cpm_bdos(CPM_SIOB, (unsigned int)(unsigned char)(b))

/*
 * Map a logical device name to a stdio FILE* for portable +cpm apps.
 * Recognises CRT: TTY: LPT: PTP: PTR: (and UC1: UL1: UP1: UR1: UP2: UR2:).
 * BAT: has no single FILE* — set IOBYTE CON=BAT instead.
 * Returns NULL if unknown or uninstantiated (e.g. TTY: without tty* CRT).
 * Does not change IOBYTE; use cpm_set_iobyte() when cooperating with BIOS.
 */
__DPROTO(,,void,*,cpm_device_file,char *name)

__DPROTO(`a,b,c',`b,c',unsigned long,,cpm_get_offset,void *p)
__DPROTO(,,void,,cpm_set_offset,void *p,unsigned long offset)

#endif
