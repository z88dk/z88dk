; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcright(void *aaddr)
;
; Modify attribute address to move right one character (eight pixels)
; If at rightmost edge move to leftmost column on next pixel row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcright

asm_tshc_aaddrcright:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address moved to right one character
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl

   inc l
   ret nz
   
   ld a,$08
   add a,h
   ld h,a
   
   cp $78
   ccf
   ret
