/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */



/*
 * strstr - find first occurrence of wanted in s
 *          found string, or NULL if none
 *
 */

#include <string.h>


#define NULL 0




char *strstr(s, wanted)
unsigned char *s;
unsigned char *wanted;
{
    unsigned char *scan;
    int len;
    unsigned char pad,firstc;

    /*
     * The odd placement of the two tests is so "" is findable.
     * Also, we inline the first char for speed.
     * The ++ on scan has been moved down for optimization.
     */
    firstc = *wanted;
    len = strlen(wanted);
    for (scan = s; *scan != firstc || strncmp(scan, wanted, len); /*!= 0; */)
        if (*scan++ == '\0')
            return(NULL);
    return(scan);
}

