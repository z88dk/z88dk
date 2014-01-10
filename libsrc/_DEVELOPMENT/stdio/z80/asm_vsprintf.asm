
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vsprintf(char *s, const char *format, void *arg)
;
; As vfprintf but output is directed to a string.
;
; ===============================================================

XLIB asm_vsprintf

LIB asm0_vfprintf_unlocked, asm_memset, asm_memcpy

asm_vsprintf:

   ; enter : de  = char *format
   ;         bc  = void *stack_param = arg
   ;         de' = char *s
   ;
   ; exit  : de  = char *format (next unexamined char)
   ;         hl' = char *s (address of terminating '\0')
   ;
   ;         success
   ;
   ;            hl = number of chars output to string not including '\0'
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = - (chars output + 1) < 0
   ;            carry set, errno set as below
   ;
   ;            erange = width or precision out of range
   ;            einval = unknown printf conversion
   ;
   ; note  : High level stdio uses hl' to track number of chars
   ;         written to the stream but modifies no other exx registers
   ;            
   ; uses  : all

   ; create a fake FILE structure on the stack
   
   ld hl,0
   push hl
   ld hl,$4000 + (vsprintf_outchar / 256)
   push hl
   ld hl,195 + ((vsprintf_outchar % 256) * 256)
   push hl
   
   ld ix,0
   add ix,sp                   ; ix = vsprintf_file *
   
   ; print to string
   
   call asm0_vfprintf_unlocked
   
   ; repair stack
   
   pop bc
   pop bc
   pop bc
   
   ; terminate string
   
   exx
   ex de,hl
   ld (hl),0
   exx
   
   ret

vsprintf_outchar:

   cp STDIO_MSG_PUTC
   jr z, _putc
   
_writ:

   ; de  = char *s
   ; hl  = length > 0
   ; hl' = void *buffer
   ; bc' = length > 0

   push de
   exx
   pop de
   
   call asm_memcpy
   
   push de
   exx
   pop de
   
   ret

_putc:

   ; de  = char *s
   ; hl  = number > 0
   ;  e' = char
   ; bc' = number > 0
   
   push de
   exx
   pop hl
   
   call asm_memset
   
   push de
   exx
   pop de
   
   ret
