
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bdos output driver ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC __bdoscons_driver_00

EXTERN error_enotsup_zc, error_lznc, error_znc

EXTERN STDIO_MSG_PUTC, STDIO_MSG_WRIT, STDIO_MSG_SEEK
EXTERN STDIO_MSG_FLSH, STDIO_MSG_CLOS

__bdoscons_driver_00:

   cp STDIO_MSG_PUTC
   jr z, __bdos_putc
   
   cp STDIO_MSG_WRIT
   jr z, __bdos_writ
   
   cp STDIO_MSG_SEEK
   jp z, error_lznc            ; do nothing, report no error
   
   cp STDIO_MSG_FLSH
   jp z, error_znc             ; do nothing, report no error
   
   cp STDIO_MSG_CLOS
   jp z, error_znc             ; do nothing, report no error
   
   jp error_enotsup_zc         ; hl = 0 puts stream in error state

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdos_putc:

   ; E' = char
   ; BC' = number > 0
   ; HL  = number > 0
   ;
   ; return HL = number of bytes successfully output
   ; carry reset
    
   push ix
   push hl                     ; output length
    
   exx
   
   ld   a,e
   exx
   cp   12      ; FF (CLS) ?
   jr   z,__bdos_putc_docls
   cp   13      ; CR ?
   jr   nz,__bdos_putc_nocrlf
   ld   de,10
   ld   c,2
   push af
   call 5
   pop  af
   ld   a,13
__bdos_putc_nocrlf:
   ld   e,a
   ld   d,0
   ld   c,2
   call 5
   pop  hl                      ; say we output everything
   pop  ix
   and  a
   ret 
   
__bdos_putc_docls:
   ;  This is the ANSI CLS call
   ld      e,27
   ld      c,2
   call    5
   ld      e,'['
   ld      c,2
   call    5
   ld      e,'J'
   ld      c,2
   call    5
   pop     hl
   pop     ix
   and     a
   ret
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

__bdos_writ:

   ; BC' = length > 0
   ; HL' = void *buffer = byte source
   ; HL  = length > 0
   ; 
   ; return HL = number of bytes successfully output
   ; carry reset

   push ix
   push hl                     ; save output length
   exx
__bdos_writ_loop:
   ld   a,(hl)
   exx
   ld   e,a
   ld   c,2
   call 5
   exx
   inc hl
   dec bc
   ld  a,b
   or  c
   jr  nz,__bdos_writ_loop
   exx
   pop hl                      ; say we output everything
   pop ix
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

