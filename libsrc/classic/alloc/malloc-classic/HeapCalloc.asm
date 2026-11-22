; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapCalloc
PUBLIC _HeapCalloc

EXTERN asm_HeapCalloc

.HeapCalloc
._HeapCalloc

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   inc hl
   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)
   ld hl,4
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ELSE
   pop af
   pop de
   pop hl
   pop bc
   push bc
   push hl
   push de
   push af
   ENDIF
   
   jp asm_HeapCalloc
