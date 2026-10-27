/* Benchmark parsing in a peephole optimizer
   At a lower level, we mostly benchmark string handling and memory management.
   This part of the benchmark is based on real-world code.
   Source: http://sdcc.sourceforge.net/ 

   (c) ?    - ?    Michael Hope
   (c) ?    - ?    ?
   (c) ?    - ?    Kevin Vigor
   (c) ?    - ?    Johan Knol
   (c) ?    - ?    Scott Dattalo
   (c) ?    - ?    Paul Stoffregen
   (c) 1998 - ?    Sandeep Dutta
   (c) ?    - ?    Frieder Ferlemann
   (c) ?    - 2006 Bernhard Held
   (c) ?    - 2004 Erik Petrich
   (c) 2004 - 2016 Maarten Brock
   (c) 2007 - 2010 Borut Razem
   (c) 2007        Jesus Calvino-Fraga
   (c) 2008 - 2018 Philipp Klaus Krause
   (c) 2012        Leland Morrison
   (c) 2014 - 2017 Ben Shi

   This program is free software; you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by the
   Free Software Foundation; either version 2, or (at your option) any
   later version. */

#include "stdcbench.h"

#ifdef C90LIB

#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "c90lib-htab.h"

#include "c90lib-peep.h"

#define ISCHARDIGIT(c) isdigit((unsigned char)c)
#define ISCHARSPACE(c) isspace((unsigned char)c)
#define ISCHARALNUM(c) isalnum((unsigned char)c)

#define MAX_PATTERN_LEN 80

typedef struct peepRule
  {
    lineNode *match;
    lineNode *replace;
    unsigned int restart:1;
    unsigned int barrier:1;
    char *cond;
    hTab *vars;
    struct peepRule *next;
  }
peepRule;

#define FBYNAME(x) static int x (hTab *vars, lineNode *currPl, lineNode *endPl, \
        lineNode *head, char *cmdLine)

static peepRule *rootRules = 0;
static peepRule *currRule = 0;

/*-----------------------------------------------------------------*/
/* newLineNode - creates a new peep line                           */
/*-----------------------------------------------------------------*/
lineNode *
newLineNode (const char *line)
{
  lineNode *pl;

  pl = Safe_alloc (sizeof (lineNode));
  pl->line = Safe_strdup (line);
  return pl;
}

/*-----------------------------------------------------------------*/
/* newLineNode - destroys a new peep line                           */
/*-----------------------------------------------------------------*/
void
deleteLineNode (lineNode *pl)
{
  Safe_free (pl->line);
  Safe_free (pl);
}

/*-----------------------------------------------------------------*/
/* connectLine - connects two lines                                */
/*-----------------------------------------------------------------*/
lineNode *
connectLine (lineNode * pl1, lineNode * pl2)
{
  if (!pl1 || !pl2)
    {
      stdcbench_error("c90lib c90lib_peep(): trying to connect null line\n");
      return NULL;
    }

  pl2->prev = pl1;
  pl1->next = pl2;

  return pl2;
}

/*-----------------------------------------------------------------*/
/* notUsed - Check, if value in register is not read again         */
/*-----------------------------------------------------------------*/
FBYNAME (notUsed)
{
  char *digitend;
  char *var;

  while (*cmdLine)
    {
      if (*cmdLine++ == '%')
        {
          int varNumber = strtol (cmdLine, &digitend, 10);
          var = hTabItemWithKey (vars, varNumber);
          break;
        }
      else if (*cmdLine != '\'')
        {
          var = cmdLine;
          *strchr (cmdLine, '\'') = 0;
          break;
        }
    }

  return (stm8notUsed (var, endPl, head));
}

static const struct ftab
{
  const char *fname;
  int (*func) (hTab *, lineNode *, lineNode *, lineNode *, char *);
}
ftab[] =
{
  {
    "notUsed", notUsed
  },
};

