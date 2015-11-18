
INCLUDE "clib_cfg.asm"

SECTION code_fcntl

PUBLIC cpm_00_input_cons_ichar_msg_getc

EXTERN __CPM_RCOB
EXTERN l_offset_ix_de, asm_cpm_bdos_alt, error_mc

cpm_00_input_cons_ichar_msg_getc:

   ;    enter : ix = & FDSTRUCT.JP
   ;
   ;     exit : a = keyboard char after character set translation
   ;            carry set on error, hl = 0 (stream error) or -1 (eof)
   ;
   ;  can use : af, bc, de, hl

   ld hl,14
   call l_offset_ix_de         ; hl = & index
   
   ld a,(hl)                   ; a = index
   
   ld e,l
   ld d,h                      ; de = &index
   
   inc hl
   inc hl
   
   cp (hl)                     ; compare to buffer len
   jr nc, read_line            ; if buffer exhausted

   ld c,a
   ld b,0
   inc bc

   add hl,bc                   ; hl = &buffer[index]
   ld a,(hl)

   ; a = ascii code
   ; de = &index

   cp CHAR_CTRL_Z
   jp z, error_mc              ; generate EOF

   ex de,hl                    ; hl = &index
   inc (hl)                    ; ++index

   ; for cpm swap CR/LF since return key only generates CR

   cp 13
   jr z, change_cr_to_lf
   
   cp 10
   jr z, change_lf_to_cr
   
   or a
   ret

change_cr_to_lf:

   ld a,CHAR_LF
   ret

change_lf_to_cr:

   ld a,CHAR_CR
   ret


read_line:

   xor a
   
   ld (de),a                   ; index = 0   
   inc de                      ; de = &max
   
   ld c,__CPM_RCOB             ; read console buffered (edit line)
   call asm_cpm_bdos_alt       ; exx and ix/iy preserved
   
   jr cpm_00_input_cons_ichar_msg_getc
