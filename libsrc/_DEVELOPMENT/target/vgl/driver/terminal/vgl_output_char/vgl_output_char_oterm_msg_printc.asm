
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_output_char_oterm_msg_printc

;EXTERN asm_zx_cxy2saddr, asm_zx_saddr2aaddr

vgl_output_char_oterm_msg_printc:

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

   ;@TODO: Convert from l/h coordinates to address
   ;ZX:	call asm_zx_cxy2saddr
   ;	ex de,hl                    ; de = screen address
   ;	ld a,b                      ; a = colour
   ld hl, 	0xdca0	; VRAM start
   ld (hl), c
   

;	__print_loop:
;	
;	   ld a,(hl)
;	   ld (de),a
;	   
;	   inc hl
;	   inc d
;	   
;	   djnz __print_loop
   
   
   ; Refresh row(s)
   ld hl,0xdcf0	;+row-num
   ld (hl),0x01
   
   ret
