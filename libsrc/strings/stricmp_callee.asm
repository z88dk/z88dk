; char __CALLEE__ *stricmp_callee(char *s1, char *s2)
; a caseless string comparison
; 12.2006 aralbrec

SECTION code_clib
PUBLIC stricmp_callee
PUBLIC _stricmp_callee
PUBLIC stricmp1

EXTERN asm_tolower

.stricmp_callee
._stricmp_callee

   pop hl
   pop de
   ex (sp),hl
   
   ; enter : hl = char *s1
   ;         de = char *s2
   ; exit : if s1==s2 : hl = 0, Z flag set
   ;        if s1<<s2 : hl < 0, NC+NZ flag set
   ;        if s1>>s2 : hl > 0, C+NZ flag set
   ; uses : af, c, de, hl

.asmentry
.stricmp1

   ld a,(hl)   
   call asm_tolower
   ld c,a
   
   ld a,(de)   
   call asm_tolower
   
   cp c
   jr nz, different
   
   inc de
   inc hl
   
   or a
   jp nz, stricmp1
   
   ; here strings are equal
   
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

