/* Smiley Smiley
 * By Henk Poley
 *
 * Displays lots of Smileys in a ( = the same) smiley pattern.
 *
 * Idea taken from "SmallC4.1 for UsGard"-compiler.
 *
 * First ported to Ti8xcc.
 * Later on ported to the Z88DK.
 */

#pragma string name Smiley Smiley (picture)
#pragma output nostreams
#pragma data icon 0x3C,0x42,0xA5,0xA5,0x81,0xA5,0x5A,0x3C;

#include <stdio.h>
#include <games.h>

char smile[] =
{
	8,8,
	0x3C, /* defb @00111100 ;  oooo   */
	0x42, /* defb @01000010 ; o    o  */
	0xA5, /* defb @10100101 ;o o  o o */
	0xA5, /* defb @10100101 ;o o  o o */
	0x81, /* defb @10000001 ;o      o	*/
	0xA5, /* defb @10100101 ;o o  o o */
	0x5A, /* defb @01011010 ; o oo o  */
	0x3C  /* defb @00111100 ;  oooo   */
};

main()
{
	char x, y, temp;

	for(y=0 ; y<8 ; y++)
	{
		temp = smile[y+2];
		for(x=0 ; x<8 ; x++)
		{
			if(temp & 1)
			{
				putsprite(spr_or, 8 * x, 8 * y, smile);
			}
			temp >>= 1;
		}
	}
	getk(); /*pause*/
}






