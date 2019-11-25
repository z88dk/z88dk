#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>
#include <fonts.h>

/* pixel level bit masks for display */
/* this array is setup to map the order */
/* of bits in a byte to the vertical order */
/* of bits at the LCD controller */
const unsigned char l_mask_array[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };

/* the LCD display image memory */
/* buffer arranged so page memory is sequential in RAM */
unsigned char Display_Array[X_BYTES * NBR_PAGES];
unsigned char *Screen;

const unsigned char Mod_Table[] = {
		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,
		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,
		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,
		0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80
	};
const unsigned char Div_Table[] = {
		0 / 8, 1 / 8,
		2 / 8, 3 / 8,
		4 / 8, 5 / 8,
		6 / 8, 7 / 8,
		8 / 8, 9 / 8,
		10 / 8, 11 / 8,
		12 / 8, 13 / 8,
		14 / 8, 15 / 8,
		16 / 8, 17 / 8,
		18 / 8, 19 / 8,
		20 / 8, 21 / 8,
		22 / 8, 23 / 8,
		24 / 8, 25 / 8,
		26 / 8, 27 / 8,
		28 / 8, 29 / 8,
		30 / 8, 31 / 8
	};

void LCD_Initialise(unsigned char Contrast) {
	Screen = Display_Array;
	FONTS();
	LCDTARGET_Initialise(Contrast);
}
