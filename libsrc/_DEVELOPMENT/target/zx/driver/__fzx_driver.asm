
;; fzx output driver ;;;;;;;;;;

EXTERN asm_fzx_putc, asm_fzx_write
EXTERN error_enotsup_zc, error_lznc, error_znc

__fzx_driver:

   cp STDIO_MSG_PUTC
   jr z, __fzx_putc
   
   cp STDIO_MSG_WRIT
   jr z, __fzx_writ
   
   cp STDIO_MSG_SEEK
   jp z, error_lznc            ; do nothing, report no error
   
   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
   
   call cls                    ; also resets fzx state
   
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
   
   call cls                    ; also resets fzx state
   
   pop de
   pop bc

   call asm_fzx_write          ; finish writing
   
__fzx_writ_exit:

   pop hl                      ; say we output everything
   pop ix
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
