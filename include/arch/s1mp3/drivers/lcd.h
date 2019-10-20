
#ifndef __LCD_H__
#define __LCD_H__

#include <sys/compiler.h>

/* LCD screen and bitmap image array constants */
#define ARRAY_OFFSET 2
#define X_BYTES	132
#define Y_BYTES	32
#define NBR_PAGES 4
#define SCRN_LEFT 0
#define SCRN_TOP 0
#define SCRN_RIGHT X_BYTES - 1
#define SCRN_BOTTOM Y_BYTES - 1

/* LCD function prototype list */
extern void __LIB__ LCD_Initialise(unsigned char Contrast);
extern void __LIB__ LCD_ClearScreen(void);
extern void __LIB__ LCD_WriteText(unsigned char left, unsigned char top, unsigned char font, unsigned char *str) __smallc;
extern void __LIB__ LCD_UpdateScreen(void);
extern void __LIB__ LCD_CopyPicture(unsigned char *Planar_Buffer, int X, int Y, int Width, int Height) __smallc;

#endif /* __LCD_H__ */

