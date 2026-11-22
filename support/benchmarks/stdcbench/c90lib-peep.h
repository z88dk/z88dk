#if __STDC_VERSION__ >= 199901L
#include <stdbool.h>
#else
typedef unsigned char bool;
#endif

#define FALSE 0
#define TRUE 1

typedef struct lineNode_s
{
  char *line;
  unsigned int isComment:1;
  unsigned int visited:1;
  struct lineNode_s *prev;
  struct lineNode_s *next;
}
lineNode;

bool
stm8notUsed (const char *what, lineNode *endPl, lineNode *head);

