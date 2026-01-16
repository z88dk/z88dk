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
PUBLIC ___strdup
PUBLIC strdup_fastcall
PUBLIC _strdup_fastcall


EXTERN asm_HeapAlloc
EXTERN _heap

.strdup
._strdup
.___strdup
    pop bc
    pop hl
    push hl
    push bc

.strdup_fastcall
._strdup_fastcall

   push hl
   ld bc,0
   
.sizeloop

   inc bc
   ld a,(hl)
   inc hl
   or a
   jp NZ,sizeloop

   ld hl,_heap
   push bc
   call asm_HeapAlloc
   pop bc
   pop de
   ret NC

   ex de,hl
   push de

IF __CPU_INTEL__ || __CPU_GBZ80__
   dec bc
   inc b
   inc c
.ldir_loop
   ld a,(hl+)
   ld (de+),a
   dec c
   jr NZ,ldir_loop
   dec b
   jr NZ,ldir_loop
ELSE
   ldir
ENDIF

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
