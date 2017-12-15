SECTION code_env

PUBLIC asm_env_qualify_name

asm_env_qualify_name:

   ; Qualify NAME for NAME=VALUE pairs
   ; must not contain whitespace, equals, not empty
   ;
   ; enter : hl = char *name
   ;
   ; exit  : if name is acceptable
   ;
   ;            carry set
   ;
   ;         if name is rejected
   ;
   ;            carry reset
   ;
   ; uses  : af, hl
   
   ld a,h
   or l
   ret z                       ; disqualify NULL
   
   ld a,(hl)
   or a
   ret z                       ; disqualify empty string
   
loop:

   cp '='
   ret z
   
   call asm_isspace
   ret nc
   
   inc hl
   
   ld a,(hl)
   or a
   jr nz, loop
   
   scf
   ret
