/*
 * Aztec C (CP/M version) Compatibility
 * $Id: aztecc.h $
 */

#ifndef __AZTECC_H__
#define __AZTECC_H__

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <setjmp.h>
#include <string.h>
#include <ctype.h>
#include <cpm.h>


/**********************************************************************
	General purpose Symbolic constants:
***********************************************************************/

//#define NULL 0		/* Used by some functions to indicate zilch */
//#define EOF -1		/* Physical EOF returned by low level I/O functions */

#define FALSE 0
#define TRUE 1

#define unlink(a) remove(a)


/*******   CP/M RELATED   *******/

#define	OPNFIL	15
#define CLSFIL	16
#define DELFIL	19
#define READSQ	20
#define WRITSQ	21
#define MAKFIL	22
#define SETDMA	26
#define READRN	33
#define WRITRN	34
#define FILSIZ	35
#define SETREC	36

/* References to the fcb struct
   the original sources must be adapted by adding extra 8 bytes to the FCB buffers */
#define f_driv  drive
#define f_name  name
#define f_type  ext
#define f_ext   extent
#define f_resv  filler
#define f_rc    records
#define f_sydx  discmap
#define f_cr    next_record
#define f_record ((int *)(ranrec))
#define f_overfl ranrec[2]

#define fcbinit(a,b) setfcb(b,a)

#define bdos(a,b) ((unsigned char)bdos(a,b))

// Get/Set user number, BDOS CALL CPM_SUID=32
#define getusr()    bdos(32,0xFF)
#define setusr(u)   bdos(32,u)


#endif
