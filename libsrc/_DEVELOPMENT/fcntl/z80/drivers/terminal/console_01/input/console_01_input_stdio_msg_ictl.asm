
SECTION seg_code_fcntl

PUBLIC console_01_input_stdio_msg_ictl

EXTERN console_01_input_stdio_msg_flsh, asm_memcpy, error_enotsup_mc
EXTERN IOCTL_ITERM_RESET, IOCTL_ITERM_TIE, IOCTL_ITERM_GET_EDITBUF, IOCTL_ITERM_SET_EDITBUF

console_01_input_stdio_msg_ictl:

   ; enter : ix = & FDSTRUCT.JP
   ;         bc = first parameter
   ;         de = request
   ;         hl = void *arg
   ;
   ; exit  : carry reset if ok, HL = return value != -1
   ;         carry set if fail

   ld a,d
   and $c0
   jr z, unmanaged_flags       ; if IOCTL is not managed by stdio
   
   ; if line mode is being disabled reset the edit buffer
   
   ld a,e
   and $20
   ret z                       ; if line mode unaffected return ok
   
   and c
   and $20
   ret nz                      ; if line mode not being disabled return ok
   
   jp console_01_input_stdio_msg_flsh

unmanaged_flags:

   inc d
   dec d
   jp z, error_enotsup_mc      ; know nothing about these ICTLs

   ld a,e
   and $07                     ; ITERMs have device code = 1
   dec a
   jp nz, error_enotsup_mc     ; not an ITERM ioctl
   
   ld a,e                      ; a = LSB of ioctl request
   
   cp IOCTL_ITERM_TIE & 0xff
   jr z, tie_oterm             ; tie to an output terminal
   
   cp IOCTL_ITERM_RESET & 0xff ; reset means flush
   jp z, console_01_input_stdio_msg_flsh

   cp IOCTL_ITERM_GET_EDITBUF & 0xff
   jr z, get_editbuf           ; return copy of edit buffer
   
   cp IOCTL_ITERM_SET_EDITBUF & 0xff
   jp nz, error_enotsup_mc     ; if unrecognized request

set_editbuf:

   ; bc = b_array * (src edit buffer)
   
   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,19
   add hl,de
   
   ex de,hl                    ; de = & FDSTRUCT.b_array
   
   ld l,c
   ld h,b                      ; hl = b_array *
   
   ld bc,6                     ; bc = sizeof(b_array)
   call asm_memcpy

   jp console_01_input_stdio_msg_flsh

get_editbuf:

   ; bc = b_array * (dst edit buffer)
   
   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,19
   add hl,de                   ; hl = & FDSTRUCT.b_array
   
   ld e,c
   ld d,b                      ; de = b_array *
   
   ld bc,6                     ; bc = sizeof(b_array)
   jp asm_memcpy

tie_oterm:

   ; bc = void *f_oterm (FDSTRUCT *oterm)
   
   call console_01_input_stdio_msg_flsh
   
   push ix
   pop hl                      ; hl = & FDSTRUCT.JP
   
   ld de,14
   add hl,de                   ; hl = & FDSTRUCT.oterm
   
   ld e,(hl)
   ld (hl),c
   inc hl
   ld d,(hl)
   ld (hl),b                   ; FDSTRUCT.oterm = f_oterm
   
   ex de,hl                    ; hl = old f_oterm
   ret
