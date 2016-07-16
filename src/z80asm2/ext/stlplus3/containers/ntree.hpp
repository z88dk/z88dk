#ifndef STLPLUS_NTREE
#define STLPLUS_NTREE
////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   A templated n-ary tree data structure. STL-like but the definition of
//   iterators is really only applicable to one-dimensional structures. I use
//   iterators to access tree nodes, but there is no increment or decrement
//   operators for them. I also define prefix and postfix traversal iterators
//   which do have increment.

////////////////////////////////////////////////////////////////////////////////
#include "containers_fixes.hpp"
#include "exceptions.hpp"
#include "safe_iterator.hpp"
#include <vector>
#include <iterator>

namespace stlplus
{

  ////////////////////////////////////////////////////////////////////////////////
  // Internals

  template<typename T> class ntree_node;
  template<typename T> class ntree;
  template<typename T, typename TRef, typename TPtr> class ntree_iterator;
  template<typename T, typename TRef, typename TPtr> class ntree_prefix_iterator;
  template<typename T, typename TRef, typename TPtr> class ntree_postfix_iterator;

  ////////////////////////////////////////////////////////////////////////////////
  // Iterators

  // Simple iterators which are just used as pointers to tree nodes. These have
  // no increment or decrement operations defined. An uninitialised iterator is
  // null - similarly, if you ask for the root of an empty tree or the parent of
  // the root node then you get a null iterator.

  template<typename T, typename TRef, typename TPtr>
  class ntree_iterator :
    public safe_iterator<ntree<T>,ntree_node<T> >
  {
  public:
    // local type definitions
    // an iterator points to an object whilst a const_iterator points to a const object
    typedef ntree_iterator<T,T&,T*> iterator;
    typedef ntree_iterator<T,const T&,const T*> const_iterator;
    typedef ntree_iterator<T,TRef,TPtr> this_iterator;
    typedef TRef reference;
    typedef TPtr pointer;

    // constructor to create a null iterator - you must assign a valid value to this iterator before using it
    ntree_iterator(void);
    ~ntree_iterator(void);

    // Type conversion methods allow const_iterator and iterator to be converted
    const_iterator constify(void) const;
    iterator deconstify(void) const;

    // tests useful for putting iterators into other STL structures and for testing whether iteration has completed
    bool operator == (const this_iterator& r) const;
    bool operator != (const this_iterator& r) const;
    bool operator < (const this_iterator& r) const;

    // access the node data - a const_iterator gives you a const element, an iterator a non-const element
    // it is illegal to dereference an invalid (i.e. null or end) iterator
    reference operator*(void) const
      throw(null_dereference,end_dereference);
    pointer operator->(void) const
      throw(null_dereference,end_dereference);

    friend class ntree<T>;
    friend class ntree_prefix_iterator<T,TRef,TPtr>;
    friend class ntree_postfix_iterator<T,TRef,TPtr>;

  public:
    // Note: I had to make this public to get round a problem implementing persistence - it should be private
    // you cannot create a valid iterator except by calling an ntree method that returns one
    // constructor used by ntree to create a non-null iterator
    explicit ntree_iterator(ntree_node<T>* node);
    // constructor used by ntree to create an end iterator
    explicit ntree_iterator(const ntree<T>* owner);
    // used to create an alias of an iterator
    explicit ntree_iterator(const safe_iterator<ntree<T>, ntree_node<T> >& iterator);
  };

  // Traversal iterators are like iterators but they have increment operators (++)
  // - prefix_iterator visits the nodes of the tree in prefix order
  // - postfix_iterator visits the nodes of the tree in postfix order.
  // There is no such thing as infix order for an n-ary tree and you cannot
  // traverse backwards with these iterators. These follow the STL convention in
  // that you iterate from a begin to an end - in this case ntree exports
  // prefix_begin()/prefix_end() and postfix_begin()/postfix_end(). You can
  // simplify these iterators to the basic iterator above for functions that
  // require a simple iterator.

