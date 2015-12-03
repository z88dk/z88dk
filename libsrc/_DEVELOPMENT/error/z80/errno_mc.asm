
SECTION code_clib
SECTION code_error
   
PUBLIC errno_mc
   
EXTERN error_mc, _errno

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR = 0

   pop hl
   pop hl
   pop hl

   ld l,$ff                    ; unspecified error

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

errno_mc:
 
   ; set errno = l
   ; set hl = -1
   ; set carry flag
      
   ld h,0
   ld (_errno),hl
      
   jp error_mc
