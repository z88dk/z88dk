; char *strpbrk(char *s1, char *s2)
; return ptr to first occurrence in s1 of any char in s2
; 01.2007 aralbrec

; exit :     found : hl = ptr in s1, NC flag set
;        not found : hl = 0, C flag set
; uses : asm : af, c, hl
;          c : af, bc, de, hl

XLIB strpbrk
LIB strchr
XREF ASMDISP_STRCHR
XDEF ASMDISP_STRPBRK

.strpbrk

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
    
    ; de = char *s2
    ; hl = char *s1

.asmentry
.loop

   ld a,(hl)
   or a
   jr z, fail

   push hl
   ld l,e
   ld h,d
   ld c,a
   call strchr + ASMDISP_STRCHR
   pop hl
   ret nc
   
   inc hl
   jp loop

.fail

   ld l,a
   ld h,a
   scf
   ret

DEFC ASMDISP_STRPBRK = asmentry - strpbrk
