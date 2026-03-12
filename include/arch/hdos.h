/* Header for Heath/Zenith HDOS specific functions */

#ifndef ARCH_HDOS_H
#define ARCH_HDOS_H


// Get HDOS version
//
#define HDOS_VER_10 0x00
#define HDOS_VER_15 0x15
#define HDOS_VER_16 0x16
#define HDOS_VER_20 0x20
//
extern int __LIB__ hdos_ver(void);


// Load HDOS overlay number
// on exit: !=0 if load error
//
extern int __LIB__ hdos_overlay(int ov) __z88dk_fastcall;


////////////////////
// File management
//
// The file fucntions will return non-zero if an error occurs
// When no device or file extension is specified, the default values will be used

// Default device and extension, set to "SY1TXT"
extern char *hdos_default;

// Rename HDOS file, doesn't check existence of files with the same newname
//
extern int __LIB__          hdos_rename(char *name, char *newname) __smallc;
extern int __LIB__   hdos_rename_callee(char *name, char *newname) __smallc __z88dk_callee;
#define hdos_rename(a,b) hdos_rename_callee(a,b)

// Delete HDOS file
//
extern int __LIB__          hdos_delete(char *name) __z88dk_fastcall;

// Change HDOS file attribute flags
//
#define F_HIDDEN    0x80    // "System hidden" attribute.  File won't appear in the directory listing.
#define F_LOCKED    0x40    // A "file lock" cannot be revoked
#define F_RDONLY    0x04    // If a file is "read only" and "locked" it cant be deleted or altered anymore
//
extern int __LIB__          hdos_chflg(char *name, int flags) __smallc;
extern int __LIB__   hdos_chflg_callee(char *name, int flags) __smallc __z88dk_callee;
#define hdos_chflg(a,b) hdos_chflg_callee(a,b)



#endif
