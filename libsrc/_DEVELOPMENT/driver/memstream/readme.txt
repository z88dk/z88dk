
MEMSTREAMS

C11 introduced memstreams, which are FILEs stored in memory.


* Near memstream driver

A FILE is created in near memory (ie the usual 64k memory space).
The memory required by the memstream is managed by a b_vector
and is allocated using realloc().


* Far memstream driver

Not implemented yet.
The driver makes use of bankswitched memory to hold memory files
larger than 64k.

An implementation may alternatively introduce a ramdisk device to access
memory outside the 64k area.  A ramdisk device is treated as a block
device so that stdio will hold copies of records in the local 64k
space for access by the program.  The ramdisk device driver is
responsible for copying records from bankswitched memory to and from
stdio's local copies.
