
SECTION code_clib
SECTION code_error
   
PUBLIC errno_znc
   
EXTERN error_znc, _errno

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR = 0

   pop hl
   pop hl
   pop hl

   ld l,$ff                    ; unspecified error

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

errno_znc:
 
   ; set errno = l
   ; set hl = 0
   ; reset carry flag
      
   ld h,0
   ld (_errno),hl
      
   jp error_znc
