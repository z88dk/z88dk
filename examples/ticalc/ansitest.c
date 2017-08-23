/*
 *	Test the ANSI terminal
 *
 *	15/4/2000 Stefano Bodrato
 *	21/11/2002 Stefano Bodrato - release for small displays test
 *
 *	Compile with zcc +ti83ansi (or similar) ansitest.c
 */


#include "stdio.h"

main()
{
int x;

/*
        A stupid CSI escape code test
        (normally no use uses CSI)
*/
  printf ("If you can read this, CSI is not working.\n");
  printf ("%c2J",155);
  printf ("If this is the first thing you can read, CSI is OK.\n");


/*
        Cursor Position test
        "Draw" an X
*/

  for (x=0; x<5; x++)
  {
    printf ("%c[%u;%uH*\n",27,1+x,21+x);
    printf ("%c[%u;%uH*\n",27,5-x,21+x);
  }


/*
        Set Graphic Rendition test
*/
  printf ("%c[1mBold Text\n",27);
  printf ("%c[2mDim text\n",27);
  printf ("%c[4mUnderlined Text\n",27);
  printf ("%c[24mUn-underlined text\n",27);
  printf ("%c[7mReverse Text\n",27);
  printf ("%c[27mUn-reverse text\n",27);

/*
        Restore default text attributes
*/
    printf ("%c[m",27);

}
