
/*
 *	MIOSYS C compatibility functions
 *	Stefano Bodrato - 2019
 *
 *	$Id: syserrlist.c $
 */


/*
Possible alternate way to let DOS abend with its own error messages.

syserr(errno)
	int errno;
{
#asm
	pop  de
	pop  hl
	push hl
	push de
	ld a,l
	jp 0x4409
#endasm
}
*/


#include <trsdos.h>


char *_trsdos_syserrlist[]={
	"OK",
	"FN",
	"NO_DATA",
	"PARM",
	"CRC",
	"SECTOR",
	"FILE_BUSY",
	"DISK_CHANGE",
	"NOT_READY",
	"DATA",
	"MAX_FILES",
	"FILE_EXISTS",
	"NO_WR",
	"READONLY",
	"NO_DRIVE",
	"WR_PROTECTED",
	"DCB_CHANGE",
	"DIR_RD",
	"DIR_WR",
	"FILESPEC",
	"GAT_READ",
	"GAT_WRITE",
	"HIT_READ",
	"HIT_WRITE",
	"NOT_FOUND",
	"PASSWD_PROT",
	"DIR_FULL",
	"DISK_FULL",
	"EOF",
	"EOF_R",
	"FRAGMENTED",
	"PRG_NOT_FOUND",
	"INVALID_DRIVE",
	"FRAGMENTED_SP",
	"NOT_PRG",
	"PRG_MEM",
	"OPEN_PARM",
	"ALREADY_OPEN",
	"NOT_OPEN",
	"IO",
	"SEEK",
	"DATA_LOSS",
	"PRN_NOT_RDY",
	"PRN_NO_PAPER",
	"PRN_FAULT",
	"PRN",
	"VLR_FILE",
	"CMD_PARM_MISS",
	"CMD_PARM",
	"HARDWARE",
	"EXTENT"
};

char *syserrlist(int errno)
{
	return (_trsdos_syserrlist[errno]);
}
