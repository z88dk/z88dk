
SECTION code_driver

PUBLIC generic_console_cls
PUBLIC generic_console_vpeek
PUBLIC generic_console_scrollup
PUBLIC generic_console_printc
PUBLIC generic_console_ioctl
PUBLIC generic_console_set_ink
PUBLIC generic_console_set_paper
PUBLIC generic_console_set_attribute

INCLUDE "ioctl.def"
PUBLIC  CLIB_GENCON_CAPS
defc       CLIB_GENCON_CAPS = 0


EXTERN asm_lcd_clear
EXTERN asm_lcd_putchar
EXTERN asm_lcd_vpeek
EXTERN asm_lcd_scrollup

defc generic_console_cls = asm_lcd_clear
defc generic_console_printc = asm_lcd_putchar
defc generic_console_scrollup = asm_lcd_scrollup
defc generic_console_vpeek = asm_lcd_vpeek

generic_console_ioctl:
       scf
generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
       ret
