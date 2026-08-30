; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapSbrk
PUBLIC _HeapSbrk

EXTERN asm_HeapSbrk

.HeapSbrk
._HeapSbrk

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   ld hl,2
   add hl,sp
   ld c,(hl)
   inc hl
   ld b,(hl)
   inc hl
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld hl,4
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
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
   
   jp asm_HeapSbrk
