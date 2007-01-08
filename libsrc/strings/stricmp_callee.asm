; char __CALLEE__ *stricmp_callee(char *s1, char *s2)
; a caseless string comparison
; 12.2006 aralbrec

XLIB stricmp_callee
XDEF ASMDISP_STRICMP_CALLEE

.stricmp_callee

   pop bc
   pop de
   pop hl
   push bc
   
   ; enter : hl = char *s1
   ;         de = char *s2
   ; exit : if s1==s2 : hl = 0, Z flag set
   ;        if s1<<s2 : hl < 0, NC+NZ flag set
   ;        if s1>>s2 : hl > 0, C+NZ flag set
   ; uses : af, c, de, hl

.asmentry
.stricmp1

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
   jr nz, different
   
   or a
   jp nz, stricmp1
   
   ; here strings are equal
   
   ld l,a
   ld h,a
   ret

.different

   ; effectively performed *s2 - *s1

   ld h,$80
   ret nc
   dec h
   ret

DEFC ASMDISP_STRICMP_CALLEE = asmentry - stricmp_callee
