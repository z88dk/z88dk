
SECTION seg_code_error
   
PUBLIC errno_zc
   
EXTERN error_zc, _errno

   ld l,$ff                    ; unspecified error

errno_zc:
 
   ; set errno = l
   ; set hl = 0
   ; set carry flag
      
   ld h,0
   ld (_errno),hl
      
   jp error_zc
