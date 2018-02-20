(INCOMPLETE)

Shows how to implement stdin, stdout, stderr for a generic target.
Must customize the asm functions found in terminal/term_01_output_char

Compile:

sccz80
zcc +z80 -vn -clib=new @zproject.lst -o test -pragma-include:zpragma.inc -create-app

zsdcc:
zcc +z80 -vn -clib=sdcc_iy -SO3 --max-allocs-per-node200000 @zproject.lst -o test -pragma-include:zpragma.inc -create-app
