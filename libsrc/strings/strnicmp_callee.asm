; int __CALLEE__ strnicmp_callee(char *s1, char *s2, uint n)
; caseless compare
; 12.2006 aralbrec

SECTION code_clib
PUBLIC strnicmp_callee
PUBLIC _strnicmp_callee
PUBLIC ASMDISP_STRNICMP_CALLEE

EXTERN asm_tolower

.strnicmp_callee
._strnicmp_callee

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
   ; uses : af, bc, de, hl

.asmentry
.strnicmp1

   ld a,b
   or c
   jr z, equal
   
   push bc
   
   ld a,(hl)
   call asm_tolower
   ld c,a
   
   ld a,(de)
   call asm_tolower
   
   cp c
   pop bc
   jr nz, different
   
   dec bc
   inc de
   inc hl
   
   or a
   jp nz, strnicmp1

   ; here strings are equal

.equal

   ld l,a
   ld h,a
   ret

.different

   ld a,(de)                   ; redo mismatch compare without tolower modification
   cp (hl)

   ; effectively performed *s2 - *s1

   ld h,$80
   ret nc
   dec h
   ret

DEFC ASMDISP_STRNICMP_CALLEE = # asmentry - strnicmp_callee
