
/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/avltree.c,v 1.1 2000-07-04 15:33:30 dom Exp $ */
/* $History: AVLTREE.C $ */
/*  */
/* *****************  Version 4  ***************** */
/* User: Gbs          Date: 17-04-99   Time: 0:30 */
/* Updated in $/Z80asm */
/* New GNU programming style C format. Improved ANSI C coding style */
/* eliminating previous compiler warnings. New -o option. Asm sources file */
/* now parsed even though any line feed standards (CR,LF or CRLF) are */
/* used. */
/*  */
/* *****************  Version 2  ***************** */
/* User: Gbs          Date: 20-06-98   Time: 15:10 */
/* Updated in $/Z80asm */
/* SourceSafe Version History Comment Block added. */

#include <stdlib.h>
#include "avltree.h"

/* Internal manipulation functions */
void rotateleft (avltree ** p);
void rotateright (avltree ** p);
void fixheight (avltree * p);
void balanceleft (avltree ** p, short adj);
void balanceright (avltree ** p, short adj);
void deletemin (avltree ** p, void **data);
short difference (avltree * p);


/*
 * rotate nodes pointed to by x and x->right
 */
void 
rotateleft (avltree ** x)
{				/* return *x to caller */
  avltree *y;

  if ((*x) != NULL)
    if ((*x)->right != NULL)
      {
	y = (*x)->right;
	(*x)->right = y->left;	/* left subtree of y becomes right subtree */
	y->left = (*x);		/* x becomes left child of y */
	(*x) = y;		/* y becomes new root of whole subtree */
      }
}

/*
 * rotate nodes pointed to by x and x->left
 */
void 
rotateright (avltree ** x)
{				/* return *x to caller */
  avltree *y;

  if ((*x) != NULL)
    if ((*x)->left != NULL)
      {
	y = (*x)->left;
	(*x)->left = y->right;	/* left subtree of y becomes right subtree */
	y->right = (*x);	/* x becomes left child of y */
	(*x) = y;		/* y becomes new root of whole subtree */
      }
}

/*
 * return the difference between the heights of the left and right subtree of node n
 */
short 
difference (avltree * n)
{
  short leftheight, rightheight;

  if (n == NULL)
    return 0;
  else
    {
      if (n->left == NULL)
	leftheight = -1;
      else
	leftheight = n->left->height;	/* get height of left subtree */
      if (n->right == NULL)
	rightheight = -1;
      else
	rightheight = n->right->height;	/* get height of right subtree */

      return (leftheight - rightheight);
    }
}

/*
 * sets the correct height for node pointed to by n, used after insertion into subtree
 */
void 
fixheight (avltree * n)
{
  short leftheight, rightheight;

  if (n->left == NULL)
    leftheight = -1;
  else
    leftheight = n->left->height;

  if (n->right == NULL)
    rightheight = -1;
  else
    rightheight = n->right->height;

  if (leftheight > rightheight)
    n->height = leftheight + 1;
  else
    n->height = rightheight + 1;
}

/*
 * restores balance at n after insertion, assuming that the right subtree of n is too high
 */
void 
balanceright (avltree ** n, short adjust)
{
  short dif;

  dif = difference ((*n)->right);
  if (dif == 0)
    {
      rotateleft (n);		/* both subtrees of right child of n have same height */
      ((*n)->height) -= adjust;	/* 'decrease' height of current node */
      ((*n)->left->height) += adjust;	/* 'increase' height of left subtree */
    }
  else
    {
      if (dif < 0)
	{
	  rotateleft (n);	/* right subtree of right child of n is higher */
	  (*n)->left->height -= 2;
	}
      else
	{			/* left subtree of right child of n is higher */
	  rotateright (&(*n)->right);	/* pointer to n->right */
	  rotateleft (n);
	  ++((*n)->height);	/* increase height of current node */
	  (*n)->left->height -= 2;
	  --((*n)->right->height);	/* decrease height of right subtree */
	}
    }
}


void 
balanceleft (avltree ** n, short adjust)
{
  short dif;

  dif = difference ((*n)->left);
  if (dif == 0)
    {
      rotateright (n);		/* both subtrees of left child of n have same height */
      ((*n)->height) -= adjust;	/* 'decrease' height of current node */
      ((*n)->right->height) += adjust;	/* 'increase' height of right subtree */
    }
  else
    {
      if (dif > 0)
	{
	  rotateright (n);	/* left subtree of left child of n is higher */
	  (*n)->right->height -= 2;
	}
      else
	{			/* right subtree of left child of n is higher */
	  rotateleft (&(*n)->left);	/* pointer to n->left */
	  rotateright (n);
	  ++((*n)->height);	/* increase height of current node */
	  (*n)->right->height -= 2;
	  --((*n)->left->height);	/* decrease height of left subtree */
	}
    }
}


void 
deletemin (avltree ** n, void **dataptr)
{
  avltree *temp;
  short dif;

  if ((*n)->left != NULL)	/* keep going for leftmost node */
    deletemin (&(*n)->left, dataptr);
  else
    {				/* leftmost node found */
      *dataptr = (*n)->data;	/* get pointer to data */
      temp = *n;
      *n = (*n)->right;		/* return pointer to right subtree */
      free (temp);		/* of leftmost node                */
    }

  if (*n != NULL)
    {
      fixheight (*n);
      dif = difference (*n);
      if (dif > 1)		/* deletion caused left subtree to be too high */
	balanceleft (n, -1);
      else if (dif < -1)	/* deletion caused right subtree to be too high */
	balanceright (n, -1);
    }
}