/*-----------------------------------------------------------------*/
/* callFuncByName - calls a function as defined in the table       */
/*-----------------------------------------------------------------*/
static int
callFuncByName (char *fname,
                hTab *vars,
                lineNode *currPl, /* first source line matched */
                lineNode *endPl,  /* last source line matched */
                lineNode *head)
{
  int   i;
  char  *cmdCopy, *funcName, *funcArgs, *cmdTerm;
  char  c;
  int   rc;

  /* Isolate the function name part (we are passed the full condition
   * string including arguments)
   */
  cmdTerm = cmdCopy = Safe_strdup(fname);

  do
    {
      funcArgs = funcName = cmdTerm;
      while ((c = *funcArgs) && c != ' ' && c != '\t' && c != '(')
        funcArgs++;
      *funcArgs = '\0';  /* terminate the function name */
      if (c)
        funcArgs++;

      /* Find the start of the arguments */
      if (c == ' ' || c == '\t')
        while ((c = *funcArgs) && (c == ' ' || c == '\t'))
          funcArgs++;

      /* If the arguments started with an opening parenthesis,  */
      /* use the closing parenthesis for the end of the         */
      /* arguments and look for the start of another condition  */
      /* that can optionally follow. If there was no opening    */
      /* parethesis, then everything that follows are arguments */
      /* and there can be no additional conditions.             */
      if (c == '(')
        {

          int num_parenthesis = 0;
          cmdTerm = funcArgs;          

          while ((c = *cmdTerm) && (c != ')' || num_parenthesis))
            {
              if (c == '(')
                num_parenthesis++;
              else if (c == ')')
                num_parenthesis--;
              cmdTerm++;
            }
          *cmdTerm = '\0';  /* terminate the arguments */
          if (c == ')')
            {
              cmdTerm++;
              while ((c = *cmdTerm) && (c == ' ' || c == '\t' || c == ','))
                cmdTerm++;
              if (!*cmdTerm)
                cmdTerm = NULL;
            }
          else
            cmdTerm = NULL; /* closing parenthesis missing */
        }
      else
        cmdTerm = NULL;

      if (!*funcArgs)
        funcArgs = NULL;

      rc = -1;
      for (i = 0; i < ((sizeof (ftab)) / (sizeof (struct ftab))); i++)
        {
          if (strcmp (ftab[i].fname, funcName) == 0)
            {
              rc = (*ftab[i].func) (vars, currPl, endPl, head, funcArgs);
              break;
            }
        }

      if (rc == -1)
        {
          stdcbench_error("c90lib c90lib_peep(): could not find named function in peephole function table\n");

          /* If the function couldn't be found, let's assume it's
             a bad rule and refuse it. */
          rc = FALSE;
          break;
        }
    }
  while (rc && cmdTerm);

  Safe_free(cmdCopy);

  return rc;
}

/*-----------------------------------------------------------------*/
/* newPeepRule - creates a new peeprule and attach it to the root  */
/*-----------------------------------------------------------------*/
static peepRule *
newPeepRule (lineNode *match,
             lineNode *replace,
             char *cond,
             int restart,
             int barrier)
{
  peepRule *pr;

  pr = Safe_alloc ( sizeof (peepRule));
  pr->match = match;
  pr->replace = replace;
  pr->restart = restart;
  pr->barrier = barrier;

  if (cond && *cond)
    {
      pr->cond = Safe_strdup (cond);
    }
  else
    pr->cond = NULL;

  pr->vars = newHashTable (4);

  /* if root is empty */
  if (!rootRules)
    rootRules = currRule = pr;
  else
    currRule = currRule->next = pr;

  return pr;
}

#define SKIP_SPACE(x,y) { while (*x && (ISCHARSPACE(*x) || *x == '\n')) x++; \
                         if (!*x) { stdcbench_error("c90lib c90lib_peep(): expected space\n"); return ; } }

#define EXPECT_STR(x,y,z) { while (*x && strncmp(x,y,strlen(y))) x++ ;   \
                           if (!*x) { stdcbench_error("c90lib c90lib_peep(): expected str\n"); return ; } }
#define EXPECT_CHR(x,y,z) { while (*x && *x != y) x++ ;   \
                           if (!*x) { stdcbench_error("c90lib c90lib_peep(): expected chr\n"); return ; } }

