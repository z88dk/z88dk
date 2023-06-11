
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_saddr2py(void *saddr)
;
; Pixel y coordinate corresponding to screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC old_zx_saddr2py

old_zx_saddr2py:

   ; enter : hl = screen address
   ;
   ; exit  :  l = pixel y coordinate
   ;
   ; uses  : af, l
   
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

IF __SCCZ80
   ld h,0
ENDIF

   ret
