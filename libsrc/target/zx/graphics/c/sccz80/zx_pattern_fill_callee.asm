
; int zx_pattern_fill(uchar x, uchar y, void *pattern, uint depth)

SECTION code_clib
SECTION code_arch

PUBLIC zx_pattern_fill_callee

EXTERN asm_zx_pattern_fill

zx_pattern_fill_callee:
IF __CLASSIC
   ld  hl,2
   add hl,sp
   ld  c,(hl)   ;depth
   inc hl
   ld  b,(hl)
   inc hl
   ld  e,(hl)   ;pattern
   inc hl
   ld  d,(hl)
   inc hl
   ld  a,(hl)   ;y
   inc hl
   inc hl
   ld  l,(hl)   ;x
   ld  h,a
   push ix
   call asm_zx_pattern_fill
   pop  ix
   pop  de	;ret
   pop  bc      ;dump args
   pop  bc
   pop  bc
   pop  bc
   push de
   ret
ELSE
   PUBLIC l0_zx_pattern_fill_callee
   pop af
   pop bc
   pop de
   pop hl
   pop ix
   push af

l0_zx_pattern_fill_callee:

   ld a,ixl
   ld h,l
   ld l,a
   
   jp asm_zx_pattern_fill
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _zx_pattern_fill_callee
defc _zx_pattern_fill_callee = zx_pattern_fill_callee
ENDIF

