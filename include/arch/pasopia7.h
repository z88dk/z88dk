/*
 * Header file for Toshiba Pasopia 7 specific stuff
 *
 */

#ifndef __PASOPIA7_H__
#define __PASOPIA7_H__

#include <sys/compiler.h>
#include <stdint.h>

// Read count sectors of 256 bytes into buf from the floppy disk controller (a polled uPD765A), starting at the sector (1 to 16) of the track (0 to 39: the
// cylinder; the disks are single sided) of the drive, carrying on to the next track after sector 16.  Returns 0, or an error (2 not ready, 3 the seek failed,
// 4 the controller refused or said no, 5 timed out).  Interrupts are not used (the caller's state is kept), the ROM is not used, and the drive's motor is on only for the
// call.  A program built by appmake +pasopia7 is on the disk from track 2 (8 sectors a track: 2 KB), and what --data adds follows it from the next track.
extern int __LIB__ pasopia7_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
extern int __LIB__ pasopia7_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;

#endif
