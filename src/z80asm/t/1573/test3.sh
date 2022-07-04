#!/bin/sh
z80asm -Ooutput -ooutput/foobar.bin -b -l -g -m -reloc-info input/file1.asm input/file2.asm
