SECTION code_env

PUBLIC asm_env_name_sm

EXTERN asm_isspace

asm_env_name_sm:

; State Machine for Locating Values in "NAME=VALUE" pairs.
;
; enter :  a = char to examine
;         de = char *name (qualified - no whitespace, no equals, not empty)
;         (iy is used to hold current state, do not modify between calls)
;
; exit  : if success
;
;            current char is start of value string
;            carry set
;
;         if no match yet
;
;            carry reset
;
; uses  : af, hl, iy

asm_env_name_sm_leading_ws_enter:

   ld iy,asm_env_name_sm_leading_ws

asm_env_name_sm_leading_ws:

   ; eliminate whitespace from stream
   
   call asm_isspace
   ret nc                      ; if whitespace

asm_env_name_sm_match_enter:

   ld iy,asm_env_name_sm_match
   
   ld l,e
   ld h,d

asm_env_name_sm_match:

   ; match name to stream
   
   cp (hl)
   jr nz, asm_env_sm_name_purge_enter
   
   inc hl
   
   ld a,(hl)
   or a  
   ret nz                      ; if end of name not reached
   
asm_env_name_sm_equal_enter:

   ld iy,asm_env_name_sm_equal
   ret                         ; carry is reset

asm_env_name_sm_equal:

   ; accept whitespace not \n up to equal
   
   cp '\n'
   jr z, asm_env_name_sm_leading_ws_enter
   
   call asm_isspace
   ret nc                      ; if whitespace
   
   cp '='
   jr nz, asm_env_sm_name_purge_enter
   
asm_env_name_sm_trailing_ws_enter:

   ld iy,asm_env_name_sm_trailing_ws
   
   or a
   ret

asm_env_name_sm_trailing_ws:

   ; accept whitespace not \n
   
   cp '\n'
   jr z, asm_env_name_sm_accept  ; match an empty value string
   
   call asm_isspace
   ret nc                      ; if whitespace

asm_env_name_sm_accept:

   ; current character is the start of the value string

   scf
   ret

asm_env_sm_name_purge_enter:

   ld iy,asm_env_sm_name_purge

asm_env_sm_name_purge:

   ; ignore all up to \n
   
   cp '\n'
   jr z, asm_env_name_sm_leading_ws_enter
   
   or a
   ret
