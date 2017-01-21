/*
 *	This file contains pretty well all the z88 specific routines
 *	Most of these will probably have no equivalent on any other
 *	machine..
 *
 *      Link using -lz88
 *
 *	$Id: z88.h,v 1.9 2016-06-23 21:11:24 dom Exp $
 */

#ifndef __Z88_H__
#define __Z88_H__

#include <sys/compiler.h>
#include <sys/types.h>

/*
 * Read and send mail
 */

extern int __LIB__ readmail(const char *type, const char *info, size_t length) __smallc;
extern int __LIB__ sendmail(const char *type, const char *info, size_t ength) __smallc;

/*
 * Two defines for the system supported mail types 
 */

#define FILEMAIL "NAME"
#define DATEMAIL "DATE"

/*
 * Look at dev notes for the significence of these
 */

extern int __LIB__ savescr(void);
extern int __LIB__ restscr(int);
extern int __LIB__ freescr(int);
extern int __LIB__ pagewait(void);      /* Do not use, causes error! */

/*
 * Next two calls aren't recommended!
 */

extern int __LIB__ di(void);
extern void __LIB__ ei(int);

/*
 * Name an application
 */

extern void __LIB__ nameapp(const char *);

/*
 * Some calls provided for by the packages system 
 *
 * First of all types for the type in RegisterInt()
 *
 * All these return 0 on failure
 */

#define INT_TICK	1
#define INT_SEC		2
#define INT_MIN		4
#define INT_UART	8

extern int __LIB__ RegisterInt(void (*fn)(),int type, int tick) __smallc;
extern int __LIB__ DeRegisterInt(void);

/*
 *	Open a library/package, returns 0 on failure
 *	Supply 0 to check if package handling is available
 *	Specify major=minor=0 to disable version checking
 *
 */

extern bool_t __LIB__ QueryPackage(int which, int major, int minor) __smallc;

/*
 *	Get the PID of a process
 */

extern pid_t __LIB__ getpid(void);

/*
 *	Macro for package calls directly in C code
 *	(probably not useful..)
 */

#define CALL_PKG(b) asm("call_pkg ("#b")\n")

/*
 *	Some package names
 */

#define LIB_NONE	0x00
#define LIB_PACKAGE	0x0f
#define LIB_XFS		0x12
#define LIB_TCP		0x15
#define LIB_TFTPD       0x18
#define LIB_EXAMPLE	0x45

extern int __LIB__ opendor(const char *filename);
extern void __LIB__ readdor(int dor, int type, size_t len, void *buf) __smallc;
extern void __LIB__ closedor(int dor);

/* These are still in z88_crt0.lib though they're not referenced */
extern void __LIB__ writedor(int dor, int type, size_t len, const void *buf) __smallc;
extern void __LIB__ deletedor(int dor);

/* Return the son/brother of the dor, supply pointer to store minor type */

extern int __LIB__ sondor(int dor, char *store) __smallc;
extern int __LIB__ brotherdor(int dor, char *store) __smallc;

/*
 * Wildcard handler routines
 */

typedef struct wildcard_st {
	void	*endptr;
	u8_t	segments;
	u8_t	length;
	u8_t	dortype;
} wildcard_t;

/* Open a wildcard handler, 
 * Returns handle
 * mode is the logical OR ( | ) of the defines below 
 * Returns NULL if unable to comply
 */

#define WILD_SCANDIR 1
#define WILD_PARENTS 2

extern wild_t __LIB__ wcopen(far char *, int mode);

/* Read the next entry from the wildcard handler /hand/
 * Store it in /buf/ which has length /len/
 * Put information about this entry in /st/ (supply NULL if not reqd
 *
 * Returns EOF if no more entries, NULL otherwise
 */
extern int __LIB__ wcnext(wild_t hand,void *buf, size_t len, wildcard_t *st) __smallc;

/* Close wildcard handler /hand/ 
 * Returns NULL if closed okay EOF otherwise
 */

extern int __LIB__ wcclose(wild_t hand);

/* Expand a filename */
extern char __LIB__ *fnexpand(far char *filename, char *buf, size_t buflen);


#ifdef IFIXEDTHEMBUTWHY
/*
 *	Parsing of filename/segment
 *	I've never used these (in either asm/C) but they're here
 *	for completeness (I'm gleaning the devnotes ATM!)
 *
 *	These routines return EOF on error
 */

/* Defines which the routines return (OR'd together) */
#define PRS_EXTN 1
#define PRS_FILE 2
#define PRS_XDIR 4
#define PRS_CDIR 8
#define PRS_PDIR 16
#define PRS_WDIR 32
#define PRS_DEV  64
#define PRS_WILD 128

/* Parse an extension return flags as per defines for the filename
 * segment /seg/ puts ptr to terminating char in buf 
 */

extern int __LIB__ parseseg(far char *seg, far char **buf);

/* Parse a filename return flags as per defines above for the
 * filename /file/ puts number of segments and length of filename
 * (including \0 in the wildcard structure /wild/
 */

extern int __LIB__ parsefile(far char *seg, wildcard_t *wild);

#endif


/* Execute a CLI string (returns 0 on success)
extern int __LIB__ exec_cli(char *str);

/*
 *	Some routines from GWL now
 */

/* Returns a pointer to after the device */
extern char __LIB__ *stripdev(char *explicitname);

/* Returns a pointer to the filename segment */
extern char __LIB__ *strippath(char *explicitname);

/* Open a popup window */
extern void __LIB__ openpopup(int wid, int tlx, int tly, int width, int height, const char *name) __smallc;

/* Open a window */
extern void __LIB__ openwindow(int wid, int tlx, int tly, int width, int height) __smallc;

/* Open a titled window */
extern void __LIB__ opentitled(int wid, int tlx, int tly, int width, int height, const char *name) __smallc;


#endif /* Z88_H */
