/*      Hey, it's that infamous program again!
 *      Yup, Hello World strikes back in it's 
 *      newest form!
 */

#define ANSI_STDIO

#include <stdio.h>


main()
{
	char buffer[80];
	fputc_cons('g');
	fputs("Using fputs\n",stdout);
	putchar(':');
	printn(100,10,stdout);
        printf("Hello World %d\n",1);
	sprintf(buffer,"Testing sprintf %d",1);
	printf(buffer);
	printf("%08u",32768);
}
