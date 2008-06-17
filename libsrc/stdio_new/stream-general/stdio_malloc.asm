; stdio_malloc
; 06.2008 aralbrec

XLIB stdio_malloc

LIB HeapAlloc_callee
XREF ASMDISP_HEAPALLOC_CALLEE, _stdio_heap

; Stdio file objects are allocated from the stdio heap
; (_stdio_heap) which may or may not be the same heap used
; by the regular malloc call.  This is an opportunity
; for machines with bankswitched memory to locate stdio
; and the dynamic memory it uses in its own bank.

.stdio_malloc

   ; enter : bc = request size in bytes
   ; exit  : hl = address of allocated block and carry set if success
   ;         hl = 0 and carry reset if fail
   ; uses  : af, bc, de, hl
   
   ld hl,_stdio_heap
   jp HeapAlloc_callee + ASMDISP_HEAPALLOC_CALLEE
