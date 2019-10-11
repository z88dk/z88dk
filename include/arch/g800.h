#ifndef __G800_H__
#define __G800_H__


// invlcd(1) -> invert LCD display
// invlcd(0) -> undo inversion
extern void __LIB__  invlcd() __z88dk_fastcall;

// lcd_contrast(x) - set LCD contrast (0..17)
extern void __LIB__  lcd_contrast() __z88dk_fastcall;

// Turn on/off the LCD display
extern void __LIB__  lcd_on();
extern void __LIB__  lcd_off();


#endif
