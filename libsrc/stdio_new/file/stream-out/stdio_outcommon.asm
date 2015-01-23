; stdio_outcommon
; 05.2008 aralbrec

PUBLIC stdio_outcommon
PUBLIC LIBDISP_STDIO_OUTCOMMON_SIGNED
EXTERN stdio_outsign, stdio_outbuff, stdio_outpad

; common code that performs padding and justification for numbers
;
; enter :  b = num chars written to buffer
;          d = width
;          e = flags [-+ O#PLN]
;         hl = & next free position in destination buffer

.stdio_outcommon

   ld a,e                      ; for unsigned numbers clear
   and $9e                     ; the "+ N" flags
   ld e,a

.signedenter

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

defc LIBDISP_STDIO_OUTCOMMON_SIGNED = # signedenter - stdio_outcommon
