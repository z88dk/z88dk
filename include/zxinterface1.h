/*
 *      ZX Interface 1 and Microdrive low level support
 *
 *      Stefano Bodrato - 6/9/2004
 *
 *	$Id: zxinterface1.h,v 1.11 2016-07-01 22:09:25 dom Exp $
 */


#ifndef __ZXINTERFACE1_H__
#define __ZXINTERFACE1_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <fcntl.h>


#ifndef __ZX_CHANNELS__
#define	__ZX_CHANNELS__

struct BASE_CHAN {
	// base channel descriptor
	u16_t	errptr1;	/* first pointer to main ERROR-1     */
	u16_t	errptr2;	/* second pointer to main ERROR-1    */
	u8_t	id_char;	/* inverted or regular "M"/"N" char  */
	u16_t	out;		/* pointer to the output routine     */
	u16_t	in;		/* pointer to the input routine      */
	u16_t	len;		/* length of channel                 */
};

// M_CHAN is 603 bytes long
struct M_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// "M" channel specific stuff
	u16_t	bytecount;	/* (IX+$0B) Count bytes in record */
	u8_t	record;
	char    name[10];	/* file name */
	u8_t	flag;
	u8_t	drive;		/* drive number (0-7)*/
	u16_t	map;		/* Address of MAP for this microdrive.*/
	char    hdpreamble[12];	/* 12 bytes of header preamble */
	u8_t	hdflag;
	u8_t	sector;		/* sector number */
	u16_t	unused;
	char    hdname[10];	/* cartridge name */
	u8_t	hdchk;		/* Header checksum */
	char    dpreamble[12];	/* 12 bytes of data block preamble */
	u8_t	recflg;		/* bit 1 set for EOF, bit 2 set for PRINT file type */
	u8_t	recnum;		/* Record number in the range 0-255 */
	u16_t	reclen;		/* (IX+$45) Number of databytes in record 0-512 */
	char    recname[10];	/* file name */
	u8_t	recchk;		/* Record  description checksum */
	char    data[512];	/* the 512 bytes of data. */
	//char    datahd[10];	/* first 9 bytes of the 512 bytes of data. */
	//char	data[502]	/* real program */
	u8_t	datachk;	/* Checksum of preceding 512 bytes */

	/* These values are added for the file handling
	   the ROM shouldn't overwrite those fileds */
	long	position;	/** NEW** - current position in file */
	int	flags;
	mode_t	mode;
};


struct M_SECT {
	char    foo[3072];
};


struct M_MAP {
	char    map[32];	/* 32 bytes = 256 bits for a microdrive map */
};


struct N_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// "N" channel specific stuff
	u8_t	remote;		/* The destination station number */
	u8_t	local;		/* This Spectrum's station number */
	u16_t	nc_number;	/* The block number */
	u8_t	nc_type;	/* The packet type code . 0 data, 1 EOF */
	u8_t	nc_obl;		/* Number of bytes in data block */
	u8_t	datachk;	/* The data checksum */
	u8_t	hdachk;		/* The header checksum */
	u8_t	nc_cur;		/* The position of last buffer char taken */
	u8_t	nc_ibl;		/* Number of bytes in the input buffer */
	char    data[255];	/* 255 byte data buffer */
};

#endif /*__ZX_CHANNELS__*/


// Load a sector identified by file name and record number
extern int __LIB__ if1_load_record (int drive, char *filename, int record, struct M_CHAN buffer) __smallc;

// Load a sector identified by the sector number
extern int __LIB__ if1_load_sector (int drive, int sector, struct M_CHAN buffer) __smallc;

// Write the sector in "buffer"
extern int __LIB__ if1_write_sector (int drive, int sector, struct M_CHAN buffer) __smallc;

// Add a record containing the data in "buffer"
extern int __LIB__ if1_write_record (int drive, struct M_CHAN buffer) __smallc;

// Put a 10 characters file name at the specified location; return with the file name length
extern int __LIB__ if1_setname(char* name, char *location) __smallc;

extern char __LIB__ *if1_getname(char *location);

// Delete a file
extern int __LIB__ if1_remove_file(int drive, char *filename) __smallc;

// Create a file if it doesn't exist
extern int __LIB__ if1_touch_file(int drive, char *filename) __smallc;

// Create a file and return handle
extern int __LIB__ if1_init_file (int drive, char *filename, struct M_CHAN buffer) __smallc;

// Load the map values for the specified drive
extern void __LIB__ if1_update_map (int drive, char *mdvmap) __smallc;

// Find a free sector
extern int __LIB__ if1_find_sector (int drive);

// Find a free sector in the specified map
extern int __LIB__ if1_find_sector_map (char *mdvmap);

// Returns true if the current program has been loaded from microdrive
extern int __LIB__ if1_from_mdv();

// Returns true if the system variables are already present
extern int __LIB__ if1_installed();

// Returns the ROM version of the Interface 1
extern int __LIB__ if1_edition();

// Returns true if the Interface 1 is present
extern int __LIB__ zx_interface1();

// Returns the microdrive status 0=ok, 1=wr protect, 2=not present
extern int __LIB__ if1_mdv_status(int drive);

// Count the free sectors in the given drive
extern int __LIB__   if1_free_sectors(int drive);

#endif /* _ZXINTERFACE1_H */
