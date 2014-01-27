
XLIB __stdio_input_sm_getdelim

LIB asm_realloc, asm__galloc

__stdio_input_sm_getdelim:

   ; GETDELIM STATE MACHINE
   ;
   ; Qualify function for STDIO_MSG_EATC
   ; Accepts all chars up to and including delim char
   ;
   ; enter : de = & struct
   ;         { 
   ;            char *lineptr;      // start of buffer
   ;            int   delim_char;
   ;            char *lineptr;      // start of buffer
   ;         }
   ;
   ;         if using existing buffer
   ;
   ;            bc = remaining_n
   ;            lineptr != 0
   ;
   ;         if using an allocated buffer
   ;
   ;            lineptr == 0

   ; first call to state machine, determine where to join

   ex de,hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   inc e
   dec e
   jr nz, state_1_join         ; if lineptr != 0, have a buffer
   
   inc d
   dec d
   jr nz, state_1_join         ; if lineptr != 0, have a buffer
   
   ; allocating a buffer
   
   ; de = 0
   ; hl = & struct.delim_char
   
   push hl                     ; save & struct.delim_char
   push af                     ; save char
   
   ld bc,2
   call asm_realloc            ; allocate a two byte buffer

   jr nc, state_3t             ; if successfully allocated buffer

   ; unable to allocate initial buffer
   
   pop af
   pop af
   
   scf                         ; indicate reject
   ret

state_1:

   ; STATE MACHINE PART 1
   ;
   ; Use available space in the destination buffer.
   ;
   ; hl = state machine address
   ; de = struct
   ;      {
   ;         char *lineptr_ptr;  // where to write next char
   ;         int   delim_char;
   ;         char *lineptr;      // start of buffer
   ;      }
   ; bc = remaining_n > 0

   ex de,hl

   ; every char gets written to the buffer, including the delimiter
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl

state_1_join:

   ld (de),a                   ; write char to buffer
   inc de
   
   ; found delimiter ?
   
   cp (hl)
   jr z, matches_1             ; if char matches delim_char

rejoin_1:

   dec hl
   ld (hl),d
   dec hl
   ld (hl),e                   ; write new char *lineptr_ptr
   
   dec bc                      ; remaining_n --
   
   ld a,b
   or c
   jr z, buffer_exhausted      ; if buffer used up
   
   ex de,hl                    ; de = & struct
   
   ld hl,state_1
   ret                         ; carry reset to accept char

matches_1:

   inc hl
   
   ld a,(hl)
   or a
   
   dec hl
   jr nz, rejoin_1             ; if delim_char > 255, never match

   ; delimiter met
   
   ; hl = & struct.delim_char
   ; de = char *lineptr_ptr
   
   ld hl,state_2
   ret                         ; carry reset to accept delim char

buffer_exhausted:

   ; the supplied buffer space is exhausted
   ; prepare to grow the buffer in following calls

   ; bc = 0
   ; hl = & struct
   
   ld (hl),c
   inc hl
   ld (hl),b                  ; struct.lineptr = 0
   inc hl
   
   ld e,l
   ld d,h                      ; de = & struct.delim_char
   
   inc hl
   inc hl
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = char *lineptr
   
   ld hl,state_3
   ret                         ; carry reset to accept char

state_2:

   ; STATE MACHINE PART 2
   ;
   ; Delim char seen and buffer was never grown.

state_4:

   ; STATE MACHINE PART 4
   ;
   ; Delim char seen and buffer has been grown.
   ;
   ; bc = char *lineptr

   scf                         ; reject this char
   ret

state_3t:

   ; hl = char *lineptr
   ; stack = & struct.delim_char, char
   
   push hl
   
   ld de,1
   jr state_3_join
   
state_3:

   ; STATE MACHINE PART 3
   ;
   ; Supplied buffer space is exhausted.
   ; Buffer must be grown for each additional char.
   ;
   ; hl = state machine address
   ; de = & struct.delim_char
   ;      struct
   ;      {
   ;         char *junk = 0;
   ;         int   delim_char;
   ;         char *junk;
   ;      }
   ; bc = char *lineptr

   push de                     ; save & struct.delim_char
   push af                     ; save char
   push bc                     ; save char *lineptr

   ld e,c
   ld d,b                      ; de = char *lineptr
   ld bc,1
   
   call asm__galloc            ; attempt to grow buffer by one char
   jr c, memory_insufficient

state_3_join:

   ; hl = new char *linptr
   ; de = old size of buffer

   ld c,l
   ld b,h                      ; bc = new char *lineptr
   
   pop af
   pop af                      ; a = char
   
   add hl,de
   dec hl
   ld (hl),a                   ; write char to end of buffer

   pop hl                      ; hl = & struct.delim_char
   
   cp (hl)
   jr z, matches_3             ; if char matches delim_char

rejoin_3:

   ex de,hl                    ; de = & struct.delim_char
   ld hl,state_3
   
   or a                        ; indicate char accepted
   ret

matches_3:

   inc hl
   
   ld a,(hl)
   or a
   
   dec hl
   jr nz, rejoin_3             ; if delim_char > 255, never match

   ; delimiter met
   
   ld hl,state_4
   ret                         ; carry reset to indicate delim_char accepted

memory_insufficient:

   pop bc                      ; bc = char *lineptr
   pop af                      ;  a = char
   pop de
   
   scf                         ; indicate char is rejected
   ret
