; char *strncpy(char *s1, char *s2, int n)
; copy at most n chars from s2 to s1, padding with '\0' if nec
; 12.2006 aralbrec

; exit : hl = char *s1
; uses : af, bc, de, hl

XLIB strncpy
XDEF ASMDISP_STRNCPY

.strncpy

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af

   ; bc = int n
   ; de = src char *s2
   ; hl = dest char *s1

.asmentry

   ld a,b
   or c
   ret z
      
   ex de,hl
   push de
   
   ; first copy string s2 into s1
   
.loopcpy

   ld a,(hl)
   ldi
   jp po, done               ; reached max number of chars
   or a
   jp nz, loopcpy
   
   ; now pad with zeroes
   
   ld l,e
   ld h,d
   dec hl
   ldir

.done

   pop hl
   ret

DEFC ASMDISP_STRNCPY = asmentry - strncpy
