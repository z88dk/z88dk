
SECTION code_clib
SECTION code_stdlib

PUBLIC __dtoa_print

EXTERN __stdio_printf_sign_0, __dtoa_print_zeroes

__dtoa_print:

   push hl                     ; save buf_dst

   ;                bc = length of workspace
   ;                de = workspace *
   ;                hl = char *buf_dst
   ;
   ;            (IX-6) = flags, bit 7 = 'N', bit 4 = '#', bit 0 = precision==0
   ;            (IX-5) = iz (number of zeroes to insert before .)
   ;            (IX-4) = fz (number of zeroes to insert after .)
   ;            (IX-3) = tz (number of zeroes to append)
   ;            (IX-2) = ignore
   ;            (IX-1) = '0' marks start of buffer
   ;
   ;             stack = char *buf
   ;
   ;             carry' set indicates special form
   ;
   ; exit : hl = output length
   ;        de = char *buf_dst

   ;;;;; print sign

   ld a,(ix-6)                 ; a = printf flags byte
   call __stdio_printf_sign_0
   
   ex af,af'
   jr c, special_form          ; if nan or inf
   
   ;;;;; print workspace up to non-digit
   
   ex de,hl                    ; hl = workspace *, de = buf_dst *

integer_part:

   ld a,(hl)

   cp '.'
   jr z, iz_zeroes             ; if integer part done
   
   cp 'E'
   jr z, tze_zeroes            ; if exponent reached
   
   cp 'P'
   jr z, tze_zeroes            ; if exponent reached
   
   ldi                         ; copy workspace digit to destination
   jp pe, integer_part         ; if workspace not exhausted

   ;;;;; print iz zeroes (zeroes trailing the integer part)
   
iz_zeroes:
   
   ex de,hl                    ; hl = buf_dst *, de = workspace *

   ld a,(ix-5)                 ; a = iz
   call __dtoa_print_zeroes

   ex de,hl                    ; hl = workspace *, de = buf_dst *

   ld a,b
   or c
   jr z, zero_terminate        ; if workspace exhausted

   ;;;;; print decimal point
   
   ldi
   jp po, tz_zeroes            ; if workspace exhausted
   
   ;;;;; print fz zeroes

fz_zeroes:

   ex de,hl                    ; hl = buf_dst *, de = workspace *
   
   ld a,(ix-4)                 ; a = fz
   call __dtoa_print_zeroes

   ;;;;; print workspace up to exponent
   
   ex de,hl                    ; hl = workspace *, de = buf_dst*

fraction_part:

   ld a,(hl)
   
   cp 'E'
   jr z, tze_zeroes            ; if exponent reached
   
   cp 'P'
   jr z, tze_zeroes            ; if exponent reached
   
   ldi                         ; copy workspace digit to destination
   jp pe, fraction_part        ; if workspace not exhausted

   ;;;;; print trailing zeroes

tz_zeroes:

   ex de,hl                    ; hl = buf_dst *, de = workspace *

   ld a,(ix-3)
   call __dtoa_print_zeroes

   ex de,hl

   ;;;;; zero terminate and exit

zero_terminate:

   ;    de = char *buf_dst
   ; stack = char *buf

   xor a
   ld (de),a                   ; terminate buf
   
   pop hl
   ex de,hl                    ; hl = buf_dst *, de = buf *
   
   sbc hl,de                   ; hl = output length
   ret

   ;;;;; print trailing zeroes (ftoe - exponent present)
   
tze_zeroes:

   set 5,(hl)                  ; exponent to lower case
   ex de,hl                    ; hl = buf_dst *, de = workspace *

   ld a,(ix-3)
   call __dtoa_print_zeroes

   ;;;;; print remaining workspace (ftoe - exponent present)
   
special_form:

   ex de,hl                    ; hl = workspace *, de = buf_dst *
   ldir
   
   jr zero_terminate
