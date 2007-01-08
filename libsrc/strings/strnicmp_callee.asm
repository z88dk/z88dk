; int __CALLEE__ strnicmp_callee(char *s1, char *s2, uint n)
; caseless compare
; 12.2006 aralbrec

XLIB strnicmp_callee
XDEF ASMDISP_STRNICMP_CALLEE

.strnicmp_callee

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
   ; uses : af, bc, de, hl

.asmentry
.strnicmp1

   ld a,b
   or c
   jr z, equal
   
   push bc
   
   ld a,(hl)
   inc hl
   
   cp 'A'
   jr c, +6
   cp 'Z'+1
   jr nc, +2
   or $20
   
   ld c,a
   
   ld a,(de)
   inc de
   
   cp 'A'
   jr c, +6
   cp 'Z'+1
   jr nc, +2
   or $20
   
   cp c
   pop bc
   jr nz, different
   
   dec bc
   or a
   jp nz, strnicmp1
   
.equal

   ld hl,0
   ret

.different

   ; effectively performed *s2 - *s1

   ld h,$80
   ret nc
   dec h
   ret

DEFC ASMDISP_STRNICMP_CALLEE = asmentry - strnicmp_callee
