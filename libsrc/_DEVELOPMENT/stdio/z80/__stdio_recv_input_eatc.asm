
XLIB __stdio_recv_input_eatc

LIB l_saturated_inc_de, l_saturated_inc_bc, l_saturated_add_hl_bc, l_jpix

__stdio_recv_input_eatc:

   ; Driver consumes chars from the stream, as qualified by ignore()
   ;
   ; enter : ix = FILE *
   ;         hl'= int (*qualify)(char c)
   ;         bc'= reserved
   ;         de'= reserved
   ;         bc = max_length = max number of stream chars to consume
   ;         de = number of chars read from stream so far
   ;         hl = number of items assigned so far
   ;
   ; exit  : ix = FILE *
   ;         hl'= unchanged
   ;         bc'= unchanged
   ;         de'= unchanged
   ;         bc = number of chars consumed from stream in this operation
   ;         de = number of chars read from stream so far (updated)
   ;         hl = number of items assigned so far
   ;          a = next unconsumed char (if error: 0 on stream error, -1 on eof)
   ;
   ;         carry set on error or eof, stream state set appropriately

   bit 3,(ix+3)
   jr nz, immediate_stream_error
   
   bit 4,(ix+3)
   jr nz, immediate_eof_error

   bit 0,(ix+4)
   jr z, _no_ungetc_ec         ; if no unget char available

   ; examine unget char

   ld a,b
   or c
   
   ld a,(ix+6)                 ; a = unget char
   jr z, _ungetc_rejected_ec   ; if max_length is zero only provide peek
   
   exx
   call l_jphl                 ; qualify(a)
   exx
   
   jr c, _ungetc_rejected_ec

   res 0,(ix+4)                ; consume the unget char
   dec bc                      ; max_length--

   call _no_ungetc_ec

_post_ungetc:

   push af                     ; save error state
   
   call l_saturated_inc_de     ; total num chars read from stream++
   call l_saturated_inc_bc     ; num chars consumed in this operation++
   
   pop af
   ret

_ungetc_rejected_ec:

   ; a = rejected char
   
   ld bc,0                     ; no chars consumed in this operation
   
   or a                        ; indicate no error
   ret

_no_ungetc_ec:

   ld a,STDIO_MSG_EATC

   push hl
   push de
   
   ld l,c
   ld h,b                      ; hl = max_length

   call l_jpix
   
   ld a,l
   pop hl

   ;  a = next unconsumed char (if error: 0 for stream error, -1 for eof)
   ; bc = number of bytes consumed from stream in this operation
   ; hl = total num chars read from stream so far
   ; carry set on error or eof
   ; stack = number of items assigned

   push af

   call l_saturated_add_hl_bc
   ex de,hl                    ; de = total num chars read from stream (updated)

   pop af
   pop hl                      ; hl = total num items assigned
   
   ret nc                      ; if no error

   ; eof is only an error if no chars were read

   or a
   scf
   ret z                       ; if stream error
   
   ld a,b
   or c
   
   ld a,$ff
   ret nz                      ; if at least one char was read, indicate no error
   
   scf
   ret

immediate_stream_error:

   xor a
   jr error_exit

immediate_eof_error:

   ld a,$ff

error_exit:

   ld bc,0

   scf
   ret
