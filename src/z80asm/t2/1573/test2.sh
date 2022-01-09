#!/bin/sh
z80asm -Ooutput -ofoobar.bin -b -l -g -m -reloc-info input/file1.asm input/file2.asm
