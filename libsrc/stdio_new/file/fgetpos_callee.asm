; int __CALLEE__ fgetpos_callee(FILE *stream, fpos_t *pos)
; an fpos_t is a long
; 06.2008 aralbrec

PUBLIC fgetpos_callee
PUBLIC ASMDISP_FGETPOS_CALLEE

EXTERN l_declong, l_jpix
EXTERN stdio_error_mc, stdio_success_znc

INCLUDE "../stdio.def"

.fgetpos_callee

   pop de
   pop hl
   pop ix
   push de

.asmentry

   ; enter : ix = FILE *stream
   ;         hl = long *pos
   ; exit  : hl = 0 and no carry for success
   ;              -1 and carry for fail
   
   push hl                     ; save & pos
   
   ld c,STDIO_SEEK_REP         ; report file pos, no change
   ld a,STDIO_MSG_SEEK
   call l_jpix
   jp c, stdio_error_mc - 1    ; device driver error
   
   ; dehl = file position
   
   bit 0,(ix+3)                ; if an unget char is available
   call nz, l_declong          ; the device fp is actually one less
   
   ex de,hl                    ; fp = hlde
   ex (sp),hl                  ; hl = & pos

   ld (hl),e                   ; write fp into pos*
   inc hl
   ld (hl),d
   inc hl
   pop de
   ld (hl),e
   inc hl
   ld (hl),d
   
   jp stdio_success_znc

defc ASMDISP_FGETPOS_CALLEE = # asmentry - fgetpos_callee
