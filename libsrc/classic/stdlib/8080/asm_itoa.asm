; uint __CALLEE__ itoa_callee(int num, char *s, uchar radix)
; convert int to string and store in s, return size of string
; 06.2008 aralbrec
; redone to be more in line with modern versions of this function

SECTION code_clib
PUBLIC asm_itoa
EXTERN l_deneg, l_div_u, strrev
EXTERN itox_basechar, error_einval_zc


   ; enter : hl = uint num
   ;         bc = int radix [2,36

   ;         de = char *buf
   ;
   ; exit  : hl = address of terminating 0 in buf
   ;         carry reset no errors

asm_itoa:
   ex de,hl


   ; enter : de = int num
   ;         hl = char *s (if NULL no chars are written)
   ;          c = radix (0 < c <= 36)
   ; exit  : de = number of digits in written number (zero and carry set for error)
   ;         hl = addr of terminating '\0' in s (or NULL)
   ; uses  : af, bc, de, hl

   ld a,c
   or a                      ; divide by zero
   jp z, error_einval_zc

   dec a
   jp z, error_einval_zc     ; radix = 1 makes no sense

   cp 36                     ; max radix (37 - 1!)
   jp nc, error_einval_zc

   ld b,0                    ; num chars output = 0

IF __CPU_INTEL__
   ld a,d
   rra
   jp nc,notneg
ELSE
   bit 7,d                   ; is num negative?
   jr z, notneg
ENDIF

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
   ld bc,itox_basechar
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
IF __CPU_GBZ80__
   ; hl = end of string, (sp) = start of string
   ld d,h		;de = end of string
   ld e,l
   pop hl		;hl = start of string
   push de		
ELSE
   ex (sp),hl                  ; hl = char *s, stack = end of char *s
ENDIF
   push bc			;Save count
   call strrev			;__FASTCALL__ takes hl=string to reverse
   pop bc
   pop de

.exit0

   ld l,b
   xor a                       ; clears carry flag
   ld h,a
   ex de,hl
   ret

.exit1

   pop de
   jr exit0
