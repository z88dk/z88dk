/*
 *      ZX Interface 1 and Microdrive low level support
 *
 *      Stefano Bodrato - 6/9/2004
 *
 *	$Id: zxinterface1.h $
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
	u8_t	id_char;	/* 04 - inverted or regular "M"/"N" char  */
	u16_t	out;		/* 05 - pointer to the output routine     */
	u16_t	in;			/* 07 - pointer to the input routine      */
	u16_t	len;		/* 09 - length of channel                 */
};

// M_CHAN is 603 bytes long
struct M_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// "M" channel specific stuff
	u16_t	bytecount;	/* 0B - Count bytes in record */
	u8_t	record;		/* 0D - */
	char    name[10];	/* 0E - file name */
	u8_t	flag;		/* 18 - CHFLAG "0000000x", bit 0 used */
	u8_t	drive;		/* 19 - drive number (0-7)*/
	u16_t	map;		/* 1A - Address of MAP for this microdrive.*/
	char    hdpreamble[12];	/* 1C - 12 bytes of header preamble */
	// FETCH_H gets 14 bytes (+checksum) starting from here
	u8_t	hdflag;		/* 28 - bit 0 used */
	u8_t	sector;		/* 29 - sector number */
	u16_t	unused;		/* 2A - */
	char    hdname[10];	/* 2C - cartridge name */
	u8_t	hdchk;		/* 36 - Header checksum */
	char    dpreamble[12];	/* 37 - 12 bytes of data block preamble */
	// RD_BUFF gets the data block
	u8_t	recflg;		/* 43 - bit 1 set for EOF, bit 2 set for PRINT file type */
	u8_t	recnum;		/* 44 - Record number in the range 0-255 */
	u16_t	reclen;		/* 45 - Number of databytes in record 0-512 */
	char    recname[10];	/* 47 - file name */
	u8_t	recchk;		/* 51 - Record  description checksum */
	char    data[512];	/* 52 - the 512 bytes of data. */
	u8_t	datachk;	/* 252 - Checksum of preceding 512 bytes */

	/* These values are added for the file handling
	   the ROM shouldn't overwrite those fileds */
	long	position;	/** NEW** - current position in file */
	int	flags;
	mode_t	mode;
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


/* NON-PRINT files header struct
   on microdrive data block      */
struct zxmdvhdr {
   unsigned char   type;        /* 0=BASIC, 3=CODE block, etc... */
   size_t          length;
   size_t          address;
   size_t          offset;
   size_t          autorun;     /* BASIC program line for autorun */
   char            data[503]
};

#endif /*__ZX_CHANNELS__*/



// Extract the drive number from a file path (e.g. "a:filename")
extern int __LIB__ if1_driveno (char *filename) __z88dk_fastcall;
extern int if1_default_drv;

// Remove the drive specifier (if present) from a file path
extern int __LIB__ if1_filename (char *filename) __z88dk_fastcall;

// Load a sector identified by file name and record number
// On exit: current sector number
extern int __LIB__ if1_load_record (int drive, char *filename, int record, struct M_CHAN *buffer) __smallc;

// Load a sector identified by the sector number
extern int __LIB__ if1_load_sector (int drive, int sector, struct M_CHAN *buffer) __smallc;

// Load the next sector referring to a first file record
// On exit: current sector number
extern int __LIB__ if1_next_file (int drive, struct M_CHAN *buffer) __smallc;

// Microdrive tape seek timeout (originally 255*5 sectors, set to 256*4 in z88dk)
extern int mdv_seek_count;

// Write the sector in "buffer"
extern int __LIB__ if1_write_sector (int drive, int sector, struct M_CHAN *buffer) __smallc;

// Add a record containing the data in the "sector buffer"
#define if1_write_record(n,b) if1_write_sector(n, if1_find_sector(n), b)

// Get the (int) sector number out from the (long) file pointer
extern int __LIB__ if1_recnum (long fp) __z88dk_fastcall;

// Get the (int) position within a record out from the (long) file pointer
extern int __LIB__ if1_bytecount (long fp) __z88dk_fastcall;

// Put a 10 characters file name at the specified location; return with the file name length
extern int __LIB__ if1_setname(char* name, char *location) __smallc;

extern char __LIB__ *if1_getname(char *location) __z88dk_fastcall;

// Delete a file
extern int __LIB__ if1_remove_file(int drive, char *filename) __smallc;

// Create a file if it doesn't exist
extern int __LIB__ if1_touch_file(int drive, char *filename) __smallc;

// Create a file and return handle
extern int __LIB__ if1_init_file (int drive, char *filename, struct M_CHAN *buffer) __smallc;

// Load the map values for the specified drive
extern void __LIB__ if1_update_map (int drive, char *mdvmap) __smallc;

// Find a free sector
extern int __LIB__ if1_find_sector (int drive) __z88dk_fastcall;

// Find a free sector in the specified map
// ** requires if1_update_map() **
extern int __LIB__ if1_find_sector_map (char *mdvmap) __z88dk_fastcall;

// Returns true if the current program has been loaded from microdrive
extern bool_t __LIB__ if1_from_mdv();

// Returns true if the system variables are already present
extern bool_t __LIB__ if1_installed();

// Returns the ROM version of the Interface 1
extern int __LIB__ if1_edition();

// Returns true if the Interface 1 is present
extern int __LIB__ zx_interface1();

// Returns the microdrive status 0=ok, 1=wr protect, 2=not present
extern int __LIB__ if1_mdv_status(int drive) __z88dk_fastcall;

// Test a Microdrive map to check if it is full (1 if full, otherwise 0)
// ** requires if1_update_map() **
extern int __LIB__ if1_mdv_full(char *mdvmap) __z88dk_fastcall;

// Count the free sectors in the given drive
extern int __LIB__   if1_free_sectors(int drive) __z88dk_fastcall;

#endif /* _ZXINTERFACE1_H */
