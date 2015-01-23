; stdio_getfdstruct
; 07.2009 aralbrec

PUBLIC stdio_getfdstruct

; return fd struct address given fd table entry
; (see stdio_fdtblentry), validate it by checking
; if non-zero
;
; enter : hl = & stdio_fdtbl[fd]
; exit  : ix = fdstruct *, carry reset
;         hl = & stdio_fdtbl[fd] + 1
;         carry set if fdstruct is invalid
; uses  : af, hl, ix

.stdio_getfdstruct

   ld a,(hl)
   ld ixl,a
   inc hl
   ld a,(hl)
   ld ixh,a
   
   or ixl
   ret nz
   scf
   ret
