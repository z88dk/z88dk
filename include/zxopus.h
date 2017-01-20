/*
 *      Small C+ Library
 *
 *      Opus Discovery low level support
 *
 *      Stefano Bodrato - 7/6/2006
 *
 *	$Id: zxopus.h,v 1.10 2016-06-27 19:16:33 dom Exp $
 */


#ifndef __ZXOPUS_H__
#define __ZXOPUS_H__

#include <sys/compiler.h>
#include <sys/types.h>
#include <fcntl.h>


#ifndef __ZX_CHANNELS__
#define	__ZX_CHANNELS__

struct BASE_CHAN {
	// base channel descriptor
	u16_t	out;		/* pointer to the output routine     */
	u16_t	in;		/* pointer to the input routine      */
	u8_t	id_char;	/* upper (if permanent) or lower "M".. char  */
	u16_t	len;		/* length of channel                 */
};


// M_CHAN is 33 bytes long (including BASE_CHAN), + the block size
// (the block-size can be 128, 256, 512 or 1024 bytes)
struct M_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// "M" channel specific stuff
	u8_t	drive;		/* drive number */
	char    name[10];	/* file name */
	u16_t	blklen;		/* Block size */
	u16_t	reclen;		/* Number of databytes in record */
	u16_t	lastblkbyt;	/* Number of bytes in the last block */
	u16_t	firstblk;	/* Location of the first block */
	u16_t	lastblk;	/* Location of the last block */
	u16_t	block;		/* Location of the current block */
	u16_t	bytecount;	/* Position in the current block */
	u8_t	flag;		/* bit 0 : SET if changes were made to the buffer */
	//char	data[512]	/* the buffer */
};


// The 'd' channel is only used by the  MOVE  command,
// however it should act as a normal channel;
// you should be able to read and write to it.
struct D_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// '#' channel specific stuff
	u8_t	outdrive;		/* output drive number */
	u8_t	indrive;		/* input drive number */
};


struct CODE_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// '#' channel specific stuff
	u16_t	address;		/* pointed address */
};


struct T_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	
	u8_t	tflags;
	u8_t	lastcol;
	u8_t	currcol;
};

// these are the single bits for 'tflags' in T_CHAN
	#define TCHAN_ZXPRTEMU	1	/* ZX printer emulation     */
	#define TCHAN_SEQ	2
	#define TCHAN_BACKSP	4	/* set for true backspacing */
	#define TCHAN_AT	32	/* set for AT character     */
	#define TCHAN_TAB	64	/* set for TAB character    */
	#define TCHAN_AT_TAB	128


struct B_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// that's all !!
};


struct STRM_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// '#' channel specific stuff
	u8_t	stream;			/* stream address */
};


// Joystick !!  
// Note that it works in this way only if the kempston emulation is off
// WARNING: all the joystick stuff could not work with the Spectrum emulators
struct J_CHAN {
	// base channel descriptor
	struct	BASE_CHAN base;
	// '#' channel specific stuff
	u8_t	joystick;		/* 1 for QWERT and 67890 */
					/* 2 for QWERT and 12345 */
};

#endif /*__ZX_CHANNELS__*/


// set the kempston emulation (1=on, 0=off)
extern void __LIB__ set_kempston (int mode);

// get the kempston emulation status (1=on, 0=off)
extern int __LIB__ get_kempston ();

// get the number of sectors
extern int __LIB__ opus_getblocks (int drive);

// get the sector size
extern int __LIB__ opus_getblocksize (int drive);

// load a sector
// A standard 178K Opus disk has 0..718 (719?) sectors
// Each sector is 256 bytes long
extern int __LIB__ opus_getsect(int drive, int sector, unsigned char * buffer) __smallc;
extern int __LIB__  opus_getsect_callee(int drive, int sector, char * buffer)__smallc __z88dk_callee;
#define opus_getsect(a,b,c)           opus_getsect_callee(a,b,c)

// save a sector
// A standard 178K Opus disk has 0..718 (719?) sectors
// Each sector is 256 bytes long
extern int __LIB__ opus_putsect(int drive, int sector, unsigned char * buffer) __smallc;
extern int __LIB__  opus_putsect_callee(int drive, int sector, char * buffer)__smallc __z88dk_callee;
#define opus_putsect(a,b,c)           opus_putsect_callee(a,b,c)

// parallel port put/get byte
extern void __LIB__ opus_lptwrite (unsigned int databyte);
extern unsigned char __LIB__ opus_lptread ();

// Returns true if the Opus Discovery interface is present
extern int __LIB__ zx_opus();

// Get the Opus firmware version
extern float __LIB__ opus_version ();


#endif /* _ZXOPUS_H */
