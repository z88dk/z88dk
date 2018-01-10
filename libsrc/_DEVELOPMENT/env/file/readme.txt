This set of functions implements persistent environment
variables in a file on disk.  The implementation in the mem
sub-directory (one level up) does the same for environment
variables maintained in memory instead.

The global environment variables file is located in a fixed
file defined in the target's configuration.

The *_ex functions also allow an arbitrary file to be used
as an environment.  The intention is to allow specific
programs to have their own environment file to hold options.
Then these functions can be used to query those options.

Environment variables are stored one per line with each
line defined as "name = value" pairs.  Whitespace is
inconsequential except that currently only unix-style line
endings is supported, ie all lines must end in "\n" and not
"\r\n" or "\r".  Environment files can be edited with a text
editor or by using the setenv and unsetenv functions.

NOTES:

1.
All functions are written to abstract away the actual disk device
so that the code can be shared with any disk and any target machine.

The index register points at a disk io object formatted like this:

ix+18  jp unlink - remove the file
ix+15  jp write  - write BC>0 bytes at address HL to disk
ix+12  jp read   - read BC>0 bytes to address HL from disk
ix+9   jp size   - return HL = file size capped at 65534
ix+6   jp seek   - seek to file position BC
ix+3   jp close  - close the file
ix+0   jp open   - open the file with mode in A (see __ENV_DEFINES.inc)
ix-2   char *filename
ix-3   (optional) error code from disk api
ix-4   flags available for use by functions
ix-5   and below - variables reserved by disk system (eg file descriptor)

The disk functions must not modify any registers except for
return values documented above.  Carry set indicates an error
in which case the disk system's error code can be optionally
saved in (ix-3).

Use esxdos as the reference implementation.

2.
The method used to modify the environment file should be changed.

Currently the new environment file is created in a tmp file and then
the environment file is truncated in place, into which the tmp file
is copied.  This leaves open the possibility the environment file is
corrupted if the last copy step is unsuccessful.

Better would be to create the tmp file in the same directory as the
environment file, then delete the original environment file and rename
the tmp file as the environment file.  Then the likelihood of corruption
is eliminated.
