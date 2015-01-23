; stdio_out_lo
; 05.2008 aralbrec

PUBLIC stdio_out_lo
EXTERN stdio_longnumprec, stdio_outcommon, stdio_nextarg

INCLUDE "../../stdio.def"

; output %lo parameter, handles both 16-bit %o and 32-bit %lo
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


.stdio_out_lo

   bit 1,c                     ; check if %lo or %o
   jr nz, long

   push hl                     ; save & parameter list
   ex de,hl                    ; generate unsigned long in dehl
   ld de,0
   jr doneparam

.long

   push de                     ; save most sig 16-bits
   call stdio_nextarg          ; get next 16-bit word from parameter list
   ex (sp),hl                  ; save & parameter list
   ex de,hl                    ; dehl = long

.doneparam

   ;    a = precision
   ;    b = width
   ;    c = flags [-+ O#PLN]
   ; dehl = unsigned integer

   push ix                     ; save output function
   push bc                     ; save width and flags
   ld bc,8                     ; num chars in buffer = 0, radix = 8
   
   ld ix,STDIO_TEMPBUFSIZE + 9
   add ix,sp                   ; ix = & last char in temporary buffer
   
   call stdio_longnumprec      ; write number to buffer including precision digits
   
   pop hl
   ld e,ixl
   ld d,ixh
   ex de,hl
   pop ix
   
   ;     b = num chars written to buffer
   ;     d = width
   ;     e = flags [-+ O#PLN]
   ;    hl = & next free position in destination buffer

   inc b                       ; no digits written to buffer means precision and integer == 0
   djnz adjwidth
   ld e,0                      ; in this case clear sign and zero-pad flags so they aren't printed too

.adjwidth

   bit 3,e
   jr z, noindicator

.addbaseindicator

   ld (hl),'0'
   dec hl
   inc b

.noindicator

   call stdio_outcommon
   pop hl                      ; hl = & parameter list
   ret
