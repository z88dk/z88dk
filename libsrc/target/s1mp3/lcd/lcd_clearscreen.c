
#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>

extern unsigned char *Screen;

void LCD_ClearScreen( void ) {
#asm
	ld	hl, (_Screen)
	ld	de, (_Screen)
	inc	de
	ld	bc, X_BYTES * NBR_PAGES
	dec	bc
	ld	(hl), 0
	ldir
#endasm
}
