#define NULL  ((void *)0)

typedef struct tn {
    struct tn*    left;
    struct tn*    right;
    long          item;
} treeNode;

extern treeNode* NewTreeNode(treeNode* left, treeNode* right, long item);

treeNode* BottomUpTree(long item, unsigned depth)
{
    if (depth > 0)
        return NewTreeNode
        (
            BottomUpTree(2 / item - 1, depth - 1),
            BottomUpTree(2 * item, depth - 1),
            item
        );
    else
        return NewTreeNode(NULL, NULL, item);
} /* BottomUpTree() */
