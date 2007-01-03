; int strcspn(char *s1, char *s2)
; return length of prefix of s1 NOT containing chars in s2
; 01.2007 aralbrec

; exit : hl = length of prefix
; uses : asm : af, bc, hl
;          c : af, bc, de, hl

XLIB strcspn
LIB strchr
XREF ASMDISP_STRCHR
XDEF ASMDISP_STRCSPN

.strcspn

   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   
   ; de = char *s2
   ; hl = char *s1

.asmentry

   ld bc,0                   ; counter
   
.loop

   ld a,(hl)
   or a
   jr z, done
   
   push bc
   push hl
   ld c,a
   ld l,e
   ld h,d
   call strchr + ASMDISP_STRCHR
   pop hl
   pop bc
   jr nc, done
   inc bc
   inc hl
   jp loop

.done

   ld l,c
   ld h,b
   ret

DEFC ASMDISP_STRCSPN = asmentry - strcspn
