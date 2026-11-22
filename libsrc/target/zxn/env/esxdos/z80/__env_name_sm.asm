SECTION code_env

PUBLIC __env_name_sm

EXTERN asm_isspace

__env_name_sm:

   ; state machine for locating value portion of "name = value" pairs
   ;
   ; enter :  a = current char
   ;         de = char *name (qualified)
   ;         hl,ix reserved
   ;
   ; exit  :  a = current char
   ;         ix = next state
   ;         de = char *name (qualified)
   ;         hl = state
   ;
   ;         success if name matched
   ;
   ;            current position points at value
   ;            carry set
   ;
   ;         continue if name not matched
   ;
   ;            carry reset
   ;
   ; uses  : f, hl, ix

enter_state_0:

   ld ix,state_0
   
state_0:

   ; skip over leading whitespace

   call asm_isspace
   ret nc                      ; if whitespace
   
   cp '='
   jr z, enter_state_purge     ; if name is empty
   
enter_state_1:
   
   ld ix,state_1

   ld l,e
   ld h,d                      ; hl = char *match

state_1:

   ; examine name portion
   
   or a
   jr z, enter_state_purge     ; if input char is illegal NUL
   
   cp (hl)
   inc hl
   
   ret z                       ; if char matches name
   
   dec hl
   ld l,(hl)
   
   inc l
   dec l

   jr nz, enter_state_purge    ; if name does not match
   
enter_state_2:

   cp '='
   jr z, enter_state_3         ; if equals follows matched name

   ld ix,state_2
   
state_2:

   ; linefeed not allowed
   
   cp '\n'
   jr z, enter_state_purge

   ; skip whitespace trailing name
   
   call asm_isspace
   ret nc                      ; if whitespace
   
   cp '='
   jr nz, enter_state_purge
   
enter_state_3:

   ; equals seen after name

   ld ix,state_3
   
   or a
   ret

state_3:

   ; linefeed indicates empty value
   
   cp '\n'
   jr z, state_found
   
   ; skip whitespace preceding value
   
   call asm_isspace
   ret nc                      ; if whitespace
   
state_found:

   ; found value
   
   scf
   ret

enter_state_purge:

   ld ix,purge

purge:

   cp '\n'
   jr z, enter_state_0
   
   or a
   ret
