/* This part of the benchmark is based on real-world code.
   Source: http://sdcc.sourceforge.net/

   (c) 2013        Valentin Dudouyt
   (c) 2013 - 2018 Philipp Klaus Krause
   (c) 2013        Maarten Brock
   (c) 2013 - 2014 Ben Shi

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90LIB

#include <ctype.h>
#include <string.h>

#include "c90lib-peep.h"

/* This function should behave just like C99 isblank(). */
static int _isblank(int c)
{
  return (c == ' ' || c == '\t');
}

typedef enum
{
  S4O_CONDJMP,
  S4O_WR_OP,
  S4O_RD_OP,
  S4O_TERM,
  S4O_VISITED,
  S4O_ABORT,
  S4O_CONTINUE
} S4O_RET;

#define ISINST(l, i) (!strncmp((l), (i), sizeof(i) - 1))

/* Check if reading arg implies reading what. */
static bool argCont(const char *arg, char what)
{
  if (arg == NULL || strlen (arg) == 0 || !(what == 'a' || what == 'x' || what == 'y'))
    return FALSE;

  while (_isblank ((unsigned char)(arg[0])))
    arg++;

  if (arg[0] == ',')
    arg++;

  while (_isblank ((unsigned char)(arg[0])))
    arg++;

  if (arg[0] == '#')
    return FALSE;

  if (arg[0] == '(' && arg[1] == '0' && (tolower(arg[2])) == 'x') 
    arg += 3; /* Skip hex prefix to avoid false x positive. */

  if (strlen(arg) == 0)
    return FALSE;

  return (strchr(arg, what) != NULL);
}

static bool
stm8MightReadFlag(const lineNode *pl, const char *what)
{
  if (!strcmp (what, "n"))
    return FALSE;

  if (!strcmp (what, "z"))
    return FALSE;

  return TRUE;
}

static bool
stm8MightRead(const lineNode *pl, const char *what)
{
  char extra = 0;

  if (!strcmp (what, "xl") || !strcmp (what, "xh"))
    extra = 'x';
  else if (!strcmp (what, "yl") || !strcmp (what, "yh"))
    extra = 'y';
  else if (strcmp (what, "a") != 0)
    return stm8MightReadFlag(pl, what);

  if (!extra)
    {
      if (ISINST (pl->line, "adc")
        || ISINST (pl->line, "sbc"))
          return TRUE;

      if (pl->line[4] == 'a' &&
        (ISINST (pl->line, "add")
        || ISINST (pl->line, "sub")))
          return TRUE;

      if ((ISINST (pl->line, "ld") || ISINST (pl->line, "ldf")) && argCont (strchr (pl->line, ','), 'a'))
          return TRUE;
    }
  else
    {
      if (pl->line[5] == extra &&
        (ISINST (pl->line, "addw")
        || ISINST (pl->line, "subw")))
          return TRUE;

      if ((strchr (pl->line, ',') ? argCont (strchr (pl->line, ','), extra) : argCont (strchr (pl->line, '('), extra)) && (ISINST (pl->line, "adc")
        || (ISINST (pl->line, "add") && !ISINST (pl->line, "addw"))
        || ISINST (pl->line, "sbc")
        || (ISINST (pl->line, "sub") && !ISINST (pl->line, "subw"))
        || ISINST (pl->line, "ldf")
        || ISINST (pl->line, "ldw")
        || (ISINST (pl->line, "ld") && !ISINST (pl->line, "ldw"))))
          return TRUE;

      if (ISINST (pl->line, "ld"))
        {
          char buf[64], *p;
          strcpy (buf, pl->line);
          if (!!(p = strstr (buf, "0x")) || !!(p = strstr (buf, "0X")))
            p[0] = p[1] = ' ';
          if (!!(p = strchr (buf, '(')) && !!strchr (p, extra))
            return TRUE;
        }
    }

  return FALSE;
}

