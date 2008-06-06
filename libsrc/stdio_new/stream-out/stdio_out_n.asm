; stdio_out_n
; 05.2008 aralbrec

XLIB stdio_out_n

; output %n parameter
;
;
; enter :    de = int *
;            hl = & parameter list
;           bc' = total num chars output on stream thus far
; exit  :   bc' = total num chars output on stream thus far
;            hl = & parameter list
;         carry reset (no error on stream)
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
