/*
 *  HDOS Directory browsing
 * 
 *  Stefano, 2026
 *
 *
 *  $Id: dir_move_next.c $
 */

#include <stdio.h>
#include <arch/hdos.h>


static int is_invalid_dirent(const uint8_t *e)
{
    //if (is_empty_dirent(e))
    //    return 1;

    ///* Printable ASCII or spaces */
    //for (int i = 0; i < 8; i++) {
    //    if (e[i] != ' ' && (e[i] < 0x21 || e[i] > 0x7E))
    //        return 1;
    //}
    //for (int i = 8; i < 11; i++) {
    //    if (e[i] != ' ' && (e[i] < 0x21 || e[i] > 0x7E))
    //        return 1;
    //}

    /* Check cluster factor */
    uint8_t clus = e[13];
    if (clus == 0 || clus > 16)
        return 1;

    /* first/last group */
    uint8_t fg = e[16];
    uint8_t lg = e[17];
    if (lg < fg)
        return 1;

    // /* group overflow */
    // if ((lg - fg) > 200)
    //     return 1;

    /* last-sector-index < cluster_factor */
    uint8_t lsi = e[18];
    if (lsi >= clus)
        return 1;

    return 0;   /* valid entry */
}


int dir_move_next(void)
{
    if (!hdos_dir_fp || hdos_dir_eof)
        return 0x24;

    while (1) {
        size_t r = fread(hdos_dir_buf, 1, HDOS_DIRENT_LEN, (FILE *)hdos_dir_fp);
        if (r < HDOS_DIRENT_LEN) {
            hdos_dir_eof = 1;
            return 0x24; /* let's simulate FLOS error code $24 (= Reached end of directory) */
        }

        //hdos_dir_index++;
		if (!is_invalid_dirent(hdos_dir_buf)) {
			if (!is_empty_dirent(hdos_dir_buf))
				return 0;    /* success */
		}
    }
}
