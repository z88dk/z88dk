;
;       Small C+ Compiler
;       
;       Long Support Library
;
;       1/3/99 djm

;       This routine is used to push longs on the stack for a 
;       call to a function defined as a pointer. To make the
;       routine shorter (by one byte) we could use ix - pop ix/jp(ix)
;       but we'd lose 6T - give me your thoughts as to whether it's
;       worth it...

; actually use of ix saves us 4T

                SECTION   code_crt0_sccz80
PUBLIC    lpush2

.lpush2

   pop ix
   
   pop bc
   push de
   push hl
   push bc
   
   jp (ix)

;        exx
;        pop     hl      ;save return address
;        exx
;        pop     bc      ;save next item on stack
;        push    de      ;dump our long
;        push    hl
;        push    bc      ;store back "next item on stack"
;        exx
;        jp      (hl)