/*-----------------------------------------------------------------*/
/* getPeepLine - parses the peep lines                             */
/*-----------------------------------------------------------------*/
static void
getPeepLine (lineNode **head, const char **bpp)
{
  char lines[MAX_PATTERN_LEN];
  char *lp;
  int isComment;

  lineNode *currL = NULL;
  const char *bp = *bpp;
  while (1)
    {
      if (!*bp)
        {
          return;
        }

      if (*bp == '\n')
        {
          bp++;
          while (ISCHARSPACE (*bp) ||
                 *bp == '\n')
            bp++;
        }

      if (*bp == '}')
        {
          bp++;
          break;
        }

      /* read till end of line */
      lp = lines;
      while ((*bp != '\n' && *bp != '}') && *bp)
        *lp++ = *bp++;
      *lp = '\0';

      lp = lines;
      while (*lp && ISCHARSPACE(*lp))
        lp++;
      isComment = (*lp == ';');

      if (!currL)
        *head = currL = newLineNode (lines);
      else
        currL = connectLine (currL, newLineNode (lines));
      currL->isComment = isComment;
    }

  *bpp = bp;
}

/*-----------------------------------------------------------------*/
/* readRules - reads the rules from a string buffer                */
/*-----------------------------------------------------------------*/
static void
readRules (const char *bp)
{
  char restart = 0, barrier = 0;
  char lines[MAX_PATTERN_LEN];
  size_t safetycounter;
  char *lp;
  const char *rp;
  lineNode *match;
  lineNode *replace;
  lineNode *currL = NULL;

  if (!bp)
    return;
top:
  restart = 0;
  barrier = 0;

  /* look for the token "replace" that is the
     start of a rule */
  while (*bp && strncmp (bp, "replace", 7))
    {
      if (!strncmp (bp, "barrier", 7))
        barrier = 1;
      bp++;
    }

  /* if not found */
  if (!*bp)
    return;

  /* then look for either "restart" or '{' */
  while (strncmp (bp, "restart", 7) &&
         *bp != '{' && bp)
    bp++;

  /* not found */
  if (!*bp)
    {
      stdcbench_error("c90lib c90lib_peep(): expected 'restart' or '{'\n");
      return;
    }

  /* if brace */
  if (*bp == '{')
    bp++;
  else
    {                           /* must be restart */
      restart++;
      bp += strlen ("restart");
      /* look for '{' */
      EXPECT_CHR (bp, '{', "expected '{'\n");
      bp++;
    }

  /* skip thru all the blank space */
  SKIP_SPACE (bp, "unexpected end of rule\n");

  match = replace = currL = NULL;
  /* we are the start of a rule */
  getPeepLine (&match, &bp);

  /* now look for by */
  EXPECT_STR (bp, "by", "expected 'by'\n");

  /* then look for a '{' */
  EXPECT_CHR (bp, '{', "expected '{'\n");
  bp++;

  /* save char position (needed for generating error msg) */
  rp = bp;

  SKIP_SPACE (bp, "unexpected end of rule\n");
  getPeepLine (&replace, &bp);

  /* look for a 'if' */
  while ((ISCHARSPACE (*bp) || *bp == '\n') && *bp)
    bp++;

  if (strncmp (bp, "if", 2) == 0)
    {
      bp += 2;
      while ((ISCHARSPACE (*bp) || *bp == '\n' || (*bp == '/' && *(bp+1) == '/')) && *bp)
      {
        bp++;
        if (*bp == '/')
          while (*bp && *bp != '\n')
            bp++;
      }
      if (!*bp)
        {
          stdcbench_error("c90lib c90lib_peep(): expected condition name\n");
          return;
        }

      /* look for the condition */
      lp = lines;
      for (safetycounter = 0; *bp && (*bp != '\n'); safetycounter++)
        {
          if (safetycounter >= MAX_PATTERN_LEN)
            stdcbench_error("c90lib c90lib_peep(): Peephole line too long.\n");
          *lp++ = *bp++;
        }
      *lp = '\0';

      newPeepRule (match, replace, lines, restart, barrier);
    }
  else
    {
      if (*bp && strncmp (bp, "replace", 7) && strncmp (bp, "barrier", 7))
        {
          stdcbench_error("c90lib c90lib_peep(): expected '} if ...'\n");
          
          return;
        }
      newPeepRule (match, replace, NULL, restart, barrier);
    }
  goto top;

}

static void
destroyRules(void)
{
  peepRule *pr, *oldpr;
  lineNode *pl, *oldpl;

  for(pr = rootRules; pr;)
    {
      oldpr = pr;
      pr = pr->next;

      if  (oldpr->cond)
        Safe_free (oldpr->cond);

      for (pl = oldpr->match; pl;)
        {
          oldpl = pl;
          pl = pl->next;
          deleteLineNode(oldpl);
        }

      for (pl = oldpr->replace; pl;)
        {
          oldpl = pl;
          pl = pl->next;
          deleteLineNode(oldpl);
        }

      Safe_free (oldpr);
    }

  rootRules = 0;
}

