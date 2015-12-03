
; ===============================================================
; Jun 2007
; ===============================================================
;
; void *zx_saddrcright(void *saddr)
;
; Modify screen address to move right one character (eight pixels)
; If at rightmost edge move to leftmost column on next pixel row.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddrcright

asm_zx_saddrcright:

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
   
   cp $58
   ccf
   ret
