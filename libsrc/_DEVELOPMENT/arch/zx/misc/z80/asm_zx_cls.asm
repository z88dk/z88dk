
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_cls(uchar attr)
;
; Clear screen using attibute.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_cls

asm_zx_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl
 
   ; attributes

IF __CLIB_OPT_FASTCOPY & $20

   EXTERN l_fast_ldir_0

   ld a,l
   
   ld hl,$5800
   ld (hl),a
   
   ld de,$5801
   ld bc,767
   
   call l_fast_ldir_0 + 2

ELSE

   EXTERN asm_memset
   
   ld e,l
   
   ld hl,$5800
   ld bc,768
   
   call asm_memset

ENDIF

   ; pixels

IF __CLIB_OPT_FASTCOPY & $20

   ld hl,$4000
   ld (hl),l
   
   ld de,$4001
   ld bc,6143
   
   jp l_fast_ldir_0 + 2

ELSE

   ld hl,$4000
   ld e,l
   ld bc,6144
   
   jp asm_memset

ENDIF
