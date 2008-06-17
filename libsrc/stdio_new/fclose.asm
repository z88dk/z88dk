; int __FASTCALL__ fclose(FILE *stream)
; 06.2008 aralbrec

XLIB fclose

LIB close_fdstruct, fileno, stdio_free
XREF LIBDISP_FILENO

.fclose

   ; hl = FILE *

   push hl                     ; save FILE* for freeing later
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = fdstruct *
   
   ex (sp),hl
   call stdio_free             ; free the FILE struct now
   pop hl                      ; hl = fdstruct *
   
   push hl
   call close_fdstruct         ; carry = error, z = reference count reached zero
   pop hl
   jp c, stdio_error_mc
   jp nz, stdio_success_znc    ; if reference count did not reach zero
   
   ; reference count of underlying fd reached zero
   ; which means we must remove the fdstruct from the
   ; fd table if it is there
   
   call fileno + LIBDISP_FILENO
   ret c                       ; fdstruct not in the fd table
   
   ; de = MSB of entry in fd table
   
   xor a
   ld (de),a
   dec de
   ld (de),a                   ; remove fd table entry
   
   jp stdio_success_znc
