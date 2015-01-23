; stdio_fdcommon1
; 07.2009 aralbrec

PUBLIC stdio_fdcommon1

; common code factored out of a lot of fd functions
;
; enter :  l = fd
; exit  : ix = fdstruct *, carry reset
;         hl = & stdio_fdtbl[fd] + 1
;         carry set if fd out of range or fdstruct is invalid
; uses  : af, hl, ix

.stdio_fdcommon1

   ld a,l
   call stdio_getfdtblentry    ; hl = & stdio_fdtbl[fd]
   ret c                       ; fd out of range

   jp stdio_getfdstruct        ; ix = fdstruct *, carry set if fd not open
