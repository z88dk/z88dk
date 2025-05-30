/*
 * To use BDOS READ (#20) and BDOS WRITE (#21) in a non-sequential way,
 * the S2, EX, and CR values need to be managed.
 *
 * Set the FCB parameters to the record number supplied by library
 * Set S2, EX, and CR to the record_number.
 *
 * Assume record_number is set to rwptr / SECSIZE
 *
 * CR = current record,     ie (rwptr % 16384) / 128
 * EX = current extent,     ie (rwptr % 524288) / 16384
 * S2 = extent high byte,   ie (rwptr / 524288) (preserve the clean/dirty bit 7)
 * The CP/M Plus source code refers to this use of the S2 byte as 'module number'.
 *
 * RC = number of the records allocated in the present extent
 *
 * This can be rewritten in assembly once proven to be correct.
 */


#include <cpm.h>
#include <ctype.h>

void setrecord(struct fcb *fc) __z88dk_fastcall
{
    uint16_t record_nr = (uint16_t)fc->record_nr;

    fc->current_record = (char)record_nr & 0x7F;
    fc->extent = (uint8_t)(record_nr >> 7) & 0x1F;

    fc->s2 &= 0x80;     // preserve the clean/dirty bit 7
    fc->s2 |= (char)(record_nr >> 12) & 0x0F;
}

