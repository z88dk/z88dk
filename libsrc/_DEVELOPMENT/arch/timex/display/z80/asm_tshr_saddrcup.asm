; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrcup(void *saddr)
;
; Modify screen address to move up one character (eight pixels)
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrcup

asm_tshr_saddrcup:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address one character up
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   sub $20
   ld l,a
   ret nc
   
   ld a,h
   sub $08
   ld h,a
   
   and $18
   cp $18
   
   ccf
   ret
