/*
 *      wc.c
 *      An imitation of the unix wc utility
 *
 *      26/4/99 djm
 *      Another pointless application done because I want to corner
 *      the market in throwaway apps and popdowns!
 *
 *      Virtually the same as the viewer.c app, just a little bit
 *      changed..see, it's really easy to do!!
 *
 * 	Although we use printf() miniprintf() gets used for us
 * 	and cuts the size of the app down...nice!
 */

/* Compiler directives, no bad space, not expanded */

#pragma -reqpag=0
#pragma -no-expandz88

#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <z88.h>


int main()
{
        char    buffer[81];
        int     lcount;
        int     wcount;
        int     ccount;
        unsigned char word;
        int c;
        FILE    *fp;


        if ( readmail(FILEMAIL,(far char *)buffer,81) == NULL ) {
                printf("No input file, exiting");
                sleep(1);
                exit(0);
        }
        if  ( (fp=fopen(buffer,"r") ) == NULL ) {
                printf("Cannot open file: %s...sorry!",buffer);
                sleep(1);
                exit(0);
        }

        lcount=wcount=ccount=0;
        printf("\001F\001R  WORKING!!!  \001R\001F\n");
        while ((c = fgetc(fp)) != EOF) {
                ccount++;

                if (isspace(c)) {
                        if (word) wcount++;
                        word = 0;
                } else {
                        word = 1;
                }

                if (c == '\n' || c == '\f' || c == '\l' ) lcount++;
        }
        fclose(fp);

        printf("\0013@  File %s Lines = %d Words = %d Chars = %d\n\n\001R  PRESS ANY KEY  \001R\n",buffer,lcount,wcount,ccount);
        getkey();
        exit(0);        /* Saves a bit of space on stack cleanup */
}

#include <dor.h>

/*
 * We're a popup so APP_INFO is not needed
 */

#define APP_INFO ""

#define HELP1   "A simple imitation of wc from the Unix world"
#define HELP2   "Select a file from the Filer and enter this app"
#define HELP3   "Made with z88dk v1.2"
#define HELP4   ""
#define HELP5   "v0.1 26.4.99 djm"
#define HELP6   "Email:djm@jb.man.ac.uk"

#define APP_KEY  'W'
#define APP_NAME "WordCount"
#define APP_TYPE AT_Popd
#define APP_TYPE2 AT2_Cl

#include <application.h>

/* THE END! */
