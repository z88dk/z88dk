SECTION code_env

PUBLIC asm_env_value_sm
PUBLIC asm_env_value_sm_count

EXTERN asm_isspace

asm_env_value_sm:

   ; Determine Value String Length
   ;
   ; enter : a = char to examine
   ;         (de, hl used to hold counts, do not modify between calls)
   ;
   ; exit  : when done
   ;
   ;            de = length of value string
   ;            hl = offset of next line
   ;            carry set
   ;
   ;         keep calling asm_env_value_sm_count
   ;
   ;            carry reset
   ;
   ; uses  : af, de, hl

   ld hl,0
   ld e,l
   ld d,h
   
asm_env_value_sm_count:

   inc hl
   
   cp '\n'
   scf
   ret z

   call asm_isspace
   ret nc
   
   ld e,l
   ld d,h
   
   or a
   ret
