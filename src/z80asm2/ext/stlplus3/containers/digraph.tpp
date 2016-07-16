////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

//   Note: I tried to write this using STL lists for the node and arc lists, but
//   it got far too hairy. The specific problem is that I wanted a digraph
//   iterator to contain a list::iterator so I needed to be able to generate a
//   list::iterator from a node or arc and STL list iterators don't give you that
//   functionality. I tried burgling the data structures, but that was
//   non-portable between different STL implementations so needed lots of #ifdefs
//   and so was mind-bogglingly awful and unreadable - in other words a
//   maintenance nightmare. I gave up and impemented my own lists - not difficult.

//   I use circular double-linked lists. The circular design means that both
//   ends of the list are equally accessible in unit time. An empty list
//   contains no objects. There is no end node in the list - unlike the STL
//   lists which have a dummy node for end iterators to point to -
//   conceptually the end iterator points one element beyond the end of the
//   list. However, I implement the end iterator concept in the iterator
//   itself, so do not need the dummy end node.

////////////////////////////////////////////////////////////////////////////////
#include <algorithm>
#include <deque>

////////////////////////////////////////////////////////////////////////////////
// Internals

namespace stlplus
{

  // the raw node data structure used in the node list
  // does very little itself, all node manipulations are carried out at a higher level
  template<typename NT, typename AT>
  class digraph_node
  {
  public:
    master_iterator<digraph<NT,AT>, digraph_node<NT,AT> > m_master;
    NT m_data;
    digraph_node<NT,AT>* m_prev;
    digraph_node<NT,AT>* m_next;
    std::vector<digraph_arc<NT,AT>*> m_inputs;
    std::vector<digraph_arc<NT,AT>*> m_outputs;
    digraph_node(const digraph<NT,AT>* owner, const NT& d = NT()) :
      m_master(owner,this), m_data(d), m_prev(0), m_next(0)
      {
      }
    ~digraph_node(void)
      {
      }
  };

  // the raw arc data structure used in the arc list
  // does very little itself, all arc manipulations are carried out at a higher level
  template<typename NT, typename AT>
  class digraph_arc
  {
  public:
    master_iterator<digraph<NT,AT>, digraph_arc<NT,AT> > m_master;
    AT m_data;
    digraph_arc<NT,AT>* m_prev;
    digraph_arc<NT,AT>* m_next;
    digraph_node<NT,AT>* m_from;
    digraph_node<NT,AT>* m_to;
    digraph_arc(const digraph<NT,AT>* owner, digraph_node<NT,AT>* from = 0, digraph_node<NT,AT>* to = 0, const AT& d = AT()) : 
      m_master(owner,this), m_data(d), m_prev(0), m_next(0), m_from(from), m_to(to)
      {
      }
  };

  ////////////////////////////////////////////////////////////////////////////////
  // Iterators
  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////
  // Node iterator

  // construct a null iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_iterator<NT,AT,NRef,NPtr>::digraph_iterator(void)
  {
  }

  // valid iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_iterator<NT,AT,NRef,NPtr>::digraph_iterator(digraph_node<NT,AT>* node) :
    safe_iterator<digraph<NT,AT>,digraph_node<NT,AT> >(node->m_master)
  {
  }

  // end iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_iterator<NT,AT,NRef,NPtr>::digraph_iterator(const digraph<NT,AT>* owner) :
    safe_iterator<digraph<NT,AT>,digraph_node<NT,AT> >(owner)
  {
  }

  // alias an iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_iterator<NT,AT,NRef,NPtr>::digraph_iterator(const safe_iterator<digraph<NT,AT>, digraph_node<NT,AT> >& iterator) : 
    safe_iterator<digraph<NT,AT>,digraph_node<NT,AT> >(iterator)
  {
  }

  // destructor
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_iterator<NT,AT,NRef,NPtr>::~digraph_iterator(void)
  {
  }

  // convert an iterator to its const form
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::const_iterator digraph_iterator<NT,AT,NRef,NPtr>::constify (void) const
  {
    return digraph_iterator<NT,AT,const NT&,const NT*>(*this);
  }

  // convert an iterator to its non-const form
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::iterator digraph_iterator<NT,AT,NRef,NPtr>::deconstify (void) const
  {
    return digraph_iterator<NT,AT,NT&,NT*>(*this);
  }

  // increment/decrement operators implement iteration through the list

