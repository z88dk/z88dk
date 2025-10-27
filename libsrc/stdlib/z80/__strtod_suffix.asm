
SECTION code_clib
SECTION code_stdlib

PUBLIC __strtod_suffix

EXTERN asm_tolower

__strtod_suffix:

   ; hl = char *
   
   ld a,(hl)
   call asm_tolower
   
   cp 'f'
   jr z, valid_suffix
   
   cp 'l'
   ret nz

valid_suffix:

   inc hl
   ret
