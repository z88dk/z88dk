#include <arch/sms/SMSlib.h>
#include <string.h>
#include "rastercolor.h"

/****
 * 
 * This works thanks to the help of sverx and psidum
 * 
 ****/
#ifdef TARGET_GG
static u8 colorsL[24]; 
static u8 colorLSB;
#endif

static u8 colorsM[24]; 
static u8 colorMSB;


static volatile u8 currentRow;

void rastercolor_init( )
{
	//rastercolor_fill(0);
	rastercolor_vint();
	
	
	SMS_setLineCounter(8-1); //according SMS doc, line counter should be set to (number of lines wanted -1)
								//but int occurs at 1, 9, 17
								//not 0, 8, 16 
								//so
	SMS_setBGScrollY(223);
}

#ifdef TARGET_GG
void rastercolor_fill(u16 *pal, u8 idx) // __z88dk_fastcall
{
	u16 color = pal[idx];
	colorMSB = color >>8;
	colorLSB = color & 0xFF;
	memset(colorsL, colorLSB, 24);
#else
void rastercolor_fill(u8* pal, u8 idx) // color) __z88dk_fastcall
{
	colorMSB = pal[idx];
#endif
	memset(colorsM, colorMSB, 24);
}

// lineInterrupt occurs at the END of line
// so if you want to set color ON this line,
// you have to set it on previous lineInterrupt, hence...
#ifdef TARGET_GG
void rastercolor_setRowColor(u8 row, u16* pal, u8 idx)
{
	u16 color = pal[idx];
	if (row == 0)	row = 24;

	colorMSB = color >>8;
	colorLSB = color & 0xFF;
	colorsL[row-1] = colorLSB;
#else
void rastercolor_setRowColor(u8 row, u8* pal, u8 idx)
{
	if (row == 0)	row = 24;

	colorMSB = pal[idx];
#endif
	colorsM[row-1] = colorMSB;
}

void inline rastercolor_start( )
{
	SMS_enableLineInterrupt();
}


void rastercolor_hint( )
{

#ifdef TARGET_GG
	colorLSB = colorsL[currentRow];
#endif	
	//using a ref table, avoid complex opcodes (memory vs speed)
	colorMSB = colorsM[currentRow];
	
	//TODO win some clock writing the full method using asm (based on generated asm)
	
	__asm

#ifdef TARGET_GG
		ld a, 2
#else
		ld a, 1
#endif
		out (0xbf), a
		ld a, 0xc0
		out (0xbf), a

#ifdef TARGET_GG
		ld a, (_colorLSB)
		out (0xbe), a
		sub 0
		nop
#endif

		ld a, (_colorMSB)
		out (0xbe), a
	__endasm;
		
	currentRow++;
}

void rastercolor_vint( )
{
	currentRow = 0;
}