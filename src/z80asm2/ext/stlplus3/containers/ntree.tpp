////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include <vector>
#include <algorithm>

namespace stlplus 
{

  ////////////////////////////////////////////////////////////////////////////////
  // ntree_node

  template<typename T>
  class ntree_node
  {
  public:
    master_iterator<ntree<T>, ntree_node<T> > m_master;
    T m_data;
    ntree_node<T>* m_parent;
    std::vector<ntree_node<T>*> m_children;

  public:
    ntree_node(const ntree<T>* owner, const T& data = T()) :
      m_master(owner,this), m_data(data), m_parent(0)
      {
      }

    void change_owner(const ntree<T>* owner)
      {
        m_master.change_owner(owner);
        for (TYPENAME std::vector<ntree_node<T>*>::iterator i = m_children.begin(); i != m_children.end(); i++)
          (*i)->change_owner(owner);
      }

    ~ntree_node(void)
      {
        m_parent = 0;
        for (TYPENAME std::vector<ntree_node<T>*>::iterator i = m_children.begin(); i != m_children.end(); i++)
          delete *i;
      }

  };

  template<typename T>
  static ntree_node<T>* ntree_copy(const ntree<T>* new_owner, ntree_node<T>* root)
  {
    if (!root) return 0;
    ntree_node<T>* new_tree = new ntree_node<T>(new_owner, root->m_data);
    for (TYPENAME std::vector<ntree_node<T>*>::iterator i = root->m_children.begin(); i != root->m_children.end(); i++)
    {
      ntree_node<T>* new_child = ntree_copy(new_owner, *i);
      new_tree->m_children.push_back(new_child);
      new_child->m_parent = new_tree;
    }
    return new_tree;
  }

  template<typename T>
  static unsigned ntree_size(ntree_node<T>* root)
  {
    if (!root) return 0;
    unsigned result = 1;
    for (TYPENAME std::vector<ntree_node<T>*>::iterator i = root->m_children.begin(); i != root->m_children.end(); i++)
      result += ntree_size(*i);
    return result;
  }

