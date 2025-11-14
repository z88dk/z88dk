; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrcright(void *saddr)
;
; Modify screen address to move right one character (eight pixels)
; If at rightmost edge move to leftmost column on next pixel row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrcright

asm_tshr_saddrcright:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address moved to right one character
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl
   
   bit 5,h
   set 5,h
   ret z
   res 5,h

   inc l
   ret nz
   
   ld a,$08
   add a,h
   ld h,a
   
   and $18
   cp $18
   
   ccf
   ret
   