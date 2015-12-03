
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_bitmask2px(uchar bitmask)
;
; Return x coordinate 0-7 corresponding to bitmask.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_bitmask2px

asm_zx_bitmask2px:

   ; enter :  l = 8-bit bitmask
   ;
   ; exit  : hl = x coordinate corresponding to leftmost set bit
   ;
   ; uses  : af, hl
   
   ld a,l
   ld hl,0
   
   or a
   ret z
   
   dec l
   
loop:

   inc l
   add a,a
   jp nc, loop
   
   ret
