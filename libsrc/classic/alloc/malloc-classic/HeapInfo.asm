; CALLER linkage for function pointers

SECTION code_clib
PUBLIC HeapInfo
PUBLIC _HeapInfo
EXTERN MAHeapInfo

.HeapInfo
._HeapInfo

   ; A return address can't go through AF on these CPUs: the flags byte does not
   ; read back what was pushed, and on the VM1 pop af also switches the data bank.
   IF __CPU_INTEL__ | __CPU_GBZ80__
   pop de
   pop hl
   push de
   call MAHeapInfo
   ld hl,2
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld (hl),c
   inc hl
   ld (hl),b
   ld hl,4
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   ld (hl),e
   inc hl
   ld (hl),d
   pop de
   push de
   push de
   ret
   ELSE
   pop af
   pop hl
   push af
   call MAHeapInfo
   pop af
   pop hl
   ld (hl),c
   inc hl
   ld (hl),b
   pop hl
   ld (hl),e
   inc hl
   ld (hl),d
   push hl
   push hl
   push hl
   push af
   ret
   ENDIF
