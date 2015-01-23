; stdio_out_caplp
; 05.2008 aralbrec

PUBLIC stdio_out_caplp
EXTERN stdio_out_lx

; output %lP parameter, handles 16-bit %P and 24-bit %lP
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

.stdio_out_caplp

   set 3,c
   scf
   bit 2,c
   jp nz, stdio_out_lx
   
   set 2,c
   ld a,6
   jp stdio_out_lx

