; int strspn(char *s1, char *s2)
; return length of prefix in s1 containing chars in s2
; 01.2007 aralbrec

; exit : hl = length of prefix in s1
; uses : asm : af, bc, hl
;          c : af, bc, de, hl

XLIB strspn
LIB strchr
XREF ASMDISP_STRCHR
XDEF ASMDISP_STRSPN

.strspn

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   ; de = char *s2
   ; hl = char *s1

.asmentry
   
   ld bc,0
   
.loop

   ld a,(hl)
   or a
   jr z, done
   
   inc hl
   push bc
   push hl
   ld c,a
   ld l,e
   ld h,d
   call strchr + ASMDISP_STRCHR
   pop hl
   pop bc
   jr c, done
   inc bc
   jp loop

.done

   ld l,c
   ld h,b
   ret

DEFC ASMDISP_STRSPN = asmentry - strspn
