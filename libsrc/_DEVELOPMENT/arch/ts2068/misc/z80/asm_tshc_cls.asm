; ===============================================================
; 2017
; ===============================================================
; 
; void tshc_cls(uchar attr)
;
; Clear screen using attibute.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshc_cls

asm_tshc_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl
 
   ; attributes

   ld a,l
   
   ld hl,$6000
   ld (hl),a
   
   ld de,$6001
   ld bc,6143

IF __CLIB_OPT_FASTCOPY & $20

   EXTERN l_fast_ldir_0
   call   l_fast_ldir_0 + 2

ELSE

   ldir

ENDIF

   ; pixels

   ld hl,$4000
   ld (hl),l
   
   ld de,$4001
   ld bc,6143

IF __CLIB_OPT_FASTCOPY & $20

   jp l_fast_ldir_0 + 2

ELSE

   ldir
   ret

ENDIF
