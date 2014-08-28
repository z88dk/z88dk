
PUBLIC db_bin_00_stdio_msg_eatc

EXTERN FILE_MSG_FP_TO_EOF, FILE_MSG_FP_RECORD_INFO, FILE_MSG_POINTER_FP
EXTERN BUFFER_MSG_PIN_RECORD, BUFFER_MSG_UNPIN_RECORD, BUFFER_MSG_UNPIN_ACTIVE_RECORD

EXTERN l_jpix, l_jphl, error_mc, error_zc, l_minu_bc_dehl, l_long_add_mhl_bc, l_long_inc_mhl

db_bin_00_stdio_msg_eatc:

   ; read chars from the stream until one is disqualified
   ;
   ; enter:
   ;
   ;   IX = FILE *
   ;   HL'= int (*qualify)(char c)
   ;   HL = max_length = max number of stream chars to consume >= 0
   ;   exx set must not be modified
   ; 
   ; return:
   ;
   ;   BC = number of bytes consumed from stream
   ;   HL = next unconsumed (unmatching) char or EOF

   push hl
   push hl                     ; create space for L_record_num
   
   push hl                     ; save max_len
   
   ld a,FILE_MSG_FP_TO_EOF
   call l_jpix                 ; find out number of bytes to EOF
   
   jp c, error_mc - 3          ; if at EOF already (with bc = 0)
   
   ;  dehl = number of bytes to eof
   ;    bc = record size in bytes
   ; stack = L_record_num, max_len
   
   pop af
   push bc
   push af
   pop bc                      ; bc = max_len
   
   call l_minu_bc_dehl         ; hl = min(bc = max_len, dehl = num bytes to eof)
   
   pop bc                      ; bc = record size
   push af                     ; save flag(avail - max_len)
   push hl                     ; save num_bytes_remaining
   push bc                     ; save record size
   
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size

   ld hl,6
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   ld a,FILE_MSG_FP_RECORD_INFO
   call l_jpix                 ; get info on record containing file pointer
   
   ; de = L_record_num *
   ; hl = offset into record
   ; bc = bytes remaining in record
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size

   push hl
   ex de,hl
   
   ; hl = L_record_num *
   ; bc = bytes remaining in record
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, offset into record
   
   jr z, eatc_record_next      ; if offset == 0 start at beginning of record
   push bc                     ; save bytes remaining in record
   
   ld a,BUFFER_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jr c, eatc_error_0          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, offset into record, bytes remaining in record

   pop bc                      ; bc = bytes remaining in record
   ex (sp),hl                  ; hl = offset into record
   
   add hl,de                   ; hl = char *src
   push hl
   
   ; bc = bytes remaining in record
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, char *src
   
   ld hl,6
   add hl,sp
   
   ld e,l
   ld d,h
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = num bytes remaining
   
   sbc hl,bc                   ; num bytes remaining -= bytes remaining in record
   jr nc, eatc_entire_record_0 ; if entire record can be consumed
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes remaining < bytes remaining in record

eatc_entire_record_0:

   ; hl = updated num bytes remaining
   ; bc = num chars avail in record
   ; de = & num bytes remaining
   ;  f = flag(num bytes remaining - record size)
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, char *src

   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; update num bytes remaining

   pop hl                      ; hl = char *src
   push af                     ; save flag(num bytes remaining - record size)
   
   ld de,-1

eatc_loop_0:

   dec hl
   inc bc

eatc_loop_1:
   
   inc de
   
   ; bc = num chars avail in record + 1
   ; de = num chars read
   ; hl = char *src - 1
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   cpi                         ; hl++, bc--
   jp po, eatc_record_end      ; if current record exhausted
   
   ld a,(hl)                   ; a = current char
   
   exx
   call l_jphl                 ; qualify the char
   exx
   
   jp nc, eatc_loop_1          ; if char is accepted
   
