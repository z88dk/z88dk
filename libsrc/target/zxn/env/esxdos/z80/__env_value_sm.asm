SECTION code_env

PUBLIC __env_value_sm

EXTERN asm_isspace

__env_value_sm:

   ; state machine for locating end of value portion of "name = value" pairs
   ;
   ; enter :  a = current char
   ;         bc = file position
   ;         ix, hl reserved
   ;
   ; exit  :  a = current char
   ;         bc = file position
   ;         ix = next state
   ;         hl = position following last non-whitespace char
   ;
   ;         success if end of value determined
   ;
   ;            hl = position following last char in value
   ;            carry reset
   ;
   ;         continue if end of value not determined
   ;
   ;            carry set
   ;
   ; uses  : f, hl, ix

enter_state_0:
   
   ld l,c
   ld h,b

   ld ix,state_0

state_0:

   ; end of line indicates last of value string
   
   cp '\n'
   ret z
   
   or a
   ret z
   
   call asm_isspace
   
   ccf
   ret c                       ; if whitespace

   ld l,c
   ld h,b

   inc hl                      ; record one past position of non-whitespace char

   scf
   ret
