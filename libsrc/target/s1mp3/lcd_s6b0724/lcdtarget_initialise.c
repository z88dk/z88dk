
#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>
#include <drivers/ioport.h>
#include <ATJ2085_Ports.h>

static unsigned char lcdtarget_srampagereg;
static unsigned char lcdtarget_memmapreg;
static unsigned char lcdtarget_empagehireg;

void LCDTARGET_EnableLCDWrite( void ) {
#asm
	in	a, (INTERNAL_MROM_SRAM_PAGE_REG)
	ld	(_lcdtarget_srampagereg), a
	or	INT_MROM_SRAM_ZRAM2
	out	(INTERNAL_MROM_SRAM_PAGE_REG), a
	
	in	a, (B1_2_MEMMAP_REG)
	ld	(_lcdtarget_memmapreg), a
	set	5, a
	set	4, a
	out	(B1_2_MEMMAP_REG), a
	
	in	a, (MFP_GPOA_SELECT_REG)
	and	1Fh
	out	(MFP_GPOA_SELECT_REG),	a
	
	in	a, (EM_PAGE_HI_REG)
	ld	(_lcdtarget_empagehireg), a
	ld	a, EM_PAGE_HI_CE3_INV		
	out	(EM_PAGE_HI_REG), a
#endasm		
}


void LCDTARGET_DisableLCDWrite( void )
{
#asm
	ld	a, (_lcdtarget_empagehireg)
	out	(EM_PAGE_HI_REG), a

	ld	a, (_lcdtarget_memmapreg)
	out	(B1_2_MEMMAP_REG), a

	ld	a, (_lcdtarget_srampagereg)
	out	(INTERNAL_MROM_SRAM_PAGE_REG), a
#endasm
}


/*
**
** low level routine to send a byte value out the serial bus
** to the LCD controller control register. entry argument is
** the data to output.
**
*/
void __FASTCALL__ LCDTARGET_PutControlByte( unsigned int byte ) __naked
{
#asm
	in	a, (MFP_GPOA_SELECT_REG)
	and	0FEh				;(~LCDTARGET_A0)	11111110
	out	(MFP_GPOA_SELECT_REG),	a

	ld	a, l
	ld	(0x8000), a
    ret
#endasm
}


/*
**
** low level routine to send a byte value out the serial bus
** to the LCD controller data register. entry argument
** is the data to output.
**
*/
/*
void __FASTCALL__ LCDTARGET_PutDataByte( unsigned int byte )
{
#asm
	in	a, (MFP_GPOA_SELECT_REG)
	or	LCDTARGET_A0					; Enable Data write
	out	(MFP_GPOA_SELECT_REG),	a		

    	ld	a, l
	ld	(0x8001), a
#endasm
}
*/
/*
**
** low level routine to send a byte value out the serial bus
** to the LCD controller data register. entry argument
** is the data to output.
**
*/

//void LCDTARGET_PutDataBytes( unsigned int numbytes, unsigned char *location )
//{
/* TBD sort the variables coming in correctly */
/*#asm
; Write data starting at hl for b bytes
	
	in	a, (MFP_GPOA_SELECT_REG)
	or	LCDTARGET_A0					; Enable Data write
	out	(MFP_GPOA_SELECT_REG),	a

LCDTARGET_PutDataBytes_Loop:				
	ld	a, (hl)
	ld	(0x8001), a
	inc	hl
	djnz	LCDTARGET_PutDataBytes_Loop
#endasm	
}
*/
void LCDTARGET_Delay( void )
{
    unsigned int i;

	for(i=0; i<1000; i++)
	{
	}
}


/*
**
**
**
**
**
*/

void LCDTARGET_Initialise( unsigned char Contrast )
{

	LCDTARGET_EnableLCDWrite();

	LCDTARGET_PutControlByte(LCD_RESET);

#asm
	; LCD reset
	ld	c, 2
	ld	d, 0FDh	
	in	a, (MFP_GPOA_SELECT_REG)
	or	c
   	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	and	d
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	or	c
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
	out	(MFP_GPOA_SELECT_REG), a
#endasm

	LCDTARGET_PutControlByte(LCD_SET_ADC_REV);		// set ADC reverse
	LCDTARGET_PutControlByte(LCD_SET_SHL_REV);		// set SHL normal
	LCDTARGET_PutControlByte(LCD_PWR_CTL | 7);		// now turn on the VC+VR+VF
	LCDTARGET_PutControlByte(LCD_REG_RESISTOR | 7);		// set default resistor ratio
	//LCDTARGET_PutControlByte(LCD_REG_RESISTOR | 7);		// set default resistor ratio
	LCDTARGET_PutControlByte(LCD_SET_BIAS_0);		// set for the low bias mode
	LCDTARGET_PutControlByte(LCD_SET_MODIFY);

	//LCDTARGET_PutControlByte(LCD_ST_IND_MODE_1);
	//LCDTARGET_PutControlByte(LCD_ST_IND_REG | 3);
	LCDTARGET_PutControlByte(LCD_EON_OFF);

	LCDTARGET_PutControlByte(LCD_REF_VOLT_MODE);
	LCDTARGET_PutControlByte(LCD_REF_VOLT_REG | Contrast);

	/*LCDTARGET_PutControlByte(LCD_BOOSTER_SET);
	LCDTARGET_PutControlByte(LCD_BOOSTER_RATE_4X);*/

	LCDTARGET_PutControlByte(LCD_DISP_ON);

	LCDTARGET_PutControlByte(LCD_SET_LINE);
	LCDTARGET_PutControlByte(LCD_SET_PAGE);
	LCDTARGET_PutControlByte(LCD_SET_COL_HI);
	LCDTARGET_PutControlByte(LCD_SET_COL_LO);

	LCDTARGET_DisableLCDWrite();

}
