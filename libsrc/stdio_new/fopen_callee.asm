; FILE __CALLEE__ *fopen_callee(char *filename, char *mode)
; 06.2008 aralbrec

XLIB fopen_callee
XDEF ASMDISP_FOPEN_CALLEE

LIB open_callee, stdio_parseperm, stdio_malloc, stdio_free
LIB stdio_error_enomem_zc, stdio_error_einval_zc, stdio_error_zc
XREF ASMDISP_OPEN_CALLEE

.fopen_callee

   pop hl
   pop de
   ex (sp),hl
   
.asmentry

   ; enter : hl = char *filename
   ;         de = char *mode
   ; exit  : hl = FILE * and carry reset for success
   ;         hl = 0 and carry set for fail

   ; 1. get memory for new struct FILE

   push hl                     ; save char *filename
   push de                     ; save char *mode
   
   ld bc,FILESTR_SZ            ; sizeof(struct FILE)
   call stdio_malloc           ; get memory for new FILE*
   jp nc, stdio_error_enomem_zc - 2
   
   ex (sp),hl
   
   ; 2. parse mode flags
   ;
   ; hl = char *mode
   ; stack = char *filename, FILE *
   
   call stdio_parseperm        ; a = b = mode flags
   pop hl
   pop de
   jp z, stdio_error_einval_zc ; mode flags not understood

   ; 3. open file
   ;
   ;  b = a = mode flags 0000 CIOA
   ; de = char *filename
   ; hl = FILE *

   push hl
   push af
   call open_callee + ASMDISP_OPEN_CALLEE  ; returns de = fdstruct *
   pop af                      ; a = mode flags
   pop hl                      ; hl = FILE *
   jr c, fail

   ; 4. fill in struct FILE
   ;
   ; de = fdstruct (0 offset)
   ;  a = mode flags 0000 0CIOA
   ; hl = FILE *

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

.fail

   call stdio_free             ; free struct FILE
   jp stdio_error_zc

defc ASMDISP_FOPEN_CALLEE = asmentry - fopen_callee
