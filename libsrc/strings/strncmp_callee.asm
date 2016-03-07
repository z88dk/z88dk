; int __CALLEE__ strncmp_callee(char *s1, char *s2, uint n)
; compare at most n chars of string s1 to string s2
; 05.2002 dom, 12.2006 aralbrec

SECTION code_clib
PUBLIC strncmp_callee
PUBLIC _strncmp_callee
PUBLIC ASMDISP_STRNCMP_CALLEE
EXTERN     rcmx_cpi


.strncmp_callee
._strncmp_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
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

DEFC ASMDISP_STRNCMP_CALLEE = # asmentry - strncmp_callee
