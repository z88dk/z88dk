/*
 *  HDOS directory — check for empty entry
 * 
 *  Stefano, 2026
 *
 *
 *  $Id: is_empty_dirent.c $
 */

#include <arch/hdos.h>

int is_empty_dirent(unsigned char *e)
{
    /* HDOS uses these markers for empty / free directory entries */
    return (e[0] == 0x00 ||
            e[0] == 0xFE ||
            e[0] == 0xFF);
}
