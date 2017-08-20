/*  cmp.c -- UTOOL. Compare 2 files or file and std input
     for equality.  
     author: David H. Wolen
     last change: 11/23/82

     usage: cmp file1 file2
            // prog |cmp file1  <- this won't work !

     input:    2 files or file and STDIN
     output:   STDOUT


$Id: cmp.c,v 1.1 2013-06-25 10:55:05 stefano Exp $

This is a good example on how to convert a BDS C program to z88dk.
The original code portions are commented out but kept, look for '//'.

*/

#include <bdscio.h>
//#include "dio.h"
//#define STDIN 0

main(argc,argv)
int  argc;
char *argv[];
{
     //char buf1[BUFSIZ], buf2[BUFSIZ], 
     FILE *buf1;
     FILE *buf2;
     char line1[MAXLINE];
     char line2[MAXLINE];
     int  isstdin, lineno, m1, m2;

     dioinit(&argc,argv);

     switch(argc)
          { case 2:      /* stdin and 1 file */
               isstdin=TRUE;
               //if(fopen(argv[1],buf2)==ERROR)
               if((buf2=fopen(argv[1],"r"))==0)
                    error("cmp: can't open file");
               break;
            case 3:      /* 2 files */
               isstdin=FALSE;
               //if(fopen(argv[1],buf1)==ERROR)
               if((buf1=fopen(argv[1],"r"))==0)
                    error("cmp: can't open file 1");
               //if(fopen(argv[2],buf2)==ERROR)
               if((buf2=fopen(argv[2],"r"))==0)
                    error("cmp: can't open file 2");
               break;
            default:
               error("usage: cmp file1 file2 or STDIN file");
          }

     lineno=0;

     while(1)
	      // The BDS C fgets() implementation gets two parameters only: see {z88dk}/include/bdscio.h
          {m1=(isstdin) ? fgets(line1,STDIN) : fgets(line1,buf1);
          m2=fgets(line2,buf2);
          if(!m1 || !m2)
               break;
          lineno++;
          if(!eqs(line1,line2))
               printf("%d\n%s%s",lineno,line1,line2);
          }

     if(!m1 && m2)
          out("cmp: eof on file 1");
     else if(!m2 && m1)
          out("cmp: eof on file 2");

     //dioflush();
}

