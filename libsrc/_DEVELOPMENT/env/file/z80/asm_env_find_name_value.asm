SECTION code_env

PUBLIC asm_env_find_name_value

EXTERN error_znc, error_mnc, l_jpix_12, l_jpiy
EXTERN asm_env_name_sm, asm_env_value_sm

asm_env_find_name_value:

   ; Using the provided buffer space as a window into the env file,
   ; locate the name-value pair in the file
   ;
   ; enter : de = buf
   ;         bc = bufsz
   ;         hl = env file size (max 65534)
   ;         de'= char *name (validated)
   ;
   ;         ix+12 = jp read : hl=address, bc>0=length, carry set if fail
   ;
   ; exit  : if name-value found
   ;
   ;           hl = file offset to start of line
   ;           bc = file offset to start of value string
   ;           de = length of value string
   ;           iy = file offset to next line
   ;
   ;           carry set
   ;
   ;        if not found in env file
   ;
   ;           hl = 0
   ;           carry reset
   ;
   ;        if disk error
   ;
   ;           hl = -1
   ;           carry reset
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', iy

   exx

   ld bc,0
   push bc                     ; stack = offset of current line
   
   dec bc                      ; bc = offset of current char (-1 now)
   
   exx

   ld iy,asm_env_name_sm       ; start of name state machine
   
locate_name:

   ; fill buffer from disk

   ; de = buf
   ; bc = bufsz
   ; hl = remaining bytes in file
   ; stack = offset of current line

   ld a,h
   or l
   jp z, error_znc - 1         ; if end of file
   
   sbc hl,bc
   jr nc, load_it
   add hl,bc

   ld c,l
   ld b,h                      ; bc = num remaining bytes in file
   
   ld hl,0                     ; no more bytes left

load_it:

   ; de = buf
   ; bc = bufsz
   ; hl = remaining bytes in file
   ; stack = offset of current line
   
   ex de,hl                    ; hl = buf
   call l_jpix_12              ; read bc>0 bytes from disk into buf hl

   jp c, error_mnc - 1         ; if disk error

   pop af
   push hl
   push bc
   push de
   push af

locate_name_loop:

   ; hl = buf ptr
   ; bc = buf remain
   ; stack = buf, bufsz, remaining bytes, offset of current line
   
   ld a,(hl)
   
   exx
   
   call l_jpiy                 ; name match state machine
   inc bc                      ; increase file offset to current char
   
   exx
   
   jr c, locate_value          ; if name is matched
   
   ld a,'\n'
   cpi                         ; hl++, bc--

   jr nz, loop
   
   ; start of a new line
   
   inc sp
   inc sp
   
   exx
   
   inc bc
   push bc                     ; record offset of start of line
   dec bc
   
   exx

loop:

   jp pe, locate_name_loop
   
   pop af
   pop hl
   pop bc
   pop de
   push af
   
   jr locate_name              ; re-load buffer

locate_value:

   ; name found, examine value
   
   ; hl = buf ptr
   ; bc = buf remain
   ; bc'= offset of start of value string
   ; stack = buf, bufsz, remaining bytes, offset of current line
   
   ld iy,asm_env_value_sm

locate_value_loop:

   ; hl = buf ptr
   ; bc = buf remain
   ; bc'= offset of start of value string
   ; stack = buf, bufsz, remaining bytes, offset of current line
   
   ld a,(hl)
   
   exx
   
   call l_jpiy                 ; value state machine
   
   exx
   
   jr c, name_value_found
   
   cpi                         ; hl++, bc--
   jp pe, locate_value_loop
   
   ; re-load buffer from disk
   
   pop af
   pop hl
   pop bc
   pop de
   push af
   
   ; de = buf
   ; bc = bufsz
   ; hl = remaining bytes in file
   ; stack = offset of current line
   
   ld a,h
   or l
   jr z, name_value_found_2

   sbc hl,bc
   jr nc, load_it_2
   add hl,bc

   ld c,l
   ld b,h                      ; bc = num remaining bytes in file
   
   ld hl,0                     ; no more bytes left

load_it_2:

   ; de = buf
   ; bc = bufsz
   ; hl = remaining bytes in file
   ; stack = offset of current line
   
   ex de,hl                    ; hl = buf
   call l_jpix_12              ; read bc>0 bytes from disk into buf hl

   jp c, error_mnc - 1         ; if disk error

   pop af
   push hl
   push bc
   push de
   push af
   
   jr locate_value_loop

name_value_found:

   ; name-value pair found

   ; bc'= offset of start of value string
   ; de' = length of value string
   ; hl' = offset from start of value string to next line
   ; stack = buf, bufsz, remaining bytes, offset of current line
   
   pop af
   pop hl
   pop hl
   pop hl
   push af

name_value_found_2:

   ; name-value pair found
   
   ; bc'= offset of start of value string
   ; de' = length of value string
   ; hl' = offset from start of value string to next line
   ; stack = offset of current line
   
   exx
   
   add hl,bc
   ex (sp),hl
   
   pop iy
   
   scf
   ret
