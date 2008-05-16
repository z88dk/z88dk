; stdio_out_u
; 05.2008 aralbrec

XLIB stdio_out_u
XDEF DISP_STDIO_OUT_U_COMMON
LIB stdio_numprec, stdio_outbuff, stdio_outpad

INCLUDE "stdio.def"

; output %u parameter
;
; enter :    ix  = & attached file / device output function
;             a = precision
;             b = width
;             c = flags [-+ O#P0N]
;            de = integer
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
; exit  :   bc' = total num chars output on stream thus far
;         stack = & parameter list
;         carry set if error on stream, a = (errorno) set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_u

   ex (sp),hl
   push hl
   push bc                     ; save width and flags
   
   ld bc,10                    ; num chars in buffer = 0, radix = 10
   ld hl,STDIO_TEMPBUFSZ + 7
   add hl,sp                   ; hl = & last char in temporary buffer
   
   call stdio_numprec          ; write number to buffer including precision digits
   pop de

   ;     b = num chars written to buffer
   ;     d = width
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   inc b                       ; no digits written to buffer means precision and integer == 0
   djnz commonentry
   ld e,0                      ; in this case clear zero-pad flag so zeroes aren't written

.commonentry

   ;     b = num chars written to buffer
   ;     d = width
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   bit 7,e
   jr z,rightjustified

.leftjustified

   ld e,b                      ; e = num chars in buffer
   call stdio_outbuff
   ret c
   
   ld a,d                      ; satisfy width parameter
   sub e
   ccf
   ret nc                      ; if satisfied return with no carry (no stream error)
   
   ld b,a
   ld c,' '
   jp stdio_outpad

.rightjustified

   ld a,d                      ; first satisfy width requirement
   sub b
   ld d,b
   jr c, nopad

   ld b,a                      ; pad with zeroes or spaces
   ld c,' '
   bit 4,e
   jr z, spacefiller

.zerofiller

   ld c,'0'

.spacefiller

   call stdio_outpad
   ret c

.nopad

   ;     d = num chars written to buffer
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   ld b,d
   jp stdio_outbuff

DEFC DISP_STDIO_OUT_U_COMMON = commonentry - stdio_out_u
