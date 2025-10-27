
; ===============================================================
; Sep 2005, Apr 2014
; ===============================================================
; 
; void in_mouse_kempston_setpos(uint16_t x, uint16_t y)
;
; Set the mouse coordinate.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_mouse_kempston_setpos

EXTERN __input_kempston_mouse_x, __input_kempston_mouse_y
EXTERN __input_kempston_mouse_rawx, __input_kempston_mouse_rawy

asm_in_mouse_kempston_setpos:

   ; enter : de = x
   ;         bc = y
   ;
   ; uses  : af, bc, de

   ; zero out any existing deltas
   
   ld a,$fb
   in a,($df)
   ld (__input_kempston_mouse_rawx),a

   ld a,$ff
   in a,($df)
   ld (__input_kempston_mouse_rawy),a

   ; boundary check
   
test_x:

   inc d
   dec d
   jr z, test_y

adjust_x:

   ld de,$00ff

test_y:

   inc b
   djnz adjust_y
   
   ld a,c
   cp 192
   jr c, set_xy
   
adjust_y:

   ld bc,191

set_xy:

   ld (__input_kempston_mouse_x),de
   ld (__input_kempston_mouse_y),bc

   ret
