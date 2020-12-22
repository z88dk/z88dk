

SECTION code_driver
PUBLIC lcd_delay_long
PUBLIC asm_lcd_delay_long

lcd_delay_long:
asm_lcd_delay_long:
        push    hl
        ld      hl, $1fff
_delay_1fff_loop:
        dec     l
        jr      nz, _delay_1fff_loop
        dec     h
        jr      nz, _delay_1fff_loop
        pop     hl
        ret
