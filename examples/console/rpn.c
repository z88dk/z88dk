/*
 *      Reverse Polish Notation calculator - integer only!
 *
 *      Nabbed from GBDK distribution, converted over to Small C+
 *      
 *      Small C+ changes:
 *
 *      - include <ctype.h>
 *      - #define for UBYTE WORD BYTE
 *      - Correcting gets() statement so that we give a max size
 *
 *      Added to Small C+ archive 14/3/99 djm
 *
 *      I'm guessing that Pascal Felber originally wrote this, if
 *      not, then I apologise.
 *
 *      Enjoy it: enter expressions like 1000 2342 + then 2 *
 *      or something like that, it's all a bit too much like Forth 
 *      for my liking! <grin>
 *
 */

#define ANSI_STDIO

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

UBYTE s[MAXOP];
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

  if(isdigit(s[pos])==0)
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
      return;
    case '\n':
      printf("==> %d\n", top());
      break;
    }
  }
}


