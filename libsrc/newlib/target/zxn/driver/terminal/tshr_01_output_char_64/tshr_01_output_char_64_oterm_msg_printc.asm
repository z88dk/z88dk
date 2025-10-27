SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_64_oterm_msg_printc

EXTERN asm_tshr_cxy2saddr

tshr_01_output_char_64_oterm_msg_printc:

   ;   enter  :  c = ascii code
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl

   ld a,c
   cp 32
   jr nc, code_ok
   
   ld c,'?'

code_ok:

   call asm_tshr_cxy2saddr
   ex de,hl                    ; de = screen address
   
   ld l,c
   ld h,0
   
   add hl,hl
   add hl,hl
   add hl,hl                   ; hl = 8 * ascii code
   
   ld c,(ix+21)
   ld b,(ix+22)                ; bc = font address
   
   add hl,bc                   ; hl = & character definition
   
   ; print character pixels
   
   ld b,7

__print_loop:

   ld a,(hl)
   ld (de),a
   
   inc hl
   inc d
   
   djnz __print_loop
   
   ld a,(hl)
   ld (de),a

   ret
