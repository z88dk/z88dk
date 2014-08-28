
PUBLIC db_bin_00_stdio_msg_getc

EXTERN FILE_MSG_FP_TO_EOF, FILE_MSG_FP_RECORD_INFO, FILE_MSG_POINTER_FP
EXTERN BUFFER_MSG_PIN_RECORD, BUFFER_MSG_UNPIN_RECORD, BUFFER_MSG_UNPIN_ACTIVE_RECORD

EXTERN l_jpix, error_mc, error_zc, l_long_inc_mhl

db_bin_00_stdio_msg_getc:

   ; read a single character from the stream
   ; 
   ; enter:
   ;
   ;   IX = FILE *
   ;    
   ; return:
   ;
   ;   HL = char
   ;   carry set on error (HL=0) or eof (HL=-1)

   ld a,FILE_MSG_FP_TO_EOF
   call l_jpix                 ; determine if at EOF
   
   jp c, error_mc              ; if at EOF
   
   push hl
   push hl                     ; create L_record_num
   
   ld hl,0
   add hl,sp
   ex de,hl                    ; de = L_record_num *
   
   ld a,FILE_MSG_FP_RECORD_INFO
   call l_jpix                 ; get info on record containing file pointer
   
   ; de = L_record_num *
   ; hl = offset into record
   ; bc = num bytes remaining in record
   ; stack = L_record_num
   
   push bc                     ; save bytes remaining in record
   push hl                     ; save record offset
   
   ex de,hl                    ; hl = L_record_num *
   
   ld a,BUFFER_MSG_PIN_RECORD
   call l_jpix                 ; bring record into memory
   
   pop bc                      ; bc = record offset
   jp c, error_zc - 3          ; if i/o error
   
   ; hl = & record->flags
   ; de = & record->data
   ; bc = record offset
   ; stack = L_record_num, bytes remaining in record
   
   ex de,hl                    ; de = & record->flags

   add hl,bc                   ; hl = void *src
   ld l,(hl)                   ; l = char
   
   ex (sp),hl                  ; hl = bytes remaining in record
   
   dec hl
   ld a,h
   or l                        ; bytes remaining in record now zero ?
   
   ex de,hl                    ; hl = & record->flags
   
   ; hl = & record->flags
   ; stack = L_record_num, char
   
   ld a,BUFFER_MSG_UNPIN_ACTIVE_RECORD
   jr nz, getc_unpin           ; if more bytes are available in record
   ld a,BUFFER_MSG_UNPIN_RECORD

getc_unpin:

   call l_jpix                 ; unpin record
   
   ; stack = L_record_num, char
   
   ld a,FILE_MSG_POINTER_FP
   call l_jpix                 ; hl = & file pointer
   
   call l_long_inc_mhl         ; file pointer++
   
   pop hl
   xor a
   ld h,a                      ; hl = char
   
   pop bc
   pop bc                      ; junk item
   
   ret
