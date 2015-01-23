; stdio_dupcommon2
; 07.2009 aralbrec

PUBLIC stdio_dupcommon2

INCLUDE "../../stdio.def"

; common code factored out of dup functions
; centralizes key steps for making dup fds
;
; enter :  l = source fd
; exit  : ix = source fdstruct, carry reset
;         carry set if source fd invalid
; uses  : af, hl, ix

.stdio_dupcommon2

   call stdio_fdcommon1        ; ix = source fdstruct
   ret c                       ; invalid source fd
   
   ; we do not allow duping of dup fds
   ; instead, find the first non-dup fd in stdio chain and dup that
   
.loop

   bit 7,(ix+3)                ; is this a dup fd?
   ret z                       ; if not return with carry reset
   
   ld a,(ix+1)
   ld l,(ix+2)
   ld ixl,a
   ld ixh,l                    ; ix = next fdstruct in stdio chain
   
   jp loop
