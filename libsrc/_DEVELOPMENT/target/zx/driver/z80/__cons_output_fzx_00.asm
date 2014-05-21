
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fzx output driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __cons_output_fzx_00, __cons_output_echo, __cons_output_scroll

; fzx used to generate console output
; ROM independent

EXTERN asm_fzx_putc, asm_fzx_write, asm_cons_scroll_00
EXTERN error_enotsup_zc, error_lznc, error_znc, _fzx

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS

__cons_output_fzx_00:

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
   call __cons_output_echo

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
   jr c, __writ_screen_full

   pop hl                      ; say we output everything
   pop ix

   ret

__writ_screen_full:
   
   ; bc = num remaining chars
   ; de = void *buffer_ptr

   push bc
   push de
   
   call __cons_output_scroll
   
   pop de
   pop bc

   jr __writ_loop              ; finish writing

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__cons_output_echo:

   ; enter :  a = output char
   ; 
   ; uses  : all except ix, bc', de', hl'
   
   ld e,a
   push ix

__echo_loop:

   push de
   
   call asm_fzx_putc
   jr c, __echo_screen_full

   pop de
   pop ix
   
   ret

__echo_screen_full:

   call __cons_output_scroll
   
   pop de
   jr __echo_loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__cons_output_scroll:

   ; scroll upward by a number of character rows such that
   ; another line of fzx text can be written
   ;
   ; uses : all except ix, bc', de', hl'

   exx
   
   push bc
   push de
   push hl
   
   ld hl,(_fzx)                ; hl = struct fzx_font *
   ld l,(hl)                   ; l = font height in pixels
   
   ld a,(_fzx+5)               ; a = current y coordinate
   
   add a,l
   sub 192
   jr c, __scroll_done

   inc a
   ld hl,1

__amount_loop:

   sub 8
   jr c, __scroll
   
   inc l
   jr __amount_loop

__scroll:

   ; adjust fzx state
   
   xor a
   ld (_fzx+4),a               ; x coordinate = 0
   
   ld a,l
   add a,a
   add a,a
   add a,a
   ld e,a
   
   ld a,(_fzx+5)
   sub e
   ld (_fzx+5),a               ; y coordinate -= L * 8

   call asm_cons_scroll_00

__scroll_done:

   pop hl
   pop de
   pop bc
   
   exx
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
