
; =============================================================
; May 2015
; =============================================================
;
; size_t ftoa(float x, char *buf, uint16_t prec, uint16_t flag)
;
; Write zero-terminated floating point number to buffer and
; return number of characters written not including '\0'
;
; If buf == 0, number of chars returned not incl '\0'
;
; =============================================================

SECTION code_stdlib

PUBLIC asm_ftoa

EXTERN __ftoa__, __stdio_printf_sign, __ftoa_print_zeroes

asm_ftoa:

   ; enter :  c = flag (bit 6='+', bit 5=' ', bit 4='#')
   ;         de = precision (clipped at 255)
   ;         hl = char *buf (0 = no write to buffer)
   ;        EXX = float x
   ;
   ; exit  : hl = number of characters written not incl '\0'
   ;
   ; uses  : af, bc, de, hl, ix, af', bc', de', hl'

   ld c,l
   ld b,h
   
   ld hl,-44
   add hl,sp
   ld sp,hl                    ; create 44 bytes of workspace
   
   push bc                     ; save buf
   call __ftoa__

   ;                hl = buffer_dst * (address of next char to write)
   ;                ix = buffer * (start of decimal string)
   ;            (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ;            (IX-4) = tz (number of zeroes to append)
   ;            (IX-3) = fz (number of zeroes to insert after .)
   ;            (IX-2) = iz (number of zeroes to insert before .)
   ;            (IX-1) = if not '0' must be included in decimal string
   ;             stack = char *buf
   ;
   ;             carry set indicates special form
   ;
   ;             stack = char *buf

   ex af,af'
   
   push ix
   pop de                      ; de = buffer *
   
   ld a,(de)
   cp '0'
   jr z, m0
   dec de                      ; include carry digit

m0:

   or a
   sbc hl,de
   
   ld c,l
   ld b,h                      ; bc = length of workspace
   
   pop hl                      ; hl = char *buf
   
   ld a,h
   or l
   jr z, count_only

   push hl                     ; save buf

   ;                bc = length of workspace
   ;                de = workspace *
   ;                hl = char *buf_dst
   ;            (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ;            (IX-4) = tz (number of zeroes to append)
   ;            (IX-3) = fz (number of zeroes to insert after .)
   ;            (IX-2) = iz (number of zeroes to insert before .)
   ;            (IX-1) = if not '0' must be included in decimal string
   ;
   ;             stack = char *buf
   ;
   ;             carry' set indicates special form

   ; 1. print sign

   ld a,(ix-5)                 ; a = printf flags byte
   call __stdio_printf_sign
   
   ex af,af'
   jr c, special_form          ; if nan or inf
   
   ; 2. print workspace up to decimal point
   
   ld a,'.'
   ex de,hl                    ; hl = workspace, de = buf_dst

m1:

   cp (hl)
   jr z, m2                    ; decimal point found
   
   ldi                         ; copy workspace digit
   jp pe, m1                   ; if workspace not exhausted
   
   jr terminate

m2:

   ; 3. print iz zeroes
   
   ex de,hl                    ; hl = buf_dst, de = workspace
   ld a,(ix-2)                 ; a = iz
   call __ftoa_print_zeroes

   ; 4. print decimal point
   
   ex de,hl                    ; hl = workspace, de = buf_dst
   ldi
   jp po, terminate
   
   ; 5. print fz zeroes
   
   ex de,hl                    ; hl = buf_dst, de = workspace
   ld a,(ix-3)                 ; a = fz
   call __ftoa_print_zeroes

special_form:

   ; 6. print remaining workspace
   
   ex de,hl                    ; hl = workspace, de = buf_dst
   ldir
   
   ; 7. print trailing zeroes
   
   ex de,hl                    ; hl = buf_dst, de = workspace
   ld a,(ix-4)
   call __ftoa_print_zeroes
   ex de,hl

terminate:

   ;    de = char *buf_dst
   ; stack = char *buf

   xor a
   ld (de),a                   ; terminate buf
   
   pop hl
   ex de,hl                    ; hl = buf_dst, de = buf
   
   sbc hl,de

t2:

   ld e,l
   ld d,h                      ; de = length

   ld hl,44
   add hl,sp
   ld sp,hl                    ; restore stack
   
   ex de,hl                    ; hl = length
   ret

count_only:

   ;                bc = length of workspace
   ;            (IX-5) = flags, bit 7='N', bit 4='#', bit 0=(precision==0), others unaffected
   ;            (IX-4) = tz (number of zeroes to append)
   ;            (IX-3) = fz (number of zeroes to insert after .)
   ;            (IX-2) = iz (number of zeroes to insert before .)
   ;            (IX-1) = if not '0' must be included in decimal string

   ld a,(ix-5)
   and $e0
   jr z, c1
   inc bc                      ; sign will be present

c1:

   push ix
   pop hl
   
   dec hl
   dec hl
   ld e,(hl)                   ; e = iz
   dec hl
   ld d,(hl)                   ; d = fz
   dec hl
   ld l,(hl)                   ; l = tz
   
   xor a
   ld h,a
   add hl,bc                   ; hl = len + tz
   ld c,d
   ld b,a
   ld d,a
   add hl,de                   ; hl += iz
   add hl,bc                   ; hl += fz
   
   jr t2
