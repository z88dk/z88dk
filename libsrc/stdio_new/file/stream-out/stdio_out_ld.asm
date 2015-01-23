; stdio_out_ld
; 05.2008 aralbrec

PUBLIC stdio_out_ld
EXTERN stdio_longnumprec, stdio_outcommon, stdio_nextarg
EXTERN l_int2long_s, l_long_neg
EXTERN LIBDISP_STDIO_OUTCOMMON_SIGNED

INCLUDE "../../stdio.def"

; output %ld parameter, handles both 16-bit %d and 32-bit %ld
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


.stdio_out_ld

   bit 1,c                     ; check if %ld or %d
   jr nz, long

   push hl                     ; save & parameter list
   push af                     ; save precision
   ex de,hl                    ; only doing integer so form long in dehl
   call l_int2long_s           ; sign extend hl into dehl
   jr checksign

.long

   push de                     ; save most sig 16-bits
   call stdio_nextarg          ; get next 16-bit word from parameter list
   ex (sp),hl                  ; save & parameter list
   ex de,hl                    ; dehl = long
   push af                     ; save precision

.checksign

   bit 0,c
   call nz, l_long_neg         ; get magnitude if negative
   pop af

   ;    a = precision
   ;    b = width
   ;    c = flags [-+ O#PLN]
   ; dehl = unsigned integer

   push ix                     ; save output function
   push bc                     ; save width and flags
   ld bc,10                    ; num chars in buffer = 0, radix = 10
   
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

   call stdio_outcommon + LIBDISP_STDIO_OUTCOMMON_SIGNED
   pop hl                      ; hl = & parameter list
   ret
