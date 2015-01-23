; stdio_out_d
; 05.2008 aralbrec

PUBLIC stdio_out_d
EXTERN stdio_numprec, stdio_outcommon
EXTERN LIBDISP_STDIO_OUTCOMMON_SIGNED

INCLUDE "../../stdio.def"

; output %d parameter
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

.stdio_out_d

   push hl                     ; save & parameter list

   bit 0,c
   jr z, positive

.negative

   or a
   ld hl,0                     ; de = -de without touching a
   sbc hl,de
   ex de,hl
   
.positive

   ;  a = precision
   ;  b = width
   ;  c = flags [-+ O#PLN]
   ; de = unsigned integer
   ; stack = & parameter list

   push bc                     ; save width and flags
   ld bc,10                    ; num chars in buffer = 0, radix = 10

   ld hl,STDIO_TEMPBUFSIZE + 7
   add hl,sp                   ; hl = & last char in temporary buffer
   
   call stdio_numprec          ; write number to buffer including precision digits

   pop de
   
   ;     b = num chars written to buffer
   ;     d = width
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   inc b                       ; no digits written to buffer means precision and integer == 0
   djnz noadj
   ld e,0                      ; in this case clear sign and zero-pad flags so they aren't printed too

.noadj

   call stdio_outcommon + LIBDISP_STDIO_OUTCOMMON_SIGNED
   pop hl                      ; hl = & parameter list
   ret
