; stdio_outchar
; 05.2008 aralbrec

PUBLIC stdio_outchar
EXTERN l_jpix

INCLUDE "../../stdio.def"

; all stream character output to attached file or device passes through this function
;
; enter : ix  = FILE *
;          a  = char for output
;         bc' = number of chars output thus far
;         MUST NOT ALTER DE'/HL' FOR SPRINTF FUNCTIONS
; exit  : bc' = number of chars output thus far
;         carry set if error on stream, ERRNO set appropriately
; uses  : af, exx

.stdio_outchar

   exx
   push bc
   ld c,a
   ld a,STDIO_MSG_PUTC
   call l_jpix
   pop bc
   jr c, error
   
   inc bc

.error

   exx
   ret
