#ifndef __CPM_H__
#define __CPM_H__

/*
 *    TRS80 Specific Header File
 *
 *    A file specifier in TRS-DOS (or derivatives) is slightly different than MS-DOS, e.g.:
 *    "FILENAME/EXT.PASSWORD:<drive number><CR>", maximum total length is 32 bytes.
 *
 *
 *    $Id: trsdos.h $
 */

#include <sys/compiler.h>
#include <sys/types.h>


/* Size of TRS-80 Sector */
#define SECSIZE  256


/* Flags for fcp->use */
#define U_READ  1               /* file open for reading */
#define U_WRITE 2               /* file open for writing */
#define U_RDWR  3               /* open for read and write */
#define U_CON   4               /* device is console */


/* TRSDOS preset devices */
#define TRSDOS_KI  0x4015	/* Keyboard DCB (*KI) */
#define TRSDOS_DO  0x401D	/* Video DCB (*DO) */
#define TRSDOS_PR  0x4025	/* Printer DCB (*PR) */


//#define __STDIO_EOFMARKER  -1   /* End of file marker (^Z) */
//#define __STDIO_BINARY     1    /* We should consider binary/text differences */
//#define __STDIO_CRLF       1    /* Automatically convert between CR and CRLF */


struct TRSDOS_FCB {
	u8_t    type;          /* bit7 = open condition, bit2 = write event happened */
	u8_t    flags;         /* bit7 = byte/sector addressingmode, bit6 = EOF detection mode,     */
	                       /* bit5 = zero if sector in buffer, bit4 = buffer changes happened,  */
	                       /* bit3 = record autosave mode, bits 2-0 = access protection level   */
	u8_t    reserved;      /* reserved by the system for future use */
	u16_t   buf;           /* buffer address */
	u8_t    offset;        /* end of record offset within current buffer */
	u8_t    drive;         /* logical drive number for current file (not to be changed !) */
	u8_t    DEC;           /* Directory Entry Code for current file (not to be changed !) */
	u8_t    eof_offset;    /* end of file offset within current buffer */
	u8_t    LRL;           /* Logical Record Length */
	u16_t   NRN;           /* Next Record Number, sequential sector counter */
	u16_t   ERN;           /* Ending Record Number, 0 in a null file, total sectors if data is present */
	u8_t    pos_cyl;       /* file position (CYL) as taken from directory */
	u8_t    pos_grn;       /* file position (relative granule within starting cylinder) and number of continous granules */
	u16_t   ext;           /* cumulative number of allocated granules, excluding extents */
	u8_t    ext_cyl;       /* starting cylinder of this extent */
	u8_t    ext_grn;       /* starting relative granule of this extent and number of continous granules */
	u16_t   ext2;          /* see above */
	u8_t    ext2_cyl;      /* ... */
	u8_t    ext2_grn;      /* ... */
	u16_t   ext3;          /* see above */
	u8_t    ext3_cyl;      /* ... */
	u8_t    ext3_grn;      /* ... */
	u16_t   ext4;          /* see above */
	u8_t    ext4_cyl;      /* ...for more than 4 extents the system will pick the information */
	u8_t    ext4_grn;      /* from the directory and shift the data in this structure */
};
	

/* TRS-80 file/device struct */
struct TRSDOS_FILE {
	struct	TRSDOS_FCB fcb;  /* TRSDOS FCB or DCB*/
	char    buffer[256];     /* file buffer */
	//long	pos;
};


extern int __LIB__ errno;

/* convert errno to short text */
extern char __LIB__  *syserrlist(int errno) __smallc __z88dk_fastcall;

/* Error codes */

#define FERR_OK              0      // No Errors
#define FERR_FN              1      // Bad Function Code
#define FERR_NO_DATA         2      // Character Not Available
#define FERR_PARM            3      // Parameter Error On Call
#define FERR_CRC             4      // CRC Error During Disk I/O
#define FERR_SECTOR          5      // Disk Sector Not Found
#define FERR_FILE_BUSY       6      // Attempt To Open A File Which Has Not Been Closed
#define FERR_DISK_CHANGE     7      // Illegal Disk Change
#define FERR_NOT_READY       8      // Disk Drive Not Ready
#define FERR_DATA            9      // Invalid Data Provided By Caller
#define FERR_MAX_FILES      10      // Maximum Of 16 Files May Be Open At Once
#define FERR_FILE_EXISTS    11      // File Already In Directory
#define FERR_NO_WR          12      // No Drive Available For An Open
#define FERR_READONLY       13      // Write Attempt To A Read Only File
#define FERR_NO_DRIVE       14      // No Drive Available For An Open
#define FERR_WR_PROTECTED   15      // Disk Is Write Protected
#define FERR_DCB_CHANGE     16      // DCB Is Modified And Is Unusable (changed while the file was open)
#define FERR_DIR_RD         17      // Directory Read Error
#define FERR_DIR_WR         18      // Directory Write Error
#define FERR_FILESPEC       19      // Improper File Name
#define FERR_GAT_READ       20      // Granule Allocation Table Read Error
#define FERR_GAT_WRITE      21      // Granule Allocation Table Write Error
#define FERR_HIT_READ       22      // Hash Index Table Read Error
#define FERR_HIT_WRITE      23      // Hash Index Table Write Error
#define FERR_NOT_FOUND      24      // File Not Found
#define FERR_PASSWD_PROT    25      // File Access Denied Due To Password Protection
#define FERR_DIR_FULL       26      // Directory Space Full
#define FERR_DISK_FULL      27      // Disk Space Full
#define FERR_EOF            28      // Attempt To Read Past EOF
#define FERR_EOF_R          29      // Read Attempt Outside Of File Limits, (use valid record numbers)
#define FERR_FRAGMENTED     30      // No More Extents Available (16 Maximum, COPY to another file to reduce fragmentation)
#define FERR_PRG_NOT_FOUND  31      // Program Not Found
#define FERR_INVALID_DRIVE  32      // Unknown Drive Number (in Filespec)
#define FERR_FRAGMENTED_SPC 33      // Disk Space Allocation Cannot Be Made Due To Fragmentation Of Space (use COPY..)
#define FERR_NOT_PRG        34      // Attempt To Use A NON Program File As A Program
#define FERR_PRG_MEM        35      // Memory Fault During Program Load
#define FERR_OPEN_PARM      36      // Parameter For Open Is Incorrect
#define FERR_ALREADY_OPEN   37      // Open Attempt For A File Already Open
#define FERR_NOT_OPEN       38      // I/O Attempt To An Unopen File
#define FERR_IO             39      // Illegal I/O Attempt (disk swap or differently formatted disk)
#define FERR_SEEK           40      // Seek Error (faulty or unformatted disk)
#define FERR_DATA_LOSS      41      // Data Lost During Disk I/O (Hardware Fault)
#define FERR_PRN_NOT_RDY    42      // Printer Not Ready
#define FERR_PRN_NO_PAPER   43      // Printer Out Of Paper
#define FERR_PRN_FAULT      44      // Printer Fault (May Be Turned Off)
#define FERR_PRN            45      // Printer Not Available
#define FERR_VLR_FILE       46      // Not Applicable To VLR Type Files
#define FERR_CMD_PARM_MISS  47      // Required Command Parameter Not Found
#define FERR_CMD_PARM       48      // Incorrect Command Parameter
#define FERR_HARDWARE       49      // Hardware Fault During Disk I/O
#define FERR_EXTENT         50      // Invalid Space Descriptor (try a dufferent diskette)
#define FERR_UNKNOWN        63      // Unknown error code


