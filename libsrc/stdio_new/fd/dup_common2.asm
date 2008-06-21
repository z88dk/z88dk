; common code from dup/dup2
; 06.2008 aralbrec

XLIB dup_common2
LIB fd_fdtblindex

.dup_common2

   ; 7. enter dup fdstruct into fdtbl
   ;
   ;  c = fd dst
   ; de = dup fdstruct
   
   ld a,c
   call fd_fdtblindex          ; hl = fdtbl entry for fd dst
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   ld l,c
   ld h,0
   or a

   ret
