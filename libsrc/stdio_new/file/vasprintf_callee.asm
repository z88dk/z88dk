; int __CALLEE__ vasprintf_callee(char **s, const char *fmt, void *arg_ptr)
; 05.2008 aralbrec

PUBLIC vasprintf_callee
PUBLIC ASMDISP_VASPRINTF_CALLEE

EXTERN vsnprintf_callee, malloc, stdio_error_enomem_mc
EXTERN ASMDISP_VSNPRINTF_CALLEE

.vasprintf_callee

   pop hl
   pop bc
   pop de
   exx
   pop hl
   ld de,0
   exx
   push hl

.asmentry

   ; enter : de  = format string
   ;         bc  = & parameter list (arg_ptr)
   ;         hl' = char **s
   ;         de' = 0
   ; exit  : hl  = number of chars written to destination string not incl \0, -1 and carry if error

   push bc                     ; save & parameter list
   push de                     ; save format string
   
   call vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE
   inc hl                      ; size of buffer required for output string
   
   call malloc                 ; try to allocate it
   pop de                      ; format string
   pop bc                      ; & parameter list
   jr nc, fail                 ; if allocation failed...
   
   push hl                     ; malloced buffer address
   exx
   pop de
   ld (hl),e                   ; write buffer address into char**s
   inc hl
   ld (hl),d
   ex de,hl                    ; hl = destination buffer address
   ld de,$ffff                 ; size of buffer (we know there's enough space)
   exx
   
   jp vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE

.fail

   ; de' = 0
   
   exx
   ld (hl),e                   ; write 0 into char**s
   inc hl
   ld (hl),d
   exx
   jp stdio_error_enomem_mc
   
defc ASMDISP_VASPRINTF_CALLEE = # asmentry - vasprintf_callee
