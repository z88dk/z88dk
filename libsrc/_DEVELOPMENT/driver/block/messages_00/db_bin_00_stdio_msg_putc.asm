
PUBLIC db_bin_00_stdio_msg_putc
EXTERN __db_bin_00_putc_success_1, __db_bin_00_putc_success_0, __db_bin_00_putc_error_0, __db_bin_00_putc_error_2   ; stdio_msg_writ

EXTERN FILE_MSG_WRITE_MODE, FILE_MSG_FP_TO_MAX, FILE_MSG_EOF_TO_MAX, FILE_MSG_FP_RECORD_INFO, FILE_MSG_EOF_RECORD_INFO
EXTERN BUFFER_MSG_PIN_RECORD, BUFFER_MSG_UNPIN_DIRTY_RECORD, BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD, BUFFER_MSG_CREATE_RECORD

EXTERN l_jpix, error_zc, error_efbig_zc, l_long_inc_mhl, l_minu_bc_dehl, asm_memset

db_bin_00_stdio_msg_putc:

   ; output a single char multiple times on the stream
   ;
   ; enter:
   ;
   ;   IX = FILE *
   ;    A = STDIO_MSG_PUTC
   ;    E'= char
   ;   BC'= number > 0
   ;   HL = number > 0
   ;
   ; return:
   ;
   ;   HL = number of bytes successfully output
   ;   carry set if error

   push hl
   push hl                     ; create L_record_num

   dec l
   jr nz, putc_buf

   ld a,h
   or a
   jr nz, putc_buf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; common case: output one char ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

putc_ch:

   ld a,FILE_MSG_WRITE_MODE
   call l_jpix                 ; nz if append mode
   
   push af                     ; save flag(write mode)
   
   ld a,FILE_MSG_FP_TO_MAX
   jr z, putc_ch_mode_0        ; if write mode
   ld a,FILE_MSG_EOF_TO_MAX

putc_ch_mode_0:

   call l_jpix                 ; determine if at max file size
   jp c, error_efbig_zc - 3    ; if at max file size
   
   ; e' = char
   ; stack = L_record_num, flag(write mode)
   
   pop af                      ; f = flag(write mode)
   push af                     ; save flag(write mode)

   ld a,FILE_MSG_FP_RECORD_INFO
   jr z, putc_ch_mode_1        ; if write mode
   ld a,FILE_MSG_EOF_RECORD_INFO

putc_ch_mode_1:

   ld hl,2
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   call l_jpix                 ; get info on first record to write

   ; de = L_record_num *
   ; hl = offset into record
   ; bc = num bytes remaining in record
   ; e' = char
   ; stack = L_record_num, flag(write mode)
   
   push bc                     ; save bytes remaining in record
   push hl                     ; save record offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BUFFER_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   pop bc                      ; bc = record offset
   jp c, error_zc - 4          ; if i/o error
      
   ; hl = & record->flags
   ; de = & record->data
   ; bc = record offset
   ; e' = char
   ; stack = L_record_num, flag(write mode), bytes remaining in record
   
   ex de,hl                    ; de = & record->flags
   
   add hl,bc                   ; hl = void *dst

   exx
   ld a,e                      ; a = char
   exx
   
   ld (hl),a                   ; putchar

   pop hl                      ; hl = bytes remaining in record
   
   dec hl
   ld a,h
   or l                        ; bytes remaining in record now zero ?
   
   ex de,hl                    ; hl = & record->flags
   
   ; hl = & record->flags
   ; stack = L_record_num, flag(write mode)
   
   ld a,BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD
   jr nz, putc_ch_unpin        ; if more space in record
   ld a,BUFFER_MSG_UNPIN_DIRTY_RECORD

putc_ch_unpin:

   call l_jpix                 ; unpin record
   
   pop af
   
   ; f = flag(write mode)
   ; stack = L_record_num
   
   ld a,FILE_MSG_POINTER_FP
   jr z, putc_ch_mode_2        ; if write mode
   ld a,FILE_MSG_POINTER_EOF

putc_ch_mode_2:

   call l_jpix                 ; hl = & file pointer
   
   call l_long_inc_mhl         ; file pointer++
   
   pop bc
   pop bc                      ; junk item
   
   ld hl,1                     ; one char output
   
   or a
   ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general case: output more than one char ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

putc_buf:

   inc l

   ld a,FILE_MSG_WRITE_MODE
   call l_jpix                 ; nz if append mode
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
      
   ld a,FILE_MSG_FP_TO_MAX
   jr z, putc_mode_0           ; if write mode
   ld a,FILE_MSG_EOF_TO_MAX

putc_mode_0:

   call l_jpix                 ; determine max bytes that can be written
   jp c, error_efbig_zc - 4    ; if file already at max size

   ; dehl = max num bytes that can be written
   ;   bc = record size
   ;    e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes
   
   pop af
   push bc
   push af
   pop bc                      ; bc = max num bytes
   
   call l_minu_bc_dehl         ; hl = min(bc = max_num_bytes, dehl = max_write)
   
   pop bc                      ; bc = record size
   pop af                      ; f = flag(write mode)
   
   push af                     ; save flag(write mode)
   push hl                     ; save max num bytes
   push bc                     ; save record size
   push hl                     ; save num bytes remaining
   
   ;  e'= void *src
   ;  f = flag(write mode)
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   ld a,FILE_MSG_FP_RECORD_INFO
   jr z, putc_mode_1           ; if write mode
   ld a,FILE_MSG_EOF_RECORD_INFO

