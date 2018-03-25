
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_4000_oterm_msg_printc
PUBLIC vgl_01_output_4000_oterm_msg_printc_raw
;PUBLIC vgl_01_output_4000_oterm_msg_printc_cursor

EXTERN vgl_01_output_4000_refresh


vgl_01_output_4000_oterm_msg_printc:
   ;   enter  :  c = ascii code
   ;             b = parameter (foreground colour, 255 if none specified)
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl
   
   
   ; call vgl_01_output_4000_set_cursor_coord
   
   ; Show cursor on screen
   ld a, l
   inc a    ;Show NEXT pos
   ld (__VGL_4000_DISPLAY_CURSOR_X_ADDRESS), a
   ld a, h
   ld (__VGL_4000_DISPLAY_CURSOR_Y_ADDRESS), a
   ld a, 1  ;0=off, 1=block 2=line
   ld (__VGL_4000_DISPLAY_CURSOR_MODE_ADDRESS), a
   
   ; Put character to VRAM at 0xdca0 + (Y*COLS) + X
   ; a := Y*20
   ld a, h
   add a   ; *2
   add a   ; *4
   add a   ; *8
   add a   ; *16
   ;ld b, 4
   ;sla b   ; *16 (shl 4)
   add h   ; *17
   add h   ; *18
   add h   ; *19
   add h   ; *20
   ; Convert to VGL_VRAM_ADDRESS offset 0xdca0 + A + X
   add l   ; Add X coordinate to A
   add __VGL_4000_DISPLAY_VRAM_START & 0x00ff ;0xa0
   ld h, __VGL_4000_DISPLAY_VRAM_START >> 8   ;0xdc
   ld l, a
   
   ld (hl), c   ; Put character to calculated VRAM offset
   
   jp vgl_01_output_4000_refresh


; Version without refresh
vgl_01_output_4000_oterm_msg_printc_raw:
   ;   enter  :  c = ascii code
   ;             b = parameter (foreground colour, 255 if none specified)
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl
   
   push hl
   
   ; Put character to VRAM at 0xdca0 + (Y*COLS) + X
   ; a := Y*20
   ld a, h
   add a   ; *2
   add a   ; *4
   add a   ; *8
   add a   ; *16
   ;ld b, 4
   ;sla b   ; *16 (shl 4)
   add h   ; *17
   add h   ; *18
   add h   ; *19
   add h   ; *20
   ; Convert to VGL_VRAM_ADDRESS offset 0xdca0 + A + X
   add l   ; Add X coordinate to A
   add __VGL_4000_DISPLAY_VRAM_START & 0x00ff ;0xa0
   ld h, __VGL_4000_DISPLAY_VRAM_START >> 8   ;0xdc
   ld l, a
   
   ld (hl), c   ; Put character to calculated VRAM offset
   
   pop hl
   
   ret

