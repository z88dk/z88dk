
SECTION seg_code_error
   
PUBLIC errno_mc
   
EXTERN error_mc, _errno

   ld l,$ff                    ; unspecified error

errno_mc:
 
   ; set errno = l
   ; set hl = -1
   ; set carry flag
      
   ld h,0
   ld (_errno),hl
      
   jp error_mc
