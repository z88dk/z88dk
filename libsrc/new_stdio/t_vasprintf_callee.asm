; int __CALLEE__ t_vasprintf_callee(char **s, const char *fmt, void *arg_ptr)
; 05.2008 aralbrec

XLIB t_vasprintf_callee
XDEF ASMDISP_VASPRINTF_CALLEE

LIB t_vsnprintf_callee, malloc
XREF ASMDISP_VSNPRINTF_CALLEE

.t_vasprintf_callee

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
   ; exit  : hl  = number of chars allocated for buffer, -1 if error

   push bc                     ; save & parameter list
   push de                     ; save format string
   
   call t_vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE
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
   ld de,$ffff                 ; de = length of buffer (we know there is sufficient space)
   exx
   
   call t_vsnprintf_callee + ASMDISP_VSNPRINTF_CALLEE
   inc hl                      ; return size of malloced buffer (output length + one for \0)
   ret

.fail

   ; de' = 0
   
   exx
   ld (hl),e                   ; write 0 into char**s
   inc hl
   ld (hl),d
   exx
   
   ld hl,-1                    ; return -1 indicating malloc failed
   ret
   
defc ASMDISP_VASPRINTF_CALLEE = asmentry - t_vasprintf_callee
