; stdio_out_c
; 05.2008 aralbrec

XLIB stdio_out_c
LIB stdio_outchar, stdio_outpad

; output %c parameter
;
; enter :    ix  = & attached file / device output function
;             b = width
;             c = flags [-+ O#P0N]
;             e = char
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
; exit  :   bc' = total num chars output on stream thus far
;         stack = & parameter list
;         carry set if error on stream, a = (errorno) set appropriately
; uses  : af, bc, de, hl, exx, bc'

.stdio_out_c

   ex (sp),hl
   push hl

   inc b                       ; make width at least 1
   djnz widthok
   inc b
   
.widthok

   bit 7,e
   jr z, rightjustified

.leftjustified

   ld a,e
   call stdio_outchar
   ret c
   
   djnz satisfywidth
   ret
      
.satisfywidth

   ld c,' '
   jp stdio_outpad

.rightjustified

   dec b
   call nz, satisfywidth
   ret c
   
   ld a,e
   jp stdio_outchar
