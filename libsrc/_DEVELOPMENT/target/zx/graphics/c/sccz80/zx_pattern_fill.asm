
; int zx_pattern_fill(uchar x, uchar y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pattern_fill

EXTERN l0_zx_pattern_fill_callee
EXTERN asm_zx_pattern_fill

zx_pattern_fill:
IF __CLASSIC
   ld  hl,2
   add hl,sp
   ld  c,(hl)	;depth
   inc hl
   ld  b,(hl)
   inc hl
   ld  e,(hl)	;pattern
   inc hl
   ld  d,(hl)
   inc hl
   ld  a,(hl)	;y
   inc hl
   inc hl
   ld  l,(hl)   ;x
   ld  h,a
   push ix
   call asm_zx_pattern_fill
   pop  ix
   ret
ELSE
   pop af
   pop bc
   pop de
   pop hl
   pop ix
   
   push hl
   push hl
   push de
   push bc
   push af

   jp l0_zx_pattern_fill_callee
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_pattern_fill
defc _zx_pattern_fill = zx_pattern_fill
ENDIF