static bool
stm8SurelyWritesFlag(const lineNode *pl, const char *what)
{
  if (!strcmp (what, "n") || !strcmp (what, "z"))
    {
      if (ISINST (pl->line, "addw") && !strcmp (pl->line + 5, "sp"))
        return FALSE;
      if (ISINST (pl->line, "sub") && !strcmp (pl->line + 4, "sp"))
        return FALSE;
      if (ISINST (pl->line, "ld") || ISINST (pl->line, "ldw"))
        return FALSE;
      return TRUE;
    }

  return FALSE;
}

static bool
stm8SurelyWrites(const lineNode *pl, const char *what)
{
  char extra = 0;
  if (!strcmp (what, "xl") || !strcmp (what, "xh"))
    extra = 'x';
  else if (!strcmp (what, "yl") || !strcmp (what, "yh"))
    extra = 'y';
  else if (strcmp (what, "a"))
    return (stm8SurelyWritesFlag (pl, what));

  if (!extra)
    {
      if (ISINST (pl->line, "adc")
        || ISINST (pl->line, "sbc"))
          return TRUE;

      if (pl->line[4] == 'a' &&
        (ISINST (pl->line, "add")
        || ISINST (pl->line, "sub")))
          return TRUE;

      if (pl->line[3] == 'a' && ISINST (pl->line, "ld"))
        return TRUE;
    }
  else
    {
      if (pl->line[4] == extra && ISINST (pl->line, "ldw"))
          return TRUE;

      if (pl->line[5] == extra && (ISINST (pl->line, "addw")
        || ISINST (pl->line, "subw")))
          return TRUE;

      if ((ISINST (pl->line, "ld") && !ISINST (pl->line, "ldw") && !ISINST (pl->line, "ldf"))
        && strncmp (pl->line + 3, what, strlen (what)) == 0)
        return TRUE;
    }

  return FALSE;
}

static S4O_RET
scan4op (lineNode **pl, const char *what, const char *untilOp,
         lineNode **plCond)
{
  for (; *pl; *pl = (*pl)->next)
    {
      if (!(*pl)->line || (*pl)->isComment)
        continue;

      if ((*pl)->visited)
        return S4O_VISITED;

      (*pl)->visited = TRUE;

      if(stm8MightRead(*pl, what))
        return S4O_RD_OP;

      if(stm8SurelyWrites(*pl, what))
        return S4O_WR_OP;
    }
  return S4O_ABORT;
}

/*-----------------------------------------------------------------*/
/* doTermScan - scan through area 2. This small wrapper handles:   */
/* - action required on different return values                    */
/* - recursion in case of conditional branches                     */
/*-----------------------------------------------------------------*/
static bool
doTermScan (lineNode **pl, const char *what)
{
  lineNode *plConditional;
  for (;; *pl = (*pl)->next)
    {
      switch (scan4op (pl, what, NULL, &plConditional))
        {
          case S4O_TERM:
          case S4O_VISITED:
          case S4O_WR_OP:
            /* all these are terminating conditions */
            return TRUE;
          case S4O_RD_OP:
          default:
            /* no go */
            return FALSE;
        }
    }
}

/*-----------------------------------------------------------------*/
/* univisitLines - clear "visited" flag in all lines               */
/*-----------------------------------------------------------------*/
static void
unvisitLines (lineNode *pl)
{
  for (; pl; pl = pl->next)
    pl->visited = FALSE;
}

bool
stm8notUsed (const char *what, lineNode *endPl, lineNode *head)
{
  lineNode *pl;
  if(strcmp(what, "x") == 0)
    return(stm8notUsed("xl", endPl, head) && stm8notUsed("xh", endPl, head));
  else if(strcmp(what, "y") == 0)
    return(stm8notUsed("yl", endPl, head) && stm8notUsed("yh", endPl, head));

  unvisitLines (head);

  pl = endPl->next;
  return (doTermScan (&pl, what));
}

#endif

