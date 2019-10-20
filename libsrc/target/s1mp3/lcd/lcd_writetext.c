
#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>
#include <fonts.h>

extern unsigned char l_mask_array[];
extern unsigned char *Screen;

extern struct FONT_DEF fonts[];

/*
**
** Writes a glyph to the display at location x,y
**
** Arguments are:
**    column     - x corrdinate of the left part of glyph
**    row        - y coordinate of the top part of glyph
**    width  	 - size in pixels of the width of the glyph
**    height 	 - size in pixels of the height of the glyph
**    glyph      - an unsigned char pointer to the glyph pixels
**                 to write assumed to be of length "width"
**
*/

static void LCD_WriteGlyph( unsigned char left, unsigned char top,
			         unsigned char width, unsigned char height,
			         unsigned char *glyph, unsigned char store_width)
{
	unsigned char bit_pos;
	unsigned int  array_offset;
	unsigned char byte_offset;
	unsigned char y_bits;
	unsigned char remaining_bits;
	unsigned char mask;
	unsigned char char_mask;
	unsigned char x;
	unsigned char *glyph_scan;
	unsigned char glyph_offset;

  	bit_pos = top & 0x07;		/* get the bit offset into a byte */

	glyph_offset = 0;			/* start at left side of the glyph rasters */
	char_mask = 0x80;			/* initial character glyph mask */

  	for (x = left; x < (left + width); x++)
  	{
    	byte_offset = top >> 3;        	/* get the byte offset into y direction */
		y_bits = height;				/* get length in y direction to write */
		remaining_bits = 8 - bit_pos;	/* number of bits left in byte */
		mask = l_mask_array[bit_pos];	/* get mask for this bit */
		glyph_scan = glyph + glyph_offset;	 /* point to base of the glyph */

    	/* boundary checking here to account for the possibility of  */
    	/* write past the bottom of the screen.                        */
    	while((y_bits) && (byte_offset < NBR_PAGES)) /* while there are bits still to write */
    	{
			/* check if the character pixel is set or not */
			array_offset = byte_offset + (x<<ARRAY_OFFSET);
			if(*glyph_scan & char_mask)
			{
		               	Screen[array_offset] |= mask;
			}
			else
			{
               			Screen[array_offset] &= ~mask;
			}

			if(l_mask_array[0] & 0x80)
			{
				mask >>= 1;
			}
			else
			{
				mask <<= 1;
			}
			
			y_bits--;
			remaining_bits--;
      		if(remaining_bits == 0)
      		{
				/* just crossed over a byte boundry, reset byte counts */
				remaining_bits = 8;
				byte_offset++;
				mask = l_mask_array[0];
      		}

			/* bump the glyph scan to next raster */
			glyph_scan += store_width;
		}

		/* shift over to next glyph bit */
		char_mask >>= 1;
		if(char_mask == 0)				/* reset for next byte in raster */
		{
			char_mask = 0x80;
			glyph_offset++;
	    }
	}
}

/*
**
**	Prints the given string at location x,y in the specified font.
**  Prints each character given via calls to lcd_glyph. The entry string
**  is null terminated and non 0x20->0x7e characters are ignored.
**
**  Arguments are:
**      left       coordinate of left start of string.
**      top        coordinate of top of string.
**      font       font number to use for display
**      str   	   text string to display
**
*/

void LCD_WriteText(unsigned char left, unsigned char top, unsigned char font, unsigned char *str)
{
  	unsigned char x = left;
  	unsigned char glyph;
  	unsigned char width;
	unsigned char height;
	unsigned char store_width;
	unsigned char *glyph_ptr;

  	while(*str != 0x00)
  	{
    	glyph = *str;

		/* check to make sure the symbol is a legal one */
		/* if not then just replace it with the default character */
		if((glyph < fonts[font].glyph_beg) || (glyph > fonts[font].glyph_end))
		{
			glyph = fonts[font].glyph_def;
		}

    	/* make zero based index into the font data arrays */
    	glyph -= fonts[font].glyph_beg;
    	width = fonts[font].fixed_width;	/* check if it is a fixed width */
		if(width == 0)
		{
			width=fonts[font].width_table[glyph];	/* get the variable width instead */
		}

		height = fonts[font].glyph_height;
		store_width = fonts[font].store_width;

		glyph_ptr = fonts[font].glyph_table + ((unsigned int)glyph * (unsigned int)store_width * (unsigned int)height);

		/* range check / limit things here */
		if(x > SCRN_RIGHT)
		{
			x = SCRN_RIGHT;
		}
		if((x + width) > SCRN_RIGHT+1)
		{
			width = SCRN_RIGHT - x + 1;
		}
		if(top > SCRN_BOTTOM)
		{
			top = SCRN_BOTTOM;
		}
		if((top + height) > SCRN_BOTTOM+1)
		{
			height = SCRN_BOTTOM - top + 1;
		}

		LCD_WriteGlyph( x, top, width, height, glyph_ptr, store_width );  /* plug symbol into buffer */

		x += width;							/* move right for next character */
		str++;								/* point to next character in string */
	}
}

