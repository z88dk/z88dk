# Arkos support tools

If you want to use an Arkos music/effects file (`.aks` extension) with the
Arkos player, you need to convert it to a binary piece of data that the
player understands and include it in your program.

You can use the `arkos-song-to-asm.pl` script to convert the AKS file to an
Z88DK assembler file containing your song, which you can then compile and
include in your program as an additional source file.

For this tool to work, you need to have Arkos 2 installed, these script uses
its tools to do the conversion.

The `arkos-to-z88dk.pl` tool should only be used to update the Arkos player
source code included in the Z88DK library.  The Arkos sources have not been
written for the Z88DK assembler and so must be prepared before being used by
Z88DK (but regular users do not need to do this, read below!)

For this latter script, you also need to have the RASM assembler installed.

See the **References** section at the end of this document for the places
where you can download the required software.

## Converting Arkos music and effects files

Converting a song from a file called `my_song.aks` and exporting the binary
data to your program as a byte array called `_my_song_data`, and redirecting
the output to `my_song.asm`:

```
./arkos-song-to-asm.pl -s _my_song_data my_song.aks > my_song.asm
```

Converting sound effects from a file called `my_effects.aks` and exporting
the binary data to your program as a table called `_my_effects_data`, and
redirecting the output to `my_effects.asm`:

```
./arkos-song-to-asm.pl -e -s _my_effects_data my_effects.aks > my_effects.asm
```

You can (most probably should) pass the optional `-p <arkos_install_path>`
argument to specify where your Arkos install is, so that the script can find
and use the needed Arkos export tools.

## Updating the player from original Arkos sources

As a user, you don't need to do this yourself, Z88DK already ships with a
ready-to-use Arkos player library.  This section is mostly intended for
Z88DK developers and library maintainers.

Follow these steps:

- Install Arkos and RASM assembler

- Edit the Makefile and ensure the paths for Arkos and RASM are set to the
  ones corresponding to your installation

- Copy the files `PlayerAkg.asm` and `PlayerAkg_SoundEffects.asm` to this
  directory

- Execute `make update-all-players`  in this directory.  The new sources
  will be processed and installed to the relevant places under the `libsrc`
  directory.

- Commit the changes

## References

- RASM: https://github.com/EdouardBERGE/rasm

- Arkos Tracker 2: https://www.julien-nevo.com/arkostracker/index.php/download/
