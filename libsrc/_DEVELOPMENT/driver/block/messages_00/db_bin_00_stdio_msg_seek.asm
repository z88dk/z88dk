
PUBLIC db_bin_00_stdio_msg_seek

EXTERN FILE_MSG_POINTER_FP, FILE_MSG_POINTER_EOF

EXTERN l_jpix, l_long_load_mhl, l_long_addus_exx

db_bin_00_stdio_msg_seek:

   ; set file pointer to new position
   ; 
   ; enter:
   ;
   ;   IX = FILE *
   ;    A = STDIO_MSG_SEEK
   ;    C = STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ; DEHL'= file offset
   ;    C'= STDIO_SEEK_SET (0), STDIO_SEEK_CUR (1), STDIO_SEEK_END (2)
   ;
   ; return:
   ;
   ; DEHL = updated file position
   ; carry set on error (file position out of range, not possible here)

   dec c
   jr z, seek_cur
   
   dec c
   jr z, seek_end

seek_set:

   exx
   jr seek_setfp               ; dehl = new file pointer

seek_end:

   ld a,FILE_MSG_POINTER_EOF   ; eof file pointer
   jr seek_getfp

seek_cur:

   ld a,FILE_MSG_POINTER_FP    ; current file pointer

seek_getfp:

   call l_jpix                 ; hl = & file pointer
   call l_long_load_mhl        ; dehl = *hl = file pointer
   
   exx
   
   ; dehl = signed file offset
   ; dehl'= unsigned file pointer
   
   call l_long_addus_exx       ; dehl = new file pointer
   
seek_setfp:

   ; dehl = new file pointer
   
   push hl                     ; save LSW
   push de                     ; save MSW
   
   ex de,hl                    ; de = LSW
   
   ld a,FILE_MSG_POINTER_FP
   call l_jpix                 ; hl = & file pointer
   
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   
   pop de                      ; de = MSW
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; file pointer = new file pointer
   
   pop hl                      ; hl = LSW
   
   or a
   ret
