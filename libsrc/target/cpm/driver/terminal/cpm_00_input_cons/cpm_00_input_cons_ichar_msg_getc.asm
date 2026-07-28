
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC cpm_00_input_cons_ichar_msg_getc

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

rejoin:

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
   
   or a
   ret


read_line:

   push de                     ; save &index
   inc de                      ; de = &max
   
   ld c,__CPM_RCOB             ; read console buffered (edit line)
   call asm_cpm_bdos_alt       ; exx and ix/iy preserved

   pop hl                      ; hl = &index
   
   xor a
   ld (hl),a                   ; index = 0
   
   ld e,l
   ld d,h                      ; de = &index
   
   inc hl
   inc hl                      ; hl = &len
   
   inc (hl)                    ; make space for terminator
   
   ld c,(hl)
   ld b,a                      ; bc = len + 1
   add hl,bc

   ld (hl),CHAR_LF             ; terminate buffer
   
   ex de,hl
   jr rejoin
