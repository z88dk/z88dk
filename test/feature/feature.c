#include <features.h>
#include <stdio.h>
#include <graphics.h>
#include <input.h>
#include <sound.h>
#include <games.h>
#include <time.h>

int main()
{
   char buf[10];
   int  c;

   printf("x\n");
#ifdef __HAVE_FGETC_CONS
   c = fgetc_cons();
 #ifdef __HAVE_GETK
   c = getk();
 #endif
#endif
#ifdef __HAVE_INKEY
   c = in_LookupKey('2');
   c = in_KeyPressed(2);
   c = in_Inkey();
#endif
#ifdef __HAVE_GFX
   plot(0,0);
   unplot(0,0);
 #ifdef __HAVE_GFX_XORPLOT
   xorplot(0,0);
 #endif
 #ifdef __HAVE_GFX_POINTXY
   point(0,0);
 #endif
#endif
#ifdef __HAVE_ONEBITSOUND
   bit_click(1);
#endif
#ifdef __HAVE_TIME
   c = time(NULL);
#endif
#ifdef __HAVE_FILEIO
   fopen("asfsf","r");
   c = read(0, buf, 0);
   fclose(NULL);
#endif
#ifdef __HAVE_JOYSTICK
   c = joystick(1);
   {
     char *d = joystick_type[0];
   }
#endif
}

#if defined(__Z88__) && defined(__Z88_APPLICATION)
#include <arch/z88/dor.h>


#include <arch/z88/application.h>


#endif
