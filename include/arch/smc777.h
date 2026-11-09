/*
 * Header file for Sony SMC-777 specific stuff
 *
 */

#ifndef __SMC777_H__
#define __SMC777_H__

#include <sys/compiler.h>
#include <stdint.h>

// Read count sectors of 256 bytes into buf from the floppy disk controller, starting at the sector (the first on a track is 1) of the track (the
// disk is single sided: the track is the cylinder), carrying on to the next track after sector 16.  Returns 0, or 1 on an error.  Interrupts are
// turned off for the call.  The disk in drive 0 is the one booted from.  The program is on the disk from cylinder 1 (appmake +smc777): a
// program's own data goes beyond it.
extern int __LIB__ smc777_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
extern int __LIB__ smc777_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;

#endif
