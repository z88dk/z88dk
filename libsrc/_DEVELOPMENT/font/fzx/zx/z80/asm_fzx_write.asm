
; ===============================================================
; aralbrec - Nov 2013
; ===============================================================
;
; int fzx_write(void *buf, uint len)
;
; Render len chars from the buffer buf to screen using fzx_putc.
;
; ===============================================================

SECTION seg_code_fzx

PUBLIC asm_fzx_write

EXTERN asm_fzx_putc

asm_fzx_write:

   ; enter : de = void *buf
   ;         bc = len
   ;
   ; exit  : hl = number of chars written (<= len)
   ;         de = & first char in buf not written
   ;         bc = num unwritten chars
   ;
   ;         carry flag set if not all chars output successfully
   ;         (an off screen error)
   ;
   ; uses  : all except iy
   
   ld hl,0                     ; number of chars written

loop:

   ld a,b
   or c
   ret z
   
   ld a,(de)
   exx
   call asm_fzx_putc
   exx
   ret c                       ; error
   
   inc de
   inc hl
   
   dec bc
   jr loop
