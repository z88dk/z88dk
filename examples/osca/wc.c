/*
	wc [file ...]

	Count the number of bytes, words, and lines in one or more files.
	Wildcards are accpeted
	
 */

/* To build:
		zcc +osca -lflosdos -owc.exe -DWILDCARD wc.c
		zcc +cpm -owc.com -DWILDCARD wc.c
*/


#include <stdio.h>
#include <stdlib.h>

long	twords	= 0;
long	tlines	= 0;
long	tbytes	= 0;
long	bytes;


output(long lines, long words, long bytes, char *filename)
{
	printf("%07ld ", lines);
	printf("%07ld ", words);
	printf("%07ld ", bytes);
	if (filename != NULL)
	    printf(" %s", filename);
	printf("\n");
}




int main(int argc, char *argv[])

{
	int	x,i, nfiles;
	FILE	*fp;
	int		gotcha;

	nfiles = 0;
	if(argc < 2) {
	    //++nfiles;
	    //count(stdin, NULL);
			printf("\nwc - Count the number of bytes, words,\nand lines in one or more files.\n");
		    exit (0);
	}
	else {
	printf("\nLines   Words   Bytes    File\n");
	printf("------- ------- -------  -----------\n");

#ifdef WILDCARD
	    for (i = 1; i < argc; ++i) {
			if ((x=dir_move_first())!=0) return(0);

			while (x == 0) {
				if (wcmatch(argv[i],dir_get_entry_name())) {
					if (!dir_get_entry_type()) {
						++nfiles;
						fp = fopen(dir_get_entry_name(), "r");
						bytes=dir_get_entry_size();
						count(fp, dir_get_entry_name());
						fclose(fp);
					}
				}
				x = dir_move_next();
			}

		    if (gotcha == 0)
			printf("\"%s\": no matching files\n", argv[i]);
	    }
#else
	    for (i = 1; i < argc; ++i) {
		if ((fp = fopen(argv[i], "r")) == NULL) {
		    //perror(argv[i]);
			printf("\"%s\": file not found\n", argv[i]);
		    exit (0);
		}
		else {
		    ++nfiles;
		    count(fp, argv[i]);
		    fclose(fp);
		}
	    }
#endif
	}
	if (nfiles > 1) {
		printf("------- ------- -------  -----------\n");
		output(tlines, twords, tbytes, "TOTAL");
	}
}

count(fp, filename)
FILE		*fp;			/* File pointer			*/
char		*filename;		/* File name string		*/
{
	register int c, inword;
	long lines;
	long words;

	lines = 0;
	words = 0;
#ifndef FLOS
	bytes = 0;
#endif
	inword = 0;
	while((c = getc(fp)) != EOF) {
#ifndef FLOS
	    ++bytes;
#endif
	    if (c == ' ' || c == '\t' || c == '\n') {
		inword = 0;
		if (c == '\n')
		    ++lines;
	    }
	    else if (!inword) {
		++inword;
		++words;
	    }
	}
	twords += words;
	tlines += lines;
	tbytes += bytes;
	output(lines, words, bytes, filename);
	
	return(0);
}
