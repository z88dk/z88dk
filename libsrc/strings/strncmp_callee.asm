; int __CALLEE__ strncmp_callee(char *s1, char *s2, uint n)
; compare at most n chars of string s1 to string s2
; 05.2002 dom, 12.2006 aralbrec

XLIB strncmp_callee
XDEF ASMDISP_STRNCMP_CALLEE

.strncmp_callee

   pop af
   pop bc
   pop de
   pop hl
   push af
   
   ; enter : bc = uint n
   ;         de = char *s2
   ;         hl = char *s1
   ; exit  : if s1==s2 : hl = 0, Z flag set
   ;         if s1<<s2 : hl < 0, NC+NZ flag set
   ;         if s1>>s2 : hl > 0, C+NZ flag set
   ; uses : af, de, hl

.asmentry

   ld a,b
   or c
   jr z, equal
      
.strncmp1

   ld a,(de)
   inc de
   cpi
   jr nz, different
   jp po, equal
   or a
   jp nz, strncmp1
   
.equal

   ld hl,0
   ret

.different

   dec hl
   cp (hl)
   ld h,$80
   ret nc
   dec h
   ret

DEFC ASMDISP_STRNCMP_CALLEE = asmentry - strncmp_callee
