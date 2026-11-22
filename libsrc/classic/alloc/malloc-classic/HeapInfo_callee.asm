; void __CALLEE__ HeapInfo_callee(unsigned int *total, unsigned int *largest, void *heap)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC HeapInfo_callee
PUBLIC _HeapInfo_callee
EXTERN MAHeapInfo

.HeapInfo_callee
._HeapInfo_callee

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
   inc sp
   inc sp
   inc sp
   inc sp
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
   push af
   ret
   ENDIF
