; stdio_out_n
; 05.2008 aralbrec

PUBLIC stdio_out_n

; output %n parameter
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
; uses  : f, de, hl

.stdio_out_n

   push hl                     ; save & parameter list
   
   ex de,hl                    ; hl = int *

   exx
   push bc
   exx
   pop de                      ; de = number of chars output thus far
   
   ld (hl),e
   inc hl
   ld (hl),d
   
   pop hl                      ; hl = & parameter list
   or a
   ret
