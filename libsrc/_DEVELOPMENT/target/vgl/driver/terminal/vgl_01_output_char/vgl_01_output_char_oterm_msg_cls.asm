
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_char_oterm_msg_cls

EXTERN vgl_01_output_char_refresh

vgl_01_output_char_oterm_msg_cls:
   ; clear the window
   ;
   ; can use : af, bc, de, hl
   
   ; Use call to LCD driver
   ld a, 1
   out (__VGL_DISPLAY_CONTROL_PORT), a	; Clear Display (also clear DDRAM content)
   ; Delay afterwards!
   
   ; Now fill the screen with spaces
   ; Use LDIR to fill it
   ;ld hl, VGL_VRAM_ADDRESS_START
   ;ld de, VGL_VRAM_ADDRESS_START + 1
   ;ld bc, 20*4 - 1
   ;ld (hl), 0x20	; Character to use
   ;ldir	; Copy BC bytes from (HL) to (DE)
   
   ; As seen in gl4000 @068e
   ld hl, __VGL_VRAM_ADDRESS_START
   ld a, 0x20
   vgl_01_output_char_oterm_msg_cls_loop:
   ld (hl), a
   inc hl
   djnz vgl_01_output_char_oterm_msg_cls_loop
   
   
   ; Set cursor
   ;xor a
   ;ld (__VGL_DISPLAY_CURSOR_X_ADDRESS), a
   ;ld (__VGL_DISPLAY_CURSOR_Y_ADDRESS), a
   ;ld (__VGL_DISPLAY_CURSOR_Y_ADDRESS), a
   ;ld a, 1
   ;ld (__VGL_DISPLAY_CURSOR_MODE_ADDRESS), a
   
   ; Not sure about this, but it can be seen in system4000
   xor a
   ld (__VGL_DISPLAY_CLEAR_ADDRESS), a
   
   jp vgl_01_output_char_refresh
   ;ret

