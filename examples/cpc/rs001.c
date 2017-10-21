/*
	001 - 8x8 Chars & Small Scroll
	CPCRSLIB demo
	
	zcc +cpc -lndos -create-app -Cz--audio -lm rs001.c
 */

#include <cpc.h>	// CPC Library


void main (void) {
	unsigned char z;

	cpc_DisableFirmware();		//Now, I don't gonna use any firmware routine so I modify interrupts jump to nothing
	cpc_ClrScr();				//fills scr with ink 0
	cpc_SetMode(1);				//hardware call to set mode 1
	
	
	cpc_PrintGphStrStd(1,"THIS IS A SMALL DEMO",0xc050);	//parameters: pen, text, adress
	cpc_PrintGphStrStd(2,"OF MODE 1 TEXT WITH",0xc0a0);
	cpc_PrintGphStrStd(3,"8x8 CHARS WITHOUT FIRMWARE",0xc0f0);
	cpc_PrintGphStrStdXY(3,"AND A SMALL SOFT SCROLL DEMO",8,70);
	cpc_PrintGphStrStdXY(2,"CPCRSLIB FOR YOU!",19,80);
	cpc_PrintGphStrStdXY(1,"-- FONT BY ANJUEL  2009  --",2,160);
	cpc_PrintGphStrStdXY(1,"ABCDEFGHIJKLMNOPQRSTUVWXYZ",2,174);
	         
	while (!cpc_AnyKeyPressed()) {			//Small scrolling effect
	   z = !z;
	   if (z) {
	      cpc_RRI (0xe000, 40, 79);
	      cpc_RRI (0xe4b0, 32, 79);
	   }
	   cpc_RRI (0xe5f0, 12, 79);         
	   cpc_RLI (0xe5f0+0x50+0x50+79, 12, 79);  
	}
	   
	cpc_EnableFirmware();	//before exit, firmware jump is restored
}

