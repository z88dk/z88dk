; ===============================================================
; May 2017
; ===============================================================
;
; void *tshc_aaddrcleft(void *aaddr)
;
; Modify attribute address to move left one character (eight pixels)
; If at the leftmost edge, move to rightmost column on prev row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_aaddrcleft

asm_tshc_aaddrcleft:

   ; enter : hl = attribute address
   ;
   ; exit  : hl = attribute address moved left one character
   ;         carry set if new attribute address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   dec l
   or a
   ret nz
   
   ld a,h
   sub $08
   ld h,a
   
   cp $60
   ret
