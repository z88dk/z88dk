/*
 *  HDOS Directory browsing
 * 
 *  Stefano, 2026
 *
 *
 *  $Id: dir_get_entry_name.c $
 */


#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <arch/hdos.h>


static char hdos_name_buf[20];

char *dir_get_entry_name(void)
{
    /* entry layout:
       [0..7] name
       [8..10] ext
    */

    char name[9], ext[4];

    memcpy(name, hdos_dir_buf, 8);
    name[8] = 0;

    memcpy(ext, hdos_dir_buf + 8, 3);
    ext[3] = 0;

    /* Trim spaces */
    for (int i = 7; i >= 0 && name[i] == ' '; i--)
        name[i] = 0;
    for (int i = 2; i >= 0 && ext[i] == ' '; i--)
        ext[i] = 0;

    if (ext[0])
        sprintf(hdos_name_buf, "%s.%s", name, ext);
    else
        sprintf(hdos_name_buf, "%s", name);

    return hdos_name_buf;
}
