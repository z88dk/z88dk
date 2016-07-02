/*
 *      A little pointless application to demonstrate menus, topics
 *      commands, and various other functions.
 *
 *      Not very interesting, but the source will hopefully be quite
 *      informative!
 */

/* Compiler directives, no bad space, not expanded */

#pragma -no-expandz88

/* Redirect OZ required callbacks to our functions */
#pragma redirect handlecmds=_handlecmds
#pragma redirect redrawscreen=_redrawscreen



/* Call up the required header files */

#include <stdio.h>
#include <stdlib.h>


char baswindres[]= {
               1,'7','#','3',32,32,32+94,32+8,128,1,'2','C','3',
               1,'2','+','S',1,'2','+','C',0
               };

void redrawscreen(void);

main()
{
        redrawscreen();         /* Define the windows */
/* Loop forever */
        while (1)
                getk();

}

/*
 * Function called when we need to redraw the screen
 */

void redrawscreen(void)
{
/*
 * Clear the whole screen
 */
        fputs(baswindres,stdout);
        puts("A silly, pointless demo for app features");
}

/*
 * Now, some application info, have a look at doc/apps.html to see
 * what is going on!
 */

/*
 *      This function handles menu codes
 */

void  handlecmds(int cmd)
{
        fputs("So you want to....",stdout);
        switch(cmd) {
                case 0x84:
                        puts("Quit? Wait 1 second");
                        sleep(1);
                        exit(0);
                case 0x81:
                        puts("eat");
                        break;
                case 0x82:
                        puts("drink");
                        break;
                case 0x83:
                        puts("sleep");
                        break;
        }
}

#include <dor.h>

#define HELP1   "A pointless demo application made with z88dk"
#define HELP2   "Simply loops, points out menu selections and dies"
#define HELP3   "..eventually..see source for details"
#define HELP4   ""
#define HELP5   "v0.1 - 9.4.99 (djm)"
#define HELP6   ""

#define APP_INFO "Made by z88dk"
#define APP_KEY  'U'
#define APP_NAME "Useless"
#define APP_TYPE AT_Good

#define TOPIC1   "Action"
#define TOPIC1ATTR      TP_Help
#define TOPIC1HELP1     "Some help for the topic"
#define TOPIC1HELP2     "And another line of help"

#define TOPIC1_1         "Eat"
#define TOPIC1_1KEY      "AE"
#define TOPIC1_1CODE     $81
#define TOPIC1_1ATTR     MN_Help

#define TOPIC1_1HELP1    "Are you hungry?"

#define TOPIC1_2         "Drink"
#define TOPIC1_2KEY      "AD"
#define TOPIC1_2CODE     $82
#define TOPIC1_2ATTR     MN_Help
#define TOPIC1_2HELP1    "Why yes, if you're offering, mine'd a"
#define TOPIC1_2HELP2    "pint of something nice"

#define TOPIC1_3         "Sleep"
#define TOPIC1_3KEY      "AS"
#define TOPIC1_3CODE     $83
#define TOPIC1_3ATTR     MN_Help
#define TOPIC1_3HELP1    "Yawn...."

#define TOPIC2           "Commands"
#define TOPIC2ATTR       TP_Help
#define TOPIC2HELP1      "From this menu you can quit this"
#define TOPIC2HELP2      "Completely useless application"

#define TOPIC2_1         "Quit"
#define TOPIC2_1KEY      "CQ"
#define TOPIC2_1CODE     $84
#define TOPIC2_1ATTR     MN_Help
#define TOPIC2_1HELP1    "Go on, leave me now!"


#include <application.h>

/* THE END! */
