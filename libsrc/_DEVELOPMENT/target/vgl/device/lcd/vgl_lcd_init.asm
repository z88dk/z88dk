SECTION data_clib
;SECTION data_sound_bit

PUBLIC vgl_lcd_init


vgl_lcd_init:
   ; as found in ROM and on HD44780 data sheet:
   
   call delay_010f
   call delay_010f
   
   
   ld a, 0x38
   call out_0x0a
   ; delay 0x330 in total
   call delay_010f
   call delay_010f
   
   ld a, 0x38
   call out_0x0a
   ; delay 0x330 in total
   call delay_010f
   call delay_010f
   
   ld a, 0x38
   call out_0x0a
   ; delay 0x330 in total
   call delay_010f
   call delay_010f
   
   ld a, 0x38
   call out_0x0a
   ; delay 0x330 in total
   call delay_010f
   call delay_010f
   
   ld a, 0x0f
   call out_0x0a
   ld a, 0x0e
   call out_0x0a
   ld a, 0x0c
   call out_0x0a
   
   ld a, 0x01
   call out_0x0a
   
   ld a, 0x06
   call out_0x0a
   ld a, 0x04
   call out_0x0a
   ld a, 0x01
   call out_0x0a
   ; delay 0x330 in total
   call delay_010f
   call delay_010f
   
   ld a, 0x02
   call out_0x0a
   ; delay 0x330 in total
   call delay_010f
   call delay_010f
   
   ; First byte is missing if we do not delay enough
   call delay_010f
   
   ret

out_0x0a:
   out (0ah),a
   call delay_010f
   ret

delay_010f:
   ; Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
   push	hl
   ld	hl, 010fh
   
_delay_010f_loop:
   dec l
   jr	nz, _delay_010f_loop
   dec h
   jr	nz, _delay_010f_loop
   pop hl
   ret