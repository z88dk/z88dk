/* Short C Example for the Z88 Dev Kit
 * Insultingly simple just takes first 5
 * lines of text file and displays them on
 * screen.
 *
 * Updated a little 5/5/99
 */

#define ANSI_STDIO

#include <stdio.h>
#include <stdlib.h>



main()
{
        FILE *fp;
        char line[81];
        int     i;

/* Do yourself a favour and change the filename to something else! */
        fp=fopen("filetest.c","r");
        if ((fp == NULL))
        {
                fputs("\nCan't open file, sorry",stdout);
                exit(0);
        }
	printn(fp,10,stdout);
        for (i=0; i!=5; i++)
        {
                fgets(line,80,fp);
                fputs(line,stdout);
        }
        fclose(fp);
}
