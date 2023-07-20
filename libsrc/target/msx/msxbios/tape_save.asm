;
;      Tape save routine
;
;      Stefano, 2022
;
;      int  tape_save(char *name, size_t loadstart, void *start, void *exec, size_t len);
;

PUBLIC tape_save
PUBLIC _tape_save
PUBLIC ___tape_save

EXTERN asm_tape_save


.tape_save
._tape_save
.___tape_save


  POP AF	; ret_addr
  POP DE	; len
  POP BC	; exec
  POP HL	; start
  EXX
  POP DE	; loadstart
  POP HL	; name
  
  PUSH HL
  PUSH DE
  EXX
  PUSH HL
  PUSH BC
  PUSH DE
  PUSH AF

  EXX
  jp asm_tape_save

.asm_tape_save
