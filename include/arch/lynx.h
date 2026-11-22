/*
 * Header file for Camputers Lynx specific stuff
 *
 */

#ifndef __LYNX_H__
#define __LYNX_H__

#include <sys/compiler.h>
#include <stdint.h>

// Read count sectors of 512 bytes into buf from the disk interface's floppy controller (a WD1793), starting at the sector (1 to 10) of the
// track (0 to 39) of the drive (the disk is single sided), carrying on to the next track after sector 10.  Returns 0, or 1 on an error (a
// drive that is not ready is an error at once).  Interrupts are turned off for the call, and the drive's motor is stopped at the end of it.
// A program built with -subtype=allram (loaded at $0000) is on the disk from the sector after the boot sector (appmake +lynx --disc): a program's own data
// goes beyond it, from the next track (--data).
extern int __LIB__ lynx_disk_read(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
extern int __LIB__ lynx_disk_write(uint8_t drive, uint8_t track, uint8_t sector, uint8_t count, const void *buf) __smallc;

#endif
