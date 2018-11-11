#include <stdio.h>
#include <stdlib.h>
#include <arch/zxn/esxdos.h>

#include "load.h"
#include "run.h"

void load_tap(void)
{
   // currently mounted tap will be closed by open
   
   if (esx_m_tapein_open(dirent_sfn.name))
      return;

   printf("\nTo start - %sLOAD \"\"\n", mode48 ? "" : "LOAD \"t:\": ");
   exit(0);
}
