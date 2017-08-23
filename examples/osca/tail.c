/*  tail.c -- UTOOL. Print last n lines of file.


$Id: tail.c,v 1.1 2013-06-20 08:25:45 stefano Exp $


     author: David H. Wolen
     last David's change: 01/25/83

     usage:  tail  [n]

     options:  n  number of lines to print.  Range
                  1--1000.  Default 10.

     input:  STDIN
     output: STDOUT


Z88DK port by Stefano Bodrato.
  Changes were made in fopen() calls and argv[] referencing;
  the default number of lines has been changed from 32 to 10


Compiler hints:
  zcc +cpm -lmalloc -DAMALLOC -O3 -o tail.com tail.c
  zcc +osca -lflosxdos -lmalloc -DAMALLOC -O3 -o tail.exe tail.c


Usage example:
  tail 50 <filein >fileout

It the <filein is omitted then the console input will be active 
for stdin; to close the stream type CTRL-Z, ESC or BREAK 
depending on the target platform you're running tail on.

*/


#include <bdscio.h>

#define  LINES  1000     /* max lines to display */
#define  OS1LINES  10    /* default lines to display */
#define  SIZECP  2       /* size of pointer to char in bytes */


int main(int argc, char *argv[])
{
     int  ntail, nsave, i;
     char *linbuf[LINES], line[MAXLINE];

     dioinit(&argc,argv);
     nsave=0;
     if(argc > 1) {  /* number of lines to print given on command line */
          ntail=atoi(argv[1]);
          if(ntail < 1 || ntail > LINES)
               error("tail: lines to print must be 1--1000");
          }
     else           /* use default */
          ntail=OS1LINES;

     while(fgets(line,STDIN))
          saveline(line,linbuf,&nsave,ntail);

     if(nsave <= 0)
          error("tail: empty input");

     for(i=0; i < nsave; i++)
          fputs(linbuf[i],STDOUT);

     dioflush();
}



/* saveline -- store lines and save pointers to them */
saveline(line,linbuf,nsave,ntail)
char *line, *linbuf[];
int  *nsave, ntail;
{
     char *p;

     if(*nsave < ntail) {
          if((p=alloc(strlen(line)+1)) == NULL)
               error("tail: out of room in saveline #1");
          strcpy(p,line);
          linbuf[(*nsave)++]=p;
          }
     else
          {free(linbuf[0]);
          movmem(&linbuf[1],&linbuf[0],(ntail-1)*SIZECP);
          if((p=alloc(strlen(line)+1)) == NULL)
               error("tail: out of room in saveline #2");
          strcpy(p,line);
          linbuf[ntail-1]=p;
          }
}

