
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_parse_mode

__stdio_parse_mode:

   ; parse the fopen mode string
   ; valid characters include "rwabx+"
   ;
   ; enter : de = char *mode
   ;
   ; exit  : de = char *mode_ptr (address of non-matching char)
   ;
   ;         success, mode string valid
   ;
   ;            c = flags = 0TXC BAWR
   ;            carry reset
   ;
   ;         fail, mode string invalid
   ;
   ;            carry set
   ;
   ; note  : 0TXC BAWR, O_RDWR = O_RDONLY | O_WRONLY
   ;
   ;          R = $01 = O_RDONLY = open for reading
   ;          W = $02 = O_WRONLY = open for writing
   ;          A = $04 = O_APPEND = append writes
   ;          B = $08 = O_BINARY = binary mode (many drivers ignore this)
   ;
   ;          C = $10 = O_CREAT  = create file if it does not exist
   ;          X = $20 = O_EXCL   = if file already exists return error
   ;          T = $40 = O_TRUNC  = if file exists reduce it to zero length
   ;
   ; uses  : af, bc, de, hl

   ld c,0

flags_loop:

   ld b,6
   ld hl,mode_table

   ld a,(de)
   or a
   jr z, check_validity        ; if end of permission string reached
   
match_loop:

   cp (hl)
   inc hl
   
   jr z, found_flag
   
   inc hl
   djnz match_loop

   ; no match

invalid:

   scf
   ret

found_flag:

   ld a,(hl)
   or c
   ld c,a
   
   inc de
   jr flags_loop

check_validity:

   ; c = flags = 1TXC BAWR
   
   ld a,c
   xor $80                     ; complete mode string has bit 7 set
   ld c,a
   
   ret p
   
   scf
   ret

mode_table:

   defb 'r', $81               ; bit 7 set indicates mode string is complete
   defb 'w', $d2               ; bit 7 set indicates mode string is complete
   defb 'a', $96               ; bit 7 set indicates mode string is complete
   defb '+', $03
   defb 'b', $08
   defb 'x', $20
