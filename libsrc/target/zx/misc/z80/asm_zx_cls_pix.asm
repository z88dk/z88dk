
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls_pix(unsigned char pix)
;
; Clear screen pixels.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls_pix
PUBLIC asm0_zx_cls_pix

asm_zx_cls_pix:

   ; enter : l = screen byte
   ;
   ; uses  : af, bc, de, hl

   ld a,l

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld hl,$c000
   ld de,$c001
ELSE
   ld hl,$4000
   ld de,$4001
ENDIF

asm0_zx_cls_pix:

   ld (hl),a
   ld bc,6143

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi_loop
   jp     l_ldi_loop

ELSE

   ldir
   ret

ENDIF