  template<typename T, typename TRef, typename TPtr>
  class ntree_prefix_iterator : 
    public std::iterator<std::forward_iterator_tag, T, std::ptrdiff_t, TPtr, TRef>
  {
  public:
    typedef ntree_prefix_iterator<T,T&,T*>             iterator;
    typedef ntree_prefix_iterator<T,const T&,const T*> const_iterator;
    typedef ntree_prefix_iterator<T,TRef,TPtr>         this_iterator;
    typedef ntree_iterator<T,TRef,TPtr>                simple_iterator;
    typedef TRef                                       reference;
    typedef TPtr                                       pointer;

    // constructor to create a null iterator - you must assign a valid value to this iterator before using it
    ntree_prefix_iterator(void);
    ~ntree_prefix_iterator(void);

    // tests
    // a null iterator is one that has not been initialised with a value yet
    // i.e. you just declared it but didn't assign to it
    bool null(void) const;
    // an end iterator is one that points to the end element of the list of nodes
    // in STL conventions this is one past the last valid element and must not be dereferenced
    bool end(void) const;
    // a valid iterator is one that can be dereferenced
    // i.e. non-null and non-end
    bool valid(void) const;

    // Type conversion methods allow const_iterator and iterator to be converted
    // convert an iterator/const_iterator to a const_iterator
    const_iterator constify(void) const;
    iterator deconstify(void) const;

    // generate a simple iterator from a traversal iterator
    simple_iterator simplify(void) const;

    // tests useful for putting iterators into other STL structures and for testing whether iteration has completed
    bool operator == (const this_iterator& r) const;
    bool operator != (const this_iterator& r) const;
    bool operator < (const this_iterator& r) const;

    // increment/decrement operators used to step through the set of all nodes in a graph
    // it is only legal to increment a valid iterator
    // pre-increment
    this_iterator& operator ++ (void)
      throw(null_dereference,end_dereference);
    // post-increment
    this_iterator operator ++ (int)
      throw(null_dereference,end_dereference);

    // access the node data - a const_iterator gives you a const element, an iterator a non-const element
    // it is illegal to dereference an invalid (i.e. null or end) iterator
    reference operator*(void) const
      throw(null_dereference,end_dereference);
    pointer operator->(void) const
      throw(null_dereference,end_dereference);

    friend class ntree<T>;
    friend class ntree_iterator<T,TRef,TPtr>;

  private:
    simple_iterator m_iterator;

    explicit ntree_prefix_iterator(const simple_iterator& i);
    const simple_iterator& get_iterator(void) const;
    simple_iterator& get_iterator(void);
  };

  ////////////////////////////////////////////////////////////////////////////////

  template<typename T, typename TRef, typename TPtr>
  class ntree_postfix_iterator :
    public std::iterator<std::forward_iterator_tag, T, std::ptrdiff_t, TPtr, TRef>
  {
  public:
    typedef ntree_postfix_iterator<T,T&,T*>             iterator;
    typedef ntree_postfix_iterator<T,const T&,const T*> const_iterator;
    typedef ntree_postfix_iterator<T,TRef,TPtr>         this_iterator;
    typedef ntree_iterator<T,TRef,TPtr>                 simple_iterator;
    typedef TRef                                        reference;
    typedef TPtr                                        pointer;

    // constructor to create a null iterator - you must assign a valid value to this iterator before using it
    ntree_postfix_iterator(void);
    ~ntree_postfix_iterator(void);

    // tests
    // a null iterator is one that has not been initialised with a value yet
    // i.e. you just declared it but didn't assign to it
    bool null(void) const;
    // an end iterator is one that points to the end element of the list of nodes
    // in STL conventions this is one past the last valid element and must not be dereferenced
    bool end(void) const;
    // a valid iterator is one that can be dereferenced
    // i.e. non-null and non-end
    bool valid(void) const;

    // Type conversion methods allow const_iterator and iterator to be converted
    // convert an iterator/const_iterator to a const_iterator
    const_iterator constify(void) const;
    iterator deconstify(void) const;

    // generate a simple iterator from a traversal iterator
    simple_iterator simplify(void) const;

    // tests useful for putting iterators into other STL structures and for testing whether iteration has completed
    bool operator == (const this_iterator& r) const;
    bool operator != (const this_iterator& r) const;
    bool operator < (const this_iterator& r) const;

    // increment/decrement operators used to step through the set of all nodes in a graph
    // it is only legal to increment a valid iterator
    // pre-increment
    this_iterator& operator ++ (void)
      throw(null_dereference,end_dereference);
    // post-increment
    this_iterator operator ++ (int)
      throw(null_dereference,end_dereference);

    // access the node data - a const_iterator gives you a const element, an iterator a non-const element
    // it is illegal to dereference an invalid (i.e. null or end) iterator
    reference operator*(void) const
      throw(null_dereference,end_dereference);
    pointer operator->(void) const
      throw(null_dereference,end_dereference);

    friend class ntree<T>;
    friend class ntree_iterator<T,TRef,TPtr>;

  private:
    simple_iterator m_iterator;

    explicit ntree_postfix_iterator(const simple_iterator& i);
    const simple_iterator& get_iterator(void) const;
    simple_iterator& get_iterator(void);
  };

