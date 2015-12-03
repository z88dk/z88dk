
; ===============================================================
; Aug 2003
; ===============================================================
; 
; void in_mouse_amx_setpos(uint16_t x, uint16_t y)
;
; Set the mouse coordinate.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_amx_setpos

EXTERN __input_amx_mouse_x, __input_amx_mouse_y

asm_in_mouse_amx_setpos:

   ; enter : de = x
   ;         bc = y
   ;
   ; uses  : af, bc, de

test_x:

   inc d
   dec d
   jr z, test_y

adjust_x:

   ld de,$ff00

test_y:

   inc b
   djnz adjust_y
   
   ld a,c
   cp 192
   jr c, set_xy
   
adjust_y:

   ld bc,191*256

set_xy:

   ld (__input_amx_mouse_x),de   ; atomic
   ld (__input_amx_mouse_y),bc   ; atomic

   ret
