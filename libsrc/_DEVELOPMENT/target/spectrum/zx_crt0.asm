
; zx spectrum crt0 for testing purposes

org 32768

XLIB start
XDEF _Exit

LIB _ff_ao_SoixanteQuatre, asm_fzx_write, asm_fzx_putc
LIB asm_memset, error_ebadf_zc, error_enotsup_zc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_defs.inc"
INCLUDE "crt_zx_defs.inc"

defc __heap_sz = 2048          ; malloc's heap, eliminate if not required
defc __qtbl_sz = 6             ; balloc's qtable, eliminate if not required

defc __exit_stack_sz      = 6  ; set to 0 if not required, default is 32
defc __quickexit_stack_sz = 6  ; set to 0 if not required, default is 32

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

start:

   ld (__sp),sp

   INCLUDE "../crt_init.asm"

   ; clear screen 

   ld e,0
   call cls
      
   ; initialize fzx state
   
   ld hl,_ff_ao_SoixanteQuatre
   ld (_fzx),hl                ; initial font
   
   ; call user program

   call _main                  ; hl holds return status

   INCLUDE "../crt_exit.asm"
   
_Exit:

   INCLUDE "../crt_cleanup.asm"

   ld sp,(__sp)
   ret

cls:

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

__FILE_STDIN:
   
   defb 195
   defw error_ebadf_zc         ; just return errors for now
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
   
   jp error_enotsup_zc

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

loop_0:

   ld a,e
   push de
   push bc
   
   call asm_fzx_putc
   call c, cls
   
   pop bc
   pop de
   
   dec bc
   
   ld a,b
   or c
   jr nz, loop_0

   pop hl                      ; say we output everything
   pop ix

   ret
    
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
   
   call c, cls                 ; error means end of screen reached
   
   pop hl                      ; say we output everything
   pop ix
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INCLUDE "../crt_vars.asm"
INCLUDE "../crt_stubs.asm"
