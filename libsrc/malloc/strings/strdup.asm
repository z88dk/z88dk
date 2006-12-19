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

XLIB strdup
LIB malloc

.strdup

   push hl
   ld bc,0
   
.sizeloop

   inc bc
   ld a,(hl)
   inc hl
   or a
   jp nz, sizeloop
   
   ld l,c
   ld h,b
   push bc
   call malloc
   pop bc
   ret nc
   
   pop de
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
