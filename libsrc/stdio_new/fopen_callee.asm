; FILE __CALLEE__ *fopen_callee(char *filename, char *mode)
; 06.2008 aralbrec

XLIB fopen_callee
XDEF ASMDISP_FOPEN_CALLEE

LIB open, stdio_malloc, stdio_free, stdio_parseperm
LIB stdio_error_einval_zc, stdio_error_enomem_zc, stdio_error_zc
XREF ASMDISP_OPEN

.fopen_callee

   pop hl
   pop de
   ex (sp),hl
   
.asmentry

   ; enter : hl = char *filename
   ;         de = char *mode
   ; exit  : hl = FILE * and carry reset for success
   ;         hl = 0 and carry set for fail
   
   push hl                     ; save char *filename
   push de                     ; save char *mode
   
   ld bc,FILESTR_SZ            ; sizeof(struct FILE)
   call stdio_malloc           ; get memory for new FILE*
   jp nc, stdio_error_enomem_zc - 2
   
   ex (sp),hl
   
   ; hl = char *mode
   ; stack = char *filename, FILE *
   
   call stdio_parseperm        ; a = b = mode flags
   jp z, stdio_error_einval_zc - 2
   
   pop hl
   ex (sp),hl
   
   ; hl = char *filename
   ;  b = a = mode flags 0000 CIOA
   ; stack = FILE *
   
   push af
   call open + ASMDISP_OPEN    ; returns de = fdstruct *
   pop af                      ; a = mode flags
   pop hl                      ; hl = FILE *
   jr nc, allgood

   call stdio_free             ; free struct FILE
   jp stdio_error_zc
   
.allgood

   ld (hl),195                 ; fill in the FILE struct
   inc hl
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   and $06                     ; only interested in r/w flag bits
   ld (hl),a
   dec hl
   dec hl
   dec hl
   
   ret
   
defc ASMDISP_FOPEN_CALLEE = asmentry - fopen_callee
