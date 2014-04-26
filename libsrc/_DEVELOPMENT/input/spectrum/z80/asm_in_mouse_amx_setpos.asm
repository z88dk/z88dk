
; ===============================================================
; Aug 2003
; ===============================================================
; 
; void in_mouse_amx_setpos(uint16_t x, uint16_t y)
;
; Set the mouse coordinate.
;
; ===============================================================

INCLUDE "clib_target_cfg.asm"

XLIB asm_in_mouse_amx_setpos

asm_in_mouse_amx_setpos:

   ; enter : hl = x
   ;         de = y
   ;
   ; uses  : af, de, hl

test_x:

   inc h
   dec h
   jr z, test_y

adjust_x:

   ld hl,$00ff

test_y:

   inc d
   dec d
   jr nz, adjust_y
   
   ld a,e
   cp 192
   jr c, set_xy
   
adjust_y:

   ld de,191

set_xy:

   ld (__input_amx_mouse_x),hl   ; atomic
   ld (__input_amx_mouse_y),de   ; atomic

   ret
