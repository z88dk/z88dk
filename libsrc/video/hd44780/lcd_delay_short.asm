

SECTION code_driver
PUBLIC lcd_delay_short
PUBLIC asm_lcd_delay_short

lcd_delay_short:
asm_lcd_delay_short:
        push    hl
        ld      hl, $010f
_delay_010f_loop:
        dec     l
        jr      nz, _delay_010f_loop
        dec     h
        jr      nz, _delay_010f_loop
        pop     hl
        ret
