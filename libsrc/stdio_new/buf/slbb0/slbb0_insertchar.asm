; slbb0_insertchar
; 08.2009 aralbrec

XLIB slbb0_insertchar
XREF slbb0_appendchar_lib

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
   
   sub e                       ; a = end - cursor = num bytes to move
   jp c, slbb0_appendchar_lib  ; if cursor is past end of last byte in buffer
   jp z, slbb0_appendchar_lib  ;   we are appending not inserting
   ld c,a                      ; c = num bytes to move
   
   inc hl
   ld a,(hl)                   ; a = LSB start of linear buffer
   add a,e                     ; add cursor position
   inc hl
   ld h,(hl)
   ld l,a
   jp nc, noinc
   inc h

.noinc                         ; hl = insert position in linear buffer

   ld a,d                      ; a = char being inserted

   ld e,l
   ld d,h
   inc de                      ; de = insert position + 1
   
   ld b,0                      ; bc = num bytes to move
   push hl
   ldir                        ; make space for one insert char
   pop hl
   
   ld (hl),a                   ; write insert char  
   scf                         ; success!
   ret

.full

   dec hl
   dec (hl)                    ; fix end
   ret
 