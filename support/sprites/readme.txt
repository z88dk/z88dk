


Z88DK Sprite Editor
-------------------
By Daniel McKinnon

(windows port tested by Stefano Bodrato)


This is a simple sprite editor for z88dk with it's main feature being that it
automatically will generate code for you.

This program is a little dodgy, and could use some work.  That's why you can send
me YOUR OWN updates!  stikmansoftware@yahoo.com
Anything welcome


Compiling:
Make sure you have Allegro (obtainable at http://www.allegro.cc/) a C compiler, and
an Operating System (which includes the Virus known as Wingblowz! :)


Unix: type "gcc -o sprite sprite.c `allegro-config --libs` "
Those are ticks " ' " (above the ~ key on most keyboards) not apostraphies " ' "

DJGPP: type "gcc -o sprite.exe sprite.c -lalleg "

Wingblowz:  works with some change in the source (commented out).


How to use:

Image Editing
Up / Down......................Zoom In / Out
I..............................Invert Sprite
L..............................Import From BMP or PCX
C..............................Choose Source Sprite for Copying (copy)
P..............................Copy Source sprite to current sprite (paste)


Saving / Loading
F2.............................Saves all sprites into a sprite file (not code)
F3.............................Load sprites from sprite file (not code)
F5.............................Save code file generating code from sprite 0 - selected