/* Functions */

#define DOS_GET_BYTE    0x0013    // read byte from file
#define DOS_PUT_BYTE    0x001B    // write byte to file
#define DOS_COMMAND     0x4405    // enter DOS and execute a command
#define DOS_ERROR       0x4409    // Display DOS error message on screen (A=error code, bit 7 for detailed message)
#define DOS_DEBUG       0x440D    // enter DEBUG
#define DOS_ENQUEUE     0x4410    // enqueue user timer interrupt routine
#define DOS_DEQUEUE     0x4413    // dequeue user timer interrupt routine
#define DOS_ROTATE      0x4416    // Keep drives rotating
#define DOS_CALL        0x4419    // dos-call execute a DOS command and return
#define DOS_FSPEC       0x441C    // (aka filename EXTRACT), fetches a file specification in TRSDOS standard format
#define DOS_OPEN_NEW    0x4420    // open new/exist file
#define DOS_OPEN_EX     0x4424    // open existing file
#define DOS_CLOSE       0x4428    // close file
#define DOS_KILL        0x442C    // kill FCB's associated file
#define DOS_LOAD        0x4430    // load a program file
#define DOS_EXECUTE     0x4433    // load and commence execution of a program file
#define DOS_READ_SECT   0x4436    // read file's record
#define DOS_WRIT_SECT   0x4439    // write file's record
#define DOS_REWIND      0x443F    // set NEXT to 0/0/0.
#define DOS_POSIT       0x4442    // position to relrec;  DE=DCB, BC=logical record (file sector)
#define DOS_BACK_RECD   0x4445    // position back 1 recd
#define DOS_POS_EOF     0x4448    // position to END
#define DOS_ALLOCATE    0x444B    // allocate file space
#define DOS_POS_RBA     0x444E    // position to RBA
#define DOS_WRITE_EOF   0x4451    // from fcb to directory
#define DOS_POWERUP     0x445B    // Select and power up the specified drive
#define DOS_TEST_MOUNT  0x445E    // Test for mounted diskette
#define DOS_NAME_ENQ    0x4461    // *name routine enqueue
#define DOS_NAME_DEQ    0x4464    // *name routine dequeue
#define DOS_TIME        0x446D    // convert clock time to HH:MM:SS format
#define DOS_DATE        0x4470    // convert date to MM/DD/YY format


/* Calling the TRSDOS ROM, on exit the error code is given */
extern int __LIB__ trsdos(unsigned int fn, char *hl_reg, char *de_reg) __smallc;
extern int __LIB__ trsdos_callee(unsigned int fn, char *hl_reg, char *de_reg) __smallc __z88dk_callee; 
#define trsdos(a,b,c) trsdos_callee(a,b,c)

/* Calling the TRSDOS ROM, on exit the zero flag is given */
extern int __LIB__ trsdos_tst(unsigned int fn, char *hl_reg, char *de_reg) __smallc;
extern int __LIB__ trsdos_tst_callee(unsigned int fn, char *hl_reg, char *de_reg) __smallc __z88dk_callee; 
#define trsdos_tst(a,b,c) trsdos_tst_callee(a,b,c)

/* Use TRSDOS ROM to read a file, -1 if EOF */
extern int __LIB__  trsdos_get(int fcb) __smallc __z88dk_fastcall;

/* Set up an FCB by given filespec */
extern int __LIB__ initdcb(char *name, struct TRSDOS_FCB *fcb) __smallc;


/* Miosys C compatibility */
extern char __LIB__ *addext(char *filespec, char *ext) __smallc;
extern char __LIB__ *genspec( char *inspec, char *partspec, char *extn) __smallc;


#endif
