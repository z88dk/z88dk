; uint __CALLEE__ ltoa_callee(long num, char *s, uchar radix)
; convert long to string and store in s, return size of string
; 06.2008 aralbrec
; redone to be more in line with modern versions of this function

PUBLIC ltoa_callee
PUBLIC _ltoa_callee
PUBLIC ASMDISP_LTOA_CALLEE
PUBLIC LIBDISP_LTOA_CALLEE

EXTERN l_long_neg, l_long_div_u, strrev
EXTERN stdio_basechar, stdio_error_zc

.ltoa_callee
._ltoa_callee

   pop af
   pop bc
   pop ix
   pop hl
   pop de
   push af

.asmentry

   ; enter : dehl = long num
   ;           ix = char *s (if NULL no chars are written)
   ;            c = radix (0 < c <= 36)
   ; exit:     hl = number of digits in written number (zero and carry set for error)
   ;           de = addr of terminating '\0' in s (or NULL)
   ; uses  : af, bc, de, hl, exx, ix

   ld a,c
   or a
   jp z, stdio_error_zc        ; divide by zero

   dec a                       ; radix = 1 makes no sense
   jp z, stdio_error_zc

   cp 36
   jp nc, stdio_error_zc       ; max radix (37 - 1!)
   
   ld b,0                      ; num chars output = 0
   
   bit 7,d                     ; is num negative?
   jr z, notneg

.negative

   call l_long_neg             ; dehl = -dehl
   inc b                       ; count++

IF FORrcmx000

   push bc
   
   push ix
   pop bc
   
   ld a,b
   or c
   
   pop bc
   jr z, notneg

ELSE

   ld a,ixh
   or ixl
   jr z, notneg

ENDIF
   
   ld (ix+0),'-'               ; write negative sign
   inc ix

.libentry
.notneg

   ; enter : dehl = long num
   ;           ix = char *s (if NULL no chars are written)
   ;            b = 0
   ;            c = radix (1 < c <= 36)
   ; exit:     hl = number of digits in written number (zero and carry set for error)
   ;           de = addr of terminating '\0' in s (or NULL)
   ; uses  : af, bc, de, hl, exx, ix

   push ix                     ; save char *s (skip leading '-')

.loop

   inc b                       ; count++
   push bc                     ; save num chars, radix
   
   push de
   push hl                     ; num on stack
   ld de,0
   ld h,d
   ld l,c                      ; dehl = radix
   
   call l_long_div_u           ; dehl = num/radix, de'hl' = num % radix

IF FORrcmx000

   push ix
   pop bc
   
   ld a,b
   or c
   
   pop bc
   jr z, nowrite0

ELSE

   pop bc                      ; b = num chars, c = radix
   
   ld a,ixh
   or ixl
   jr z, nowrite0

ENDIF

   exx
   ld de, stdio_basechar
   add hl,de
   ld a,(hl)                   ; a = digit to output
   exx
   
   ld (ix+0),a
   inc ix

.nowrite0

   ld a,d
   or e
   or h
   or l
   jr nz, loop

   pop hl

   ;  b = count
   ; ix = address of soon-to-be-written '\0' in buffer
   ; hl = char *s

IF FORrcmx000

   push ix
   pop de
   
   ld a,d
   or e
   jr z, exit

   ld (ix+0),0                 ; terminate string

ELSE

   ld a,ixh
   or ixl
   jr z, exit
   
   ld (ix+0),e                 ; terminate string

ENDIF
   
   ; now we have a backward string in the buffer so we need to reverse it!

   push bc
   call strrev
   pop bc

.exit

   push ix
   pop de                      ; de = end of char *s 

   ld l,b
   xor a                       ; clears carry flag
   ld h,a
   ret

DEFC ASMDISP_LTOA_CALLEE = # asmentry - ltoa_callee
DEFC LIBDISP_LTOA_CALLEE = # libentry - ltoa_callee

