/*
 * Header file for NEC PC-6001mkII specific stuff (zcc +pc6001 -subtype=mk2disc: a boot disc, the program at $0000 in all RAM)
 *
 * The routines here use the mkII's hardware and link only with that subtype.  The disc is 40 tracks of 16 sectors of 256 bytes; the program is on tracks 1 to n, the overlays after it
 * (appmake +pc6001mk2), and pc6001mk2_data_track() says where the free tracks start.
 *
 * Overlays: name the linker sections OVERLAY_0, OVERLAY_1 ... (up to 8), put them all at one address with a memory map of your own (-pragma-define:MMAP=-1 and a mmap.inc with
 * "SECTION OVERLAY_0", "org window" ...), and say how many with -pragma-define:CRT_PC6001MK2_OVERLAYS=n.
 */

#ifndef __PC6001MK2_H__
#define __PC6001MK2_H__

#include <sys/compiler.h>
#include <stdint.h>

// Read or write count sectors (up to the end of the track) of 256 bytes from sector (1 to 16) of track (0 to 39).  Return 0, or 255 for an error.
extern int __LIB__ pc6001mk2_disk_read(uint8_t track, uint8_t sector, uint8_t count, void *dest) __smallc;
extern int __LIB__ pc6001mk2_disk_write(uint8_t track, uint8_t sector, uint8_t count, const void *src) __smallc;

// Read overlay n (the section OVERLAY_n) into its window.  Returns 0, or 255 for a disc error.  Interrupts are put back as they were.
extern int __LIB__ pc6001mk2_overlay_load(uint8_t n) __smallc;

// The first track after the program and the overlays
extern int __LIB__ pc6001mk2_data_track(void);

#endif
