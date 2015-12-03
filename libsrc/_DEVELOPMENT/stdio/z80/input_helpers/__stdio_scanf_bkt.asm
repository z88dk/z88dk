
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_scanf_bkt

EXTERN asm_memset, l_bitset_locate, l_inc_sp, __stdio_scanf_sm_bkt
EXTERN __stdio_recv_input_eatc, error_einval_zc, __stdio_scanf_s_tail

__stdio_scanf_bkt:

   ; %[ converter called from vfscanf()
   ;
   ; enter : ix = FILE *
   ;         de = void *buffer (workspace)
   ;         bc = field width (0 means default)
   ;         hl = void *p (destination buffer, 0 means suppressed)
   ;         bc'= char *format (ptr following '[')
   ;
   ; exit  : bc'= char *format (ptr following ']')
   ;         carry set if error
   ;
   ; uses  : all except ix

   push bc                     ; push field width
   push hl                     ; push void *p

   ; CREATE CHARACTER ACCEPT BITSET

   ex de,hl                    ; hl = void *buffer = workspace
   ld bc,32                    ; 32 bytes = 256 bits, one for each char
   ld e,b                      ; e = 0

   call asm_memset             ; initialize bitset to zero

   ex de,hl                    ; de = void *workspace
   call generate_accept_set    ; create the accept set in workspace

   pop bc
   jp nc, error_einval_zc - 1  ; if conversion spec is invalid

   ld a,(de)
   and $fe
   ld (de),a                   ; remove \0 from the bitset

   ; CONSUME STREAM CHARS
   
   ; de = void *bitset
   ; bc = void *buffer (0 if assignment suppressed)
   ; bc'= char *format
   ; stack = field width
   
   ld hl,__stdio_scanf_sm_bkt  ; bracket state machine

   exx
   
   pop af
   push bc                     ; save char *format
   push af
   pop bc                      ; bc = field width
   
   ld a,b
   or c
   jr nz, width_specified      ; if field width was supplied
   
   dec bc                      ; otherwise consume all matching chars from stream

width_specified:

   call __stdio_recv_input_eatc
   
   exx
   
   ; bc = void *buffer (0 if assignment suppressed)
   ; stack = char *format
   ; carry set on error

   call __stdio_scanf_s_tail   ; terminate string, deal with errors

   exx
   pop bc                      ; bc = char *format
   exx
   
   ret

   ; FORMAT STRING STATE MACHINE

generate_accept_set:

   ; inside this state machine
   ;
   ; de = void *buffer = 32 bytes for accept set
   ; bc'= char *format = address of next format string char
   ; exit: carry set if no error

   call as_next_char
   ret z
   
   cp '^'
   jr nz, past_initial_carat

   call as_next_char
   ret z
   
   call past_initial_carat
   
   ; come back here to complement the accept set

   ld l,e
   ld h,d
   ld b,32
   
comp_loop:

   ld a,(hl)
   cpl

   ld (hl),a
   inc hl
   
   djnz comp_loop
   ret

past_initial_carat:

   cp ']'
   jr nz, past_initial_bracket
   
   call as_add_char            ; add ']' to the accept set

first_char:

   call as_next_char
   ret z                       ; if format string prematurely terminates

   cp ']'
   scf                         ; indicate success
   ret z                       ; if normal end of specifier

past_initial_bracket:

   ld c,a                      ; c = first char

second_char:

   ; c = first char
   
   call as_next_char
   ret z                       ; if format string terminates prematurely
   
   cp ']'
   jr nz, not_done_0

   ; finished but need to add first char to accept set
   
   ld a,c
   call as_add_char

   scf                         ; indicate success
   ret

not_done_0:

   cp '-'
   jr z, range_given

   ; add the first char to the accept set and
   ; make the second char the new first char

   ld b,a
   ld a,c                      ; a = first char = char to add
   ld c,b                      ; c = second char = new first char
   
   call as_add_char            ; add first char to accept set
   jr second_char

range_given:

   ; c = first char
   ; '-' followed

   call as_next_char
   ret z
   
   cp ']'
   jr nz, not_done_1
   
   ; format specifier ends in '-'
   ; just add first char and the '-' to the accept set

   ld a,c
   call as_add_char

   ld a,'-'
   call as_add_char

   scf                         ; success
   ret

not_done_1:

   ; range given:  c = first char, a = second char
   
   cp c
   jr nc, range_ok
   
   ; range given backwards, reverse it
   
   ld b,c
   ld c,a
   ld a,b
   
range_ok:

   sub c
   ld b,a
   inc b
   
   ; c = first char, b = length of range
   
   push bc
   
   ld a,c
   call l_bitset_locate

   pop bc
   add hl,de
   
   ; hl = bitset location
   ;  b = length of range
   ;  a = mask

   ld c,a
   or (hl)
   ld (hl),a
   
   djnz set_loop
   jr first_char

set_loop:

   sla c
   jr nc, in_byte
   
   ld c,1
   inc hl

in_byte:

   ld a,c
   or (hl)
   ld (hl),a
   
   djnz set_loop
   jr first_char

as_next_char:

   ; read next char from format string
   ; increment format string pointer

   exx
   ld a,(bc)
   inc bc
   exx
   
   or a
   ret nz
   
   exx
   dec bc
   exx
   
   ret

as_add_char:

   ; add char in A to accept set
   
   call l_bitset_locate
   
   add hl,de
   or (hl)
   ld (hl),a
   
   ret
