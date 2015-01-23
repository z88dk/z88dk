; stdio_out_p
; 05.2008 aralbrec

PUBLIC stdio_out_p
EXTERN stdio_out_x

; output %p parameter
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
; uses  : af, bc, de, hl, exx

.stdio_out_p

   set 3,c
   bit 2,c
   jp nz, stdio_out_x
   
   set 2,c
   ld a,4
   jp stdio_out_x

