
XLIB __stdio_recv_input_read

LIB l_saturated_add_hl_bc, l_saturated_inc_de, l_jpix

__stdio_recv_input_read:

   ; Driver reads a block of bytes from the stream and writes to buffer
   ;
   ; enter : ix = FILE *
   ;         bc = max_length = number of chars to read from stream
   ;         de = void *buffer = destination buffer
   ;         de'= total number of chars read from stream so far
   ;         hl'= total number of items assigned so far
   ; 
   ; exit  : ix = FILE *
   ;         de = void *buffer_ptr = address of byte following last written
   ;          a = on error: 0 for stream error, -1 for eof
   ;         bc'= number of bytes successfully read from stream
   ;         de'= total number of chars read from stream so far (updated)
   ;         hl'= total number of items assigned so far
   ;
   ;         carry set on error or eof, stream state set appropriately

   bit 3,(ix+3)
   jr nz, immediate_stream_error
   
   bit 4,(ix+3)
   jr nz, immediate_eof_error

   ld a,b
   or c
   jr z, len_zero              ; if length is zero
   
   bit 0,(ix+4)
   jr z, _no_ungetc_rd         ; if no unget char available

   ld a,(ix+6)                 ; a = unget char
   res 0,(ix+4)                ; consume the unget char

   ld (de),a                   ; write char to buffer
   inc de
   dec bc
   
   ld a,b
   or c
   jr z, len_one   

_no_ungetc_rd:

   ld a,STDIO_MSG_READ
   
   push bc
   exx
   pop bc
   
   push hl
   push de
   
   ld l,c
   ld h,b                      ; hl = max_length

   call l_jpix
   
   ld a,l
   pop hl

   ;  a = if error: 0 for stream error, -1 for eof
   ; bc = number of bytes consumed from stream in this operation
   ; hl = total num chars read from stream so far
   ; carry set on error or eof
   ; stack = number of items assigned

   push af
   
   call l_saturated_add_hl_bc
   ex de,hl                    ; de = total num of chars read from stream (updated)

   pop af
   pop hl                      ; hl = num items assigned
   
   exx
   ret

len_one:

   exx
   ld bc,1
   call l_saturated_inc_de
   exx
   
   ret

len_zero:

   exx
   ld bc,0
   exx
   
   ret

immediate_stream_error:

   xor a
   scf
   jr len_zero

immediate_eof_error:

   ld a,$ff
   scf
   jr len_zero
