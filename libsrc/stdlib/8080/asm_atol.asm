; long __FASTCALL__ atol(char *s)
; 12.2006 aralbrec

SECTION code_clib
PUBLIC asm_atol
EXTERN l_long_neg, asm_isspace

; FASTCALL

; enter : hl = char*
; exit  : dehl = long result
;         bc = & next char to interpret in char*

.asm_atol

   ld a,(hl)                 ; eat whitespace
   inc hl

   call asm_isspace
   jr z, asm_atol

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
IF __CPU_INTEL__
   push af
   ld a,l
   adc l
   ld l,a
   ld a,h
   adc h
   ld h,a
   pop af
ELSE
   adc hl,hl
ENDIF
   ex de,hl
   push de
   push hl                   ; save dehl*2
   add hl,hl
   ex de,hl
IF __CPU_INTEL__
   push af
   ld a,l
   adc l
   ld l,a
   ld a,h
   adc h
   ld h,a
   pop af
ELSE
   adc hl,hl
ENDIF
   ex de,hl
   add hl,hl
   ex de,hl
IF __CPU_INTEL__
   push af
   ld a,l
   adc l
   ld l,a
   ld a,h
   adc h
   ld h,a
   pop af
ELSE
   adc hl,hl                 ; long is hlde
ENDIF
   ex (sp),hl
   add hl,de
   pop de
   ex (sp),hl
IF __CPU_INTEL__
   push af
   ld a,l
   adc e
   ld l,a
   ld a,h
   adc d
   ld h,a
   pop af
ELSE
   adc hl,de
ENDIF
   ex de,hl
   pop hl

   add a,l
   ld l,a
   jp nc, loop
   inc h
   jp nz, loop
   inc de

   jp loop
