/*
 *  HDOS Directory browsing
 * 
 *  Stefano, 2026
 *
 *
 *  $Id: dir_get_entry_size.c $
 */

#include <stdio.h>
#include <arch/hdos.h>
#include <stdint.h>

unsigned long dir_get_entry_size(void)
{
    uint8_t clusfac = hdos_dir_buf[13];
    uint8_t fgn     = hdos_dir_buf[16];
    uint8_t lgn     = hdos_dir_buf[17];
    uint8_t lsi     = hdos_dir_buf[18];

    unsigned groups = (unsigned)lgn - (unsigned)fgn;
    unsigned long size = (unsigned long)groups * clusfac * SECSIZE + (unsigned long)lsi * SECSIZE;

    return size;
}
