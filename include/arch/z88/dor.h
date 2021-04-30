/*
 *      Really, really short header file which defines the application
 *      types.
 *
 *      To make an app do the following:
 *
 *      #include <dor.h>
 *
 *      define your config here
 *
 *      #include <application.h>
 *
 *      And with a bit of luck, an application DOR will be created -
 *      hurrah!
 *
 *      We're quite naughty cos the default is not to redraw the screen
 *      very bad, but we can't avoid this at the moment due to the generic
 *      library routines
 *
 *      djm 1/4/99
 *
 *	$Id: dor.h,v 1.2 2001-04-20 16:04:24 dom Exp $
 */


#define AT_Good         1
#define AT_Bad          2
#define AT_Ugly         4
#define AT_Popd         8
#define AT_Ones         16
#define AT_Draw         32
#define AT_Film         64
#define AT_Boot         128

#define AT_Def          AT_Bad | AT_Draw

#define AT2_Cl          1
#define AT2_Icl         2
#define AT2_Ie          128

/*
 * Some #defines for menus, these should be orred together
 * All other bits should be zero, default is 0
 */

#define MN_Col          1
#define MN_Hidden       4
#define MN_Safe         8
#define MN_Help         16

#define MN_Def          0

/*
 * Now for topics!
 */

#define TP_An           1
#define TP_Inf          2
#define TP_Help         16

#define TP_Def          0

