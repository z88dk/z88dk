/*
 *      A small program to dump out the contents of a file selected
 *      from the Filer
 *
 *      This is a popdown - use Q to quit.
 *
 *      Applications are easy with z88dk!
 *
 *      11/4/99 djm
 */

/* Compiler directives, no bad space, not expanded */

#pragma -no-expandz88



/* Call up the required header files */

#include <stdio.h>
#include <stdlib.h>
#include <z88.h>


main()
{
        char    buffer[81];
        unsigned char    count;
        FILE    *fp;
        count=0;
        if ( readmail(FILEMAIL,(far char *)buffer,81) == NULL ) {
                puts("\n\n\tNo input file, exiting");
                sleep(1);
                exit(0);
        }
        if  ( (fp=fopen(buffer,"r") ) == NULL ) {
                puts("\n\n\tCannot open file..sorry!");
                puts(buffer);
                sleep(1);
                exit(0);
        }
        while (fgets(buffer,80,fp) != NULL) {
                fputs(buffer,stdout);
                ++count;
                if ( count == 8) { 
                        count=0;
                        if ( getkey() == 'Q' ) {
                                fclose(fp);
                                exit(0);
                        }
                }
                putchar('\n');
        }
        fclose(fp);
        getkey();
        exit(0);        /* Saves space, by removing cleanup */
}


#include <dor.h>

/*
 * We're a popup so APP_INFO is not needed
 */

#define APP_INFO ""

#define HELP1   "A simple text viewer written using z88dk"
#define HELP2   "Select a file from the Filer and enter this app"
#define HELP3   "Use 'Q' to quit the viewer"
#define HELP4   ""
#define HELP5   "v0.1 11.4.99 djm"
#define HELP6   "Email:djm@jb.man.ac.uk"

#define APP_KEY  'T'
#define APP_NAME "Textview"
#define APP_TYPE AT_Popd
#define APP_TYPE2 AT2_Cl

#include <application.h>

/* THE END! */
