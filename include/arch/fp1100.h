/*
 * Header file for Casio FP-1100 specific stuff
 *
 * $Id: fp1100.h $
 */

#ifndef __FP1100_H__
#define __FP1100_H__

#include <sys/compiler.h>
#include <stdint.h>

// Read or write `count` (1 to 255) sectors of 256 bytes from `sector` (1 to 16) of `track` (= 2 * cylinder + side) of drive `unit` (0 to 3), carrying on to the next track
// after sector 16, by driving the uPD765A floppy pack directly (polled: no ROM, no interrupts, so it works with the machine all RAM).  Returns 0, or an error:
// 1 the pack is not there, 2 not ready, 3 the seek failed, 4 the controller refused or said no, 5 timed out.
extern int __LIB__ fp1100_disk_read(uint8_t unit, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;
extern int __LIB__ fp1100_disk_write(uint8_t unit, uint8_t track, uint8_t sector, uint8_t count, void *buf) __smallc;

#endif
