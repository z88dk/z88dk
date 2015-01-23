; stdio_out_caplx
; 05.2008 aralbrec

PUBLIC stdio_out_caplx
EXTERN stdio_out_lx

; output %lX parameter, handles 16-bit %X and 32-bit %lX
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

.stdio_out_caplx

   scf
   jp stdio_out_lx
