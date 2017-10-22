
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_4000_oterm_msg_cls

EXTERN vgl_01_output_4000_refresh

vgl_01_output_4000_oterm_msg_cls:
   ; clear the window
   ;
   ; can use : af, bc, de, hl
   
   ; Problem: The cursor is not showing up when not doing this:
   ; Fill screen manually (needed for the cursor to show up!)
   ld hl, __VGL_4000_DISPLAY_VRAM_START
   ld bc, __VGL_4000_DISPLAY_COLS*__VGL_4000_DISPLAY_ROWS  ; Number of chars
   ld a, 0x20     ; Which char to use: SPACE
   _screen_clear_loop:
      ld (hl), a
      inc hl
   djnz _screen_clear_loop
   ;call delay_010f
   
   ; Use call to LCD driver
   ld a, 1
   out (__VGL_4000_DISPLAY_CONTROL_PORT), a	; Clear Display (also clear DDRAM content)
   ; Delay afterwards!
   
   ; Now fill the screen with spaces
   ; Use LDIR to fill it
   ld hl, __VGL_4000_DISPLAY_VRAM_START
   ld de, __VGL_4000_DISPLAY_VRAM_START + 1
   ld bc, __VGL_4000_DISPLAY_COLS*__VGL_4000_DISPLAY_ROWS - 1
   ld (hl), 0x20	; Character to use
   ldir	; Copy BC bytes from (HL) to (DE)
   
   ;  ; As seen in gl4000 @068e
   ;  ld b, __VGL_4000_DISPLAY_COLS*__VGL_4000_DISPLAY_ROWS
   ;  ld hl, __VGL_DISPLAY_VRAM_START
   ;  ld a, 0x20
   ;  vgl_01_output_4000_oterm_msg_cls_loop:
   ;  ld (hl), a
   ;  inc hl
   ;  djnz vgl_01_output_4000_oterm_msg_cls_loop
   
   
   ; Set cursor ?
   
   ; Not sure about this, but it can be seen in system4000
   ;xor a
   ;ld (__VGL_4000_DISPLAY_CLEAR_ADDRESS), a
   
   jp vgl_01_output_4000_refresh
   ;ret

