; long __FASTCALL__ atol(char *s)
; 12.2006 aralbrec

XLIB atol
LIB l_long_neg

; FASTCALL

; enter : hl = char*
; exit  : dehl = long result
;         bc = & next char to interpret in char*

.atol

   ld a,(hl)                 ; eat whitespace
   inc hl

   cp 32                     ; inlined isspace
   jr z, atol
   cp 7
   jr z, atol
   cp 10
   jr z, atol
   cp 13
   jr z, atol

   ; ate up one too many chars, see if it's a sign
   
   cp '+'
   jr z, signdone
   dec hl
   cp '-'
   jr nz, signdone
   inc hl                    ; this is a negative number
   
   call signdone             ; do atol but come back here to negate result
   jp l_long_neg             ; dehl = -dehl
   
.signdone

   ld b,h
   ld c,l
   ld de,0
   ld l,e
   ld h,d
   
   ; bc = char *
   ; dehl = result

   dec bc

.loop

   inc bc
   ld a,(bc)
   
   sub '0'                   ; inlined isdigit
   ret c
   cp 10
   ret nc

   ; dehl *= 10
   
   add hl,hl
   ex de,hl
   adc hl,hl
   ex de,hl
   push de
   push hl                   ; save dehl*2
   add hl,hl
   ex de,hl
   adc hl,hl
   ex de,hl
   add hl,hl
   ex de,hl
   adc hl,hl                 ; long is hlde
   ex (sp),hl
   add hl,de
   pop de
   ex (sp),hl
   adc hl,de
   ex de,hl
   pop hl
      
   add a,l
   ld l,a
   jp nc, loop
   inc h
   jp nz, loop
   inc e
   jp nz, loop
   inc d

   jp loop
