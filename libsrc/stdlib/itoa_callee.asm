; uint __CALLEE__ itoa_callee(int num, char *s, uchar radix)
; convert int to string and store in s, return size of string
; 06.2008 aralbrec
; redone to be more in line with modern versions of this function

SECTION code_clib
PUBLIC itoa_callee
PUBLIC _itoa_callee
PUBLIC ASMDISP_ITOA_CALLEE
PUBLIC LIBDISP_ITOA_CALLEE

EXTERN l_deneg, l_div_u, strrev
EXTERN stdio_basechar, stdio_error_zc

.itoa_callee
._itoa_callee

   pop af
   pop bc
   pop hl
   pop de
   push af

   ; enter : de = int num
   ;         hl = char *s (if NULL no chars are written)
   ;          c = radix (0 < c <= 36)
   ; exit  : hl = number of digits in written number (zero and carry set for error)
   ;         de = addr of terminating '\0' in s (or NULL)
   ; uses  : af, bc, de, hl

.asmentry

   ld a,c
   or a                      ; divide by zero
   jp z, stdio_error_zc
   
   dec a
   jp z, stdio_error_zc      ; radix = 1 makes no sense
   
   cp 36                     ; max radix (37 - 1!)
   jp nc, stdio_error_zc

   ld b,0                    ; num chars output = 0

   bit 7,d                   ; is num negative?
   jr z, notneg

.negative

   call l_deneg              ; de = -de
   inc b                     ; count++

   ld a,h
   or l
   jr z, notneg

   ld (hl),'-'               ; write negative sign
   inc hl

.libentry
.notneg

   ; enter : de = unsigned num
   ;         hl = char *s (if NULL no chars are written)
   ;          b = 0
   ;          c = 1 < radix <= 36
   ; exit  : hl = number of digits in written number (0 and carry set for error)
   ;         de = addr of terminating '\0' in s

   push hl                   ; save char *s (skip leading '-')

.loop

   inc b                     ; count++
   push bc                   ; save count, radix
   push hl                   ; save buff address
   
   ld l,c
   ld h,0                    ; hl = radix
   call l_div_u              ; hl = num / radix, de = num % radix
   
   ex de,hl
   ld bc,stdio_basechar
   add hl,bc
   ld c,(hl)                 ; c = ascii digit
   
   pop hl                    ; hl = buffer address
   
   ld a,h                    ; if buff == NULL, not writing anything
   or l
   jr z, nowrite0
   
   ld (hl),c
   inc hl
   
.nowrite0

   pop bc                    ; b = count, c = radix

   ld a,d
   or e
   jr nz, loop

   ;  b = count
   ; hl = address of soon-to-be-written '\0' in buffer
   ; stack = char *s

   ld a,h
   or l
   jr z, exit1
   
   ld (hl),e                   ; terminate string

   ; now we have a backward string in the buffer so we need to reverse it!

   ex (sp),hl                  ; hl = char *s, stack = end of char *s
   push bc
   call strrev
   pop bc
   pop de

.exit0

   ld l,b
   xor a                       ; clears carry flag
   ld h,a
   ret

.exit1

   pop de
   jr exit0

DEFC ASMDISP_ITOA_CALLEE = # asmentry - itoa_callee
DEFC LIBDISP_ITOA_CALLEE = # libentry - itoa_callee
