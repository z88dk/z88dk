
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vasprintf(char **ptr, const char *format, void *arg)
;
; Similar to snprintf but attempts to dynamically allocate
; a buffer using malloc to store the output string.
;
; ===============================================================

SECTION code_clib
SECTION code_stdio

PUBLIC asm_vasprintf

EXTERN asm_vsnprintf, error_einval_mc, l_utod_hl, asm_malloc, error_mc

asm_vasprintf:

   ; enter : de  = char *format
   ;         bc  = void *arg
   ;         de' = char **ptr
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;
   ;         success
   ;
   ;            *ptr = char *s (address of allocated buffer)
   ;            hl   = strlen(s)
   ;            hl'  = char *s (address of terminating '\0' in allocated buffer)
   ;            carry reset
   ;
   ;         fail
   ;
   ;            *ptr = 0 (if ptr != 0)
   ;            hl   = -1
   ;            carry set, errno as below
   ;
   ;            enomem = insufficient memory for buffer
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;            einval = ptr is NULL
   ;            
   ; uses  : all

   ; check for invalid ptr
   
   exx
   ld a,d
   or e                        ; ptr == 0 ?
   
   ld bc,0                     ; initialization for vsnprintf
   exx
   
   jp z, error_einval_mc       ; if ptr == NULL
   
   ; use vsnprintf to determine length of result
   
   push bc                     ; save arg
   push de                     ; save format
   
   call asm_vsnprintf          ; hl = length of result
   jr c, error_2               ; if error

   inc hl                      ; add room for terminating '\0'
   call l_utod_hl              ; saturate hl
   
   ; allocate a buffer
   
   push hl                     ; save length
   
   call asm_malloc             ; hl = char *s
   jr c, error_3               ; if allocation failed

   ; no errors to here so can assume no more errors will occur
   
   ; hl  = char *s
   ; hl' = char **ptr
   ; stack = arg, format, length
   
   push hl
   exx
   pop de                      ; de = char *s

   ld (hl),e
   inc hl
   ld (hl),d                   ; *ptr = s
   
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
   
   exx

   ld (hl),0
   inc hl
   ld (hl),0                   ; *ptr = 0
   
   exx
   jp error_mc
