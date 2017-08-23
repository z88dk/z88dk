
/*
 oztime() by Alexander R. Pruss, based on public domain scaldate::
 scalar date routines    --    public domain by Ray Gardner
 Numerically, these will work over the range 1/01/01 thru 14699/12/31.
 Practically, these only work from the beginning of the Gregorian 
 calendar thru 14699/12/31.  The Gregorian calendar took effect in
 much of Europe in about 1582, some parts of Germany in about 1700, in
 England and the colonies in about 1752ff, and in Russia in 1918.
*/

#include <math.h>
//#include <oz.h>

#define isleap(yr) ( yr % 400 == 0 || (yr % 4 == 0 && yr % 100 != 0) )

#define months_to_days(month) ( (month * 3057 - 3007) / 100 )

#define years_to_days(yr) ( yr * 365L + yr / 4 - yr / 100 + yr / 400 )


static unsigned long time0(void)
{
   static unsigned long scalar;
   static unsigned long yr;
   //static byte mo;
   static int mo;
   yr=ozyear();
   mo=ozmonth();
   scalar = ozday() + months_to_days(mo);
   if ( mo > 2 )                         // adjust if past February
      scalar -= isleap(yr) ? 1 : 2;
   yr--;
   scalar += years_to_days(yr)-(1970*365L+1970/4-1970/100+1970/400);
   return scalar*86400L + ozhour()*3600L + (unsigned int)ozmin()*60
    + ozsec();
}



long oztime(void)
{
    static unsigned long t0;
    t0=time0(); 
    if(t0!=time0()) return time0();
        // watch out for carry problems on tc8521
    else return t0;
}