eatc_disqualified:

   ; de = num chars read
   ; hl = char *src
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   pop af                      ; junk item
   
   ld l,(hl)                   ; l = next char
   ex (sp),hl                  ; hl = & record->flags
   
   push de                     ; save num chars read
   
   ld a,BUFFER_MSG_UNPIN_ACTIVE_RECORD
   call l_jpix                 ; unpin record and mark as active

   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, next char, num chars read
   
   pop bc                      ; bc = num chars read
   pop de                      ; e = next char
   
   ld hl,10
   add hl,sp
   ld sp,hl                    ; clear stack

eatc_adjust_fp:

   ; bc = num chars read
   ; e = next char

   ld a,FILE_MSG_POINTER_FP
   call l_jpix                 ; hl = & file_pointer
   
   call l_long_add_mhl_bc      ; file_pointer += bc
   
   ld l,e
   xor a
   ld h,a                      ; hl = next unconsumed char
   
   ret

eatc_record_end:

   ; de = num chars read
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   pop af                      ; flags(num bytes remaining - record size)
   jr c, eatc_done_active_1    ; if all bytes read and current record is active
   
   pop hl                      ; hl = & record->flags
   push de                     ; save num chars read
   
   ld a,BUFFER_MSG_UNPIN_RECORD
   call l_jpix                 ; unpin record
   
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read
   
   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   ld e,l
   ld d,h                      ; de = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++
   ex de,hl                    ; hl = L_record_num *

eatc_record_next:

   ; hl = L_record_num *
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read

   ld a,BUFFER_MSG_PIN_RECORD
   call l_jpix                 ; pin next record in memory
   
   jr c, eatc_error_1          ; if i/o error
   
   ; hl = & record->flags
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read
   
   pop de                      ; de = num chars read
   pop bc                      ; bc = record size
   ex (sp),hl                  ; hl = num bytes remaining
   
   ld a,h
   or l
   jr z, eatc_done_active_0    ; if all bytes read and current record is active
   
   sbc hl,bc                   ; num bytes remaining -= record size
   jr nc, eatc_entire_record_1 ; if entire record can be consumed
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = max num bytes to read from record

eatc_entire_record_1:

   ; hl = updated num bytes remaining
   ; de = num chars read
   ; bc = num bytes to read from record
   ;  f = flag(num bytes remaining - record size)
   ; stack = L_record_num, flag(avail - max_len), & record->flags
   
   ex (sp),hl
   push bc
   push hl
   push af
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = & record->data
   
   dec de

   ; bc = max chars to read in record
   ; de = num chars read - 1
   ; hl = char *src
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags, flag(num_bytes_remaining - record_size)

   jr eatc_loop_0

eatc_done_active_0:

   ; de = num chars read
   ; stack = L_record_num, flag(avail - max_len), & record->flags

   pop hl                      ; hl = & record->flags
   push hl
   push hl
   push hl
   
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a

eatc_done_active_1:

   ; de = num chars read
   ; hl = char *src
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, & record->flags

   ld l,(hl)                   ; l = next char
   ex (sp),hl                  ; hl = & record->flags
   
   push de                     ; save num chars read
   
   ld a,BUFFER_MSG_UNPIN_ACTIVE_RECORD
   call l_jpix                 ; unpin record and mark as active
   
   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, next char, num chars read
   
   pop bc                      ; bc = num chars read
   pop de                      ; e = next char
   
   pop af
   pop af
   pop af                      ; flag(avail - max_len) = why stopped here
   
   pop hl
   pop hl                      ; junk item
   
   jr z, eatc_eof              ; if available == max_len requested
   jr nc, eatc_adjust_fp       ; if available >> max_len requested

eatc_eof:

   call eatc_adjust_fp         ; increase file pointer
   jp error_mc                 ; indicate eof

eatc_error_0:

   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, offset into record, bytes remaining in record

   ld hl,14
   add hl,sp
   ld sp,hl                    ; clear stack
   
   ld bc,0                     ; nothing read
   jp error_zc                 ; indicate i/o error

eatc_error_1:

   ; stack = L_record_num, flag(avail - max_len), num_bytes_remaining, record size, num chars read
   
   pop bc                      ; bc = num chars read
   
   ld hl,10
   add hl,sp
   ld sp,hl                    ; clear stack
   
   call eatc_adjust_fp         ; increase file pointer
   jp error_zc                 ; indicate i/o error
