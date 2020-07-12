/*
 *
 *	Demo of the far malloc() routine
 *
 *	djm 15/4/2000
 */

/* Specify that we want to use far routines (do this before any includes) */
#define FARDATA 1

/* sccz80 magic, make application and far heapsize is 16384 */
#pragma -farheap=16384
#pragma -reqpag=3

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>


#define SIZE 1024UL

static char	string1[]="This is string 1..dull as hell";
static char	string2[]="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static char	string3[]="The quick brown fox ";
static char	string4[]="jumped over the lazy dog";

void printfar(far unsigned char *ptr);

void main()
{
	char	buffer[80];	/* Buffer for us to work in */
	FILE	*fp;
	far	char	*ptr;

	printf("Welcome to far demo v0.02 - 15/4/2000\n");

	printf("Requesting %ld bytes of storage...",SIZE);
	ptr=malloc(SIZE);
	if (ptr==NULL) {
		printf("didn't get it quitting\n");
		sleep(5);
		exit(0);
	}
	printf("got it at %ld\n",ptr);
	printf("size appears to be %d\n",*(far int *)(ptr-2));
	printf("Copying %s to far\n",string2);
	strcpy(ptr,string2);
	printf("Printing from far: "); printfar(ptr);
/* Now do a strcat test */
	printf("\nCopying to far mem: \"%s\"\n",string3);
	strcpy(ptr,string3);
	printf("Concatenating: \"%s\"\n",string4);
	strcat(ptr,string4);
	printf("In far mem we have:"); printfar(ptr);
	strupr(ptr);
	printf("\nUpper case: "); printfar(ptr);
	strlwr(ptr);
	printf("\nLower case: "); printfar(ptr);
#ifdef FILETEST
/* Test the conversion routine now */
/* Change this to something you've got! */
	strcpy(ptr,"a.uue");

	printf("Opening a file using a far filename spec\n");

	if ( (fp=fopen(ptr,"r")) != NULL ) {
		fgets(buffer,79,fp);
		fputs(buffer,stdout);
		fgets(buffer,79,fp);
		fputs(buffer,stdout);
		fclose(fp);
	} else {
		printf("Couldn't open file\n");
	}
#endif

	printf("Enough fun..now make something real!!!\n");
	printf("Press Any Key\n");

	free(ptr);
	getchar();
	sleep(2);
}

void printfar(far unsigned char *ptr)
{
	int i=0;

	while (*ptr) {
		putchar(*ptr++);
		i++;
		if (i==256) {
			printf("\n256chars...aborting"); 
			break;
		}
	}
	putchar('\n');
}


#include <dor.h>

#define HELP1	"A small demo application for testing the far malloc"
#define HELP2	"and string functions."
#define HELP3	""
#define	HELP4	"v0.02 djm/gwl 15/4/2000"
#define HELP5	""

#define APP_INFO "Made by z88dk"
#define APP_KEY  'F'
#define APP_NAME "Far demo"

#include <application.h>



