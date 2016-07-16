////////////////////////////////////////////////////////////////////////////////

//   Author:    Andy Rushton
//   Copyright: (c) Southampton University 1999-2004
//              (c) Andy Rushton           2004 onwards
//   License:   BSD License, see ../docs/license.html

////////////////////////////////////////////////////////////////////////////////
#include "persistent_int.hpp"
#include "persistent_xref.hpp"

namespace stlplus
{
  ////////////////////////////////////////////////////////////////////////////////

  template<typename NT, typename AT, typename DN, typename DA>
  void dump_digraph(dump_context& context, const digraph<NT,AT>& data,
                    DN dump_node, DA dump_arc)
    throw(persistent_dump_failed)
  {
    // dump a magic key to the address of the graph for use in persistence of iterators
    // and register it as a dumped address
    std::pair<bool,unsigned> mapping = context.object_map(&data);
    if (mapping.first) throw persistent_dump_failed("digraph: already dumped this graph");
    dump_unsigned(context,mapping.second);
    // dump the nodes
    dump_unsigned(context,data.size());
    for (typename digraph<NT,AT>::const_iterator node = data.begin(); node != data.end(); node++)
    {
      // nodes are keyed by the magic key to the node address
      // this key is then used in dumping the arc from/to pointers
      std::pair<bool,unsigned> node_mapping = context.pointer_map(node.node());
      if (node_mapping.first) throw persistent_dump_failed("digraph: already dumped this node");
      dump_unsigned(context,node_mapping.second);
      // finally, dump the node contents
      dump_node(context,*node);
    }
    // dump the arcs
    dump_unsigned(context,data.arc_size());
    for (typename digraph<NT,AT>::const_arc_iterator arc = data.arc_begin(); arc != data.arc_end(); arc++)
    {
      // dump the magic key to the arc address
      // this is used by iterator persistence too
      std::pair<bool,unsigned> arc_mapping = context.pointer_map(arc.node());
      if (arc_mapping.first) throw persistent_dump_failed("digraph: already dumped this arc");
      dump_unsigned(context,arc_mapping.second);
      // now dump the from/to pointers as cross-references
      dump_xref(context,data.arc_from(arc).node());
      dump_xref(context,data.arc_to(arc).node());
      // now dump the arc's data
      dump_arc(context,*arc);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename NT, typename AT, typename RN, typename RA>
  void restore_digraph(restore_context& context, digraph<NT,AT>& data,
                       RN restore_node, RA restore_arc)
    throw(persistent_restore_failed)
  {
    data.clear();
    // restore the graph's magic key and map it onto the graph's address
    // this is used in the persistence of iterators
    unsigned magic = 0;
    restore_unsigned(context,magic);
    context.object_add(magic,&data);
    // restore the nodes
    unsigned nodes = 0;
    restore_unsigned(context, nodes);
    for (unsigned n = 0; n < nodes; n++)
    {
      unsigned node_magic = 0;
      restore_unsigned(context,node_magic);
      // create a new node and map the magic key onto the new address
      typename digraph<NT,AT>::iterator node = data.insert(NT());
      context.pointer_add(node_magic,node.node());
      // now restore the user's data
      restore_node(context,*node);
    }
    // restore the arcs
    unsigned arcs = 0;
    restore_unsigned(context, arcs);
    for (unsigned a = 0; a < arcs; a++)
    {
      unsigned arc_magic = 0;
      restore_unsigned(context,arc_magic);
      // restore the from and to cross-references
      digraph_node<NT,AT>* from = 0;
      digraph_node<NT,AT>* to = 0;
      restore_xref(context,from);
      restore_xref(context,to);
      // create an arc with these from/to pointers
      digraph_arc_iterator<NT,AT,AT&,AT*> arc = 
        data.arc_insert(digraph_iterator<NT,AT,NT&,NT*>(from), 
                        digraph_iterator<NT,AT,NT&,NT*>(to));
      context.pointer_add(arc_magic,arc.node());
      // restore the user data
      restore_arc(context,*arc);
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename NT, typename AT, typename NRef, typename NPtr>
  void dump_digraph_iterator(dump_context& context, 
                             const digraph_iterator<NT,AT,NRef,NPtr>& data)
    throw(persistent_dump_failed)
  {
    dump_object_xref(context,data.owner());
    dump_xref(context,data.node());
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  void restore_digraph_iterator(restore_context& context, 
                                digraph_iterator<NT,AT,NRef,NPtr>& data)
    throw(persistent_restore_failed)
  {
    digraph<NT,AT>* owner = 0;
    digraph_node<NT,AT>* node = 0;
    restore_object_xref(context,owner);
    restore_xref(context,node);
    data = digraph_iterator<NT,AT,NRef,NPtr>(node);
    data.assert_owner(owner);
  }

  ////////////////////////////////////////////////////////////////////////////////

  template<typename NT, typename AT, typename NRef, typename NPtr>
  void dump_digraph_arc_iterator(dump_context& context,
                                 const digraph_arc_iterator<NT,AT,NRef,NPtr>& data)
    throw(persistent_dump_failed)
  {
    dump_object_xref(context,data.owner());
    dump_xref(context,data.node());
  }

  template<typename NT, typename AT, typename NRef, typename NPtr>
  void restore_digraph_arc_iterator(restore_context& context, 
                                    digraph_arc_iterator<NT,AT,NRef,NPtr>& data)
    throw(persistent_restore_failed)
  {
    digraph<NT,AT>* owner = 0;
    digraph_arc<NT,AT>* arc = 0;
    restore_object_xref(context,owner);
    restore_xref(context,arc);
    data = digraph_arc_iterator<NT,AT,NRef,NPtr>(arc);
    data.assert_owner(owner);
  }

  ////////////////////////////////////////////////////////////////////////////////

} // end namespace stlplus
