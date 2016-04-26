;/*
; *      strtol(char *s, char **endp, int base)
; *
; *      Taken from vbcc archive
; *
; *      Added to Small C+ 27/4/99 djm
; *
; * -----
; * $Id: strtol_callee.asm,v 1.12 2016-04-26 20:15:18 dom Exp $
; *
; */
;
; rewritten in asm and lost the overflow check in process
; 12.2006 aralbrec

; Uses all registers except iy, afp
; long result in dehl

SECTION code_clib
PUBLIC strtol_callee
PUBLIC _strtol_callee
EXTERN l_long_neg, l_long_mult, asm_isspace
PUBLIC ASMDISP_STRTOL_CALLEE

.strtol_callee
._strtol_callee

   pop hl
   pop bc
   pop de
   ex (sp),hl

   ; bc = base
   ; de = char **endp
   ; hl = char *s

.asmentry
   push ix
   push de                   ; push char **endp parameter for writeendp
   call noendp               ; do strtol but return here to write endp

.writeendp

   ; dehl = result
   ; bc = char *
   ; stack = char **endp

   ex (sp),hl                ; hl = char **endp
   ld a,h
   or l
   jr z,final_return
   ld (hl),c                 ; write last string position
   inc hl                    ; into endp
   ld (hl),b
   pop hl
.final_return
   pop ix
   ret
   
.noendp

   ld e,l
   ld d,h
   
   ; bc = base
   ; hl = char *
   ; de = start char *

.eatws

   ld a,(hl)                 ; eat whitespace
   inc hl

   call asm_isspace
   jr z, eatws

   ; ate up one too many chars, see if it's a sign
   
   cp '+'
   jr z, signdone
   dec hl
   cp '-'
   jr nz, signdone
   inc hl                    ; this is a negative number
   
   call signdone             ; do strtol but return here to negate result
   jp l_long_neg             ; dehl = -dehl
   
.signdone

   ; bc = base
   ; hl = char *
   ; de = start char *

   ld a,b                    ; base must be in [0,2-36]
   or a
   jp nz, fail
   
   ld a,c
   cp 37
   jp nc, fail
   
   dec a
   jp z, fail
   
   inc a
   jr nz, checkhex

   ; base=0 so need to figure out if it's oct, dec or hex

   ld a,(hl)
   
   ld c,10
   cp '0'                    ; if leading digit not '0' must be decimal
   jr nz, knownbase
   
   inc hl
   ld a,(hl)                 ; if next char is a digit must be oct
   
   ld c,8
   cp '0'
   jp c, fail
   
   cp '7'+1
   jr c, knownbase
   
   and $df                   ; toupper(a)
   ld c,16
   cp 'X'                    ; leading 0x indicates hex
   jr nz, fail
   
   inc hl
   jp knownbase

.checkhex

   cp 16
   jr nz, knownbase
   
   ; hex numbers are allowed to begin with 0x or 0X

   ld a,(hl)
   cp '0'
   jr nz, knownbase
   
   inc hl
   ld a,(hl)
   inc hl
   cp 'x'
   jr z, knownbase
   
   cp 'X'
   jr z, knownbase
   
   dec hl
   dec hl

.knownbase

   ld a,(hl)                 ; make sure there's at least one
   sub '0'                   ; digit else fail
   jr c, fail
   
   cp 10
   jr c, noadj1
   
   add a,'0'
   and $df
   sub 'A'
   jr c, fail
   
   add a,10
   
.noadj1

   cp c                      ; base
   jr nc, fail

.pass

   ;  a = first number
   ; bc = base
   ; hl = char *

   push bc
   pop ix                    ; ix = base
   
   ld d,b
   ld e,b
   
   ld c,l
   ld b,h                    ; bc = char *

   ld h,d
   ld l,a                    ; dehl = a = total so far

.loop
   
   ;   bc = char *
   ; dehl = running total
   ;   ix = base

   ; first get next digit
   
   inc bc
   ld a,(bc)                 ; turn next char into digit

   sub '0'
   ret c
   
   cp 10
   jr c, noadj2
   
   add a,'0'
   and $df
   sub 'A'
   ret c
   
   add a,10
   
.noadj2

IF FORrcmx000

   push bc
   
   push ix
   pop bc
   
   cp c
   
   pop bc
   ret nc

ELSE

   cp ixl                    ; base
   ret nc

ENDIF

.havedigit

   push bc                   ; save char *
   push af
   
   ld bc,0                   ; push base on stack
   push bc
   push ix
   call l_long_mult          ; dehl = dehl * base

   pop af
   pop bc                    ; bc = char *
   
   ; now add in digit
      
   add a,l
   ld l,a
   jp nc, loop
   inc h
   jp nz, loop
   inc de

   jp loop
   
.fail

   ld c,e
   ld b,d                    ; bc = original char *
   ld de,0                   ; dehl = result = 0
   ld h,d
   ld l,e
   ret

DEFC ASMDISP_STRTOL_CALLEE = # asmentry - strtol_callee
