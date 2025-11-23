
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_scroll_up_attr(uchar rows, uchar attr)
;
; Scroll attrs upward by rows chars and clear vacated area
; using attribute.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_up_attr
PUBLIC asm0_zx_scroll_up_attr

EXTERN asm_zx_cls_attr
EXTERN asm_zx_cy2aaddr

asm_zx_scroll_up_attr:

   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;
   ; uses  : af, bc, de, hl

   inc d
   dec d
   jp nz, asm_zx_cls_attr

asm0_zx_scroll_up_attr:

   inc e
   dec e
   ret z
   
   ld a,23
   sub e
   jp c, asm_zx_cls_attr
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = attr
   ; a = loop count
   
   ld c,a                      ; c = loop count
   push hl                     ; save attr
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ex de,hl
   call asm_zx_cy2aaddr        ; hl = attr address corresponding to first scroll row L

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld de,$d800
ELSE
   ld de,$5800                 ; de = destination address of first scroll row
ENDIF
   
   ld a,c                      ; a = loop count
   
copy_up_loop_0:

   ; copy row of attributes

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi_32
   call   l_ldi_32

ELSE

   ld bc,32
   ldir

ENDIF

   dec a
   jr nz, copy_up_loop_0

   ;; clear vacated area
   
   pop bc
   ld b,c                      ; b = scroll amount = number of vacated rows

   pop hl
   ld a,l                      ; a = attr
   
   ex de,hl

vacate_loop_0:

   ; clear row of attributes

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

   ex de,hl

   pop bc
   djnz vacate_loop_0

   ret
