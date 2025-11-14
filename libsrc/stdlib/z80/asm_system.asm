
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int system(const char *string)
;
; If string == 0, returns non-zero to indicate if system() is
; available.  Otherwise string is passed to the system and result
; is returned.
;
; ===============================================================

SECTION code_clib
SECTION code_stdlib

PUBLIC asm_system

EXTERN l_inc_sp, __ch_system

asm_system:

   ; enter : hl = char *string
   ;
   ; exit  : string == 0 tests if system() is available
   ;
   ;           hl = 0 and carry set if unavailable
   ;           hl = non-zero and carry reset if available
   ;
   ;         string != 0
   ;
   ;           hl = result if system available
   ;           hl = 0 if system unavailable
   ;
   ; uses  :  all
   
   push hl                     ; parameter on stack in case of c linkage
   call __ch_system
   jp l_inc_sp - 2             ; do not disturb any return values
