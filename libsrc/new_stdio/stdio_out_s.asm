; stdio_out_s
; 05.2008 aralbrec

XLIB stdio_out_s
LIB stdio_outchar, stdio_outpad, strlen

; output %s parameter
;
; enter :    ix  = & attached file / device output function
;             a = precision
;             b = width
;             c = flags [-+ O#P0N]
;            de = char *s
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
; exit  :   bc' = total num chars output on stream thus far
;         stack = & parameter list
;         carry set if error on stream, a = (errorno) set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_s

   ex (sp),hl
   push hl

   push de                     ; save char *s
   push af                     ; save precision
   
   ex de,hl                    ; hl = char *s
   ld e,c                      ; e = flags
   ld d,b                      ; d = width
   
   call strlen                 ; hl = string length
   
   pop bc
   
   ;    ix = & attached file / device output function
   ;     b = precision
   ;     d = width
   ;     e = flags [-+ O#P0N]
   ;    hl = string length
   ; stack = char *s

   bit 2,e
   jr z, noprec

   ; find minimum of string length and precision
   
   ld a,h
   or a
   jr nz, precissmaller
   
   ld a,b
   cp l
   jr nc, noprec
   
.precissmaller

   ld h,0
   ld l,b

.noprec

   ;    ix = & attached file / device output function
   ;     d = width
   ;     e = flags [-+ O#P0N]
   ;    hl = num chars from string to output
   ; stack = char *s

   ld a,h                      ; determine number of padding chars required
   or a
   jr nz, nopadding
   
   ld a,d
   sub l
   jr nc, justification

.nopadding

   xor a

.justification

   ld d,a

   ;    ix = & attached file / device output function
   ;     d = number of padding chars required
   ;     e = flags [-+ O#P0N]
   ;    hl = num chars from string to output
   ; stack = char *s

   bit 7,e
   jr z, rightjustified

.leftjustified

   pop bc
   call outstring
   ret c
   
   ld b,d
   ld c,' '
   jp stdio_outpad

.rightjustified

   ld b,d
   ld c,' '
   call stdio_outpad
   pop bc
   ret c
   
.outstring

   ; bc = char *s
   ; hl = num chars to output
   
   ld a,h
   or l
   ret z
   
   ld a,(bc)
   call stdio_outchar
   ret c
   
   inc bc
   dec hl
   jp outstring
