; slbb0_appendchar
; 08.2009 aralbrec

PUBLIC slbb0_appendchar
PUBLIC slbb0_appendchar_lib

; append the char to the end of the buffer
;
; enter : hl = & struct slbb
;          d = char to insert
; uses  : af, hl
; exit  : carry set   = success
;         carry reset = buffer full

.slbb0_appendchar

   ld a,(hl)                   ; a = end
   inc (hl)                    ; end++
   inc hl
   cp (hl)                     ; compare to len
   jr nc, full                 ; return if buffer full

.slbb0_appendchar_lib

   inc hl
   add a,(hl)                  ; add LSB of buffer address
   inc hl
   ld h,(hl)
   ld l,a
   jp nc, noinc
   inc h

.noinc                         ; hl = end of buffer

   ld (hl),d                   ; write char
   scf                         ; success!
   ret

.full

   dec hl
   dec (hl)                    ; fix end
   ret
