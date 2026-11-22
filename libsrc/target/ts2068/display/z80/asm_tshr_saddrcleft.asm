; ===============================================================
; May 2017
; ===============================================================
;
; void *tshr_saddrcleft(void *saddr)
;
; Modify screen address to move left one character (eight pixels)
; If at the leftmost edge, move to rightmost column on prev row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_saddrcleft

asm_tshr_saddrcleft:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address moved left one character
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl

   bit 5,h
   res 5,h
   ret nz
   set 5,h

   ld a,l
   dec l
   or a
   ret nz
   
   ld a,h
   sub $08
   ld h,a
   
   and $18
   cp $18
   
   ccf
   ret