/*-----------------------------------------------------------------*/
/* keyForVar - returns the numeric key for a var                   */
/*-----------------------------------------------------------------*/
static int
keyForVar (const char *d)
{
  int i = 0;

  while (ISCHARDIGIT (*d))
    {
      i *= 10;
      i += (*d++ - '0');
    }

  return i;
}

/*-----------------------------------------------------------------*/
/* bindVar - binds a value to a variable in the given hashtable    */
/*-----------------------------------------------------------------*/
static void
bindVar (int key, char **s, hTab ** vtab)
{
  char vval[MAX_PATTERN_LEN];
  char *vvx;
  char *vv = vval;

  /* first get the value of the variable */
  vvx = *s;
  /* the value is ended by a ',' or space or newline or null or ) */
  while (*vvx &&
         *vvx != ',' &&
         !ISCHARSPACE (*vvx) &&
         *vvx != '\n' &&
         *vvx != ':' &&
         *vvx != ')')
    {
      char ubb = 0;
      /* if we find a '(' then we need to balance it */
      if (*vvx == '(')
        {
          ubb++;
          while (ubb)
            {
              *vv++ = *vvx++;
              if (*vvx == '(')
                ubb++;
              if (*vvx == ')')
                ubb--;
            }
          /* include the trailing ')' */
          *vv++ = *vvx++;
        }
      else
        *vv++ = *vvx++;
    }
  *s = vvx;
  *vv = '\0';
  /* got value */
  vvx = Safe_strdup(vval);

  hTabAddItem (vtab, key, vvx);
}

/*-----------------------------------------------------------------*/
/* matchLine - matches one line                                    */
/*-----------------------------------------------------------------*/
static bool
matchLine (char *s, const char *d, hTab ** vars)
{
  if (!s || !(*s))
    return FALSE;

  /* skip leading white spaces */
  while (ISCHARSPACE (*s))
    s++;
  while (ISCHARSPACE (*d))
    d++;

  while (*s && *d)
    {
      /* if the destination is a var */
      if (*d == '%' && ISCHARDIGIT (*(d + 1)) && vars)
        {
          const char *v = hTabItemWithKey (*vars, keyForVar (d + 1));
          /* if the variable is already bound
             then it MUST match with dest */
          if (v)
            {
              while (*v)
                if (*v++ != *s++)
                  return FALSE;
            }
          else
            /* variable not bound we need to bind it */
            bindVar (keyForVar (d + 1), &s, vars);

          /* in either case go past the variable */
          d++;
          while (ISCHARDIGIT (*d))
            d++;
        }
      else if (ISCHARSPACE (*s) && ISCHARSPACE (*d)) /* whitespace sequences match any whitespace sequences */
        {
          while (ISCHARSPACE (*s))
            s++;
          while (ISCHARSPACE (*d))
            d++;
        }
      else if (*s == ',' && *d == ',') /* Allow comman to match comma followed by whitespace */
        {
          s++, d++;
          while (ISCHARSPACE (*s))
            s++;
          while (ISCHARSPACE (*d))
            d++;
        }
      else if (*s && *d) /* they should be an exact match otherwise */
        {
          if (*s++ != *d++)
            return FALSE;
        }
    }

  /* skip trailing whitespaces */
  if (*s)
    while (ISCHARSPACE (*s))
      s++;

  if (*d)
    while (ISCHARSPACE (*d))
      d++;

  /* after all this if only one of them
     has something left over then no match */
  if (*s || *d)
    return FALSE;

  return TRUE;
}

