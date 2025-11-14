
SECTION code_clib
SECTION code_error
   
PUBLIC errno_zc
   
EXTERN error_zc, _errno

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR = 0

   pop hl
   pop hl
   pop hl

   ld l,$ff                    ; unspecified error

ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

errno_zc:
 
   ; set errno = l
   ; set hl = 0
   ; set carry flag

IF __CPU_GBZ80__
   ld a,l
   ld hl,_errno
   ld (hl+),a
   ld a,0
   ld (hl-),a
   ld l,(hl)
   ld h,0
ELSE
   ld h,0
   ld (_errno),hl
ENDIF
      
   jp error_zc
