
; ===============================================================
; Jan 2014
; ===============================================================
; 
; char *strerror(int errnum)
;
; Return string message corresponding to errnum.
;
; ===============================================================

SECTION code_clib
SECTION code_string

PUBLIC asm_strerror

EXTERN __rodata_error_strings_head, __str_locate_nul

asm_strerror:

   ; enter : hl = errnum
   ;
   ; exit  : hl = char *message
   ;         carry set if errnum was not found
   ;
   ; uses  : af, bc, e, hl
   
   ld a,h
   or a
   jp NZ, use_default
   
   or l
   jp Z, use_ok
   
   ld e,l
   ld hl,__rodata_error_strings_head
   
   ld a,(hl)
   
search_loop:
   
   cp e
   inc hl
   
   ret Z                       ; if found string
   
   call __str_locate_nul
   inc hl
   
   ld a,(hl)
   or a
   jp NZ, search_loop          ; if end of strings not met

use_default:

   ld hl,__error_string_default
   
   scf
   ret

use_ok:

   ld hl,__error_string_ok
   ret

__error_string_default:

   IF __CLIB_OPT_ERROR & $02

      defm "ERR - Unknown"
      defb 0

   ELSE
   
      defm "ERR"
      defb 0
   
   ENDIF

__error_string_ok:

   IF __CLIB_OPT_ERROR & $02

      defm "EOK - No error"
      defb 0

   ELSE
   
      defm "EOK"
      defb 0
   
   ENDIF
