
; ===============================================================
; Jan 2014
; ===============================================================
; 
; int vsscanf(const char *s, const char *format, va_list arg)
;
; As vfscanf() but input source is a string rather than a file.
;
; ===============================================================

XLIB asm_vsscanf

LIB asm_strnlen, asm__memstrcpy, l_jphl, error_mnc
LIB asm0_vfscanf_unlocked, error_einval_zc, error_mc

asm_vsscanf:

   ; enter : hl = char *s
   ;         de = char *format
   ;         bc = void *stack_param = arg
   ;
   ; exit  : bc = char *s (next unexamined char)
   ;         de = char *format (next unexamined char, '\0' on success)
   ;         hl = number of items assigned
   ;         de'= number of chars consumed from the stream
   ;         hl'= number of items assigned
   ;
   ;         success
   ;
   ;            carry reset
   ;
   ;         fail
   ;
   ;            carry set, errno set as below
   ;
   ;            einval = s is NULL
   ;            einval = unknown conversion specifier
   ;            einval = error during scanf conversion
   ;            erange = width out of range
   ;            
   ; uses  : all

   ld a,h
   or l
   jr z, error_s_null          ; if s == NULL

   ; create a fake FILE structure on the stack
   
   push hl                     ; char *s is stored in the FILE *
   ld hl,$8000 + (sscanf_inchar / 256)
   push hl
   ld hl,195 + ((sscanf_inchar % 256) * 256)
   push hl
   
   ld ix,0
   add ix,sp                   ; ix = sscanf FILE *
   
   ; scan the string
   
   call asm0_fscanf_unlocked
   
   pop bc                      ; repair stack
   pop bc
   pop bc                      ; bc = char *s (next unexamined char)

   ret

sscanf_inchar:

   ; vfscanf will generate three messages
   ; STDIO_MSG_EATC, STDIO_MSG_READ, STDIO_MSG_SEEK

   cp STDIO_MSG_READ
   jr z, _read
   
   cp STDIO_MSG_SEEK
   jr z, _seek

_eatc:

   ; hl = number of chars to read
   ; hl'= qualify function
   ; bc'= reserved
   ; de'= reserved
   
   ld c,l
   ld b,h
   inc bc                      ; bc = max chars to read + 1
   
   ld de,$ffff                 ; de = number of chars read - 1
   
   ld l,(ix+4)
   ld h,(ix+5)
   dec hl                      ; hl = char *s - 1

_eatc_loop:

   inc de
   
   ; bc = max chars to read + 1
   ; de = number of chars read
   ; hl = char *s - 1

   cpi                         ; hl++, bc--
   
   ld a,(hl)                   ; a = next char to consume
   jp po, return_max_reached   ; if max chars to consume reached

   or a
   jr z, return_eof            ; if string exhausted
   
   exx
   call l_jphl                 ; qualify the character
   exx
   
   jr nc, _eatc_loop           ; if char qualifies

return_unqualified:
   
   ld (ix+4),l
   ld (ix+5),h                 ; write char *s to file structure
   
   ld l,a
   ld h,0                      ; hl = next unconsumed char
   
   ld c,e
   ld b,d                      ; bc = number of bytes consumed from string
   
   or a                        ; report no error
   ret

return_eof:

   call return_unqualified
   jp error_mc                 ; hl = -1, carry set for eof error

return_max_reached:

   call return_unqualified
   ret nz                      ; if next char is not eof

   jp error_mnc                ; indicate next char will be eof

_read:

   ; hl = length > 0
   ; de'= void *buffer (destination)
   ; bc'= length > 0

   exx
   
   ld l,(ix+4)
   ld h,(ix+5)                 ; hl = char *s
   
   call asm__memstrcpy
   
   ld (ix+4),l
   ld (ix+5),h                 ; update char *s
   
   push bc
   
   exx
   
   pop bc                      ; bc = length_remaining

   sbc hl,bc                   ; hl = num bytes copied
   
   ld a,b
   or c
   
   ld c,l
   ld b,h                      ; bc = num bytes copied

   ret z                       ; if request completely satisfied
   
   ; EOF reached, only reason request cannot be satisfied
   
   jp error_mc

_seek:

   ; vfscanf will only generate a seek forward
   ; only supplies correct answers rather than proper implementation

   ; dehl'= file offset (0 for report position) <= $ffff
   
   exx
   
   ld c,l
   ld b,h                      ; bc = seek forward length
   
   ld l,(ix+4)
   ld h,(ix+5)                 ; hl = char *s
   
   call asm_strnlen
   add hl,de                   ; hl = new char *s
   
   ld (ix+4),l
   ld (ix+5),h
   
   exx
      
   or a
   ret

error_s_null:

   ld c,l
   ld b,h
   
   exx
   
   ld de,0
   ld l,e
   ld h,d

   exx
   
   jp error_einval_zc
