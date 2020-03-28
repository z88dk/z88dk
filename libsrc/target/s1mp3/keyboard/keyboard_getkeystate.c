/* 03/03/2006 23:08: fc: first version */

#include <ATJ2085_Ports.h>
#include <drivers/keyboard.h>

/*
0xd8:
01111111 0x7f Nothing
10000000 0x80 Rec
1xxxxxxx 0xxx Prev (isn't stable on my player)

0xf2:
11011111 0xdf Nothing
11011110 0xde Mode
11011010 0xda Vol up
11011011 0xdb Vol down
11011100 0xdc Next
11011101 0xdd Play 

0xff:
00000001 0x01 Nothing
00000000 0x01 Hold
*/

unsigned char KEYBOARD_GetKeyState( void ) {
#asm
	ld	l, 0

	in      a, (LRADC_DATA_REG)
	bit	7, a
	jr	z, No_Rec_Key
	bit	4, a
	jr	nz, No_Rec_Key
	ld	l, KEY_REC
No_Rec_Key:

	in      a, (LRADC_DATA_REG)
	cp	0x7f
	jr	z, No_Prev_Key
	cp	0x80
	jr	z, No_Prev_Key
	ld	l, KEY_PREV
No_Prev_Key:

	in      a, (GPIOB_DATA_REG)
	bit	2, a
	jr	nz, No_Vol_Key_Up
	bit	0, a
	jr	nz, No_Vol_Key_Up
	ld	l, KEY_VOL_UP
No_Vol_Key_Up:

	in      a, (GPIOB_DATA_REG)
	bit	2, a
	jr	nz, No_Vol_Key_Down
	bit	0, a
	jr	z, No_Vol_Key_Down
	ld	l, KEY_VOL_DOWN
No_Vol_Key_Down:

	in      a, (GPIOB_DATA_REG)
	bit	1, a
	jr	nz, No_Next_Key
	bit	0, a
	jr	nz, No_Next_Key
	ld	l, KEY_NEXT
No_Next_Key:

	in      a, (GPIOB_DATA_REG)
	bit	1, a
	jr	nz, No_Play_Key
	bit	0, a
	jr	z, No_Play_Key
	ld	l, KEY_PLAY
No_Play_Key:

	in      a, (GPIOB_DATA_REG)
	bit	2, a
	jr	z, No_Mode_Key
	bit	1, a
	jr	z, No_Mode_Key
	bit	0, a
	jr	nz, No_Mode_Key
	ld	l, KEY_MODE
No_Mode_Key:

	in      a, (GPIOG_DATA_REG)
	bit	0, a
	jr	nz, No_Hold_Key
	ld	l, KEY_HOLD
No_Hold_Key:

#endasm
}