/*-----------------------------------------------------------------*/
/* matchRule - matches a all the rule lines                        */
/*-----------------------------------------------------------------*/
static bool
matchRule (lineNode * pl,
           lineNode ** mtail,
           peepRule * pr,
           lineNode * head)
{
  lineNode *spl;                /* source pl */
  lineNode *rpl;                /* rule peep line */

  /* for all the lines defined in the rule */
  rpl = pr->match;
  spl = pl;
  while (spl && rpl)
    {

      /* if the source line starts with a ';' then
         comment line don't process or the source line
         contains == . debugger information skip it */
      if (spl->line &&
          *spl->line == ';')
        {
          spl = spl->next;
          continue;
        }

      if (!matchLine (spl->line, rpl->line, &pr->vars))
        return FALSE;

      rpl = rpl->next;
      if (rpl)
        spl = spl->next;
    }

  /* if rules ended */
  if (!rpl)
    {
      /* if this rule has additional conditions */
      if (pr->cond)
        {
          if (callFuncByName (pr->cond, pr->vars, pl, spl, head))
            {
              *mtail = spl;
              return TRUE;
            }
          else
            return FALSE;
        }
      else
        {
          *mtail = spl;
          return TRUE;
        }
    }
  else
    return FALSE;
}

/*-----------------------------------------------------------------*/
/* replaceRule - does replacement of a matching pattern            */
/*-----------------------------------------------------------------*/
static void
replaceRule (lineNode ** shead, lineNode * stail, peepRule * pr)
{
  lineNode *cl = NULL, *oldhead = NULL;
  lineNode *pl = NULL, *lhead = NULL;
  /* a long function name and long variable name can evaluate to
     4x max pattern length e.g. "mov dptr,((fie_var>>8)<<8)+fie_var" */
  char lb[MAX_PATTERN_LEN*4];
  char *lbp;
  lineNode *comment = NULL;

  /* collect all the comment lines in the source */
  for (cl = *shead; cl != stail; cl = cl->next)
    {
      if (cl->line && *cl->line == ';')
        {
          pl = (pl ? connectLine (pl, newLineNode (cl->line)) :
                (comment = newLineNode (cl->line)));
          pl->isComment = cl->isComment || (*cl->line == ';');
        }
    }
  cl = NULL;

  /* for all the lines in the replacement pattern do */
  for (pl = pr->replace; pl; pl = pl->next)
    {
      char *v;
      char *l;
      lbp = lb;

      l = pl->line;

      while (*l)
        {
          /* if the line contains a variable */
          if (*l == '%' && ISCHARDIGIT (*(l + 1)))
            {
              v = hTabItemWithKey (pr->vars, keyForVar (l + 1));
              if (!v)
                {
                  stdcbench_error("c90lib c90lib_peep(): used unbound variable in replacement\n");
                  l++;
                  continue;
                }
              while (*v) {
                *lbp++ = *v++;
              }
              l++;
              while (ISCHARDIGIT (*l)) {
                l++;
              }
              continue;
            }
          *lbp++ = *l++;
        }

      *lbp = '\0';
      if (cl)
        cl = connectLine (cl, newLineNode (lb));
      else
        lhead = cl = newLineNode (lb);
      cl->isComment = pl->isComment;
    }

  /* add the comments if any to the head of list */
  if (comment)
    {
      lineNode *lc = comment;
      while (lc->next)
        lc = lc->next;
      lc->next = lhead;
      if (lhead)
        lhead->prev = lc;
      lhead = comment;
    }

  oldhead = *shead;

  if (lhead && cl)
    {
      /* now we need to connect / replace the original chain */
      /* if there is a prev then change it */
      if ((*shead)->prev)
        {
          (*shead)->prev->next = lhead;
          lhead->prev = (*shead)->prev;
          (*shead)->prev = NULL;
        }
      *shead = lhead;
      /* now for the tail */
      if (stail && stail->next)
        {
          stail->next->prev = cl;
          if (cl)
            cl->next = stail->next;
        }
    }
  else
    {
      /* the replacement is empty - delete the source lines */
      if ((*shead)->prev)
        (*shead)->prev->next = stail->next;
      if (stail->next)
        stail->next->prev = (*shead)->prev;
      (*shead)->prev = NULL;
      *shead = stail->next;
    }
  stail->next = NULL;

  while(oldhead)
    {
      lineNode *oldpl = oldhead;
      oldhead = oldhead->next;
      deleteLineNode (oldpl);
    }
}

