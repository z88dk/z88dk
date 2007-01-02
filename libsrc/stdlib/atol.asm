; long __FASTCALL__ atol(char *s)
; 12.2006 aralbrec

XLIB atol
LIB l_long_neg

; FASTCALL

; enter : hl = char*
; exit  : hl = int result
;         de = & next char to interpret in char*

.atol

   ld a,(hl)                 ; eat whitespace
   inc hl

   cp 32                     ; inlined isspace
   jr z, atoi
   cp 7
   jr z, atoi
   cp 10
   jr z, atoi
   cp 13
   jr z, atoi

   ; ate up one too many chars, see if it's a sign
   
   cp '+'
   jr z, signdone
   dec hl
   cp '-'
   jr nz, signdone
   inc hl                    ; this is a negative number
   ld de,l_long_neg          ; sneakily push negate long function on stack
   push de                   ; so it is run on ret
   
.signdone

   ld b,h
   ld c,l
   ld de,0
   ld l,e
   ld h,d
   
   ; bc = char *
   ; dehl = result

.loop

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
   jp nc, adddone
   inc h
   jp nz, adddone
   inc e
   jp nz, adddone
   inc d
   
.adddone

   inc bc
   jp loop
