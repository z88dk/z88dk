# Far memory implementation for MSXDOS2

Implements a 24bit pointer providing linear access to extended memory.

The 24bit pointer provides a logical address which is then mapped to a physical segment via the mapping table kept in the MSXDOS crt0 file.

A 24 bit pointer is passed in ehl, and can be mapped into 16kb chunks as follows:

e = 0 = near memory, whatever is paged in
e = 1 0x0000 -> 0x3fff	= bank 1 (__msx_bank_mappings + 1)
e = 1 0x4000 -> 0x7fff	= bank 2 (__msx_bank_mappings + 2)
e = 1 0x8000 -> 0xbfff	= bank 3
e = 1 0xc000 -> 0xffff	= bank 4

etc 
