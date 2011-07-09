/* $Header: /home/dom/z88dk-git/cvs/z88dk/src/z80asm/Attic/avltree.h,v 1.2 2011-07-09 01:15:27 pauloscustodio Exp $ */
/* $History: Z80ASM.C $ */

typedef struct avlnode {
                        short           height;         /* height of avltree (max search levels from node) */
                        void            *data;          /* pointer to data of node */
                        struct avlnode  *left, *right;  /* pointers to left and right avl subtrees */
                       } avltree;

void    move(avltree **p, avltree **newroot, int  (*symcmp)(void *,void *));
void    copy(avltree *p, avltree **newroot, int  (*symcmp)(void *,void *), void  *(*create)(void *));
void    delete(avltree **root, void *key, int  (*comp)(void *,void *), void (*delkey)(void *));
void    deleteall(avltree **p, void (*deldata)(void *));
void    insert(avltree **root, void *key, int  (*comp)(void *,void *));
void    *find(avltree *p, void *key, int  (*comp)(void *,void *));
void    *reorder(avltree *p, int  (*symcmp)(void *,void *));
void    inorder(avltree *p, void  (*action)(void *));
void    preorder(avltree *p, void  (*action)(void *));
