
; ===============================================================
; Jun 2007
; ===============================================================
;
; uint zx_saddr2py(void *saddr)
;
; Pixel y coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2py

asm_zx_saddr2py:

   ; enter : hl = screen address
   ;
   ; exit  : hl = pixel y coordinate
   ;
   ; uses  : af, hl
   
   ld a,l
   rra
   rra
   and $38
   ld l,a
   
   ld a,h
   add a,a
   add a,a
   add a,a
   and $c0
   or l
   ld l,a
   
   ld a,h
   and $07
   or l
   ld l,a
   
   ld h,0
   ret
