/* Smiley Smiley
 * By Henk Poley
 *
 * Displays lots of Smileys in a ( = the same) smiley pattern.
 *
 * Idea taken from "SmallC4.1 for UsGard"-compiler.
 *
 * First ported to Ti8xcc.
 * Later on ported to the Z88DK.
 *
 *  Lo-rez version, for Galaksija & co. by Stefano Bodrato
 */

#include <graphics.h>
#include <games.h>

char smile[] =
{
	7,7,
	56, /*  ooo   */
	68, /* o   o  */
	170,/*o o o o */
	130,/*o     o */
	186,/*o ooo o */
	68, /* o   o  */
	56  /*  ooo   */
};

main()
{
	char x, y, temp;

	clg();

	for(y=0 ; y<7 ; y++)
	{
		temp = smile[y+2];
		for(x=0 ; x<8 ; x++)
		{
			if(temp & 1)
			{
				putsprite(spr_or, 7 * x, 7 * y, smile);
			}
			temp >>= 1;
		}
	}
}






