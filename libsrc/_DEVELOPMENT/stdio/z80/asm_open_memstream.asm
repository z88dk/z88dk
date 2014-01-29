
; ===============================================================
; Jan 2014
; ===============================================================
; 
; FILE *open_memstream(char **bufp, size_t *sizep)
;
; Associate a growable write-only memory buffer with a stream.
;
; This function provides an unnecessarily reduced interface
; to underlying memory streams for growable buffers.  A better
; non-standard function can be found in _fmemopen.
;
; ===============================================================

XLIB asm_open_memstream

LIB asm__fmemopen

asm_open_memstream:

   ; enter : de = char **bufp
   ;         hl = size_t *sizep
   ;
   ; exit  : success
   ;
   ;            hl = FILE *
   ;            ix = FILE *
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = 0
   ;            carry set
   ;
   ; uses  : af, bc, de, hl, ix

   xor a
   ld (hl),a
   inc hl
   ld (hl),a                   ; set size = 0, forcing new allocation
   dec hl

   ld c,l
   ld b,h                      ; bc = size_t *p
   
   ex de,hl                    ; hl = char **bufp

   ld a,$00001100              ; disallow unknown mode chars
   ld de,mode                  ; create an expanding write only buffer

   jp asm__fmemopen

mode:

   defm "wx"
   defb 0
