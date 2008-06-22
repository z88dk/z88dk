; common code from dup/dup2
; 06.2008 aralbrec

XLIB dup_common1

LIB fd_fdtblindex, stdio_malloc
LIB stdio_error_ebadf_mc, stdio_error_enomem_mc

.dup_common1

   ; 3. lookup src fdstruct
   ;
   ;  l = fd src
   ;  c = fd dst

   ld a,l
   call fd_fdtblindex          ; hl = entry in fdtbl for fd src
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = src fdstruct
   
   or h
   jp z, stdio_error_ebadf_mc  ; if there is no src fd
   
   ; 4. create a dup fd
   ;
   ;  c = fd dst
   ; hl = src fdstruct
   
   push hl
   push bc
   ld bc,FDSTR_SZ              ; sizeof(fdstruct)
   call stdio_malloc           ; hl = dup fdstruct
   pop bc
   pop de
   jp nc, stdio_error_enomem_mc
   
   ; 5. fill in the dup fdstruct
   ;
   ;  c = fd dst
   ; hl = dup fdstruct
   ; de = src fdstruct
   
   ld (hl),195
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   inc de
   inc de
   inc de
   ld a,(de)
   inc de
   or $80
   ld (hl),a
   inc hl
   ld a,(de)
   inc de
   ld (hl),a
   inc hl
   ld a,(de)
   inc a
   ld (de),a                   ; increase the refcount of src fdstruct
   ld (hl),1                   ; hl = dup fdstruct.refcount

   ld de,-5
   add hl,de

   ;  c = fd dst
   ; hl = dup fdstruct

   or a
   ret