  template<typename T>
  static unsigned ntree_depth(ntree_node<T>* root)
  {
    unsigned depth = 0;
    for (ntree_node<T>* i = root; i; i = i->m_parent)
      depth++;
    return depth;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // ntree_iterator

  // constructor to create a null iterator - you must assign a valid value to this iterator before using it
  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>::ntree_iterator(void)
  {
  }

  // used to create an alias of an iterator
  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>::ntree_iterator(const safe_iterator<ntree<T>, ntree_node<T> >& iterator) :
    safe_iterator<ntree<T>,ntree_node<T> >(iterator)
  {
  }

  // constructor used by ntree to create a non-null iterator
  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>::ntree_iterator(ntree_node<T>* node) :
    safe_iterator<ntree<T>,ntree_node<T> >(node->m_master)
  {
  }

  // constructor used by ntree to create an end iterator
  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>::ntree_iterator(const ntree<T>* owner) :
    safe_iterator<ntree<T>,ntree_node<T> >(owner)
  {
  }

  // destructor
  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>::~ntree_iterator(void)
  {
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_iterator<T,TRef,TPtr>::const_iterator ntree_iterator<T,TRef,TPtr>::constify(void) const
  {
    return ntree_iterator<T,const T&,const T*>(*this);
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_iterator<T,TRef,TPtr>::iterator ntree_iterator<T,TRef,TPtr>::deconstify(void) const
  {
    return ntree_iterator<T,T&,T*>(*this);
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_iterator<T,TRef,TPtr>::operator == (const TYPENAME ntree_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return this->equal(r);
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_iterator<T,TRef,TPtr>::operator != (const TYPENAME ntree_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return !operator==(r);
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_iterator<T,TRef,TPtr>::operator < (const TYPENAME ntree_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return this->compare(r) < 0;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_iterator<T,TRef,TPtr>::reference ntree_iterator<T,TRef,TPtr>::operator*(void) const
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    return this->node()->m_data;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_iterator<T,TRef,TPtr>::pointer ntree_iterator<T,TRef,TPtr>::operator->(void) const
    throw(null_dereference,end_dereference)
  {
    return &(operator*());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // ntree_prefix_iterator

  template<typename T, typename TRef, typename TPtr>
  ntree_prefix_iterator<T,TRef,TPtr>::ntree_prefix_iterator(void)
  {
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_prefix_iterator<T,TRef,TPtr>::~ntree_prefix_iterator(void)
  {
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_prefix_iterator<T,TRef,TPtr>::ntree_prefix_iterator(const ntree_iterator<T,TRef,TPtr>& i) :
    m_iterator(i)
  {
    // this is initialised with the root node
    // which is also the first node in prefix traversal order
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_prefix_iterator<T,TRef,TPtr>::null(void) const
  {
    return m_iterator.null();
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_prefix_iterator<T,TRef,TPtr>::end(void) const
  {
    return m_iterator.end();
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_prefix_iterator<T,TRef,TPtr>::valid(void) const
  {
    return m_iterator.valid();
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::const_iterator ntree_prefix_iterator<T,TRef,TPtr>::constify(void) const
  {
    return ntree_prefix_iterator<T,const T&,const T*>(m_iterator);
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::iterator ntree_prefix_iterator<T,TRef,TPtr>::deconstify(void) const
  {
    return ntree_prefix_iterator<T,T&,T*>(m_iterator);
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr> ntree_prefix_iterator<T,TRef,TPtr>::simplify(void) const
  {
    return m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_prefix_iterator<T,TRef,TPtr>::operator == (const TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return m_iterator == r.m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_prefix_iterator<T,TRef,TPtr>::operator != (const TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return m_iterator != r.m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_prefix_iterator<T,TRef,TPtr>::operator < (const TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return m_iterator < r.m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::this_iterator& ntree_prefix_iterator<T,TRef,TPtr>::operator ++ (void)
    throw(null_dereference,end_dereference)
  {
    // pre-increment operator
    // algorithm: if there are any children, visit child 0, otherwise, go to
    // parent and deduce which child the start node was of that parent - if
    // there are further children, go into the next one. Otherwise, go up the
    // tree and test again for further children. Return null if there are no
    // further nodes
    m_iterator.assert_valid();
    ntree_node<T>* old_node = m_iterator.node();
    if (!old_node->m_children.empty())
    {
      // simply take the first child of this node
      m_iterator.set(old_node->m_children[0]->m_master);
    }
    else
    {
      // this loop walks up the parent pointers
      // either it will walk off the top and exit or a new node will be found and the loop will exit
      for (;;)
      {
        // go up a level
        ntree_node<T>* parent = old_node->m_parent;
        if (!parent)
        {
          // we've walked off the top of the tree, so return end
          m_iterator.set_end();
          break;
        }
        else
        {
          // otherwise walk down the next child - if there is one
          // find which index the old node was relative to this node
          TYPENAME std::vector<ntree_node<T>*>::iterator found = 
            std::find(parent->m_children.begin(), parent->m_children.end(), old_node);
          // if this was found, then see if there is another and if so return that
          found++;
          if (found != parent->m_children.end())
          {
            // visit the next child
            m_iterator.set((*found)->m_master);
            break;
          }
          else
          {
            // keep going up
            old_node = parent;
          }
        }
      }
    }
    return *this;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::this_iterator ntree_prefix_iterator<T,TRef,TPtr>::operator ++ (int)
    throw(null_dereference,end_dereference)
  {
    // post-increment is defined in terms of the pre-increment
    ntree_prefix_iterator<T,TRef,TPtr> result(*this);
    ++(*this);
    return result;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::reference ntree_prefix_iterator<T,TRef,TPtr>::operator*(void) const
    throw(null_dereference,end_dereference)
  {
    return m_iterator.operator*();
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_prefix_iterator<T,TRef,TPtr>::pointer ntree_prefix_iterator<T,TRef,TPtr>::operator->(void) const
    throw(null_dereference,end_dereference)
  {
    return m_iterator.operator->();
  }

  template<typename T, typename TRef, typename TPtr>
  const ntree_iterator<T,TRef,TPtr>& ntree_prefix_iterator<T,TRef,TPtr>::get_iterator(void) const
  {
    return m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>& ntree_prefix_iterator<T,TRef,TPtr>::get_iterator(void)
  {
    return m_iterator;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // ntree_postfix_iterator

  template<typename T, typename TRef, typename TPtr>
  ntree_postfix_iterator<T,TRef,TPtr>::ntree_postfix_iterator(void)
  {
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_postfix_iterator<T,TRef,TPtr>::~ntree_postfix_iterator(void)
  {
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_postfix_iterator<T,TRef,TPtr>::ntree_postfix_iterator(const ntree_iterator<T,TRef,TPtr>& i) :
    m_iterator(i)
  {
    // this is initialised with the root node
    // initially traverse to the first node to be visited
    if (m_iterator.valid())
    {
      ntree_node<T>* node = m_iterator.node();
      while (!node->m_children.empty())
        node = node->m_children[0];
      m_iterator.set(node->m_master);
    }
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_postfix_iterator<T,TRef,TPtr>::null(void) const
  {
    return m_iterator.null();
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_postfix_iterator<T,TRef,TPtr>::end(void) const
  {
    return m_iterator.end();
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_postfix_iterator<T,TRef,TPtr>::valid(void) const
  {
    return m_iterator.valid();
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::const_iterator ntree_postfix_iterator<T,TRef,TPtr>::constify(void) const
  {
    return ntree_postfix_iterator<T,const T&,const T*>(m_iterator);
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::iterator ntree_postfix_iterator<T,TRef,TPtr>::deconstify(void) const
  {
    return ntree_postfix_iterator<T,T&,T*>(m_iterator);
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr> ntree_postfix_iterator<T,TRef,TPtr>::simplify(void) const
  {
    return m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_postfix_iterator<T,TRef,TPtr>::operator == (const TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return m_iterator == r.m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_postfix_iterator<T,TRef,TPtr>::operator != (const TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return m_iterator != r.m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  bool ntree_postfix_iterator<T,TRef,TPtr>::operator < (const TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::this_iterator& r) const
  {
    return m_iterator < r.m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::this_iterator& ntree_postfix_iterator<T,TRef,TPtr>::operator ++ (void)
    throw(null_dereference,end_dereference)
  {
    // pre-increment operator
    // algorithm: this node has been visited, therefore all children must have
    // already been visited. So go to parent. Return null if the parent is null.
    // Otherwise deduce which child the start node was of that parent - if there
    // are further children, go into the next one and then walk down any
    // subsequent first-child pointers to the bottom. Otherwise, if there are no
    // children then the parent node is the next in the traversal.
    m_iterator.assert_valid();
    // go up a level
    ntree_node<T>* old_node = m_iterator.node();
    ntree_node<T>* parent = old_node->m_parent;
    if (!parent)
    {
      // we've walked off the top of the tree, so return end
      m_iterator.set_end();
    }
    else
    {
      // otherwise find which index the old node was relative to this node
      TYPENAME std::vector<ntree_node<T>*>::iterator found =
        std::find(parent->m_children.begin(), parent->m_children.end(), old_node);
      // if this was found, then see if there is another
      found++;
      if (found != parent->m_children.end())
      {
        // if so traverse to it and walk down the leftmost child pointers to the bottom of the new sub-tree
        ntree_node<T>* new_node = *found;
        while (!new_node->m_children.empty())
          new_node = new_node->m_children[0];
        m_iterator.set(new_node->m_master);
      }
      else
      {
        // the parent's children have all been visited - so the parent is visited
        m_iterator.set(parent->m_master);
      }
    }
    return *this;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::this_iterator ntree_postfix_iterator<T,TRef,TPtr>::operator ++ (int)
    throw(null_dereference,end_dereference)
  {
    // post-increment is defined in terms of the pre-increment
    ntree_postfix_iterator<T,TRef,TPtr> result(*this);
    ++(*this);
    return result;
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::reference ntree_postfix_iterator<T,TRef,TPtr>::operator*(void) const
    throw(null_dereference,end_dereference)
  {
    return m_iterator.operator*();
  }

  template<typename T, typename TRef, typename TPtr>
  TYPENAME ntree_postfix_iterator<T,TRef,TPtr>::pointer ntree_postfix_iterator<T,TRef,TPtr>::operator->(void) const
    throw(null_dereference,end_dereference)
  {
    return m_iterator.operator->();
  }

  template<typename T, typename TRef, typename TPtr>
  const ntree_iterator<T,TRef,TPtr>& ntree_postfix_iterator<T,TRef,TPtr>::get_iterator(void) const
  {
    return m_iterator;
  }

  template<typename T, typename TRef, typename TPtr>
  ntree_iterator<T,TRef,TPtr>& ntree_postfix_iterator<T,TRef,TPtr>::get_iterator(void)
  {
    return m_iterator;
  }

  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////
  // ntree
  ////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////

  template<typename T>
  ntree<T>::ntree(void) : m_root(0)
  {
  }

  template<typename T>
  ntree<T>::~ntree(void)
  {
    if (m_root) delete m_root;
  }

  template<typename T>
  ntree<T>::ntree(const ntree<T>& r) : m_root(0)
  {
    *this = r;
  }

  template<typename T>
  ntree<T>& ntree<T>::operator=(const ntree<T>& r)
  {
    if (m_root) delete m_root;
    m_root = ntree_copy(this, r.m_root);
    return *this;
  }

  template<typename T>
  bool ntree<T>::empty(void) const
  {
    return m_root == 0;
  }

  template<typename T>
  unsigned ntree<T>::size(void) const
  {
    return ntree_size(m_root);
  }

  template<typename T>
  unsigned ntree<T>::size(const TYPENAME ntree<T>::const_iterator& i) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    return ntree_size(i.node());
  }

  template<typename T>
  unsigned ntree<T>::size(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    return ntree_size(i.node());
  }

  template<typename T>
  unsigned ntree<T>::depth(const TYPENAME ntree<T>::const_iterator& i) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    return ntree_depth(i.node());
  }

  template<typename T>
  unsigned ntree<T>::depth(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    return ntree_depth(i.node());
  }

  template<typename T>
  TYPENAME ntree<T>::const_iterator ntree<T>::root(void) const
  {
    if (!m_root) return ntree_iterator<T,const T&,const T*>(this);
    return ntree_iterator<T,const T&,const T*>(m_root);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::root(void)
  {
    if (!m_root) return ntree_iterator<T,T&,T*>(this);
    return ntree_iterator<T,T&,T*>(m_root);
  }

  template<typename T>
  unsigned ntree<T>::children(const TYPENAME ntree<T>::const_iterator& i) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    return static_cast<unsigned>(i.node()->m_children.size());
  }

  template<typename T>
  unsigned ntree<T>::children(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    return static_cast<unsigned>(i.node()->m_children.size());
  }

  template<typename T>
  TYPENAME ntree<T>::const_iterator ntree<T>::child(const TYPENAME ntree<T>::const_iterator& i, unsigned child) const
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    i.assert_valid(this);
    if (child >= children(i)) throw std::out_of_range("stlplus::ntree::child - child out of range");
    return ntree_iterator<T,const T&,const T*>(i.node()->m_children[child]);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::child(const TYPENAME ntree<T>::iterator& i, unsigned child)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    i.assert_valid(this);
    if (child >= children(i)) throw std::out_of_range("stlplus::ntree::child - child out of range");
    return ntree_iterator<T,T&,T*>(i.node()->m_children[child]);
  }

  template<typename T>
  unsigned ntree<T>::child_offset(const TYPENAME ntree<T>::const_iterator& root, const TYPENAME ntree<T>::const_iterator& child) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    root.assert_valid(this);
    child.assert_valid(this);
    ntree_node<T>* root_node = root.node();
    ntree_node<T>* child_node = child.node();
    for (unsigned offset = 0; offset < static_cast<unsigned>(root_node->m_children.size()); ++offset)
      if (root_node->m_children[offset] == child_node)
        return offset;
    return static_cast<unsigned>(-1);
  }

  template<typename T>
  unsigned ntree<T>::child_offset(const TYPENAME ntree<T>::iterator& root, const TYPENAME ntree<T>::iterator& child)
    throw(wrong_object,null_dereference,end_dereference)
  {
    root.assert_valid(this);
    child.assert_valid(this);
    ntree_node<T>* root_node = root.node();
    ntree_node<T>* child_node = child.node();
    for (unsigned offset = 0; offset < static_cast<unsigned>(root_node->m_children.size()); ++offset)
      if (root_node->m_children[offset] == child_node)
        return offset;
    return static_cast<unsigned>(-1);
  }

  template<typename T>
  TYPENAME ntree<T>::const_iterator ntree<T>::parent(const TYPENAME ntree<T>::const_iterator& i) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    ntree_node<T>* parent = i.node()->m_parent;
    if (!parent) return ntree_iterator<T,const T&,const T*>(this);
    return ntree_iterator<T,const T&,const T*>(parent);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::parent(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    i.assert_valid(this);
    ntree_node<T>* parent = i.node()->m_parent;
    if (!parent) return ntree_iterator<T,T&,T*>(this);
    return ntree_iterator<T,T&,T*>(parent);
  }

  template<typename T>
  TYPENAME ntree<T>::const_prefix_iterator ntree<T>::prefix_begin(void) const
  {
    return ntree_prefix_iterator<T,const T&,const T*>(root());
  }

  template<typename T>
  TYPENAME ntree<T>::prefix_iterator ntree<T>::prefix_begin(void)
  {
    return ntree_prefix_iterator<T,T&,T*>(root());
  }

  template<typename T>
  TYPENAME ntree<T>::const_prefix_iterator ntree<T>::prefix_end(void) const
  {
    return ntree_prefix_iterator<T,const T&,const T*>(ntree_iterator<T,const T&,const T*>(this));
  }

  template<typename T>
  TYPENAME ntree<T>::prefix_iterator ntree<T>::prefix_end(void)
  {
    return ntree_prefix_iterator<T,T&,T*>(ntree_iterator<T,T&,T*>(this));
  }

  template<typename T>
  TYPENAME ntree<T>::const_postfix_iterator ntree<T>::postfix_begin(void) const
  {
    return ntree_postfix_iterator<T,const T&,const T*>(root());
  }

  template<typename T>
  TYPENAME ntree<T>::postfix_iterator ntree<T>::postfix_begin(void)
  {
    return ntree_postfix_iterator<T,T&,T*>(root());
  }

  template<typename T>
  TYPENAME ntree<T>::const_postfix_iterator ntree<T>::postfix_end(void) const
  {
    return ntree_postfix_iterator<T,const T&,const T*>(ntree_iterator<T,const T&,const T*>(this));
  }

  template<typename T>
  TYPENAME ntree<T>::postfix_iterator ntree<T>::postfix_end(void)
  {
    return ntree_postfix_iterator<T,T&,T*>(ntree_iterator<T,T&,T*>(this));
  }

  template<typename T>
  TYPENAME ntree<T>::iterator_vector ntree<T>::breadth_first_traversal(void)
  {
    TYPENAME ntree<T>::iterator_vector result;
    if (m_root)
    {
      // seed the traversal the the root node
      result.push_back(root());
      // now walk through the result, appending each node's children
      // allow for the vector to reallocate, so don't use vector iterators
      for (unsigned i = 0; i < result.size(); i++)
      {
        unsigned count = children(result[i]);
        for (unsigned c = 0; c < count; c++)
          result.push_back(child(result[i], c));
      }
    }
    return result;
  }

  template<typename T>
  TYPENAME ntree<T>::const_iterator_vector ntree<T>::breadth_first_traversal(void) const
  {
    TYPENAME ntree<T>::const_iterator_vector result;
    if (m_root)
    {
      // seed the traversal the the root node
      result.push_back(root());
      // now walk through the result, appending each node's children
      // allow for the vector to reallocate, so don't use vector iterators
      for (unsigned i = 0; i < result.size(); i++)
      {
        unsigned count = children(result[i]);
        for (unsigned c = 0; c < count; c++)
          result.push_back(child(result[i], c));
      }
    }
    return result;
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::insert(const T& data)
  {
    // insert a new node as the root
    erase();
    m_root = new ntree_node<T>(this,data);
    return ntree_iterator<T,T&,T*>(m_root);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::insert(const TYPENAME ntree<T>::iterator& i, unsigned offset, const T& data)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    // if i is the end iterator, this means insert a new root
    // if (i.end())
    //   return insert(data);
    // otherwise, insert a new child
    i.assert_valid(this);
    if (offset > children(i)) throw std::out_of_range("stlplus::ntree::insert - offset out of range");
    ntree_node<T>* new_node = new ntree_node<T>(this,data);
    i.node()->m_children.insert(i.node()->m_children.begin()+offset,new_node);
    new_node->m_parent = i.node();
    return ntree_iterator<T,T&,T*>(new_node);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::insert(const TYPENAME ntree<T>::iterator& i, const T& data)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return insert(i, children(i), data);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::append(const TYPENAME ntree<T>::iterator& i, const T& data)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return insert(i, children(i), data);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::insert(const ntree<T>& tree)
  {
    // insert a whole tree as root
    erase();
    m_root = ntree_copy(this, tree.m_root);
    return ntree_iterator<T,T&,T*>(m_root);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::insert(const TYPENAME ntree<T>::iterator& i, unsigned offset, const ntree<T>& tree)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    // insert a whole tree as a child of i
    i.assert_valid(this);
    if (offset > children(i)) throw std::out_of_range("stlplus::ntree::insert - offset out of range");
    ntree_node<T>* new_node = ntree_copy(this, tree.m_root);
    i.node()->m_children.insert(i.node()->m_children.begin()+offset,new_node);
    new_node->m_parent = i.node();
    return ntree_iterator<T,T&,T*>(new_node);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::insert(const TYPENAME ntree<T>::iterator& i, const ntree<T>& tree)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return insert(i, children(i), tree);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::append(const TYPENAME ntree<T>::iterator& i, const ntree<T>& tree)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return insert(i, children(i), tree);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::move(ntree<T>& tree)
  {
    // insert a whole tree as root, removing it from source
    erase();
    m_root = tree.m_root;
    tree.m_root = 0;
    if (m_root) m_root->change_owner(this);
    return ntree_iterator<T,T&,T*>(m_root);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::move(const TYPENAME ntree<T>::iterator& i, unsigned offset, ntree<T>& tree)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    // insert a whole tree as a child of i
    i.assert_valid(this);
    if (offset > children(i)) throw std::out_of_range("stlplus::ntree::move - offset out of range");
    ntree_node<T>* new_node = tree.m_root;
    tree.m_root = 0;
    if (new_node) new_node->change_owner(this);
    i.node()->m_children.insert(i.node()->m_children.begin()+offset,new_node);
    new_node->m_parent = i.node();
    return ntree_iterator<T,T&,T*>(new_node);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::move(const TYPENAME ntree<T>::iterator& i, ntree<T>& tree)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return move(i, children(i), tree);
  }

  template<typename T>
  TYPENAME ntree<T>::iterator ntree<T>::push(const TYPENAME ntree<T>::iterator& node, const T& data)
    throw(wrong_object,null_dereference,end_dereference)
  {
    // insert a new node to replace the existing node in the tree
    // making the original node the child of the new node
    // i.e. (node) becomes (new)->(node)
    // afterwards, the iterator still points to the old node, now the child
    // returns the iterator to the new node
    node.assert_valid(this);
    ntree_node<T>* new_node = new ntree_node<T>(this,data);
    if (node.node() == m_root)
    {
      // pushing the root node
      m_root = new_node;
      new_node->m_parent = 0;
    }
    else
    {
      // pushing a sub-node
      *(std::find(node.node()->m_parent->m_children.begin(), node.node()->m_parent->m_children.end(), node.node())) = new_node;
      new_node->m_parent = node.node()->m_parent;
    }
    // link up the old node as the child of the new node
    new_node->m_children.insert(new_node->m_children.begin(),node.node());
    node.node()->m_parent = new_node;
    return ntree_iterator<T,T&,T*>(new_node);
  }

  template<typename T>
  void ntree<T>::pop(const TYPENAME ntree<T>::iterator& parent, unsigned offset)
    throw(wrong_object,null_dereference,end_dereference)
  {
    // inverse of push
    // removes the specified child of the parent node, adding its children to the parent node at the same offset
    parent.assert_valid(this);
    ntree_node<T>* node = parent.node();
    if (offset >= node->m_children.size()) throw std::out_of_range("stlplus::ntree::pop - offset out of range");
    // move the grandchildren first
    ntree_node<T>* child = parent.node()->m_children[offset];
    while (!child->m_children.empty())
    {
      // remove the last grandchild and insert into node just after the child to be removed
      ntree_node<T>* grandchild = child->m_children[child->m_children.size()-1];
      child->m_children.pop_back();
      node->m_children.insert(node->m_children.begin()+offset+1, grandchild);
      grandchild->m_parent = node;
    }
    // now remove the child
    node->m_children.erase(node->m_children.begin()+offset);
    delete child;
  }

  template<typename T>
  void ntree<T>::erase(void)
  {
    // erase the whole tree
    erase(root());
  }

  template<typename T>
  void ntree<T>::erase(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    if (!i.end())
    {
      // erase this node and its subtree
      // do this by erasing this child of its parent
      // handle the case of erasing the root
      i.assert_valid(this);
      ntree_node<T>* node = i.node();
      if (node == m_root)
      {
        delete m_root;
        m_root = 0;
      }
      else
      {
        ntree_node<T>* parent = node->m_parent;
        // impossible for parent to be null - should assert this
        TYPENAME std::vector<ntree_node<T>*>::iterator found = 
          std::find(parent->m_children.begin(), parent->m_children.end(), node);
        // impossible for find to fail - should assert this
        parent->m_children.erase(found);
        delete node;
      }
    }
  }

  // erase a child designated by an offset into the node's children
  template<typename T>
  void ntree<T>::erase_child(const TYPENAME ntree<T>::iterator& i, unsigned offset)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    if (offset >= children(i)) throw std::out_of_range("stlplus::ntree::erase_child - offset out of range");
    // unhook from the children array
    ntree_node<T>* node = i.node()->m_children[offset];
    i.node()->m_children.erase(i.node()->m_children.begin() + offset);
    // now delete the subtree
    delete node;
  }

  // synonym of above
  template<typename T>
  void ntree<T>::erase(const TYPENAME ntree<T>::iterator& i, unsigned offset)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    erase_child(i, offset);
  }

  // erase all children
  template<typename T>
  void ntree<T>::erase_children(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    while(children(i) > 0)
      erase_child(i, 0);
  }

  template<typename T>
  ntree<T> ntree<T>::subtree(void)
  {
    return subtree(root());
  }

  template<typename T>
  ntree<T> ntree<T>::subtree(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    ntree<T> result;
    if (!i.end())
    {
      i.assert_valid(this);
      result.m_root = ntree_copy(&result, i.node());
    }
    return result;
  }

  template<typename T>
  ntree<T> ntree<T>::subtree(const TYPENAME ntree<T>::iterator& i, unsigned offset)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    return subtree(child(i, offset));
  }

  template<typename T>
  ntree<T> ntree<T>::cut(void)
  {
    return cut(root());
  }

  template<typename T>
  ntree<T> ntree<T>::cut(const TYPENAME ntree<T>::iterator& i)
    throw(wrong_object,null_dereference,end_dereference)
  {
    ntree<T> result;
    if (!i.end())
    {
      i.assert_valid(this);
      ntree_node<T>* node = i.node();
      if (node == m_root)
      {
        result.m_root = m_root;
        m_root = 0;
      }
      else
      {
        ntree_node<T>* parent = node->m_parent;
        // impossible for parent to be null - should assert this
        TYPENAME std::vector<ntree_node<T>*>::iterator found = 
          std::find(parent->m_children.begin(), parent->m_children.end(), node);
        // impossible for find to fail - should assert this
        result.m_root = *found;
        parent->m_children.erase(found);
      }
      if (result.m_root)
      {
        result.m_root->m_parent = 0;
        result.m_root->change_owner(&result);
      }
    }
    return result;
  }

  template<typename T>
  ntree<T> ntree<T>::cut(const TYPENAME ntree<T>::iterator& i, unsigned offset)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    return cut(child(i, offset));
  }

  template<typename T>
  void ntree<T>::reorder(const TYPENAME ntree<T>::iterator& node, unsigned child_offset, unsigned new_offset)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    // check preconditions
    node.assert_valid(this);
    if (child_offset >= children(node)) throw std::out_of_range("stlplus::ntree::reorder - child offset out of range");
    if (new_offset >= children(node)) throw std::out_of_range("stlplus::ntree::reorder - new offset out of range");
    // do nothing if the offsets are the same, i.e. move to the same place
    if (new_offset == child_offset) return;
    // perform the move
    // Note: this is not a swap operation, but a remove then re-insert which preserves the order of the remaining children
    ntree_node<T>* node_node = node.node();
    ntree_node<T>* child_node = node_node->m_children[child_offset];
    node_node->m_children.erase(node_node->m_children.begin() + child_offset);
    node_node->m_children.insert(node_node->m_children.begin() + new_offset, child_node);
  }

  template<typename T>
  void ntree<T>::swap(const TYPENAME ntree<T>::iterator& node, unsigned child1, unsigned child2)
      throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    // check preconditions
    node.assert_valid(this);
    if (child1 >= children(node)) throw std::out_of_range("stlplus::ntree::reorder - child1 offset out of range");
    if (child2 >= children(node)) throw std::out_of_range("stlplus::ntree::reorder - child2 offset out of range");
    // do nothing if the offsets are the same, i.e. move to the same place
    if (child1 == child2) return;
    // perform the move
    ntree_node<T>* node_node = node.node();
    std::swap(node_node->m_children[child1], node_node->m_children[child2]);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus

