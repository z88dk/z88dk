
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls_attr(uchar attr)
;
; Clear screen attributes.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls_attr

asm_zx_cls_attr:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

   ld a,l

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld hl,$d800
   ld de,$d801
ELSE
   ld hl,$5800
   ld de,$5801
ENDIF

   ld (hl),a
   ld bc,767

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi_loop
   jp     l_ldi_loop

ELSE

   ldir
   ret

ENDIF