  // pre-increment operator - must be valid to be able to increment, handles incrementing off the end by becoming an end iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator& digraph_iterator<NT,AT,NRef,NPtr>::operator ++ (void)
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    if (this->node()->m_next)
      this->set(this->node()->m_next->m_master);
    else
      this->set_end();
    return *this;
  }

  // post-increment operator - based on above but returns a copy of the iterator before the increment
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator digraph_iterator<NT,AT,NRef,NPtr>::operator ++ (int)
    throw(null_dereference,end_dereference)
  {
    // post-increment is defined in terms of the pre-increment
    digraph_iterator<NT,AT,NRef,NPtr> result(*this);
    ++(*this);
    return result;
  }

  // pre-decrement operator - must be valid to be able to decrement, handles stepping off the end by becoming an end iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator& digraph_iterator<NT,AT,NRef,NPtr>::operator -- (void)
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    if (this->node()->m_prev)
      this->set(this->node()->m_prev->m_master);
    else
      this->set_end();
    return *this;
  }

  // post-decrement operator - based on above but returns a copy of the iterator before the decrement
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator digraph_iterator<NT,AT,NRef,NPtr>::operator -- (int)
    throw(null_dereference,end_dereference)
  {
    // post-decrement is defined in terms of the pre-decrement
    digraph_iterator<NT,AT,NRef,NPtr> result(*this);
    --(*this);
    return result;
  }

  // comparisons

  template<typename NT, typename AT, typename NRef, typename NPtr>
  bool digraph_iterator<NT,AT,NRef,NPtr>::operator == (const TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator& r) const
  {
    return this->equal(r);
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  bool digraph_iterator<NT,AT,NRef,NPtr>::operator != (const TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator& r) const
  {
    return !operator==(r);
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  bool digraph_iterator<NT,AT,NRef,NPtr>::operator < (const TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::this_iterator& r) const
  {
    return this->compare(r) < 0;
  }

  // dereference operators
  
  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::reference digraph_iterator<NT,AT,NRef,NPtr>::operator*(void) const
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    return this->node()->m_data;
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_iterator<NT,AT,NRef,NPtr>::pointer digraph_iterator<NT,AT,NRef,NPtr>::operator->(void) const
    throw(null_dereference,end_dereference)
  {
    return &(operator*());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Arc Iterator

  template<typename NT, typename AT, typename ARef, typename APtr>
  digraph_arc_iterator<NT,AT,ARef,APtr>::digraph_arc_iterator(void)
  {
  }

  // valid iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_arc_iterator<NT,AT,NRef,NPtr>::digraph_arc_iterator(digraph_arc<NT,AT>* arc) :
    safe_iterator<digraph<NT,AT>,digraph_arc<NT,AT> >(arc->m_master)
  {
  }

  // end iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_arc_iterator<NT,AT,NRef,NPtr>::digraph_arc_iterator(const digraph<NT,AT>* owner) :
    safe_iterator<digraph<NT,AT>,digraph_arc<NT,AT> >(owner)
  {
  }

  // alias an iterator
  template<typename NT, typename AT, typename NRef, typename NPtr>
  digraph_arc_iterator<NT,AT,NRef,NPtr>::digraph_arc_iterator(const safe_iterator<digraph<NT,AT>, digraph_arc<NT,AT> >& iterator) : 
    safe_iterator<digraph<NT,AT>,digraph_arc<NT,AT> >(iterator)
  {
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  digraph_arc_iterator<NT,AT,ARef,APtr>::~digraph_arc_iterator(void)
  {
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_arc_iterator<NT,AT,NRef,NPtr>::const_iterator digraph_arc_iterator<NT,AT,NRef,NPtr>::constify (void) const
  {
    return digraph_arc_iterator<NT,AT,const AT&,const AT*>(*this);
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  TYPENAME digraph_arc_iterator<NT,AT,NRef,NPtr>::iterator digraph_arc_iterator<NT,AT,NRef,NPtr>::deconstify (void) const
  {
    return digraph_arc_iterator<NT,AT,AT&,AT*>(*this);
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator& digraph_arc_iterator<NT,AT,ARef,APtr>::operator ++ (void)
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    if (this->node()->m_next)
      this->set(this->node()->m_next->m_master);
    else
      this->set_end();
    return *this;
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator digraph_arc_iterator<NT,AT,ARef,APtr>::operator ++ (int)
    throw(null_dereference,end_dereference)
  {
    // post-increment is defined in terms of the pre-increment
    digraph_arc_iterator<NT,AT,ARef,APtr> result(*this);
    ++(*this);
    return result;
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator& digraph_arc_iterator<NT,AT,ARef,APtr>::operator -- (void)
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    if (this->node()->m_prev)
      this->set(this->node()->m_prev->m_master);
    else
      this->set_end();
    return *this;
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator digraph_arc_iterator<NT,AT,ARef,APtr>::operator -- (int)
    throw(null_dereference,end_dereference)
  {
    // post-decrement is defined in terms of the pre-decrement
    digraph_arc_iterator<NT,AT,ARef,APtr> result(*this);
    --(*this);
    return result;
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  bool digraph_arc_iterator<NT,AT,ARef,APtr>::operator == (const TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator& r) const
  {
    return this->equal(r);
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  bool digraph_arc_iterator<NT,AT,ARef,APtr>::operator != (const TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator& r) const
  {
    return !operator==(r);
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  bool digraph_arc_iterator<NT,AT,ARef,APtr>::operator < (const TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::this_iterator& r) const
  {
    return this->compare(r) < 0;
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::reference digraph_arc_iterator<NT,AT,ARef,APtr>::operator*(void) const
    throw(null_dereference,end_dereference)
  {
    this->assert_valid();
    return this->node()->m_data;
  }

  template<typename NT, typename AT, typename ARef, typename APtr>
  TYPENAME digraph_arc_iterator<NT,AT,ARef,APtr>::pointer digraph_arc_iterator<NT,AT,ARef,APtr>::operator->(void) const
    throw(null_dereference,end_dereference)
  {
    return &(operator*());
  }

  ////////////////////////////////////////////////////////////////////////////////
  // subtype utilities

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_vector digraph<NT,AT>::constify_arcs(const TYPENAME digraph<NT,AT>::arc_vector& arcs) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > result;
    for (unsigned i = 0; i < arcs.size(); i++)
    {
      arcs[i].assert_valid(this);
      result.push_back(arcs[i].constify());
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_vector digraph<NT,AT>::deconstify_arcs(const TYPENAME digraph<NT,AT>::const_arc_vector& arcs) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<digraph_arc_iterator<NT,AT,AT&,AT*> > result;
    for (unsigned i = 0; i < arcs.size(); i++)
    {
      arcs[i].assert_valid(this);
      result.push_back(arcs[i].deconstify());
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_path_vector digraph<NT,AT>::constify_paths(const TYPENAME digraph<NT,AT>::path_vector& paths) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > > result;
    for (unsigned i = 0; i < paths.size(); i++)
      result.push_back(constify_arcs(paths[i]));
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::path_vector digraph<NT,AT>::deconstify_paths(const TYPENAME digraph<NT,AT>::const_path_vector& paths) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<std::vector<digraph_arc_iterator<NT,AT,AT&,AT*> > > result;
    for (unsigned i = 0; i < paths.size(); i++)
      result.push_back(deconstify_arcs(paths[i]));
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_node_vector digraph<NT,AT>::constify_nodes(const TYPENAME digraph<NT,AT>::node_vector& nodes) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<digraph_iterator<NT,AT,const NT&,const NT*> > result;
    for (unsigned i = 0; i < nodes.size(); i++)
    {
      nodes[i].assert_valid(this);
      result.push_back(nodes[i].constify());
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::node_vector digraph<NT,AT>::deconstify_nodes(const TYPENAME digraph<NT,AT>::const_node_vector& nodes) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<digraph_iterator<NT,AT,NT&,NT*> > result;
    for (unsigned i = 0; i < nodes.size(); i++)
    {
      nodes[i].assert_valid(this);
      result.push_back(nodes[i].deconstify());
    }
    return result;
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::npos(void)
  {
    return(unsigned)-1;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // iterator ownership

  template<typename NT, typename AT>
  bool digraph<NT,AT>::owns(TYPENAME digraph<NT,AT>::iterator iter) const
  {
    return iter.owned_by(this);
  }

  template<typename NT, typename AT>
  bool digraph<NT,AT>::owns(TYPENAME digraph<NT,AT>::const_iterator iter) const
  {
    return iter.owned_by(this);
  }

  template<typename NT, typename AT>
  bool digraph<NT,AT>::owns(TYPENAME digraph<NT,AT>::arc_iterator iter) const
  {
    return iter.owned_by(this);
  }

  template<typename NT, typename AT>
  bool digraph<NT,AT>::owns(TYPENAME digraph<NT,AT>::const_arc_iterator iter) const
  {
    return iter.owned_by(this);
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Constructors etc.

  template<typename NT, typename AT>
  digraph<NT,AT>::digraph(void) :
    m_nodes_begin(0), m_nodes_end(0), m_arcs_begin(0), m_arcs_end(0)
  {
    // node and arc lists are circular double-linked lists
    // they start out empty (no dummy end node)
  }

  template<typename NT, typename AT>
  digraph<NT,AT>::~digraph(void)
  {
    clear();
  }

  template<typename NT, typename AT>
  digraph<NT,AT>::digraph(const digraph<NT,AT>& r) :
    m_nodes_begin(0), m_nodes_end(0), m_arcs_begin(0), m_arcs_end(0)
  {
    *this = r;
  }

  template<typename NT, typename AT>
  digraph<NT,AT>& digraph<NT,AT>::operator=(const digraph<NT,AT>& r)
  {
    // make it self-copy safe i.e. a=a; is a valid instruction
    if (this == &r) return *this;
    clear();
    // first phase is to copy the nodes, creating a map of cross references from the old nodes to their new equivalents
    std::map<digraph_iterator<NT,AT,const NT&,const NT*>, digraph_iterator<NT,AT,NT&,NT*> > xref;
    for (digraph_iterator<NT,AT,const NT&,const NT*> n = r.begin(); n != r.end(); n++)
      xref[n] = insert(*n);
    // second phase is to copy the arcs, using the map to convert the old to and from nodes to the new nodes
    for (digraph_arc_iterator<NT,AT, const AT&,const AT*> a = r.arc_begin(); a != r.arc_end(); a++)
      arc_insert(xref[r.arc_from(a)],xref[r.arc_to(a)],*a);
    return *this;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Basic Node functions

  template<typename NT, typename AT>
  bool digraph<NT,AT>::empty(void) const
  {
    return m_nodes_begin == 0;
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::size(void) const
  {
    unsigned count = 0;
    for (digraph_iterator<NT,AT,const NT&,const NT*> i = begin(); i != end(); i++)
      count++;
    return count;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::iterator digraph<NT,AT>::insert(const NT& node_data)
  {
    digraph_node<NT,AT>* new_node = new digraph_node<NT,AT>(this,node_data);
    if (!m_nodes_end)
    {
      // insert into an empty list
      m_nodes_begin = new_node;
      m_nodes_end = new_node;
    }
    else
    {
      // insert at the end of the list
      new_node->m_prev = m_nodes_end;
      m_nodes_end->m_next = new_node;
      m_nodes_end = new_node;
    }
    return digraph_iterator<NT,AT,NT&,NT*>(new_node);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::iterator digraph<NT,AT>::erase(TYPENAME digraph<NT,AT>::iterator iter)
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    // remove all arcs connected to this node first
    // use arc_erase rather than arcs.erase because that tidies up the node at the other end of the arc too
    for (unsigned i = fanin(iter); i--; )
      arc_erase(input(iter,i));
    for (unsigned j = fanout(iter); j--; )
      arc_erase(output(iter,j));
    // now unlink the node from the list and delete it
    if (iter.node()->m_next)
      iter.node()->m_next->m_prev = iter.node()->m_prev;
    if (iter.node()->m_prev)
      iter.node()->m_prev->m_next = iter.node()->m_next;
    // handle the case in which the item is at the beginning/end of the list
    if (iter.node() == m_nodes_begin)
      m_nodes_begin = iter.node()->m_next;
    if (iter.node() == m_nodes_end)
      m_nodes_end = iter.node()->m_prev;
    digraph_node<NT,AT>* next = iter.node()->m_next;
    delete iter.node();
    // return the next node in the list
    if (next)
      return digraph_iterator<NT,AT,NT&,NT*>(next);
    else
      return digraph_iterator<NT,AT,NT&,NT*>(this);
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::clear(void)
  {
    // delete all nodes and arcs from the graph leaving it empty
    // old solution used erase on each node but that is quite slow since each erase carefully unpicks a node from the structure
    // since we know that the whole data structure is being deleted, can do a more efficient job

    // delete all the nodes
    for (digraph_node<NT,AT>* node = m_nodes_begin; node != 0; )
    {
      digraph_node<NT,AT>* next = node->m_next;
      delete node;
      node = next;
    }
    m_nodes_begin = 0;
    m_nodes_end = 0;
    // delete all the arcs
    for (digraph_arc<NT,AT>* arc = m_arcs_begin; arc != 0; )
    {
      digraph_arc<NT,AT>* next = arc->m_next;
      delete arc;
      arc = next;
    }
    m_arcs_begin = 0;
    m_arcs_end = 0;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_iterator digraph<NT,AT>::begin(void) const
  {
    if (m_nodes_begin)
      return digraph_iterator<NT,AT,const NT&,const NT*>(m_nodes_begin);
    else
      return digraph_iterator<NT,AT,const NT&,const NT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::iterator digraph<NT,AT>::begin(void)
  {
    if (m_nodes_begin)
      return digraph_iterator<NT,AT,NT&,NT*>(m_nodes_begin);
    else
      return digraph_iterator<NT,AT,NT&,NT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_iterator digraph<NT,AT>::end(void) const
  {
    return digraph_iterator<NT,AT,const NT&,const NT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::iterator digraph<NT,AT>::end(void)
  {
    return digraph_iterator<NT,AT,NT&,NT*>(this);
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::fanin(TYPENAME digraph<NT,AT>::const_iterator iter) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return static_cast<unsigned>(iter.node()->m_inputs.size());
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::fanin(TYPENAME digraph<NT,AT>::iterator iter)
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return static_cast<unsigned>(iter.node()->m_inputs.size());
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_iterator digraph<NT,AT>::input(TYPENAME digraph<NT,AT>::const_iterator iter, unsigned i) const
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    iter.assert_valid(this);
    if (i >= iter.node()->m_inputs.size()) throw std::out_of_range("digraph::input");
    return digraph_arc_iterator<NT,AT, const AT&,const AT*>(iter.node()->m_inputs[i]);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::input(TYPENAME digraph<NT,AT>::iterator iter, unsigned i)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    iter.assert_valid(this);
    if (i >= iter.node()->m_inputs.size()) throw std::out_of_range("digraph::input");
    return digraph_arc_iterator<NT,AT,AT&,AT*>(iter.node()->m_inputs[i]);
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::fanout(TYPENAME digraph<NT,AT>::const_iterator iter) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return static_cast<unsigned>(iter.node()->m_outputs.size());
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::fanout(TYPENAME digraph<NT,AT>::iterator iter)
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return static_cast<unsigned>(iter.node()->m_outputs.size());
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_iterator digraph<NT,AT>::output(TYPENAME digraph<NT,AT>::const_iterator iter, unsigned i) const
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    iter.assert_valid(this);
    if (i >= iter.node()->m_outputs.size()) throw std::out_of_range("digraph::output");
    return digraph_arc_iterator<NT,AT, const AT&,const AT*>(iter.node()->m_outputs[i]);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::output(TYPENAME digraph<NT,AT>::iterator iter, unsigned i)
    throw(wrong_object,null_dereference,end_dereference,std::out_of_range)
  {
    iter.assert_valid(this);
    if (i >= iter.node()->m_outputs.size()) throw std::out_of_range("digraph::output");
    return digraph_arc_iterator<NT,AT,AT&,AT*>(iter.node()->m_outputs[i]);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_vector digraph<NT,AT>::inputs(TYPENAME digraph<NT,AT>::const_iterator node) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    node.assert_valid(this);
    std::vector<digraph_arc_iterator<NT,AT,const AT&, const AT*> > result;
    for (unsigned i = 0; i < fanin(node); i++)
      result.push_back(input(node,i));
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_vector digraph<NT,AT>::inputs(TYPENAME digraph<NT,AT>::iterator node)
    throw(wrong_object,null_dereference,end_dereference)
  {
    node.assert_valid(this);
    std::vector<digraph_arc_iterator<NT,AT,AT&,AT*> > result;
    for (unsigned i = 0; i < fanin(node); i++)
      result.push_back(input(node,i));
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_vector digraph<NT,AT>::outputs(TYPENAME digraph<NT,AT>::const_iterator node) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    node.assert_valid(this);
    std::vector<digraph_arc_iterator<NT,AT,const AT&, const AT*> > result;
    for (unsigned i = 0; i < fanout(node); i++)
      result.push_back(output(node,i));
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_vector digraph<NT,AT>::outputs(TYPENAME digraph<NT,AT>::iterator node)
    throw(wrong_object,null_dereference,end_dereference)
  {
    node.assert_valid(this);
    std::vector<digraph_arc_iterator<NT,AT,AT&,AT*> > result;
    for (unsigned i = 0; i < fanout(node); i++)
      result.push_back(output(node,i));
    return result;
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::output_offset(TYPENAME digraph<NT,AT>::const_iterator from,
                                         TYPENAME digraph<NT,AT>::const_arc_iterator arc) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    from.assert_valid(this);
    arc.assert_valid(this);
    for (unsigned i = 0; i < fanout(from); i++)
    {
      if (output(from,i) == arc)
        return i;
    }
    return digraph<NT,AT>::npos();
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::output_offset(TYPENAME digraph<NT,AT>::iterator from,
                                         TYPENAME digraph<NT,AT>::arc_iterator arc)
    throw(wrong_object,null_dereference,end_dereference)
  {
    from.assert_valid(this);
    arc.assert_valid(this);
    for (unsigned i = 0; i < fanout(from); i++)
    {
      if (output(from,i) == arc)
        return i;
    }
    return digraph<NT,AT>::npos();
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::input_offset(TYPENAME digraph<NT,AT>::const_iterator to,
                                        TYPENAME digraph<NT,AT>::const_arc_iterator arc) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    to.assert_valid(this);
    arc.assert_valid(this);
    for (unsigned i = 0; i < fanin(to); i++)
    {
      if (input(to,i) == arc)
        return i;
    }
    return digraph<NT,AT>::npos();
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::input_offset(TYPENAME digraph<NT,AT>::iterator to,
                                        TYPENAME digraph<NT,AT>::arc_iterator arc)
    throw(wrong_object,null_dereference,end_dereference)
  {
    to.assert_valid(this);
    arc.assert_valid(this);
    for (unsigned i = 0; i < fanin(to); i++)
    {
      if (input(to,i) == arc)
        return i;
    }
    return digraph<NT,AT>::npos();
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Basic Arc functions

  template<typename NT, typename AT>
  bool digraph<NT,AT>::arc_empty(void) const
  {
    return m_arcs_end == 0;
  }

  template<typename NT, typename AT>
  unsigned digraph<NT,AT>::arc_size(void) const
  {
    unsigned count = 0;
    for (digraph_arc_iterator<NT,AT, const AT&,const AT*> i = arc_begin(); i != arc_end(); i++)
      count++;
    return count;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::arc_insert(TYPENAME digraph<NT,AT>::iterator from,
                                                                   TYPENAME digraph<NT,AT>::iterator to,
                                                                   const AT& arc_data)
    throw(wrong_object,null_dereference,end_dereference)
  {
    from.assert_valid(this);
    to.assert_valid(this);
    // create the new arc and link it in to the arc list
    digraph_arc<NT,AT>* new_arc = new digraph_arc<NT,AT>(this, from.node(), to.node(), arc_data);
    if (!m_arcs_end)
    {
      // insert into an empty list
      m_arcs_begin = new_arc;
      m_arcs_end = new_arc;
    }
    else
    {
      // insert at the end of the list
      new_arc->m_prev = m_arcs_end;
      m_arcs_end->m_next = new_arc;
      m_arcs_end = new_arc;
    }
    // add this arc to the inputs and outputs of the end nodes
    from.node()->m_outputs.push_back(new_arc);
    to.node()->m_inputs.push_back(new_arc);
    return digraph_arc_iterator<NT,AT,AT&,AT*>(new_arc);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::arc_erase(TYPENAME digraph<NT,AT>::arc_iterator iter)
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    // first remove this arc's pointers from the from/to nodes
    for (TYPENAME std::vector<digraph_arc<NT,AT>*>::iterator i = iter.node()->m_to->m_inputs.begin(); i != iter.node()->m_to->m_inputs.end(); )
    {
      if (*i == iter.node())
        i = iter.node()->m_to->m_inputs.erase(i);
      else
        i++;
    }
    for (TYPENAME std::vector<digraph_arc<NT,AT>*>::iterator o = iter.node()->m_from->m_outputs.begin(); o != iter.node()->m_from->m_outputs.end(); )
    {
      if (*o == iter.node())
        o = iter.node()->m_from->m_outputs.erase(o);
      else
        o++;
    }
    // now unlink the arc from the list and delete it
    if (iter.node()->m_next)
      iter.node()->m_next->m_prev = iter.node()->m_prev;
    if (iter.node()->m_prev)
      iter.node()->m_prev->m_next = iter.node()->m_next;
    // handle the case in which the item is at the beginning/end of the list
    if (iter.node() == m_arcs_begin)
      m_arcs_begin = iter.node()->m_next;
    if (iter.node() == m_arcs_end)
      m_arcs_end = iter.node()->m_prev;
    digraph_arc<NT,AT>* next = iter.node()->m_next;
    delete iter.node();
    if (next)
      return digraph_arc_iterator<NT,AT,AT&,AT*>(next);
    else
      return digraph_arc_iterator<NT,AT,AT&,AT*>(this);
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::arc_clear(void)
  {
    for (digraph_arc_iterator<NT,AT,AT&,AT*> a = arc_begin(); a != arc_end(); )
      a = arc_erase(a);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_iterator digraph<NT,AT>::arc_begin(void) const
  {
    if (m_arcs_begin)
      return digraph_arc_iterator<NT,AT, const AT&,const AT*>(m_arcs_begin);
    else
      return digraph_arc_iterator<NT,AT, const AT&,const AT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::arc_begin(void)
  {
    if (m_arcs_begin)
      return digraph_arc_iterator<NT,AT,AT&,AT*>(m_arcs_begin);
    else
      return digraph_arc_iterator<NT,AT,AT&,AT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_iterator digraph<NT,AT>::arc_end(void) const
  {
    return digraph_arc_iterator<NT,AT, const AT&,const AT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::arc_end(void)
  {
    return digraph_arc_iterator<NT,AT,AT&,AT*>(this);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_iterator digraph<NT,AT>::arc_from(TYPENAME digraph<NT,AT>::const_arc_iterator iter) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return digraph_iterator<NT,AT,const NT&,const NT*>(iter.node()->m_from);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::iterator digraph<NT,AT>::arc_from(TYPENAME digraph<NT,AT>::arc_iterator iter)
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return digraph_iterator<NT,AT,NT&,NT*>(iter.node()->m_from);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_iterator digraph<NT,AT>::arc_to(TYPENAME digraph<NT,AT>::const_arc_iterator iter) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return digraph_iterator<NT,AT,const NT&,const NT*>(iter.node()->m_to);
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::iterator digraph<NT,AT>::arc_to(TYPENAME digraph<NT,AT>::arc_iterator iter)
    throw(wrong_object,null_dereference,end_dereference)
  {
    iter.assert_valid(this);
    return digraph_iterator<NT,AT,NT&,NT*>(iter.node()->m_to);
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::arc_move(TYPENAME digraph<NT,AT>::arc_iterator arc,
                                TYPENAME digraph<NT,AT>::iterator from,
                                TYPENAME digraph<NT,AT>::iterator to)
    throw(wrong_object,null_dereference,end_dereference)
  {
    arc_move_to(arc,to);
    arc_move_from(arc,from);
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::arc_move_from(TYPENAME digraph<NT,AT>::arc_iterator arc,
                                     TYPENAME digraph<NT,AT>::iterator from)
    throw(wrong_object,null_dereference,end_dereference)
  {
    arc.assert_valid(this);
    from.assert_valid(this);
    for (TYPENAME std::vector<digraph_arc<NT,AT>*>::iterator o = arc.node()->m_from->m_outputs.begin(); o != arc.node()->m_from->m_outputs.end(); )
    {
      if (*o == arc.node())
        o = arc.node()->m_from->m_outputs.erase(o);
      else
        o++;
    }
    from.node()->m_outputs.push_back(arc.node());
    arc.node()->m_from = from.node();
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::arc_move_to(TYPENAME digraph<NT,AT>::arc_iterator arc,
                                   TYPENAME digraph<NT,AT>::iterator to)
    throw(wrong_object,null_dereference,end_dereference)
  {
    arc.assert_valid(this);
    to.assert_valid(this);
    for (TYPENAME std::vector<digraph_arc<NT,AT>*>::iterator i = arc.node()->m_to->m_inputs.begin(); i != arc.node()->m_to->m_inputs.end(); )
    {
      if (*i == arc.node())
        i = arc.node()->m_to->m_inputs.erase(i);
      else
        i++;
    }
    to.node()->m_inputs.push_back(arc.node());
    arc.node()->m_to = to.node();
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::arc_flip(TYPENAME digraph<NT,AT>::arc_iterator arc)
    throw(wrong_object,null_dereference,end_dereference)
  {
    arc_move(arc,arc_to(arc),arc_from(arc));
  }

  ////////////////////////////////////////////////////////////////////////////////
  // whole graph manipulations

  // move one graph into another by moving all its nodes/arcs
  // this leaves the source graph empty
  // all iterators to nodes/arcs in the source graph will still work and will be owned by this
  template<typename NT, typename AT>
  void digraph<NT,AT>::move(digraph<NT,AT>& source)
  {
    // disallow merging a graph with itself
    if (&source == this) return;
    
    // move all the nodes/arcs from source
    // since we're moving everything, there's no need to do any remapping, just hook the pointers into this

    // change the ownership of the nodes/arcs - this will also change ownership of any iterators
    // do this before the move so the traversal is easier to calculate
    for (digraph_node<NT,AT>* node = source.m_nodes_begin; node != 0; node = node->m_next)
      node->m_master.change_owner(this);
    for (digraph_arc<NT,AT>* arc = source.m_arcs_begin; arc != 0; arc = arc->m_next)
      arc->m_master.change_owner(this);
    
    // move the nodes
    // do nothing if the source is empty
    if (source.m_nodes_begin != 0)
    {
      if (m_nodes_begin == 0)
      {
        // inserting into an empty graph
        m_nodes_begin = source.m_nodes_begin;
        m_nodes_end = source.m_nodes_end;
      }
      else
      {
        // inserting into a non-empty graph
        m_nodes_end->m_next = source.m_nodes_begin;
        source.m_nodes_begin->m_prev = m_nodes_end;
        m_nodes_end = source.m_nodes_end;
      }
    }
    // unhook from the source
    source.m_nodes_begin = 0;
    source.m_nodes_end = 0;

    // move the arcs
    // do nothing if the source is empty
    if (source.m_arcs_begin != 0)
    {
      if (m_arcs_begin == 0)
      {
        // inserting into an empty graph
        m_arcs_begin = source.m_arcs_begin;
        m_arcs_end = source.m_arcs_end;
      }
      else
      {
        // inserting into a non-empty graph
        m_arcs_end->m_next = source.m_arcs_begin;
        source.m_arcs_begin->m_prev = m_arcs_end;
        m_arcs_end = source.m_arcs_end;
      }
    }
    // unhook from the source
    source.m_arcs_begin = 0;
    source.m_arcs_end = 0;
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Adjacency Algorithms

  template<typename NT, typename AT>
  bool digraph<NT,AT>::adjacent(TYPENAME digraph<NT,AT>::const_iterator from,
                                TYPENAME digraph<NT,AT>::const_iterator to) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    return adjacent_arc(from,to) != arc_end();
  }

  template<typename NT, typename AT>
  bool digraph<NT,AT>::adjacent(TYPENAME digraph<NT,AT>::iterator from,
                                TYPENAME digraph<NT,AT>::iterator to)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return adjacent_arc(from,to) != arc_end();
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_iterator digraph<NT,AT>::adjacent_arc(TYPENAME digraph<NT,AT>::const_iterator from,
                                                                           TYPENAME digraph<NT,AT>::const_iterator to) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    from.assert_valid(this);
    to.assert_valid(this);
    for (unsigned arc = 0; arc < fanout(from); arc++)
    {
      if (arc_to(output(from, arc)) == to)
        return output(from,arc);
    }
    return arc_end();
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_iterator digraph<NT,AT>::adjacent_arc(TYPENAME digraph<NT,AT>::iterator from,
                                                                     TYPENAME digraph<NT,AT>::iterator to)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return adjacent_arc(from.constify(), to.constify()).deconstify();
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_vector digraph<NT,AT>::adjacent_arcs(TYPENAME digraph<NT,AT>::const_iterator from,
                                                                          TYPENAME digraph<NT,AT>::const_iterator to) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    from.assert_valid(this);
    to.assert_valid(this);
    std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > result;
    for (unsigned arc = 0; arc < fanout(from); arc++)
    {
      if (arc_to(output(from, arc)) == to)
        result.push_back(output(from,arc));
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_vector digraph<NT,AT>::adjacent_arcs(TYPENAME digraph<NT,AT>::iterator from,
                                                                    TYPENAME digraph<NT,AT>::iterator to)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_arcs(adjacent_arcs(from.constify(), to.constify()));
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_node_vector digraph<NT,AT>::input_adjacencies(TYPENAME digraph<NT,AT>::const_iterator to) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<digraph_iterator<NT,AT,const NT&,const NT*> > result;
    for (unsigned arc = 0; arc < fanin(to); arc++)
    {
      digraph_iterator<NT,AT,const NT&,const NT*> from = arc_from(input(to, arc));
      if (std::find(result.begin(), result.end(), from) == result.end())
        result.push_back(from);
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::node_vector digraph<NT,AT>::input_adjacencies(TYPENAME digraph<NT,AT>::iterator to)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_nodes(input_adjacencies(to.constify()));
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_node_vector digraph<NT,AT>::output_adjacencies(TYPENAME digraph<NT,AT>::const_iterator from) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<digraph_iterator<NT,AT,const NT&,const NT*> > result;
    for (unsigned arc = 0; arc < fanout(from); arc++)
    {
      digraph_iterator<NT,AT,const NT&,const NT*> to = arc_to(output(from, arc));
      if (find(result.begin(), result.end(), to) == result.end())
        result.push_back(to);
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::node_vector digraph<NT,AT>::output_adjacencies(TYPENAME digraph<NT,AT>::iterator from)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_nodes(output_adjacencies(from.constify()));
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Topographical Sort Algorithms

  template<typename NT, typename AT>
  std::pair<TYPENAME digraph<NT,AT>::const_node_vector, TYPENAME digraph<NT,AT>::const_arc_vector>
  digraph<NT,AT>::sort(TYPENAME digraph<NT,AT>::arc_select_fn select) const
  {
    std::vector<digraph_iterator<NT,AT,const NT&,const NT*> > result;
    std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > errors;
    // build a map containing the number of fanins to each node that must be visited before this one
    std::map<digraph_iterator<NT,AT,const NT&,const NT*>,unsigned> fanin_map;
    for (digraph_iterator<NT,AT,const NT&,const NT*> n = begin(); n != end(); n++)
    {
      unsigned predecessors = 0;
      // only count predecessors connected by selected arcs
      for (unsigned f = 0; f < fanin(n); f++)
      {
        digraph_arc_iterator<NT,AT, const AT&,const AT*> input_arc = input(n,f);
        digraph_iterator<NT,AT,const NT&,const NT*> predecessor = arc_from(input_arc);
        if (!select || select(*this,input_arc))
          predecessors++;
      }
      if (predecessors == 0)
      {
        result.push_back(n);
      }
      else
      {
        fanin_map[n] = predecessors;
      }
    }
    // main algorithm applies the topographical sort repeatedly. For a DAG, it
    // will complete first time. However, with backward arcs, the first
    // iteration will fail. The algorithm then tries breaking random arcs to try
    // to get an ordering.
    for(unsigned i = 0; !fanin_map.empty(); )
    {
      // now visit each node in traversal order, decrementing the fanin count of
      // all successors. As each successor's fanin count goes to zero, it is
      // appended to the result.
      for (; i < result.size(); i++)
      {
        // Note: dereferencing gives us a node iterator
        digraph_iterator<NT,AT,const NT&,const NT*> current = result[i];
        for (unsigned f = 0; f < fanout(current); f++)
        {
          // only consider successors connected by selected arcs
          digraph_arc_iterator<NT,AT, const AT&,const AT*> output_arc = output(current, f);
          digraph_iterator<NT,AT,const NT&,const NT*> successor = arc_to(output_arc);
          if (!select || select(*this,output_arc))
          {
            // don't consider arcs that have been eliminated to break a loop
            if (fanin_map.find(successor) != fanin_map.end())
            {
              --fanin_map[successor];
              if ((fanin_map[successor]) == 0)
              {
                result.push_back(successor);
                fanin_map.erase(fanin_map.find(successor));
              }
            }
          }
        }
      }
      if (!fanin_map.empty())
      {
        // there must be backward arcs preventing completion
        // try removing arcs from the sort to get a partial ordering containing all the nodes

        // select an arc that is still relevant to the sort and break it
        // first select a node that has non-zero fanin and its predecessor that has non-zero fanin
        digraph_iterator<NT,AT,const NT&,const NT*> stuck_node = fanin_map.begin()->first;
        for (unsigned f = 0; f < fanin(stuck_node); f++)
        {
          // now successively remove input arcs that are still part of the sort until the fanin reduces to zero
          // first find a relevant arc - this must be a selected arc that has not yet been traversed by the first half of the algorithm
          digraph_arc_iterator<NT,AT, const AT&,const AT*> input_arc = input(stuck_node, f);
          if (!select || select(*this,input_arc))
          {
            digraph_iterator<NT,AT,const NT&,const NT*> predecessor = arc_from(input_arc);
            if (fanin_map.find(predecessor) != fanin_map.end())
            {
              // found the right combination - remove this arc and then drop out of the fanin loop to restart the outer sort loop
              errors.push_back(input_arc);
              --fanin_map[stuck_node];
              if ((fanin_map[stuck_node]) == 0)
              {
                result.push_back(stuck_node);
                fanin_map.erase(fanin_map.find(stuck_node));
                break;
              }
            }
          }
        }
      }
    }
    return std::make_pair(result,errors);
  }

  template<typename NT, typename AT>
  std::pair<TYPENAME digraph<NT,AT>::node_vector, TYPENAME digraph<NT,AT>::arc_vector>
  digraph<NT,AT>::sort(TYPENAME digraph<NT,AT>::arc_select_fn select)
  {
    std::pair<std::vector<digraph_iterator<NT,AT,const NT&,const NT*> >,
              std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > > const_result =
      const_cast<const digraph<NT,AT>*>(this)->sort(select);

    std::pair<std::vector<digraph_iterator<NT,AT,NT&,NT*> >,
              std::vector<digraph_arc_iterator<NT,AT,AT&,AT*> > > result =
      std::make_pair(deconstify_nodes(const_result.first),deconstify_arcs(const_result.second));
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_node_vector digraph<NT,AT>::dag_sort(TYPENAME digraph<NT,AT>::arc_select_fn select) const
  {
    std::pair<std::vector<digraph_iterator<NT,AT,const NT&,const NT*> >,
              std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > > result = sort(select);
    if (result.second.empty()) return result.first;
    return std::vector<digraph_iterator<NT,AT,const NT&,const NT*> >();
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::node_vector digraph<NT,AT>::dag_sort(TYPENAME digraph<NT,AT>::arc_select_fn select)
  {
    return deconstify_nodes(const_cast<const digraph<NT,AT>*>(this)->dag_sort(select));
  }
  ////////////////////////////////////////////////////////////////////////////////
  // Path Algorithms

  template<typename NT, typename AT>
  bool digraph<NT,AT>::path_exists_r(TYPENAME digraph<NT,AT>::const_iterator from,
                                     TYPENAME digraph<NT,AT>::const_iterator to,
                                     TYPENAME digraph<NT,AT>::const_iterator_set& visited,
                                     TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // Recursive part of the digraph::path_exists function. This is based on a
    // depth first search algorithm and stops the moment it finds a path
    // regardless of its length. Simply traverse every output and recurse on that
    // node until we find the to node or run out of things to recurse on. However,
    // to avoid infinite recursion due to cycles in the graph, I need to maintain
    // a set of visited nodes. The visited set is updated when a candidate is
    // found but tested before the recursion on the candidate so that the number of
    // function calls is minimised.

    // if the current node is the target, we have found a path so return immediately
    // exclude the case where we're looking for a path from a node to itself unless at least one arc has been followed
    if ((visited.size() > 0) && (from == to)) return true;
    // update the visited set
    // if the insert fails, that indicates that the node has already been visited so don't recurse on the fanout
    if (!(visited.insert(from).second)) return false;
    // now visit all of the fanout arcs of the current node to see if any of them complete a path
    for (unsigned i = 0; i < fanout(from); i++)
    {
      digraph_arc_iterator<NT,AT, const AT&,const AT*> arc = output(from,i);
      // allow the optional select filter to choose whether this arc should be considered as part of a path
      if (!select || select(*this, arc))
      {
        // now recurse - a path exists from from to to if a path exists from an adjacent node to to
        if (path_exists_r(arc_to(arc),to,visited,select)) return true;
      }
    }
    return false;
  }

  template<typename NT, typename AT>
  bool digraph<NT,AT>::path_exists(TYPENAME digraph<NT,AT>::const_iterator from,
                                   TYPENAME digraph<NT,AT>::const_iterator to, 
                                   TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // set up the recursion with its initial visited set and then recurse
    std::set<digraph_iterator<NT,AT,const NT&,const NT*> > visited;
    return path_exists_r(from, to, visited, select);
  }

  template<typename NT, typename AT>
  bool digraph<NT,AT>::path_exists(TYPENAME digraph<NT,AT>::iterator from,
                                   TYPENAME digraph<NT,AT>::iterator to,
                                   TYPENAME digraph<NT,AT>::arc_select_fn select)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return path_exists(from.constify(), to.constify(), select);
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::all_paths_r(TYPENAME digraph<NT,AT>::const_iterator from,
                                   TYPENAME digraph<NT,AT>::const_iterator to,
                                   TYPENAME digraph<NT,AT>::const_arc_vector& so_far,
                                   TYPENAME digraph<NT,AT>::const_path_vector& result,
                                   TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // This is the recursive part of the all_paths function. The field so_far
    // contains the path so far so that when 'to' is reached, the path is
    // complete. It serves the same purpose as the visited set in the path_exists
    // function except that it also preserves the path order. It also serves the
    // purpose of detecting cycles and thus stopping infinite recursion. Every
    // time the recursion reaches the to node, a copy of so_far is appended to the
    // path set.
    for (unsigned i = 0; i < fanout(from); i++)
    {
      digraph_arc_iterator<NT,AT, const AT&,const AT*> candidate = output(from,i);
      // test whether the arc is selected and then check that the candidate has not
      // been visited already on this path and only allow further recursion if it hasn't
      // this eliminates recursion loops
      if ((!select || select(*this, candidate)) && std::find(so_far.begin(), so_far.end(), candidate) == so_far.end())
      {
        // extend the path tracing the route to this arc
        so_far.push_back(candidate);
        // if the candidate arc points to the target, update the result set and prevent further recursion, otherwise recurse
        if (arc_to(candidate) == to)
          result.push_back(so_far);
        else
          all_paths_r(arc_to(candidate),to,so_far,result,select);
        so_far.pop_back();
      }
    }
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_path_vector 
  digraph<NT,AT>::all_paths(TYPENAME digraph<NT,AT>::const_iterator from, 
                            TYPENAME digraph<NT,AT>::const_iterator to,
                            TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // set up the recursion with empty data fields and then recurse
    TYPENAME digraph<NT,AT>::const_path_vector result;
    TYPENAME digraph<NT,AT>::const_arc_vector so_far;
    all_paths_r(from, to, so_far, result, select);
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::path_vector
  digraph<NT,AT>::all_paths(TYPENAME digraph<NT,AT>::iterator from, 
                            TYPENAME digraph<NT,AT>::iterator to,
                            TYPENAME digraph<NT,AT>::arc_select_fn select)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_paths(all_paths(from.constify(), to.constify(), select));
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::reachable_nodes_r(TYPENAME digraph<NT,AT>::const_iterator from,
                                         TYPENAME digraph<NT,AT>::const_iterator_set& visited,
                                         TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // The recursive part of the reachable_nodes function.
    // This is a depth-first traversal again but this time it carries on to find all the reachable nodes
    // Just keep recursing on all the adjacent nodes of each node, skipping already visited nodes to avoid cycles
    for (unsigned i = 0; i < fanout(from); i++)
    {
      digraph_arc_iterator<NT,AT, const AT&,const AT*> arc = output(from,i);
      if (!select || select(*this,arc))
      {
        digraph_iterator<NT,AT,const NT&,const NT*> candidate = arc_to(arc);
        if (visited.insert(candidate).second)
          reachable_nodes_r(candidate,visited,select);
      }
    }
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_node_vector
  digraph<NT,AT>::reachable_nodes(TYPENAME digraph<NT,AT>::const_iterator from,
                                  TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // seed the recursion, marking the starting node as already visited
    TYPENAME digraph<NT,AT>::const_iterator_set visited;
    visited.insert(from);
    reachable_nodes_r(from, visited, select);
    // convert the visited set into the required output form
    // exclude the starting node
    TYPENAME digraph<NT,AT>::const_node_vector result;
    for (TYPENAME digraph<NT,AT>::const_iterator_set::iterator i = visited.begin(); i != visited.end(); i++)
      if (*i != from)
        result.push_back(*i);
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::node_vector
  digraph<NT,AT>::reachable_nodes(TYPENAME digraph<NT,AT>::iterator from,
                                  TYPENAME digraph<NT,AT>::arc_select_fn select)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_nodes(reachable_nodes(from.constify(), select));
  }

  template<typename NT, typename AT>
  void digraph<NT,AT>::reaching_nodes_r(TYPENAME digraph<NT,AT>::const_iterator to,
                                        TYPENAME digraph<NT,AT>::const_iterator_set& visited,
                                        TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // The recursive part of the reaching_nodes function.
    // Just like the reachable_nodes_r function but it goes backwards
    for (unsigned i = 0; i < fanin(to); i++)
    {
      digraph_arc_iterator<NT,AT, const AT&,const AT*> arc = input(to,i);
      if (!select || select(*this,arc))
      {
        digraph_iterator<NT,AT,const NT&,const NT*> candidate = arc_from(input(to,i));
        if (visited.insert(candidate).second)
          reaching_nodes_r(candidate,visited,select);
      }
    }
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_node_vector
  digraph<NT,AT>::reaching_nodes(TYPENAME digraph<NT,AT>::const_iterator to,
                                 TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    // seed the recursion, marking the starting node as already visited
    std::set<digraph_iterator<NT,AT,const NT&,const NT*> > visited;
    visited.insert(to);
    reaching_nodes_r(to,visited,select);
    // convert the visited set into the required output form
    // exclude the end node
    std::vector<digraph_iterator<NT,AT,const NT&,const NT*> > result;
    for (TYPENAME std::set<digraph_iterator<NT,AT,const NT&,const NT*> >::iterator i = visited.begin(); i != visited.end(); i++)
      if (*i != to)
        result.push_back(*i);
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::node_vector
  digraph<NT,AT>::reaching_nodes(TYPENAME digraph<NT,AT>::iterator to,
                                 TYPENAME digraph<NT,AT>::arc_select_fn select)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_nodes(reaching_nodes(to.constify(),select));
  }

  ////////////////////////////////////////////////////////////////////////////////
  // Shortest Path Algorithms

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_arc_vector
  digraph<NT,AT>::shortest_path(TYPENAME digraph<NT,AT>::const_iterator from,
                                TYPENAME digraph<NT,AT>::const_iterator to,
                                TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    std::vector<std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > > paths = all_paths(from,to,select);
    std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > shortest;
    for (TYPENAME std::vector<std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > >::iterator i = paths.begin(); i != paths.end(); i++)
      if (shortest.empty() || i->size() < shortest.size())
        shortest = *i;
    return shortest;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::arc_vector
  digraph<NT,AT>::shortest_path(TYPENAME digraph<NT,AT>::iterator from, 
                                TYPENAME digraph<NT,AT>::iterator to,
                                TYPENAME digraph<NT,AT>::arc_select_fn select)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_arcs(shortest_path(from.constify(),to.constify(),select));
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::const_path_vector
  digraph<NT,AT>::shortest_paths(TYPENAME digraph<NT,AT>::const_iterator from,
                                 TYPENAME digraph<NT,AT>::arc_select_fn select) const
    throw(wrong_object,null_dereference,end_dereference)
  {
    from.assert_valid(this);
    // This is an unweighted shortest path algorithm based on the algorithm from
    // Weiss's book. This is essentially a breadth-first traversal or graph
    // colouring algorithm. It is an iterative algorithm, so no recursion here! It
    // works by creating a node queue initialised with the starting node. It then
    // consumes the queue from front to back. For each node, it finds the
    // successors and appends them to the queue. If a node is already 'known' it
    // is not added - this avoids cycles. Thus the queue insert ordering
    // represents the breadth-first ordering. On the way it creates a map of
    // visited nodes. This is a map not a set because it also stores the arc that
    // nominated this node as a shortest path. The full path can then be recreated
    // from the map by just walking back through the predecessors. The depth (or
    // colour) can be determined by the path length.
    std::vector<std::vector<digraph_arc_iterator<NT,AT,const AT&,const AT*> > > result;
    // initialise the iteration by creating a queue and adding the start node
    std::deque<digraph_iterator<NT,AT,const NT&,const NT*> > nodes;
    nodes.push_back(from);
    // Create a map to store the set of known nodes mapped to their predecessor
    // arcs. Initialise it with the current node, which has no predecessor. Note
    // that the algorithm uses the feature of digraph iterators that they can be
    // null iterators and that all null iterators are equal.
    typedef std::map<digraph_iterator<NT,AT,const NT&,const NT*>,
                     digraph_arc_iterator<NT,AT,const AT&,const AT*> > known_map;
    known_map known;
    known.insert(std::make_pair(from,digraph_arc_iterator<NT,AT, const AT&,const AT*>()));
    // now the iterative part of the algorithm
    while(!nodes.empty())
    {
      // pop the queue to get the next node to process - unfortunately the STL
      // deque::pop does not return the popped value
      digraph_iterator<NT,AT,const NT&,const NT*> current = nodes.front();
      nodes.pop_front();
      // now visit all the successors
      for (unsigned i = 0; i < fanout(current); i++)
      {
        digraph_arc_iterator<NT,AT, const AT&,const AT*> next_arc = output(current,i);
        // assert_valid whether the successor arc is a selected arc and can be part of a path
        if (!select || select(*this,next_arc))
        {
          digraph_iterator<NT,AT,const NT&,const NT*> next = arc_to(next_arc);
          // Discard any successors that are known because to be known already they
          // must have another shorter path. Otherwise add the successor node to the
          // queue to be visited later. To minimise the overhead of map lookup I use
          // the usual trick of trying to insert the node and determining whether
          // the node was known by the success or failure of the insertion - this is
          // a Good STL Trick (TM).
          if (known.insert(std::make_pair(next,next_arc)).second)
            nodes.push_back(next);
        }
      }
    }
    // The map contains the results as an unordered set of nodes, mapped to their
    // predecessor arcs and weight. This now needs to be converted into a set of
    // paths. This is done by starting with a node from the map, finding its
    // predecessor arc and therefore its predecessor node, looking that up in the
    // map to find its predecessor and so on until the start node is reached (it
    // has a null predecessor). Note that the known set includes the from node
    // which does not generate a path.
    for (TYPENAME known_map::iterator i = known.begin(); i != known.end(); i++)
    {
      if (i->first != from)
      {
        const_arc_vector this_path;
        for (TYPENAME known_map::iterator node = i; 
             node->second.valid(); 
             node = known.find(arc_from(node->second)))
          this_path.insert(this_path.begin(),node->second);
        result.push_back(this_path);
      }
    }
    return result;
  }

  template<typename NT, typename AT>
  TYPENAME digraph<NT,AT>::path_vector
  digraph<NT,AT>::shortest_paths(TYPENAME digraph<NT,AT>::iterator from,
                                 TYPENAME digraph<NT,AT>::arc_select_fn select)
    throw(wrong_object,null_dereference,end_dereference)
  {
    return deconstify_paths(shortest_paths(from.constify(),select));
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
