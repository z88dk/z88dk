
; ===============================================================
; 2014
; ===============================================================
; 
; void zx_scroll_up(uchar rows, uchar attr)
;
; Scroll screen upward by rows chars and clear vacated area
; using attribute.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_arch

PUBLIC asm_zx_scroll_up
PUBLIC asm0_zx_scroll_up

EXTERN asm_zx_cls
EXTERN asm_zx_cy2saddr, asm_zx_cy2aaddr, asm0_zx_saddrpdown

asm_zx_scroll_up:

   ; enter : de = number of rows to scroll upward by
   ;          l = attr
   ;
   ; uses  : af, bc, de, hl, bc', de', hl'

   inc d
   dec d
   jp nz, asm_zx_cls

asm0_zx_scroll_up:

   inc e
   dec e
   ret z
   
   ld a,23
   sub e
   jp c, asm_zx_cls
   
   inc a
   
   ; e = number of rows to scroll upward
   ; l = attr
   ; a = loop count
   
   ld c,a                      ; c = loop count
   push hl                     ; save attr
   push de                     ; save scroll amount
   
   ;; copy upward
   
   ex de,hl
   call asm_zx_cy2saddr        ; hl = screen address corresponding to first scroll row L

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld de,$c000
ELSE
   ld de,$4000                 ; de = destination address of first scroll row
ENDIF
   
   exx
   
   pop hl
   push hl                     ; hl = scroll amount
   
   call asm_zx_cy2aaddr        ; hl = attribute address corresponding to first scroll row L

IF __USE_SPECTRUM_128_SECOND_DFILE
   ld de,$d800
ELSE
   ld de,$5800                 ; de = destination address of first scroll row
ENDIF

   exx
   
copy_up_loop_0:

   ; copy row of attributes
   
   exx

IF __CLIB_OPT_UNROLL & __CLIB_OPT_UNROLL_LDIR

   EXTERN l_ldi_32
   call   l_ldi_32

ELSE

   ld bc,32
   ldir

ENDIF

   exx
   
   ; copy row of pixels
   
   ld b,8

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
   
   inc d
   inc h
   
   pop bc
   djnz copy_up_loop_1
   
   ex de,hl
   call asm0_zx_saddrpdown
   ex de,hl
   call asm0_zx_saddrpdown

   dec c
   jr nz, copy_up_loop_0

   ;; clear vacated area
   
   pop bc                      ; c = scroll amount = number of vacated rows
   
   ex de,hl
   exx
   ex de,hl
   exx

vacate_loop_0:

   ; clear row of attributes
   
   exx
   
   pop de
   push de                     ; e = attr

   ld (hl),e
   
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
   
   exx
   
   ; clear row of pixels
   
   ld b,8

vacate_loop_1:

   push bc
   push hl

   ld (hl),0
   
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
   inc h
   
   pop bc
   djnz vacate_loop_1
   
   call asm0_zx_saddrpdown
   
   dec c
   jr nz, vacate_loop_0

   pop de
   ret
