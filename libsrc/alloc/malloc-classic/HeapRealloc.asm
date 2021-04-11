; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapRealloc
PUBLIC _HeapRealloc

EXTERN asm_HeapRealloc

.HeapRealloc
._HeapRealloc
IF __CPU_INTEL__ | __CPU_GBZ80__
  ld hl,sp+2
  ld c,(hl)
  inc hl
  ld b,(hl)
  inc hl
  ld e,(hl)
  inc hl
  ld d,(hl)
  inc hl
  ld a,(hl+)
  ld h,(hl)
  ld l,a
  ex de,hl
ELSE
   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
ENDIF
   
   jp asm_HeapRealloc
