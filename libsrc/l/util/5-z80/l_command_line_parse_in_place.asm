
SECTION code_clib
SECTION code_l

PUBLIC l_command_line_parse_in_place

EXTERN asm_isspace

l_command_line_parse_in_place:
   
   ; * parse command line into words in place
   ; * return argc and argv
   ; * return pointer to redirector string if '>' or '<' found
   ; * command line length capped at 255 chars
   ;
   ; enter : hl = & command line
   ;         bc = number of chars in command line
   ;              (limited to 255 chars here)
   ;
   ; note  : *(hl+bc) will be set to 0
   ;
   ; exit  : bc    = int argc
   ;         hl    = char *argv[]
   ;         hl'   = & redirector in command line (0 if none)
   ;         bc'   = num chars remaining in redirector (0 if none)
   ;         de'   = address of empty string
   ;
   ;         argv[] array is pushed onto the stack
   ;
   ; note  : on exit if there is a redirector, must 0 the
   ;         redirector byte after examining it.
   ;
   ; uses  : af, bc, de, hl, bc', de', hl', ix

   pop ix                      ; ix = return address

   ; initialize redirector pointers
   
   xor a
   
   exx

   ld c,a
   ld b,a                      ; bc'= chars remaining in redirector
   
   push bc                     ; argv[argc] = NULL
   
   ld l,a
   ld h,a
   add hl,sp
   
   ex de,hl                    ; de'= & ""

   ld l,a
   ld h,a                      ; hl'= & redirector in command line

   exx

   inc b
   dec b
   
   jr z, sz_cont

   ld b,a
   ld c,255

sz_cont:

   ; find end of command line
   
   ; hl = & command line
   ; bc = num chars remaining in command line < 256
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; de'= address of empty string
   ; ix = return address

   ld e,a
   ld d,a                      ; d = quote indicator
   
   inc c
   dec c

   jr z, argv_finished         ; if there is no command line

find_end:

   ld a,(hl)
   
   inc d
   dec d
   
   jr z, outside_quote

inside_quote:

   cp d
   jr nz, find_cont            ; if end quote not seen
   
   ld d,b                      ; quote ended
   jr find_cont

outside_quote:

   cp '"'
   jr z, start_quote
   
   cp '|'
   jr z, redirector
   
   cp '>'
   jr z, redirector
   
   cp '<'
   jr nz, find_cont

redirector:

   push bc
   push hl
   
   exx
   
   pop hl                      ; hl'= & redirector
   pop bc                      ; bc'= num chars remaining in redirector
   
   exx
   
   jr found_end

start_quote:

   ld d,a

find_cont:

   inc e
   
   cpi                         ; hl++, bc--
   jp pe, find_end

   ld (hl),b

found_end:

   ld c,e
   
   ; hl = & last char in command line + 1
   ; bc = number of chars in command line < 256
   ;  d = quote indicator
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; de'= address of empty string
   ; ix = return address

   ; work command line backwords

   ld e,b                      ; e = word_count = 0
   inc bc
   
   inc d
   dec d
   
   jr nz, word_found           ; if in an unterminated quote

word_loop:

   cpd                         ; hl--, bc--
   jp po, argv_finished        ; if reached beginning of command line

   ld a,(hl)
   
   cp '"'
   jr nz, word_ws_cont

word_ws_quote:

   ld d,a
   ld (hl),b                   ; zero terminate over quote
   
   jr word_found

word_ws_cont:

   call asm_isspace
   jr c, word_found            ; not space, end of word found

word_terminate:

   ld (hl),b
   jr word_loop

word_found:

   inc e                       ; word_count++
   
word_begin_loop:

   cpd                         ; hl--, bc--
   jp po, generate_last_argv   ; if reached beginning of command line

   ld a,(hl)
   
   inc d
   dec d
   
   jr z, word_out_quote

word_in_quote:

   cp d
   jr nz, word_begin_loop
   
   ld d,b
   jr word_end_quote

word_out_quote:

   cp '"'
   jr nz, word_out_quote_cont

   inc hl
   push hl                     ; save start of word to argv[]
   dec hl
   
   jr word_ws_quote            ; quote indicates new woed starting

word_out_quote_cont:

   call asm_isspace
   jr c, word_begin_loop       ; if next char is not space, word continues

word_end_quote:

   inc hl
   push hl                     ; save start of word to argv[]
   dec hl
   
   jr word_terminate

generate_last_argv:

   inc hl
   push hl                     ; save argv[]

argv_finished:

   ld c,e

   ; bc = argc = word count
   ; hl'= & redirector
   ; bc'= num chars remaining in redirector
   ; de'= address of empty string
   ; ix = return address
   ; stack = argv[]

   ld l,b
   ld h,b
   add hl,sp                   ; hl = &argv[0]

   jp (ix)
