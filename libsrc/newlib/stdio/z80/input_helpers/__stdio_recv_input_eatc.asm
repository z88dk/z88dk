
SECTION code_clib
SECTION code_stdio

PUBLIC __stdio_recv_input_eatc

EXTERN STDIO_MSG_EATC
EXTERN l_addu_hl_bc, l_jpix, l_jphl

; ALL INPUT FOR VFSCANF PASSES THROUGH __STDIO_RECV_INPUT_*
; DE' IS USED TO TRACK NUMBER OF CHARS READ FROM STREAM
; HL' IS USED TO TRACK NUMBER OF ITEMS ASSIGNED
;
; OTHER HIGH LEVEL STDIO SHOULD USE __STDIO_RECV_INPUT_RAW_*

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

   jr z, _ungetc_rejected_ec   ; if max_length is zero only provide peek

   ld a,(ix+6)                 ; a = unget char
   
   exx
   call l_jphl                 ; qualify(a)
   exx
   
   jr c, _ungetc_rejected_ec

   res 0,(ix+4)                ; consume the unget char
   dec bc                      ; max_length--

   call _no_ungetc_ec

_post_ungetc:
   
   inc de                      ; total num chars read from stream++
   inc bc                      ; num chars consumed in this operation++

   ret

_ungetc_rejected_ec:

   ld a,(ix+6)                 ; a = rejected unget char   
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

   call l_addu_hl_bc
   ex de,hl                    ; de = total num chars read from stream (updated)

   pop af
   pop hl                      ; hl = total num items assigned
   
   jr c, error_occurred
   
   bit 5,(ix+3)
   ret nz                      ; if driver manages ungetc
   
   ld (ix+6),a                 ; write unconsumed char to ungetc spot
   set 0,(ix+4)                ; indicate ungetc is present
   
   ret

error_occurred:

   ; stream error or eof ?

   or a
   jr z, stream_error

   ; eof is only an error if no chars were read
   
   set 4,(ix+3)                ; set stream state to eof
   
   ld a,b
   or c
   
   ld a,$ff
   ret nz                      ; if at least one char was read, indicate no error
   
   scf
   ret

stream_error:

   set 3,(ix+3)                ; set stream state to error

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
