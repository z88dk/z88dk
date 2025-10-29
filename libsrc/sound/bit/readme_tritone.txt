
==========================================================
Tritone beeper music engine by Shiru (shiru@xxxx.ru) 03'11
==========================================================


Features

The engine allows to use three channels of tone with duty cycle
control, with interrupting drum channel, and per-pattern tempo.
Overall design of the player is intended to be compact and easy
to use, to allow its use in games, although music data is rather
large.

Please note that this is version 2 of the engine. Version 1 had
no tempo correction, so the tempo could flow noticeable when
drums used; all the channels had the same volume. If you want
to have the same volume on all the channels, define NO_VOLUME
(check tritone.asm)


How to make music

There is no dedicated editor for the engine. You can make music
using any tracker with XM format support. You have to follow
certain limitations. You can hear sound while editing using
template module provided, it has sounds sampled from the engine,
so the sound is somewhat similar to the end result, although not
much. After you have made a song, you can convert it to an
assembly source file with data in needed format.

You can use patterns with arbitrary lengths in your song. Module
should have no less than three channels. You can loop the order
list to any position. You can use both tempo and BPM to change
speed.

To set speed, you can use global tempo and BPM settings, or use
Fxx effects on the first row of a pattern. Every pattern can have
own speed. The speed will be recalculated as needed, to closest
possible in the player.

You can use few octaves of notes, if a note goes out of range,
the converter warn you. You can also use effect E5x on the notes
(finetune). x is 0..8..F, 8 means no change in the note frequency,
7 means a bit higher frequency, 9 means a bit lower frequency. This
could be used to produce 'fat' sounds by putting the same note on
two channels, and using E59 on every note of one of the channels. Be
careful if you use E57 or lower on low notes, it could move frequency
out of range. Converter will show you warning messages in this case.

All the channels has different volume - from low to max. Third channel
is loudest, it is about twice louder than first. To hear volume
difference in XM tracker, use volume commands, they are ignored by
converter.

You can put drums to any channel, only one drum can be played on a
row. There are two drum sets of 12 sounds, every drum sound assigned
to a note of 4 octave. You can use both sets in a song.


Music data format

List of 16-bit pointers to patterns, LSB/MSB
0
16-bit pointer to loop point (in the list of the patterns above)
Patterns data


Pattern data format

Tempo 1..65535
Up to 6 bytes per row. If a byte is 0, it is note cut, 1 is no change,
128 and greater is 16-bit divider and duty cycle in MSB, LSB format (4
bits of duty, 12 bits of divider). If first byte of a row is larger
than 1 but lesser than 128, it is a drum sound. 255 is end of the
pattern.


===========
Z88DK NOTES
===========

The engine has been modified to work on all targets regardless of
output method.  It has also been modified to play one row at a time.
This means a program can do other things, like checking for keypress
to terminate the song, between rows.

Tritone assumes a cpu speed of 3.5 MHz.  Delay loops have been
added to compensate for faster cpus but there may be some degradation
for slow cpus or cpus marginally faster than 3.5 MHz.

A Windows PC editor called "Beepola" is now available to compose
Tritone songs.
