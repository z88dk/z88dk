/* 10/03/2006 00:22: fc: copy a planar block into the screen buffer at given position */

#include <drivers/lcd.h>
#include <drivers/lcdtarget.h>

extern unsigned char l_mask_array[];
extern unsigned char *Screen;
extern unsigned char Mod_Table[];
extern unsigned char Div_Table[];

void LCD_CopyPicture(unsigned char *Planar_Buffer, int X, int Y, int Width, int Height) {
	int i;
	int j;
	int k;
	int l;
	int Pos_X;
	int Pos_Y;

	if(X < X_BYTES && Y < Y_BYTES && Width > 0 && Height > 0 && Height <= Y_BYTES) {
		
		k = 0;
		for(i = X; i < Width + X; i++) {
			l = 0;
			for(j = Y; j < Height + Y; j++) {
				if(i >= 0 && j >= 0 && i < X_BYTES && j < Y_BYTES) {
				       	if(Planar_Buffer[(l / 8) + (k << 2)] & l_mask_array[(l % 8)]) {
			        		Screen[(j / 8) + (i << 2)] |= l_mask_array[(j % 8)];
					}
				}
				l++;
			}
			k++;
		}
	}
}
