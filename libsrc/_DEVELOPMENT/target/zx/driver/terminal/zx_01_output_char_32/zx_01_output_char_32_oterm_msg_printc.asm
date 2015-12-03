
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_oterm_msg_printc

EXTERN asm_zx_cyx2saddr, asm_zx_saddr2aaddr

zx_01_output_char_32_oterm_msg_printc:

   ;   enter  :  c = ascii code
   ;             b = parameter (foreground colour, 255 if none specified)
   ;             l = absolute x coordinate
   ;             h = absolute y coordinate
   ;   can use:  af, bc, de, hl

   ld a,c
   cp 32
   jr nc, code_ok
   
   ld c,'?'

code_ok:

   call asm_zx_cyx2saddr
   ex de,hl                    ; de = screen address

   ld a,b                      ; a = colour
   
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
   ld c,a                      ; c = colour

__print_loop:

   ld a,(hl)
   ld (de),a
   
   inc hl
   inc d
   
   djnz __print_loop
   
   ld a,(hl)
   ld (de),a
   
   ; put colour
   
   ex de,hl                    ; hl = screen address at bottom of char
   call asm_zx_saddr2aaddr     ; hl = attribute address
   
   ld a,c
   inc a

   jr nz, colour_supplied      ; if colour != 255
   
   ld c,(ix+23)                ; c = foreground colour

colour_supplied:

   ld b,(ix+24)                ; b = foreground colour mask
   
   ld a,b
   cpl
   and c
   ld c,a
   
   ld a,b
   and (hl)
   or c

   ld (hl),a
   ret
