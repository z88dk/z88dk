; CALLER linkage for function pointers

SECTION code_clib
PUBLIC mallinfo
PUBLIC _mallinfo

EXTERN HeapInfo
EXTERN _heap

.mallinfo
._mallinfo

   ld hl,_heap
IF __CPU_GBZ80__
   EXTERN __z80asm__exsphl
   call __z80asm__exsphl
ELSE
   ex (sp),hl
ENDIF
   push hl
   jp HeapInfo
