
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fzx output driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __oterm_driver_fzx_00, __oterm_echo

EXTERN asm_fzx_putc, asm_fzx_write, _crt_scroll_
EXTERN error_enotsup_zc, error_lznc, error_znc, _fzx

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS

__oterm_driver_fzx_00:

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__fzx_putc:

   ; E' = char
   ; BC' = number > 0
   ; HL  = number > 0
   ;
   ; return HL = number of bytes successfully output
   ; carry reset

   push hl                     ; output length
    
   exx

__fzx_putc_loop:

   push bc
   push de
   
   ld a,e
   call __oterm_echo

__fzx_putc_cont:

   pop de
   pop bc

   dec bc
   
   ld a,b
   or c
   jr nz, __fzx_putc_loop

   pop hl                      ; say we output everything

   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

__writ_loop:

   call asm_fzx_write
   jr nc, __fzx_writ_exit
   
   ; screen full
   
   ; bc = num remaining chars
   ; de = void *buffer_ptr

   push bc
   push de
   
   call __oterm_scroll
   
   pop de
   pop bc

   jr __writ_loop              ; finish writing
   
__fzx_writ_exit:

   pop hl                      ; say we output everything
   pop ix
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__oterm_echo:

   ; a = output char
   ; preserve ix
   
   ld e,a
   
   push ix
   push de

   call asm_fzx_putc
   jr nc, __echo_done

   ; screen full
   
   call __oterm_scroll
   
   pop de
   push de
   
   ld a,e
   call asm_fzx_putc

__echo_done:

   pop de
   pop ix
   
   ret


__oterm_scroll:

   exx
   
   push bc
   push de
   push hl
   
   ld hl,(_fzx)                ; hl = struct fzx_font *
   ld l,(hl)                   ; l = font height in pixels
   
   ld a,(_fzx+5)               ; a = current y coordinate
   
   add a,l
   sub 192
   jr c, __no_scroll

   inc a
   ld hl,1

__amount_loop:

   sub 8
   jr c, __scroll
   
   inc l
   jr __amount_loop

__scroll:

   call _crt_scroll_

__no_scroll:

   pop hl
   pop de
   pop bc
   
   exx
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
