/*
  Display a message
  FC
*/

#include <s1sdk.h>

int main() {    	
	MCU_Initialise(MCU_CLK_DIV_NONE);
	WATCHDOG_Enable(WD_5_6s);

	LCD_Initialise(16);

	LCD_ClearScreen();
	LCD_WriteText(0, 0, FONT_SIX_DOT, "Hello brave new world");
	LCD_UpdateScreen();
	
	while(1) {
		WATCHDOG_Reset();
	}
	return(0);
}
