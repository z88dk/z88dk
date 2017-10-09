INCLUDE "config_private.inc"

;SECTION data_clib
;SECTION data_vgl_lcd
SECTION code_driver

PUBLIC vgl_lcd_init


PUBLIC __vgl_lcd_init
__vgl_lcd_init:
vgl_lcd_init:
   ; This performs the LCD initialization
   ; as seen in several ROMs and in the HD44780 data sheet itself:
   
   call delay_010f
   call delay_010f
   
   ; Enter 8 bit mode
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
   
   
   ; Cursor on?
   ld a, 0x0f
   call out_0x0a
   ld a, 0x0e
   call out_0x0a
   ld a, 0x0c
   call out_0x0a
   
   ; CLS?
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
   ; End of lcd_reset()
   
   ; First byte is missing if we do not delay enough
   call delay_010f
   
   
   
   ;	; Problem: The cursor is not showing up when not doing this:
   ;	; Fill screen manually (needed for the cursor to show up!)
   ;	push hl
   ;	push bc
   ;	ld hl, __VGL_DISPLAY_VRAM_START
   ;	ld bc, __VGL_DISPLAY_COLS*__VGL_DISPLAY_ROWS  ; Number of chars
   ;	ld a, 0x20     ; Which char to use: SPACE
   ;	_screen_clear_loop:
   ;	   ld (hl), a
   ;	   inc hl
   ;	djnz _screen_clear_loop
   ;	pop bc
   ;	pop hl
   ;	
   ;	call delay_010f
   
   ret

out_0x0a:
   out (0ah),a
   ;call delay_010f
   ;ret

delay_010f:
   ; Used for screen functions (after putting stuff to ports 0x0a or 0x0b)
   push hl
   ld hl, 010fh
   
_delay_010f_loop:
   dec l
   jr nz, _delay_010f_loop
   dec h
   jr nz, _delay_010f_loop
   pop hl
   ret