/*-----------------------------------------------------------------*/
/* peepHole - matches & substitutes rules                          */
/*-----------------------------------------------------------------*/
void
peepHole (lineNode **pls)
{
  lineNode *spl;
  peepRule *pr;
  lineNode *mtail = NULL;
  bool restart, replaced;

  do
    {
      restart = FALSE;

      /* for all rules */
      for (pr = rootRules; pr; pr = pr->next)
        {
          if (restart && pr->barrier)
            break;

          for (spl = *pls; spl; spl = replaced ? spl : spl->next)
            {
              replaced = FALSE;

              /* don't waste time starting a match on debug symbol
              ** or comment */
              if (spl->isComment || *(spl->line)==';')
                continue;

              mtail = NULL;

              /* Tidy up any data stored in the hTab */

              /* if it matches */
              if (matchRule (spl, &mtail, pr, *pls))
                {
                  /* restart at the replaced line */
                  replaced = TRUE;

                  /* then replace */
                  if (spl == *pls)
                    {
                      replaceRule (pls, mtail, pr);
                      spl = *pls;
                    }
                  else
                    replaceRule (&spl, mtail, pr);

                  /* if restart rule type then
                     start at the top again */
                  if (pr->restart)
                    {
                      restart = TRUE;
                    }
                }

              if (pr->vars)
                {
                  void *v;
                  int k;
                  for (v = hTabFirstItem (pr->vars, &k); v; v = hTabNextItem (pr->vars, &k))
                    Safe_free (v);
                  hTabDeleteAll (pr->vars);
                  Safe_free (pr->vars);
                  pr->vars = NULL;
                }

            }
        }
    } while (restart == TRUE);
}

const char *volatile rules =
"\n"
"\n"
"replace restart {\n"
"	ld	%1, %2\n"
"} by {\n"
"	; peephole 0 removed dead load into %1 from %2.\n"
"} if notUsed(%1), notUsed('n'), notUsed('z')\n"
"\n"
"replace restart {\n"
"	ldw	%1, %2\n"
"} by {\n"
"	; peephole 0w removed dead load into %1 from %2.\n"
"} if notUsed(%1), notUsed('n'), notUsed('z')\n"
"\n"
"replace restart {\n"
"	clr	%1\n"
"} by {\n"
"	; peephole 1 removed dead clear of %1.\n"
"} if notUsed(%1), notUsed('n'), notUsed('z')\n"
"\n\n";

const char *volatile incode = 
"ld\ta, #0xff\n"
"ldw\tx, #0xaa55\n"
"ldw\ty, x\n"
"ldw\tx, #0x55aa\n"
"ldw\ty, x\n"
"clr\ta\n"
"ldw\tx, #0xa5a5\n"
"add\ta, #3\n"
"addw\tx, #1\n";

const char *outcode[] = 
{
"; start of test data",
"ld	a, #0xff",
"; peephole 0w removed dead load into x from #0xaa55.",
"; peephole 0w removed dead load into y from x.",
"ldw	x, #0x55aa",
"ldw	y, x",
"clr	a",
"ldw	x, #0xa5a5",
"add	a, #3",
"addw	x, #1"};

static lineNode *
add_line_node (lineNode *curr, const char *line)
{
  lineNode *pl;

  pl = Safe_alloc (sizeof (lineNode));

  {
    const char *endptr = strchr(line, '\n');
    if (!endptr)
      endptr = line + strlen(line);
    pl->line = Safe_alloc (endptr - line + 1);
    strncpy (pl->line, line, endptr - line);
    pl->line[endptr - line] = 0;
  }

  if (curr)
    {
      pl->next = 0;
      curr->next = pl;
      pl->prev = curr;
    }
  else
    pl->prev = pl->next = 0;

  pl->isComment = *line == ';';

  return(pl);
}

static lineNode *readcode(void)
{
  lineNode *pl, *ret;
  const char *code = incode;

  ret = pl = add_line_node (0, "; start of test data");

  do
    {
      while (ISCHARSPACE(*code))
        code++;

      if(!(*code))
        break;

      pl = add_line_node (pl, code);
    }
  while(code = strchr (code, '\n'));

  return(ret);
}

static void verifycode(lineNode *pl)
{
  unsigned int i;

  for (i = 0; pl; i++)
    {
      lineNode *oldpl;

      if (strncmp (pl->line, outcode[i], strlen(outcode[i])))
        stdcbench_error("c90lib c90lib_peep(): Result validation failed");
      
      oldpl = pl;
      pl = pl->next;

      deleteLineNode (oldpl);
    }
}

void c90lib_peep(void)
{
  int i;

  readRules (rules);

  for(i = 0; i < 80; i++)
    {
      lineNode *pl;

      pl = readcode ();
      peepHole (&pl);
      verifycode (pl);
    }

  destroyRules();
}

#endif

