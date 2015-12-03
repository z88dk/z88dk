
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrcleft(void *saddr)
;
; Modify screen address to move left one character (eight pixels)
; If at the leftmost edge, move to rightmost column on prev row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrcleft

asm_zx_saddrcleft:

   ; enter : hl = screen address
   ;
   ; exit  : hl = screen address moved left one character
   ;         carry set if new screen address is off screen
   ;
   ; uses  : af, hl

   ld a,l
   dec l
   or a
   ret nz
   
   ld a,h
   sub $08
   ld h,a
   
   cp $40
   ret
