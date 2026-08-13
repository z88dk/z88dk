
CHARACTER_00 — simplified serial / character stdio drivers
==========================================================

Abstract library drivers for character-oriented devices (typically serial).
Concrete targets implement one message; the library handles the rest of the
stdio message set.

Device layer contract (hardware / buffer code)
----------------------------------------------

Target code under device/ (e.g. acia_getc, uarta_putc) should provide:

  init / reset / interrupt as needed
  getc   — non-blocking preferred: carry set if char in L/A; carry reset if empty
  pollc  — carry set if Rx available (optional if getc is non-blocking)
  putc   — L = char; may return full/busy status in L for buffered Tx
  peekc / flush_Rx / flush_Tx — optional

Classic fgetc_cons / fputc_cons should thin-wrap these APIs (block on empty/
full, apply STANDARDESCAPECHARS) rather than re-implement buffer logic.

character_00_input (abstract)
-----------------------------

Consumes: STDIO_MSG_GETC, EATC, READ, SEEK, FLSH, ICTL, CLOS
Derived implements: ICHAR_MSG_GETC
  enter: ix = & FDSTRUCT.JP
  exit:  A = char; carry set on error (HL=0 stream error, HL=-1 eof)

character_00_output (abstract)
------------------------------

Consumes: STDIO_MSG_PUTC, WRIT, SEEK, FLSH, ICTL, CLOS
Derived implements: OCHAR_MSG_PUTC (text) or via OCHAR_MSG_PUTC_BIN path
  enter: C = char
  exit:  carry set if error

CRT instantiation
-----------------

Use re-entrant m4 macros (see rc2014 driver/character/rc_00_*). Multiple
ports: call the macro once per FILE. Dup stderr onto stdout with m4_file_dup.
User CRTs: CRT_INCLUDE_DRIVER_INSTANTIATION + crt_driver_instantiation.asm.m4.

FDSTRUCT type bytes: 0x03 = character input, 0x04 = character output
(see cpm_00_* and rc_00_* m4 instantiators).

console_01 vs character_00
--------------------------

console_01 / rc_01_* = full line-editing terminal (default for most startups).
character_00 / rc_00_* = simple serial character I/O (no line editor).
Both may attach to the same device layer.
