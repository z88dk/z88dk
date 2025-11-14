
; ===============================================================
; Jun 2007
; ===============================================================
;
; uchar zx_saddr2px(void *saddr)
;
; Pixel x coordinate corresponding to the leftmost pixel at
; of the screen address.
;
; ===============================================================

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_saddr2px

asm_zx_saddr2px:

   ; enter : hl = screen address
   ;
   ; exit  :  l = pixel x coordinate of leftmost pixel in byte
   ;              at screen address
   ;
   ; uses  : af, l

   ld a,l
   add a,a
   add a,a
   add a,a
   
   ld l,a

IF __SCCZ80
   ld h,0
ENDIF

   ret
