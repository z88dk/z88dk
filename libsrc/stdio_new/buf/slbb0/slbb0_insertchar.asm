; slbb0_insertchar
; 08.2009 aralbrec

PUBLIC slbb0_insertchar
EXTERN slbb0_appendchar_lib

; insert a char into the buffer prior to the position
; indicated, making space for it by copying the rest of
; the buffer forward by one position
;
; enter : hl = & struct slbb
;          d = char to insert
;          e = insertion index (cursor)
; uses  : af, bc, de, hl
; exit  : carry set   = success
;         carry reset = buffer full 

.slbb0_insertchar

   ld a,(hl)                   ; a = end
   inc (hl)                    ; end++
   inc hl
   cp (hl)                     ; compare to len
   jr nc, full                 ; return if buffer full
   
   ld b,a                      ; b = end
   sub e                       ; a = end - cursor = num bytes to move
   jr c, appendchar            ; if cursor is past end of last byte in buffer
   jr z, appendchar            ;   we are appending not inserting
   ld c,a                      ; c = num bytes to move
   
   inc hl
   ld a,(hl)                   ; a = LSB start of linear buffer
   add a,b                     ; add end
   inc hl
   ld h,(hl)
   ld l,a
   jp nc, noinc
   inc h

.noinc                         ; hl = one byte past end of data in buffer

   ld a,d                      ; a = char being inserted

   ld e,l
   ld d,h
   dec de                      ; de = last data byte in buffer
   ex de,hl
   
   ld b,0                      ; bc = num bytes to move
   lddr                        ; make space for one insert char
    
   ld (de),a                   ; write insert char  
   scf                         ; success!
   ret

.appendchar

   add a,e
   jp slbb0_appendchar_lib

.full

   dec hl
   dec (hl)                    ; fix end
   ret
 