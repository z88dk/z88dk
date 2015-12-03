
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int obstack_vprintf(struct obstack *obstack, const char *format, void *arg)
;
; Similar to snprintf but attempts to append the output
; string to the currently growing object in the obstack.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_obstack_vprintf

EXTERN asm_vsnprintf, l_utod_hl, asm_obstack_blank, error_mc

asm_obstack_vprintf:

   ; enter : de  = char *format
   ;         bc  = void *arg
   ;         hl  = struct obstack *obstack
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            hl   = strlen(generated s)
   ;            hl'  = address of terminating '\0' in obstack
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl   = -1
   ;            carry set, errno as below
   ;
   ;            enomem = insufficient memory for buffer
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;            
   ; uses  : all
   
   push bc                     ; save arg
   push de                     ; save format
   push hl                     ; save obstack
   
   ; use vsnprintf to determine length of result
   
   exx
   ld bc,0
   exx
   
   call asm_vsnprintf          ; hl = length of result
   jr c, error_3               ; if error

   inc hl                      ; add room for terminating '\0'
   call l_utod_hl              ; saturate hl
   
   ; attempt to grow object
   
   ld c,l
   ld b,h                      ; bc = size
   
   ex (sp),hl                  ; hl = obstack
   
   call asm_obstack_blank      ; de = char *s
   jr c, error_3               ; if allocation failed

   ; no errors to here so can assume no more errors will occur
   
   ; de  = char *s
   ; stack = arg, format, length

   push de
   exx
   pop de                      ; de = char *s
   pop bc                      ; bc = length
   exx
   pop de                      ; de = format
   pop bc                      ; bc = void *arg
      
   ; de' = char *s
   ; bc' = length
   ; de  = char *format
   ; bc  = void *arg
   
   jp asm_vsnprintf

error_3:

   pop de

error_2:

   pop de
   pop bc
   
   jp error_mc
