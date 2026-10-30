/*
 * Header file for Samsung SPC-1000 specific stuff
 */

#ifndef __SPC1000_H__
#define __SPC1000_H__

#include <sys/compiler.h>
#include <stdint.h>

// The cassette, in the ROM's own format (BASIC's SAVE "name",M and LOAD "name",M read and write it).
// Interrupts are off while these run, and the deck has to be running (PLAY, or RECORD and PLAY): the break keys give up.

// Save len bytes at addr as the file `name` (16 characters at most).  user and ulen (up to 102 bytes, or 0) are kept in the
// file's header for tape_load_to to give back.  Returns 0, or -1 if stopped.
extern int __LIB__ tape_save(const char *name, const void *addr, size_t len, const void *user, size_t ulen) __smallc;

// Load the next file called `name` (any file if name is 0) to buf, whatever address it has (a file longer than len is read
// and the rest dropped); the program's bytes from the header go to user (up to ulen).  Returns the bytes stored; -1 if the header
// could not be read (buf is untouched); -2 if the data could not (buf may have been written to).
extern int __LIB__ tape_load_to(const char *name, void *buf, size_t len, void *user, size_t ulen) __smallc;

#endif
