/*/*
 *      Small C+ String Library
 *
 *      Taken from c68 archive
 *
 *      Added to Small C+ archive 1/3/99 djm
 */


/* strrstr - find last occurrence of wanted in s
 *          found string, or NULL if none
 *
 *  AMENDMENT HISTORY
 *  ~~~~~~~~~~~~~~~~~
 *  12 Mar 98   DJW   - First Version.  Based on ideas from A Ives.
 *
 *   1 Mar 99   djm   - Made for Small C
 */

#include <string.h>

#define NULL 0


char *strrstr (unsigned char *s, unsigned char *wanted)
{
    unsigned char *scan;
    unsigned char pad,firstc;
    int len;

    /*
     * The odd placement of the two tests is so "" is findable.
     * Also, we inline the first char for speed.
     * The ++ on scan has been moved down for optimization.
     */
    firstc = *wanted;
    len = strlen(wanted);
    for (scan = s + strlen(s) - len ; scan >= s ; scan--)
    {
        if (*scan == firstc)
        {
            if (strncmp (scan, wanted, len) == 0)
            {
                return (scan);
            }
        }
    }
    return(NULL);
}

