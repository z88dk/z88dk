
; SP1IterateUpdateArr
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XLIB SP1IterateUpdateArr
LIB l_jpix

; Iterate over an array of struct_sp1_update*, calling the supplied function
; with each of the struct_sp1_update* as parameter.  The array must be zero
; terminated.
;
; enter : hl = zero terminated array of struct sp1_update *
;         ix = function to call for each stuct sp1_update in array (stack, hl = parameter)
; uses  : af, de, hl + whatever user function uses

.SP1IterateUpdateArr

   ld e,(hl)
   inc hl
   ld d,(hl)             ; de = struct sp1_update *

   ld a,d
   or e
   ret z

   inc hl
   push hl
   push de
   ex de,hl
   call l_jpix           ; call function with hl = struct sp1_update *
   pop de
   pop hl

   jp SP1IterateUpdateArr
