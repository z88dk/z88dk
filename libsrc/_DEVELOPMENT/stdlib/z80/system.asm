
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

INCLUDE "../../crt_vars.inc"

XLIB system
XDEF asm_system

LIB error_zc, l_inc_sp

system:
asm_system:

   ; enter : hl = char *string
   ;
   ; exit  : 
   ;
   ;         string == 0:
   ;
   ;            hl = non-zero and carry reset if system() available
   ;            hl = 0 and carry set if system() not available
   ;
   ;         string != 0 and system() available:
   ;
   ;            hl = result
   ;
   ;         string != 0 and system() unavailable:
   ;
   ;            hl = 0 and carry set
   ;
   ; uses  :  af, de, hl, plus all if system() invoked
   
   ex de,hl                    ; de = char *
   ld hl,(__system)            ; hl = address of system function
   
   ld a,h
   or l
   jp z, error_zc              ; system unavailable
   
   ld a,d
   or e
   ret z                       ; if string == NULL, return with carry reset
   
   ; de = char *
   ; hl = & system_function
   
   push de                     ; parameter on stack
   
   ld bc,l_inc_sp - 2
   push bc                     ; pop parameter on return
   
   ex de,hl                    ; hl = parameter
   push de
   ret                         ; jump to system_function
