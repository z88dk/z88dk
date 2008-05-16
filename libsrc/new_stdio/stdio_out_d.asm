; stdio_out_d
; 05.2008 aralbrec

XLIB stdio_out_d
LIB stdio_numprec, stdio_outsign, stdio_outbuff, stdio_outpad

INCLUDE "stdio.def"

; output %d parameter
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

.stdio_out_d

   ex (sp),hl
   push hl

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
   ;  c = flags [-+ O#P0N]
   ; de = unsigned integer

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
   djnz adjwidth
   ld e,0                      ; in this case clear sign and zero-pad flags so they aren't printed too

.adjwidth

   ld a,e                      ; if a sign is being printed reduce width by one
   and $61
   jr z, skipwidthadj
   inc d                       ; prevent decrement from 0 to 255
   dec d
   jr z, skipwidthadj
   dec d

.skipwidthadj

   bit 7,e
   jr z,rightjustified

.leftjustified

   call stdio_outsign          ; '+', '-', ' ' or nothing
   ret c
   
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
   bit 4,e
   jr z, spacefiller

.zerofiller

   ; for zero filler we put out sign before the zeroes
   
   ;     b = number of zeroes for padding
   ;     d = num chars written to buffer
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   call stdio_outsign
   ret c
   
   ld c,'0'
   call stdio_outpad
   ret c
   
   ld b,d
   jp stdio_outbuff

.spacefiller

   ld c,' '
   call stdio_outpad
   ret c

.nopad

   ;     d = num chars written to buffer
   ;     e = flags [-+ O#P0N]
   ;    hl = & next free position in destination buffer

   call stdio_outsign
   ret c
   
   ld b,d
   jp stdio_outbuff
