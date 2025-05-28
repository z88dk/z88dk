/*
 * To use BDOS READ (#20) and BDOS WRITE (#21) in a non-sequential way,
 * the S2, EX, and CR values need to be managed.
 *
 * Set the FCB parameters to the record supplied by library
 * Set S2, EX, and CR to record number.
 * Set RC to the record.
 *
 * RC = number of the record    ie rwptr % 128
 * CR = current record,     ie (rwptr % 16384) / 128
 * EX = current extent,     ie (rwptr % 524288) / 16384
 * S2 = extent high byte,   ie (rwptr / 524288) (preserve the clean/dirty bit 7)
 * The CP/M Plus source code refers to this use of the S2 byte as 'module number'.
 *
 * RC = number of the record in the present extent
 *
 * This can be rewritten in assembly once proven to be correct.
 */


#include <cpm.h>
#include <ctype.h>

void setrecord(struct fcb *fc) __z88dk_fastcall
{
    unsigned long rwptr = fc->rwptr;

    fc->records = (char)rwptr & 0x7F;

    fc->current_record = (char)(rwptr >> 7) & 0x7F;
    fc->extent = (uint8_t)(rwptr >> 14) & 0x1F;

    fc->s2 &= 0x80;     // preserve the clean/dirty bit 7
    fc->s2 |= (char)(rwptr >> 19) & 0x0F;
}

