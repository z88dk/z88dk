
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_char_oterm_msg_printc

EXTERN vgl_01_output_char_refresh


vgl_01_output_char_oterm_msg_printc:
   ;   enter  :  c = ascii code
   ;             b = parameter (foreground colour, 255 if none specified)
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl
   
   
   ; Update cursor manually?
   ld a, l
   ld (__VGL_DISPLAY_CURSOR_X_ADDRESS), a
   ld a, h
   ld (__VGL_DISPLAY_CURSOR_Y_ADDRESS), a
   ;ld a, 2
   ;ld (__VGL_DISPLAY_CURSOR_MODE_ADDRESS), a
   
   
   ; Put character to VRAM at 0xdca0 + (Y*COLS) + X
   ; a = Y*20
   ld a, h
   add a	; *2
   add a	; *4
   add a	; *8
   add a	; *16
   ;ld b, 4
   ;sla b   ; *16 (shl 4)
   add h	; *17
   add h	; *18
   add h	; *19
   add h	; *20
   ; Convert to VGL_VRAM_ADDRESS offset 0xdca0 + A + X
   add l	; Add X coordinate to A
   add __VGL_VRAM_ADDRESS_START & 0x00ff ;0xa0
   ld h, __VGL_VRAM_ADDRESS_START >> 8   ;0xdc
   ld l, a
   
   ld (hl), c	; Put character to calculated VRAM offset
   
   
   jp vgl_01_output_char_refresh
