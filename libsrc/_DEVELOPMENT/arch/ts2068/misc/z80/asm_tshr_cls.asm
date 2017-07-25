; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_cls(uchar ink)
;
; Clear screen using attribute.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_cls

EXTERN asm_tshr_color

asm_tshr_cls:

   ; enter : l = attr
   ;
   ; uses  : af, bc, de, hl

   ld a,l
   cp 8
   call c, asm_tshr_color

   ; dfile 1

   ld hl,$4000
   ld (hl),l
   
   ld de,$4001
   ld bc,6143

IF __CLIB_OPT_FASTCOPY & $20

   EXTERN l_fast_ldir_0
   call   l_fast_ldir_0 + 2

ELSE

   ldir

ENDIF

   ; dfile 2

   ld hl,$6000
   ld (hl),l
   
   ld de,$6001
   ld bc,6143

IF __CLIB_OPT_FASTCOPY & $20

   jp l_fast_ldir_0 + 2

ELSE

   ldir
   ret

ENDIF
