;
;	z88dk Standard library
;
;	char *strdup(s1)
;	Duplicate a string in memory
;
;	This requires linking with a malloc library
;

; char __FASTCALL *strdup(char *orig)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC strdup
PUBLIC _strdup

EXTERN HeapAlloc_callee
EXTERN _heap, ASMDISP_HEAPALLOC_CALLEE

.strdup
._strdup

   push hl
   ld bc,0
   
.sizeloop

   inc bc
   ld a,(hl)
   inc hl
   or a
   jp nz, sizeloop
   
   ld hl,_heap
   push bc
   call HeapAlloc_callee + ASMDISP_HEAPALLOC_CALLEE
   pop bc
   pop de
   ret nc
   
   ex de,hl
   push de
   ldir
   pop hl
   ret

;
;#include <stdlib.h>
;#include <string.h>
;
;
;char *strdup(char *orig)
;{
;	char *ptr;
;
;
;	ptr=malloc(strlen(orig) + 1);
;
;	if (ptr) {
;		strcpy(ptr,orig);
;	}
;	return (ptr);
;}
