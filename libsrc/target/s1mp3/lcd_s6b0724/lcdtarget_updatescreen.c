#include <drivers/lcdtarget.h>
#include <drivers/lcd.h>
#include "lcdtarget_local.h"

unsigned char *colptr;
extern unsigned char *Screen;

void LCDTARGET_UpdateScreen(void) {
	unsigned char x;
	unsigned char y;

	LCDTARGET_EnableLCDWrite();
	
	for (y = 0; y < NBR_PAGES; y++) {
		/* setup the page number for the y direction */
		LCDTARGET_PutControlByte(LCD_SET_PAGE + y);
		LCDTARGET_PutControlByte(LCD_SET_COL_HI);
		LCDTARGET_PutControlByte(LCD_SET_COL_LO);
#asm
		in	a, (MFP_GPOA_SELECT_REG)
		or	LCDTARGET_A0					; Enable Data write
		out	(MFP_GPOA_SELECT_REG), a
#endasm
		colptr = Screen + y;
#asm
		ld	hl, (_colptr)
		ld	b, X_BYTES
		ld	de, 4
Copy_Pixels:	ld	a, (hl)
		ld	(0x8001), a
		add	hl, de
		djnz	Copy_Pixels
#endasm
	}
	LCDTARGET_DisableLCDWrite();
}