void 
delete (avltree ** n, void *key, int (*comp) (void *, void *), void (*deletekey) (void *))
{
  avltree *temp;
  void *dataptr;		/* pointer to data record of avltree node */
  short dif, cmp;

  if (*n != NULL)
    {
      cmp = comp (key, (*n)->data);
      if (cmp < 0)
	delete (&(*n)->left, key, comp, deletekey);
      else
	{
	  if (cmp > 0)
	    delete (&(*n)->right, key, comp, deletekey);

	  /* node to be deleted is found */
	  else
	    {
	      if ((*n)->left != NULL && (*n)->right != NULL)
		{				/* node has both left & right subtrees */
		  deletemin (&(*n)->right, &dataptr);
		  deletekey ((*n)->data);	/* release old data */
		  (*n)->data = dataptr;		/* assign new data */
		}
	      else
		{
		  temp = *n;
		  if ((*n)->right == NULL)
		    if ((*n)->left == NULL)
		      *n = NULL;	/* node has no children */
		    else
		      *n = (*n)->left;	/* node has left child only */
		  else
		    *n = (*n)->right;	/* node has right child only */
		  deletekey (temp->data);	/* delete node data */
		  free (temp);	/* delete avltree node */
		}
	    }
	}

      if (*n != NULL)
	{
	  fixheight (*n);
	  dif = difference (*n);
	  if (dif > 1)		/* deletion caused left subtree to be too high */
	    balanceleft (n, -1);
	  else if (dif < -1)	/* deletion caused right subtree to be too high */
	    balanceright (n, -1);
	}
    }
}


void 
deleteall (avltree ** p, void (*deldata) (void *))
{
  if (*p != NULL)
    {
      deleteall (&(*p)->left, deldata);
      deleteall (&(*p)->right, deldata);

      deldata ((*p)->data);
      free (*p);
      *p = NULL;
    }
}


/*
 * insert identifier in the subtree rooted at p
 */
void 
insert (avltree ** p, void *newdata, int (*comp) (void *, void *))
{
  int cmp, dif;

  if (*p == NULL)
    {
      *p = (avltree *) malloc (sizeof (avltree));
      if (*p != NULL)
	{
	  (*p)->height = 0;
	  (*p)->data = newdata;	/* new data linked to avltree node */
	  (*p)->left = NULL;	/* initialized to no subtrees */
	  (*p)->right = NULL;
	}
    }
  else
    {
      cmp = comp (newdata, (*p)->data);
      if (cmp <= 0)
	insert (&(*p)->left, newdata, comp);	/* put it in left subtree of p */
      else if (cmp > 0)
	insert (&(*p)->right, newdata, comp);	/* put it in right subtree of p */

      fixheight (*p);		/* may have to adjust height if subtree grew */
      dif = difference (*p);
      if (dif > 1)		/* insertion caused left subtree to be too high */
	balanceleft (p, 1);
      else if (dif < -1)	/* right subtree is too high */
	balanceright (p, 1);
    }
}


/*
 * find identifier in the avltree rooted at p
 */
void *
find (avltree * p, void *key, int (*comp) (void *, void *))
{
  int cmp;

  if (p == NULL)
    return NULL;
  else
    {
      if ((cmp = comp (key, p->data)) == 0)
	return p->data;
      else
	{
	  if (cmp < 0)
	    return find (p->left, key, comp);	/* search left subtree of p */
	  else
	    return find (p->right, key, comp);	/* search right subtree of p */
	}
    }
}


/*
 * interface function to move source avltree into destination avl-tree
 * source avltree will be empty, when completed.
 */
void 
move (avltree ** p, avltree ** newroot, int (*symcmp) (void *, void *))
{
  if (*p != NULL)
    {
      move (&(*p)->left, newroot, symcmp);
      move (&(*p)->right, newroot, symcmp);

      insert (newroot, (*p)->data, symcmp);	/* insert node data by symcmp order */
      free (*p);		/* release avl-node */
      *p = NULL;
    }
}


/*
 * interface function to copy source avltree into destination avl-tree
 */
void 
copy (avltree * p, avltree ** newroot, int (*symcmp) (void *, void *), void *(*create) (void *))
{
  void *sym;

  if (p != NULL)
    {
      copy (p->left, newroot, symcmp, create);
      copy (p->right, newroot, symcmp, create);
      sym = create (p->data);	/* create a copy of data */
      if (sym != NULL)
	insert (newroot, sym, symcmp);	/* insert node data by symcmp order */
    }
}



/*
 * interface function to re-order avltree
 */
void *
reorder (avltree * p, int (*symcmp) (void *, void *))
{
  avltree *newroot = NULL;

  move (&p, &newroot, symcmp);	/* re-order avl-tree */
  return newroot;		/* return pointer to new root */
}


/*
 * interface function to traverse the avltree in inorder (left, node, right)
 * and perform appropriate action for each data node.
 */
void 
inorder (avltree * p, void (*action) (void *))
{
  if (p != NULL)
    {
      inorder (p->left, action);
      action (p->data);
      inorder (p->right, action);
    }
}


/*
 * interface function to traverse the avltree in preorder (node, left, right)
 * and perform appropriate action for each data node.
 */
void 
preorder (avltree * p, void (*action) (void *))
{
  if (p != NULL)
    {
      action (p->data);
      inorder (p->left, action);
      inorder (p->right, action);
    }
}
