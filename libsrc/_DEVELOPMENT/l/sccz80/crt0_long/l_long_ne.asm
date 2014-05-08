;       Z88 Small C+ Run Time Library 
;       Long functions
;

PUBLIC    l_long_ne

;
; DEHL != secondary
; set carry if result true
; stack = secondary MSW, secondary LSW, ret


.l_long_ne

   pop ix                      ; return address
   
   pop bc                      ; secondary LSW
   ld a,c
   cp l
   jp nz, notequal0
   ld a,b
   cp h
   jp nz, notequal0
   
   pop bc                      ; secondary MSW
   ld a,c
   cp e
   jp nz, notequal1
   ld a,b
   cp d
   jr z, equal

.notequal1

   scf

.equal

   jp (ix)

.notequal0

   pop bc                      ; clear secondary MSW from stack
   scf
   jp (ix)


;        call    l_long_cmp
;        scf
;        ret   nz
;        ccf
;        dec   hl
;        ret
