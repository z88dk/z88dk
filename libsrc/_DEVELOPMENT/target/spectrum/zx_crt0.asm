
; zx spectrum crt0 for testing purposes

org 32768

XLIB start
XDEF _Exit

LIB _ff_ao_SoixanteQuatre, asm_fzx_write, asm_fzx_putc, l_jphl
LIB asm_memset, error_ebadf_zc, error_enotsup_zc, error_znc, error_lznc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_defs.inc"      ; crt defines
INCLUDE "crt_zx_defs.inc"      ; crt defines varying by target

defc __heap_sz = 2048          ; malloc's heap, eliminate if not required
defc __qtbl_sz = 6             ; balloc's qtable, eliminate if not required

defc __exit_stack_sz      = 6  ; set to 0 if not required, default is 32
defc __quickexit_stack_sz = 6  ; set to 0 if not required, default is 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:

   ld (__sp),sp

   IF STACKPTR                 ; pragma to locate stack
   
      ld sp,STACKPTR
   
   ENDIF

   INCLUDE "../crt_init.asm"   ; intialize crt state

   ; clear screen 

   ld e,0
   call cls                    ; clear screen, set fzx coord to (0,0)
      
   ; initialize fzx state
   
   ld hl,_ff_ao_SoixanteQuatre
   ld (_fzx),hl                ; initial font
   
   ; call user program

   call _main                  ; hl holds return status

   INCLUDE "../crt_exit.asm"   ; run exit stack
   
_Exit:

   INCLUDE "../crt_cleanup.asm"  ; close files 

   ld c,l
   ld b,h                      ; return status to basic

   ld sp,(__sp)
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__FILE_STDIN:
   
   defb 195                    ; jp driver
   defw __kbd_driver
   defb $80                    ; open for reading
   defb $02                    ; last op was read, to skip auto-flush
   defb 0
   defb 0
   defs 6                      ; mutex

__FILE_STDOUT:

   defb 195                    ; jp driver
   defw __fzx_driver
   defb $40                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

__FILE_STDERR:

   ; separate from stdout allows output
   ; even when stdout is in an error state

   defb 195                    ; jp driver
   defw __fzx_driver
   defb $40                    ; open for writing
   defb 0
   defb 0
   defb 0
   defs 6                      ; mutex

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_vars.asm"      ; crt variable declarations
INCLUDE "../crt_stubs.asm"     ; crt stubs for unimplemented lib functions

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

cls:

   ; e = attr
   
   ; attributes
   
   ld hl,$5800
   ld bc,768
   
   call asm_memset

   ; reset fzx
   
   ld hl,0
   ld (_fzx + 2),hl
   ld (_fzx + 4),hl

   ; pixels
   
   ld e,0
   ld hl,$4000
   ld bc,6144
   
   jp asm_memset

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; fzx state

XDEF _fzx

_fzx:   defs 6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; fzx output driver

__fzx_driver:

   cp STDIO_MSG_PUTC
   jr z, __fzx_putc
   
   cp STDIO_MSG_WRIT
   jr z, __fzx_writ
   
   cp STDIO_MSG_SEEK
   jp z, error_lznc            ; do nothing, report no error
   
   cp STDIO_MSG_FLSH
   jp c, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state

;;

__fzx_putc:

   ; E' = char
   ; BC' = number > 0
   ; HL  = number > 0
   ;
   ; return HL = number of bytes successfully output
   ; carry reset
    
   push ix
   push hl                     ; output length
    
   exx

__fzx_putc_loop:

   push bc
   push de
   
   ld a,e
   call asm_fzx_putc
   
   jr nc, __fzx_putc_cont
   
   ; screen full
   
   call cls
   
   pop de
   pop bc
   
   push bc
   push de
   
   ld a,e
   call asm_fzx_putc           ; try again

__fzx_putc_cont:

   pop de
   pop bc

   dec bc
   
   ld a,b
   or c
   jr nz, __fzx_putc_loop

   pop hl                      ; say we output everything
   pop ix

   ret

;;

