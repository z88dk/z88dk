/*
; TVC specific tune player function,
; plays a melody with TVC native player
;
; Based on the work of Stefano Bodrato 2021
;
; Syntax: "TONE(#/b)(+/-)(duration)(.volume)"
;   TONE is one of the possible notes (CDEFGAB)
;   #/b: half note
;   +/-: octave shift
;   duration: real sustain is duration*80ms
;   volume is 0-f (hex digit)
; Sample:
;		tvc_tune_play("C8DEb4DC8");
;		tvc_tune_play("C8DEb4DC8");
;		tvc_tune_play("Eb8FGG");
;		tvc_tune_play("Eb8FGG");
;		tvc_tune_play("G8Ab4G8F4Eb4DC");
;		tvc_tune_play("G8Ab4G8F4Eb4DC");
;		tvc_tune_play("C8GC");
;		tvc_tune_play("C8GGC");
; using the volume:
;       tvc_tune_play("C4.fD8.aE4.5);
*/
#include <tvc.h>

void __LIB__ tvc_tune_play(char melody[])
{
    int sound;
    int duration = 2;
    char volume = 15;
    tvc_set_os_sound_interrupting(false);   // set to wait 
	tvc_enable_sound(true);
    while ( *melody != 0 )
    {
        switch (*melody++) {
	    case 'C':
		    if (*melody=='#') {
		    	sound=277;
		    	melody++;
			}
		    else
			    sound=262;
	    break;
	    case 'D':
		    if (*melody=='#') {
			    sound=311;
			    melody++;
			}
		    else if (*melody=='b') {
			    sound=277;
			    melody++;
			}
		    else
			    sound=294;
	    break;
	    case 'E':
		    if (*melody=='b') {
			    sound=311;
			    melody++;
			}
		    else
			    sound=330;
	    break;
	    case 'F':
		    if (*melody=='#') {
			    sound=370;
			    melody++;
			}
		    else
		    	sound=349;
	    break;
	    case 'G':
		    if (*melody=='#') {
		    	sound=415;
		    	melody++;
			}
		    else if (*melody=='b') {
		    	sound=370;
		    	melody++;
			}
		    else
		    	sound=392;
	    break;
	    case 'A':
	    	if (*melody=='#') {
		    	sound=466;
		    	melody++;
		    	}
		    else if (*melody=='b') {
		    	sound=415;
		    	melody++;
			}
		    else
		    	sound=440;
    	break;
	    case 'B':
		    if (*melody=='b') {
		    	sound=466;
		    	melody++;
		 	}
		    else
		    	sound=494;
    	break;
		}
		if( *melody == '+') {
			sound*=2;
			melody++;
		} else if (*melody == '-') {
			sound/=2;
			melody++;
		}
	    if (*melody>'0' && *melody<='9') duration=(*melody++)-'0';
        if (*melody=='.') {
            volume = *(++melody);
            if(volume>='0' && volume<='9') volume -= '0';
            if(volume>='a' && volume <= 'f') volume -= 'a' + 10;
            ++melody;
        }
	    if ((*melody >= 'A' && *melody <= 'H') || *melody==0) {
            int pitch = tvc_get_raw_pitch(sound);
            tvc_play_os_sound(pitch, volume, duration * 4);
        }
    }
    while(tvc_is_os_sound_playing()) {} // let's wait until the last note is finished
}
