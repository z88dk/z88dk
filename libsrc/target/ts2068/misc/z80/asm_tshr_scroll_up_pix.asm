; ===============================================================
; 2017
; ===============================================================
; 
; void tshr_scroll_up_pix(uchar prows, uchar pix)
;
; Scroll screen upward by rows pixels and clear vacated area.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_tshr_scroll_up_pix
PUBLIC asm0_tshr_scroll_up_pix

EXTERN asm_tshr_cls_pix, asm_tshr_py2saddr
EXTERN asm_tshr_saddrpdown

asm_tshr_scroll_up_pix:

   ; enter : de = number of pixel rows to scroll upward by
   ;          l = pix
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jp nz, asm_tshr_cls_pix

asm0_tshr_scroll_up_pix:

   inc e
   dec e
   ret z
   
   ld a,191
   sub e
   jp c, asm_tshr_cls_pix
   
   inc a
   
   ; e = number of pixel rows to scroll upward
   ; l = pix
   ; a = loop count
   
   ld b,a                      ; b = loop count
   
   push hl                     ; save pix byte
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ex de,hl
   call asm_tshr_py2saddr      ; hl = screen address corresponding to first scroll row L

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld de,$c000
ELSE
   ld de,$4000                 ; de = destination address of first scroll row
ENDIF

copy_up_loop_1:

   push bc

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi
   call   l_ldi - (31*2)

ELSE

   ld bc,31
   ldir

ENDIF

   ld a,(hl)
   ld (de),a
   
   set 5,d
   set 5,h

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldd
   call   l_ldd - (31*2)

ELSE

   ld bc,31
   lddr

ENDIF

   ld a,(hl)
   ld (de),a
   
   res 5,d
   res 5,h

   ex de,hl
   call asm_tshr_saddrpdown
   ex de,hl
   call asm_tshr_saddrpdown
   
   pop bc
   djnz copy_up_loop_1

   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows
   
   ex de,hl
   
   pop de
   ld a,e                      ; a = pix byte

vacate_loop_0:

   push bc

   ld (hl),a
   
   ld e,l
   ld d,h
   inc e

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi
   call   l_ldi - (31*2)

ELSE

   ld bc,31
   ldir

ENDIF

   set 5,d
   set 5,h

   ld (hl),a

   dec de
   dec e

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldd
   call   l_ldd - (31*2)

ELSE

   ld bc,31
   lddr

ENDIF

   ld c,a
   call asm_tshr_saddrpdown
   ld a,c

   pop bc
   djnz vacate_loop_0

   ret
