/*
 *  HDOS Directory browsing
 * 
 *  Stefano, 2026
 *
 *
 *  $Id: dir_move_first.c $
 */

#include <stdio.h>
#include <arch/hdos.h>

unsigned char  hdos_dir_buf[HDOS_DIRENT_LEN];

void *hdos_dir_fp;
int hdos_dir_eof;

int dir_move_first(void)
{
    hdos_dir_eof = 0;
    //hdos_dir_index = 0;

    if (hdos_dir_fp) {
        fclose((FILE *)hdos_dir_fp);
        hdos_dir_fp = NULL;
    }

    hdos_dir_fp = (FILE *)fopen("DIRECT.SYS", "rb");
    if (!hdos_dir_fp)
        return 0x24;     /* simulate FLOS error code $24 (= Reached end of directory) */

    //while (1) {
        size_t r = fread(hdos_dir_buf, 1, HDOS_DIRENT_LEN, (FILE *)hdos_dir_fp);
		rewind(hdos_dir_fp);  // odd workaround obtained by trial and error, it just works
        //if (r < HDOS_DIRENT_LEN) {
        //    hdos_dir_eof = 1;
        //    return 0x24;
        //}

        //hdos_dir_index++;

        //if (!is_empty_dirent(hdos_dir_buf))
            //return 0;    /* Directory cursor ready */
			return dir_move_next();
    //}
}
