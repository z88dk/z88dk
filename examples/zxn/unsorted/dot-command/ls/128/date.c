#include <stdio.h>
#include <time.h>

#include "date.h"
#include "ls.h"

struct tm date_tm;

static unsigned char buffer[30];

static unsigned char *months[] = {
   "Jan", "Feb", "Mar", "Apr", "May", "Jun",
   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
};

unsigned char *date_fmt_long_iso(struct dos_tm *dt)
{
   tm_from_dostm(&date_tm, dt);

   sprintf(buffer, "%04u-%02u-%02u %02u:%02u", date_tm.tm_year + 1900, date_tm.tm_mon + 1, date_tm.tm_mday, date_tm.tm_hour, date_tm.tm_min);
   
   return buffer;
}

unsigned char *date_fmt_iso(struct dos_tm *dt)
{
   tm_from_dostm(&date_tm, dt);
   
   if ((current_month == date_tm.tm_mon) && (current_year == date_tm.tm_year))
      sprintf(buffer, "%02u-%02u %02:%02", date_tm.tm_mon + 1, date_tm.tm_mday, date_tm.tm_hour, date_tm.tm_min);
   else
      sprintf(buffer, "%04u-%02u-%02u", date_tm.tm_year + 1900, date_tm.tm_mon + 1, date_tm.tm_mday);
   
   return buffer;
}

unsigned char *date_fmt_locale(struct dos_tm *dt)
{
   tm_from_dostm(&date_tm, dt);

   sprintf(buffer, "%s-%02u-%04u %02u:%02u", months[date_tm.tm_mon], date_tm.tm_mday, date_tm.tm_year + 1900, date_tm.tm_hour, date_tm.tm_min);
   
   return buffer;
}