__fzx_writ:

   ; BC' = length > 0
   ; HL' = void *buffer = byte source
   ; HL  = length > 0
   ; 
   ; return HL = number of bytes successfully output
   ; carry reset

   push ix
   push hl                     ; save output length
   
   exx
   ex de,hl                    ; de = buffer
   
   call asm_fzx_write
   jr nc, __fzx_writ_exit
   
   ; screen full
   
   ; bc = num remaining chars
   ; de = void *buffer_ptr

   push bc
   push de
   
   call cls
   
   pop de
   pop bc

   call asm_fzx_write          ; finish writing
   
__fzx_writ_exit:

   pop hl                      ; say we output everything
   pop ix
   
   or a
   ret
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; simple keyboard driver

__kbd_driver:

   cp STDIO_MSG_GETC
   jr z, __kbd_getc
   
   cp STDIO_MSG_EATC
   jr z, __kbd_eatc
   
   cp STDIO_MSG_READ
   jr z, __kbd_read
   
   cp STDIO_MSG_SEEK
   jr z, __kbd_seek
   
   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_CLOS
   jp c, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state

;;

__kbd_eatc:

   ; HL'= int (*qualify)(char c)
   ; BC'= optional
   ; DE'= optional
   ; HL = max_length = number of stream chars to consume
   ; 
   ; return: BC = number of bytes consumed from stream
   ;         HL = next unconsumed (unmatching) char or EOF
   ;         BC'= unchanged by driver
   ;         DE'= unchanged by driver
   ;         HL'= unchanged by driver

   ld c,l
   ld b,h                      ; bc = max num chars to consume
   
   ld de,-1                    ; de = num chars consumed - 1
   
__kbd_eatc_loop:

   call __kbd_getchar          ; l = char
   inc de                      ; de = num chars consumed
   
   ld a,b
   or c
   jr z, __kbd_eatc_exit       ; if max num reached
   
   ld a,l                      ; a = char
   exx
   call l_jphl                 ; qualify(a)
   exx
   
   jr c, __kbd_eatc_exit       ; if char is disqualified
   
   dec bc                      ; num chars remaining to consume -= 1
   jr __kbd_eatc_loop

__kbd_eatc_exit:

   ; de = num chars consumed from stream
   ;  l = next unconsumed char

   xor a
   ld h,a                      ; hl = next consumed char
   
   ld a,l
   ld (23560),a                ; shove unconsumed char back into LASTK, may not last

   ld c,e
   ld b,d                      ; bc = num chars consumed

   ret                         ; carry reset

;;

__kbd_read:

   ; DE'= void *buffer = byte destination
   ; BC'= max_length > 0
   ; HL = max_length > 0
   ;
   ; return BC = number of bytes successfully read
   ;        DE'= void *buffer_ptr = address of byte following last written
   ;        carry set on error with HL=0 for stream error, -1 for eof

   ; we never have stream errors or eof
   
   exx
   
__kbd_read_loop:

   ld a,b
   or c
   jr z, __kbd_read_exit       ; if no more chars to read
   
   dec bc
   call __kbd_getchar
   
   ld (de),a                   ; write char to buffer
   inc de
   
   jr __kbd_read_loop

__kbd_read_exit:

   exx
   
   ld c,l
   ld b,h                      ; bc = max_length
   
   ret                         ; carry is reset

;;

__kbd_seek:

   ; stdio uses seek forward to ignore input chars for %*[n]c
 
   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return DEHL = current position, carry on error

   exx
   
   ld a,c
   
   CP STDIO_SEEK_CUR
   jp nz, error_lznc           ; if not seeking forward, do nothing

   bit 7,d
   jp nz, error_lznc           ; if negative offset, do nothing
   
   ; dehl = number of chars to seek past
   ; if de != 0 the universe will be over before we are done so ignore it

   ex de,hl                    ; de = number of chars to consume

__kbd_seek_loop:

   ld a,d
   or e
   jp z, error_lznc            ; if num chars == 0

   dec de

   call __kbd_getchar
   jr __kbd_seek_loop
;;

__kbd_getchar:

   ld a,(23560)                ; LASTK
   
   or a
   jr z, __kbd_getchar         ; if no keypress

   ld l,a
   
   xor a
   ld (23560),a                ; consume the keypress
   
   ld a,l
   ret
