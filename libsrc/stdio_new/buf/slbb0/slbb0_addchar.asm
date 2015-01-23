; slbb0_addchar
; 08.2009 aralbrec

PUBLIC slbb0_addchar
EXTERN slbb0_insertchar

; add a char to the buffer after the position
; indicated, making space for it by copying the
; rest of the buffer forward by one position
;
; adding is equivalent to inserting one pos later
;
; enter : hl = & struct slbb
;          d = char to add
;          e = add index
; uses  : af, bc, de, hl
; exit  : carry set   = success
;         carry reset = buffer full 

.slbb0_addchar

   inc e
   jp slbb0_insertchar
