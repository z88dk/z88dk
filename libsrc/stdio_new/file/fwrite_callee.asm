; uint __CALLEE__ fwrite_callee(void *p, uint size, uint nitems, FILE *stream)
; 06.2008 aralbrec

PUBLIC fwrite_callee
PUBLIC ASMDISP_FWRITE_CALLEE
EXTERN l_mult, l_div_u, l_jpix
EXTERN stdio_error_mc, stdio_error_eacces_mc, stdio_success_znc

include "../stdio.def"

.fwrite_callee

   pop af
   pop ix
   pop hl
   pop de
   pop bc
   push af

.asmentry

   ; enter : ix = FILE *stream
   ;         hl = uint nitems
   ;         de = uint size
   ;         bc = void *p
   ; exit  : hl = number items written, carry reset for success
   ;         hl = -1 and carry set for problem on stream
   
   bit 1,(ix+3)                ; open for writing?
   jp z, stdio_error_eacces_mc
   
   push de                     ; save size
   push bc                     ; save void*
   call l_mult                 ; hl = nitems * size
   pop de                      ; de = void*

   ld a,h
   or l
   jp z, stdio_success_znc - 1

   ld a,STDIO_MSG_WRIT
   call l_jpix
   pop de                      ; de = size
   jp c, stdio_error_mc
   
   ex de,hl                    ; hl = size, de = number bytes read
   call l_div_u                ; hl = numbytes / size
   
   or a
   ret

defc ASMDISP_FWRITE_CALLEE = # asmentry - fwrite_callee
