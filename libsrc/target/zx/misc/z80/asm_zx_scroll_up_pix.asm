
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_scroll_up_pix(uchar prows, uchar pix)
;
; Scroll screen upward by number of pixels.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_up_pix
PUBLIC asm0_zx_scroll_up_pix
PUBLIC asm1_zx_scroll_up_pix

EXTERN asm_zx_cls_pix
EXTERN asm_zx_py2saddr, asm_zx_saddrpdown

asm_zx_scroll_up_pix:

   ; enter : de = number of pixel rows to scroll upward by
   ;          l = screen byte
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jp nz, asm_zx_cls_pix

asm0_zx_scroll_up_pix:

   inc e
   dec e
   ret z
   
   ld a,191
   sub e
   jp c, asm_zx_cls_pix
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = screen byte
   ; a = loop count
   
   ld b,a                      ; b = loop count
   
   push hl                     ; save screen byte
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ex de,hl
   call asm_zx_py2saddr        ; hl = screen address corresponding to first scroll row L

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld de,$c000
ELSE
   ld de,$4000                 ; de = destination address of first scroll row
ENDIF

asm1_zx_scroll_up_pix:
copy_up_loop_1:

   push bc
   
   push de
   push hl

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi_32
   call   l_ldi_32

ELSE

   ld bc,32
   ldir

ENDIF

   pop hl
   pop de
   
   ex de,hl
   call asm_zx_saddrpdown
   ex de,hl
   call asm_zx_saddrpdown
   
   pop bc
   djnz copy_up_loop_1

   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows
   
   ex de,hl
   
   pop de
   ld a,e                      ; a = screen byte

vacate_loop_0:

   push bc
   push hl

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

   pop hl

   ld c,a
   call asm_zx_saddrpdown
   ld a,c

   pop bc
   djnz vacate_loop_0

   ret
