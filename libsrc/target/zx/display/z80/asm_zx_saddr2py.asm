
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

PUBLIC asm_zx_saddr2py

asm_zx_saddr2py:

   ; enter : hl = screen address
   ;
   ; exit  :  l = pixel y coordinate
   ;
   ; uses  : af, l

   rr l
   rr l ; L = XX'rrr'XXX (char *R*ow)

   ld a,h
   add a,a
   add a,a
   add a,a
   xor h
   and $c0
   xor h ; A = tt'XXX'lll (*T*hird, *L*ine)

   xor l
   and $c7
   xor l ; A = tt'rrr'lll
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