  ////////////////////////////////////////////////////////////////////////////////
  // The Ntree class
  ////////////////////////////////////////////////////////////////////////////////

  template<typename T>
  class ntree
  {
  public:
    // STL-like typedefs for the types and iterators
    typedef T value_type;

    typedef ntree_iterator<T,T&,T*> iterator;
    typedef ntree_iterator<T,const T&,const T*> const_iterator;

    typedef ntree_prefix_iterator<T,T&,T*> prefix_iterator;
    typedef ntree_prefix_iterator<T,const T&,const T*> const_prefix_iterator;

    typedef ntree_postfix_iterator<T,T&,T*> postfix_iterator;
    typedef ntree_postfix_iterator<T,const T&,const T*> const_postfix_iterator;

    typedef std::vector<iterator> iterator_vector;
    typedef std::vector<const_iterator> const_iterator_vector;

    //////////////////////////////////////////////////////////////////////////////
    // Constructors, destructors and copies

    ntree(void);
    ~ntree(void);

    // copy constructor and assignment both copy the tree
    ntree(const ntree<T>&);
    ntree<T>& operator=(const ntree<T>&);

    //////////////////////////////////////////////////////////////////////////////
    // size tests

    // tests on whole tree
    bool empty(void) const;
    unsigned size(void) const;

    // tests for number of nodes in subtree starting at node
    unsigned size(const const_iterator& node) const
      throw(wrong_object,null_dereference,end_dereference);
    unsigned size(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);

    // test for depth of tree from root to node
    unsigned depth(const const_iterator& node) const
      throw(wrong_object,null_dereference,end_dereference);
    unsigned depth(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);

    //////////////////////////////////////////////////////////////////////////////
    // direct traversal

    // get the root node's iterator to start the traversal
    const_iterator root(void) const;
    iterator root(void);

    // get the number of children of this node, so they can be accessed 0..n-1
    unsigned children(const const_iterator& node) const
      throw(wrong_object,null_dereference,end_dereference);
    unsigned children(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);

