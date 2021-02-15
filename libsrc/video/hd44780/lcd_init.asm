
SECTION code_driver

PUBLIC lcd_init
PUBLIC _lcd_init
PUBLIC asm_lcd_init

EXTERN asm_lcd_write_control
EXTERN asm_lcd_write_data

INCLUDE "hd44780.def"

lcd_init:
_lcd_init:
asm_lcd_init:
        ld      a,0x38        ; 2 Line, 8-bit, 5x7 dots
        call    asm_lcd_write_control
        ld      a,0x38        ; 2 Line, 8-bit, 5x7 dots
        call    asm_lcd_write_control
        ld      a,0x38        ; 2 Line, 8-bit, 5x7 dots
        call    asm_lcd_write_control
        ld      a,0x38        ; 2 Line, 8-bit, 5x7 dots
        call    asm_lcd_write_control
        
        ld      a,LCD_CLEARDISPLAY
        call    asm_lcd_write_control

        ld      a,LCD_DISPLAYCONTROL | LCD_DISPLAYON 
        call    asm_lcd_write_control
        ld      a,LCD_ENTRYMODESET | LCD_ENTRYLEFT | LCD_ENTRYSHIFTDECREMENT
        call    asm_lcd_write_control        
        ret


