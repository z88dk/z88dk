/*
 *      Reverse Polish Notation calculator - integer only!
 *
 *      Nabbed from GBDK distribution, converted over to Small C+
 *      
 *      Small C+ changes:
 *
 *      - include <ctype.h>
 *      = #define for UBYTE WORD BYTE
 *
 *      Added to Small C+ archive 14/3/99 djm
 *
 *      I'm guessing that Pascal Felber originally wrote this, if
 *      not, then I apologise. Actually, I believe he did, there's
 *      a floating point example in K&R on which this is based.
 *
 *      Enjoy it: enter expressions like 1000 2342 + then 2 *
 *      or something like that, it's all a bit too much like Forth 
 *      for my liking! <grin>
 *
 *      5/5/99 Added compiler directives, changed everything to printf
 *      (so as to pick up miniprintf) added "." to exit
 */

/* Compiler directives, no bad space, not expanded */

#pragma -no-expandz88
#pragma redirect handlecmds = _rpn_handlecmds



#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

#define MAXOP     40
#define NUMBER    '0'
#define STACKSIZE 40

#define UBYTE unsigned char
#define WORD  int
#define BYTE  char


UBYTE sp;
WORD stack[STACKSIZE];

char s[MAXOP];
UBYTE pos;
WORD n;

void push(WORD l)
{
  if(sp < STACKSIZE)
    stack[sp++] = l;
  else
    printf("Stack full\n");
}

WORD pop()
{
  if(sp > 0)
    return stack[--sp];
  else
    printf("Stack empty\n");
  return 0;
}

WORD top()
{
  if(sp > 0)
    return stack[sp-1];
  else
    printf("Stack empty\n");
  return 0;
}

BYTE read_op()
{
  if(pos == 0) {
    gets(s);
  }

  while(s[pos] == ' ' || s[pos] == '\t')
    pos++;

  if(s[pos] == '\0') {
    pos = 0;
    return('\n');
  }

  if(!isdigit(s[pos]))
    return(s[pos++]);

  n = s[pos] - '0';
  while(isdigit(s[++pos]))
    n = 10 * n + s[pos] - '0';

  return NUMBER;
}

void main()
{
  BYTE type;
  WORD op2;

  printf("RPN Calculator\n");
  printf("Nabbed from GBDK archive\n");
  sp = 0;
  pos = 0;

  while((type = read_op()) != 0) {
    switch(type) {
    case NUMBER:
      push(n);
      break;
    case '+':
      push(pop() + pop());
      break;
    case '*':
      push(pop() * pop());
      break;
    case '-':
      op2 = pop();
      push(pop() - op2);
      break;
    case '/':
      op2 = pop();
      if(op2 != 0)
        push(pop() / op2);
      else
        printf("Divide by 0\n");
      break;
    case '.':
      exit(0);
    case '\n':
      printf("==> %d\n", top());
      break;
    }
  }
}

void rpn_handlecmds(int cmd)
{
        switch(cmd) {
                case 0x81:
                        exit(0);
        }
}


#include <dor.h>

#define HELP1   "A demo application made with z88dk - Small C+ Compiler"
#define HELP2   "Liberated from the GBDK. Original author is probably"
#define HELP3   "probably Pascal Felber, minor change for the Z88 made"
#define HELP4   "by Dominic Morris - This one is for you Garry <grin>"
#define HELP5   "Contact  djm@jb.man.ac.uk - 5/5/99 (v2.1)"

#define APP_INFO "Made by z88dk"
#define APP_KEY  'R'
#define APP_NAME "Rpn Demo"

#define TOPIC1   "Commands"

#define TOPIC1_1         "Quit"
#define TOPIC1_1KEY      "CQ"
#define TOPIC1_1CODE     $81


#include <application.h>



