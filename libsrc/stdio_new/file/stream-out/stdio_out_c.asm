; stdio_out_c
; 05.2008 aralbrec

PUBLIC stdio_out_c
EXTERN stdio_outchar, stdio_outpad

; output %c parameter
;
; enter :     ix  = FILE *
;               a = precision (default 1)
;               b = width (default 0)
;               c = flags [-+ O#PLN]
;              de = 16-bit parameter (most significant word if long)
;              hl = & parameter list
;             bc' = total num chars output on stream thus far
;             carry flag reset (important for %x, %lx)
;           stack = output buffer, ptr in format string, ret
; on exit :   bc' = total num chars output on stream thus far
;              hl = & parameter list
;         carry set if error on stream, ERRNO set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_c

   push hl                     ; save & parameter list
   call dorest
   pop hl                      ; hl = & parameter list
   ret

.dorest

   inc b                       ; make width at least 1
   djnz widthok
   inc b
   
.widthok

   bit 7,c
   jr z, rightjustified

.leftjustified

   ld a,e
   call stdio_outchar
   ret c
   
   djnz satisfywidth
   ret
      
.satisfywidth

   ld c,' '
   jp stdio_outpad

.rightjustified

   dec b
   call nz, satisfywidth
   ret c
   
   ld a,e
   jp stdio_outchar