putc_mode_1:

   ld hl,8
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   call l_jpix                 ; get info on first record to write
   jr z, putc_loop_0           ; if write pointer is at start of record

   ; write pointer is in middle of record

   ; de = L_record_num *
   ; hl = offset into record
   ; bc = bytes remaining in record
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   ; carry reset

   ex (sp),hl                  ; hl = num bytes remaining
   
   sbc hl,bc                   ; num bytes remaining -= bytes in record
   jr nc, putc_entire_record   ; if num bytes remaining >= bytes in record
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes to write into record

putc_entire_record:

   ex (sp),hl                  ; hl = offset into record
   
   push af                     ; save flag(num bytes remaining - bytes in record)
   push bc                     ; save num bytes in record
   push hl                     ; save offset
   
   ; de = L_record_num *
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BUFFER_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jp c, __db_bin_00_putc_error_0  ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining, flag(num bytes remaining - bytes in record), bytes in record, offset

   push de
   
   exx

   pop hl                      ; hl = & record->data
   pop bc                      ; bc = record offset
   
   add hl,bc                   ; hl = void *dst
   
   pop bc                      ; bc = num bytes in record

   push de                     ; save memset value
   call asm_memset
   pop de                      ; restore memset value
   
   exx
   
   pop af                      ; f = flag(num bytes remaining - bytes in record)
   
   ; hl = & record->flags
   ;  f = flag(num bytes remaining - bytes in record)
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining
   
   ld a,BUFFER_MSG_UNPIN_DIRTY_RECORD
   jr nc, putc_initial_record  ; if num bytes remaining >= bytes in record
   ld a,BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD

putc_initial_record:

   push af                     ; save flag(num bytes remaining - bytes in record)
   call l_jpix                 ; unpin dirty record
   pop af                      ; f = flag(num bytes remaining - bytes in record)
   
   ;  f = flag(num bytes remaining - bytes in record)
   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   jp c, __db_bin_00_putc_success_0  ; if num bytes remaining < bytes in record
   jp z, __db_bin_00_putc_success_0  ; if num bytes remaining = bytes in record

   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++

putc_loop_0:

   ;  e'= memset value
   ; stack = L_record_num, flag(write mode), max num bytes, record size, num bytes remaining

   pop hl                      ; hl = num bytes remaining
   pop bc                      ; bc = record size

putc_loop_1:

   ; e' = memset value
   ; hl = num bytes remaining
   ; bc = record size
   ; stack = L_record_num, flag(write mode), max num bytes
   
   or a
   sbc hl,bc                   ; num bytes remaining -= record size
   
   jr c, putc_partial          ; if num bytes remaining < record size
   
   exx
   
   push de                     ; save memset value
   push de                     ; save memset value
   
   ld hl,8
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BUFFER_MSG_CREATE_RECORD
   call l_jpix                 ; create record in memory
   
   ex (sp),hl
   ex de,hl
   
   exx
   
   ; hl = num bytes remaining
   ; bc = record size
   ;  e'= memset value
   ; hl'= & record->data
   ; stack = L_record_num, flag(write mode), max num bytes, memset value, & record->flags
   
   jr c, putc_error_1          ; i/o error (bytes remaining needs adjustment)
   
   push bc                     ; save record size
   
   exx
   
   pop bc                      ; bc = record size
   
   call asm_memset
   
   pop hl                      ; hl = & record->flags
   
   ld a,BUFFER_MSG_UNPIN_DIRTY_RECORD
   call l_jpix                 ; unpin record
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   call l_long_inc_mhl         ; L_record_num++
   
   pop de                      ; e = memset value
   
   exx
   
   jr putc_loop_1

putc_partial:

   add hl,bc
   jp z, __db_bin_00_putc_success_1  ; if num bytes remaining == 0

   push hl

   ; e' = memset value
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining
   
   ld hl,6
   add hl,sp                   ; hl = L_record_num *
   
   ld a,BUFFER_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   jp c, __db_bin_00_putc_error_2  ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; e' = memset value
   ; stack = L_record_num, flag(write mode), max num bytes, num bytes remaining

   push de
   
   exx
   
   pop hl                      ; hl = & record->data
   pop bc                      ; bc = num bytes remaining
   
   call asm_memset

   exx
   
   ; hl = & block->flags
   ; stack = L_record_num, flag(write mode), max num bytes
   
   ld a,BUFFER_MSG_UNPIN_DIRTY_ACTIVE_RECORD
   call l_jpix
   
   jp __db_bin_00_putc_success_1

putc_error_1:

   ; hl = num bytes remaining (need to add record size)
   ; bc = record size
   ; stack = L_record_num, flag(write mode), max num bytes, memset value, & record->flags

   add hl,bc                   ; attempt to transfer last record failed
   
   pop af                      ; junk item
   ex (sp),hl

   jp __db_bin_00_putc_error_2