    // get the iterator for a child given it's offset into the children array
    const_iterator child(const const_iterator& node, unsigned child) const
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);
    iterator child(const iterator& node, unsigned child)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);

    // search a node's children array to find a child given its iterator
    unsigned child_offset(const const_iterator& node, const const_iterator& child) const
      throw(wrong_object,null_dereference,end_dereference);
    unsigned child_offset(const iterator& node, const iterator& child)
      throw(wrong_object,null_dereference,end_dereference);

    // go back up the tree by getting the iterator to a node's parent - the parent of root is null
    const_iterator parent(const const_iterator& node) const
      throw(wrong_object,null_dereference,end_dereference);
    iterator parent(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);

    //////////////////////////////////////////////////////////////////////////////
    // iterator traversal

    const_prefix_iterator prefix_begin(void) const;
    prefix_iterator prefix_begin(void);
    const_prefix_iterator prefix_end(void) const;
    prefix_iterator prefix_end(void);

    const_postfix_iterator postfix_begin(void) const;
    postfix_iterator postfix_begin(void);
    const_postfix_iterator postfix_end(void) const;
    postfix_iterator postfix_end(void);

    //////////////////////////////////////////////////////////////////////////////
    // breadth-first traversal

    const_iterator_vector breadth_first_traversal(void) const;
    iterator_vector breadth_first_traversal(void);

    //////////////////////////////////////////////////////////////////////////////
    // modification

    // insert a node

    // discard previous contents and create a new root node
    iterator insert(const T&);
    // add a new child inserted into the node's children at the specified place
    iterator insert(const iterator& node, unsigned child, const T&)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);
    // shortcut for insert at the end i.e. tree.insert(node, node.children(), value)
    iterator insert(const iterator& node, const T&) 
      throw(wrong_object,null_dereference,end_dereference);
    // old name for the above
    iterator append(const iterator& node, const T&) 
      throw(wrong_object,null_dereference,end_dereference);

    // insert a copy of a subtree

    // discard previous contents and copy the tree
    iterator insert(const ntree<T>&);
    // add a copy of the tree as a new child inserted into the node's children at the specified place
    iterator insert(const iterator& node, unsigned child, const ntree<T>&)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);
    // shortcut for insert at the end i.e. tree.insert(node, node.children(), value)
    iterator insert(const iterator& node, const ntree<T>&)
      throw(wrong_object,null_dereference,end_dereference);
    // old name for the above
    iterator append(const iterator& node, const ntree<T>&)
      throw(wrong_object,null_dereference,end_dereference);

    // insert the subtree without copying

    // discard previous contents and move the tree without copying
    // invalidates all iterators to the old tree
    iterator move(ntree<T>&);
    // move the tree to become the designated child
    // invalidates all iterators to the old tree
    iterator move(const iterator& node, unsigned child, ntree<T>&)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);
    // shortcut for move to the last child i.e. node.move(node, node.children(), value)
    iterator move(const iterator& node, ntree<T>&)
      throw(wrong_object,null_dereference,end_dereference);

    // insert/erase in the middle of a tree

    // replace the node with the new value, pushing the old node down to make it the child
    // returns the iterator to the new, pushed node
    iterator push(const iterator& node, const T&) 
      throw(wrong_object,null_dereference,end_dereference);
    // erases the specified child, moving its children up to become the node's children
    void pop(const iterator& node, unsigned child) 
      throw(wrong_object,null_dereference,end_dereference);

    // erase nodes and subtrees

    // erase the whole tree
    void erase(void);
    // erase the node and all its children
    void erase(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);
    // erase the specified child
    void erase_child(const iterator& node, unsigned child)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);
    // synonym for above
    void erase(const iterator& node, unsigned child)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);
    // erase all children of the node, but leave the node
    void erase_children(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);

    // extract a subtree as a copy leaving the original tree unchanged

    // get a copy of the tree as a tree
    ntree<T> subtree(void);
    // get a copy of the subtree as a tree with the specified node as root
    ntree<T> subtree(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);
    // get a copy of the subtree as a tree with the specified child as root
    ntree<T> subtree(const iterator& node, unsigned child)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);

    // extract a subtree by moving the contents

    // move the whole tree to make a new tree
    ntree<T> cut(void);
    // move the subtree to make a new tree with the specified node as root
    ntree<T> cut(const iterator& node)
      throw(wrong_object,null_dereference,end_dereference);
    // move the subtree to make a new tree with the specified child as root
    ntree<T> cut(const iterator& node, unsigned child)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);

    // re-ordering of child nodes

    // reorder the children of a node
    // moves the child at the given offset to the new offset, reordering its siblings to make room
    // this preserves the order of the remaining siblings but not their positions e.g. reorder([a,b,c,d],0,3) = [b,c,d,a]
    void reorder(const iterator& node, unsigned child_offset, unsigned new_offset)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);

    // swap two children of a node
    // swaps the child at the given offset with the new offset
    // this preserves the position of the remaining siblings e.g. swap([a,b,c,d],0,3) = [d,b,c,a]
    void swap(const iterator& node, unsigned child1, unsigned child2)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range);

    //////////////////////////////////////////////////////////////////////////////

  private:
    ntree_node<T>* m_root;
  };

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

#include "ntree.tpp"
#endif
