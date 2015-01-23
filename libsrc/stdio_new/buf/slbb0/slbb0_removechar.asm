; slbb0_removechar
; 08.2009 aralbrec

PUBLIC slbb0_removechar

; remove a char from the buffer at the index specified
; the rest of the buffer is copied backward one position
;
; enter : hl = & struct slbb
;          e = removal index
; exit  : carry set and a = char removed if success
;         carry reset if index out of bounds
; uses  : af, bc, de, hl

.slbb0_removechar

   ld a,e                      ; a = remove index
   sub (hl)                    ; a = index - end
   ret nc                      ; return if index out of bounds
   
   dec (hl)                    ; end--
   dec a
   ld c,a                      ; c = num bytes to copy
   
   ld a,e                      ; a = remove index
   inc hl
   inc hl
   add a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp nc, noinc
   inc h

.noinc                         ; hl = remove position in linear buffer

   ld a,c
   or a                        ; num bytes to copy zero?
   ld a,(hl)                   ; a = char to be removed
   jr z, done                  ; if so skip copy

   ld e,l
   ld d,h                      ; de = remove address
   inc hl                      ; hl = one past remove address
   ld b,0                      ; bc = num chars to copy
   ldir

.done

   scf                         ; success!
   ret
