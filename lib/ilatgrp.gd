#############################################################################
##
#W  ilatgrp.gd                 	XGAP library                  Max Neunhoeffer
##
#H  @(#)$Id: ilatgrp.gd,v 1.1 1998/11/27 14:50:53 ahulpke Exp $
##
#Y  Copyright 1998,       Max Neunhoeffer,              Aachen,       Germany
##
##  This file contains code to display a subgroup lattice interactively.
##
Revision.pkg_xgap_lib_ilatgrp_gd :=
    "@(#)$Id: ilatgrp.gd,v 1.1 1998/11/27 14:50:53 ahulpke Exp $";


#############################################################################
##
#I  Info class "GraphicLattice"
##
#############################################################################

DeclareInfoClass( "GraphicLattice" );
SetInfoLevel(GraphicLattice,1);  # we normally show our messages


#############################################################################
##
#P  KnowsAllLevels . . . . . . . . . . . . . . . whether all levels are known
##
## FIXME...
DeclareFilter( "KnowsAllLevels" );

#############################################################################
##
##
## FIXME...
#F  HasHasseProperty . . . . . . . . . . . . . . .  whether lattice has Hasse
DeclareFilter( "HasseProperty" );

#############################################################################
##
#F  CanCompareSubgroups  . . . . . . . . . . whether we can compare subgroups
##
## FIXME...
DeclareFilter( "CanCompareSubgroups");


#############################################################################
##
#O  GGLSylowSubgroup(<grp>)  . . . . . .  asks for prime, calls SylowSubgroup
##
##  This operation just asks for a prime by a little dialog and calls then
##  SylowSubgroup. Returns its result.
##
DeclareOperation( "GGLSylowSubgroup", [ IsGroup ] );


#############################################################################
##
#O  GGLEpimorphisms(<sheet>,<grp>) . . . pops up box to choose on which group
##
##  This operations brings up a text selector where one can choose several
##  types of groups to calculate epimorphisms onto.
##
DeclareOperation( "GGLEpimorphisms", [ IsGraphicSheet, IsGroup ] );


#############################################################################
##
#O  GGLPresentation(<sheet>,<grp>)  . . .  asks for presentation for subgroup
##
##  This operation makes a presentation for the group <grp> and returns a
##  short description of it.
##
DeclareOperation( "GGLPresentation", [ IsGraphicSheet, IsGroup ] );


#############################################################################
##
#O  GGLAbelianPQuotient(<sheet>,<grp>) . . . . . asks for p and calls library
##
##  This operation asks for a prime p and runs then the library operations
##  to calculate abelian prime quotients.
##
DeclareOperation( "GGLAbelianPQuotient", [ IsGraphicSheet, IsGroup ] );


#############################################################################
##
##  Constructors:  
##
#############################################################################
  

#############################################################################
##
#F  GGLMakeSubgroupsMenu( <sheet>, <config> ) . . . . .  makes subgroups menu
##
##  This function is used to generate a menu out of the configuration data.
##
DeclareGlobalFunction( "GGLMakeSubgroupsMenu" );


#############################################################################
##
#O  GraphicSubgroupLattice(<G>) . . . . displays subgroup lattice graphically
#O  GraphicSubgroupLattice(<G>,<def>)  . . . . . . . . . . same with defaults
##
##  Displays a graphic poset which shows (parts of) the subgroup lattice of
##  the group <group>. Normally only the whole group and the trivial group are
##  shown (behaviour of "InteractiveLattice" in xgap3). Returns a
##  IsGraphicSubgroupLattice object. Calls DecideSubgroupLatticeType. See
##  there for details.
##
if not IsBound(GraphicSubgroupLattice) then
  DeclareOperation( "GraphicSubgroupLattice", [ IsGroup ] );
  DeclareOperation( "GraphicSubgroupLattice", [ IsGroup, IsRecord ] );
fi;


#############################################################################
##
#O  DecideSubgroupLatticeType . . . . . . decides about the type of a lattice
##
##  This operation is called while creation of a new graphic subgroup lattice.
##  It has to decide about the type of the lattice. That means it has to
##  decide 5 questions:
##   1) Are all levels known right from the beginning?
##   2) Has the lattice the HasseProperty?
##   3) Can we test two subgroups for equality reasonably cheaply?
##   4) Shall we create a vertex for the trivial subgroup at the beginning?
##   5) What menu operations are possible?
##   6) What information is displayed on RightClick?
##  Returns a list. The first four entries are boolean values for  questions
##  1-4. Note that if the answer to 2 is true, then the answer to 3 must also
##  be true. The fifth and sixth entry are configuration lists as explained 
##  in the configuration section of "ilatgrp.gi" for menu operations and
##  info displays respectively.
DeclareOperation( "DecideSubgroupLatticeType", [ IsGroup ] );


#############################################################################
##
##  Methods for manipulating the poset:
##
#############################################################################


#############################################################################
##
#O  InsertVertex( <sheet>, <grp>, <hint> )  . . . . . . . . insert new vertex
##
##  Insert the group <grp> as a new vertex into the sheet. If 
##  CanCompareSubgroups is set for the lattice, we check, if the group is
##  already in the lattice or if we already have a conjugate subgroup.
##  If the lattice has the HasseProperty, then this new vertex is sorted 
##  into the poset. So we check for all vertices on higher levels, if
##  the new vertex is contained and for all vertices on lower levels,
##  if they are contained in the new vertex. We try then to add edges to
##  the appropriate vertices. If the lattice does not have the HasseProperty,
##  nothing is done with respect to the connections of any vertex.
##  Returns list with vertex as first entry and a flag as second, which 
##  says, if this vertex was inserted right now or has already been there.
##  <hint> is a list of x coordinates which should give some hint for the
##  choice of the new x coordinate. It can for example be the x coordinates
##  of those groups which were parameter for the operation which calculated
##  the group. <hints> can be empty but must always be a list!
##
DeclareOperation( "InsertVertex", [IsGraphicSheet, IsGroup, IsList] );


#############################################################################
##
#O  NewInclusionInfo( <sheet>, <v1>, <v2> ) . . . . . . . . . . v1 lies in v2
##
##  For graphic group lattices without the HasseProperty we cannot calculate
##  all inclusion information for each new vertex. This operation is the
##  proposed method to enter an inclusion information which normally comes
##  out of the process of subgroup calculation into the poset. It should
##  normally only be called if one conjectures or knows that v1 is a
##  maximal subobject with respect to the current poset, but the methods
##  for this operation first check, if there is already a way from v1 up
##  to v2. If this is the case, nothing is done. Otherwise we have to check,
##  if this new connection can be established: If v2 lies in a lower level
##  than v1 (of course those two levels are not comparable, so by definition
##  both subgroups must lie in a level of their own!) then, we try
##  to move the level of v1 into a new level right below that of v2. If 
##  that does not work we try to move the level of v2 right over the level
##  of v1. If that does not work check if we know that v2 is contained in v1
##  In this case we call MergeVertices. Otherwise we finally give up and 
##  display an info!
##  Now we draw the connection but have to make sure, that this new connection
##  does not close a circle such that there is an edge in the poset which
##  connects a vertex "below" v1 to a vertex "over" v2. Therefore we 
##  calculate all vertices lying "below" v1 and "over" v2 and disconnect
##  them pairwise. This is all done by means of posets and not by means
##  of groups. There are no group inclusion checks performed!
DeclareOperation( "NewInclusionInfo", 
                  [ IsGraphicSheet, IsGPVertex, IsGPVertex ] );


#############################################################################
##
#O  MergeVertices( <sheet>, <v1>, <v2> ) . . . . . . . . . . . merge vertices
##
##  For graphic group lattices without the HasseProperty we cannot calculate
##  all inclusion information for each new vertex. If we don't have
##  CanCompareSubgroups either, we have to think of the case where we have two
##  vertices to which belongs the same group respectively. If we come to
##  know this, then we have to fix this situation by merging vertices.
##  This operation does exactly this *without* further checks. The vertex
##  residing in a higher level or having a lower x-coordinate survives and
##  inherits all inclusion information the other has. The second one is
##  deleted.
DeclareOperation( "MergeVertices",
                  [ IsGraphicSheet, IsGPVertex, IsGPVertex ] );


#############################################################################
##
##  The following operations are menu functions for GraphicSubgroupLattices:
##
#############################################################################


#############################################################################
##
#O  GGLMenuOperation . . . . . . . . . . . . . . . .  is called from the menu
##
##  This operation is called for all so called "menu operations" the user
##  wants to perform on lattices. It is highly configurable with respect
##  to the input and output and the GAP-Operation which is actually performed
##  on the selected subgroups. See the configuration section in "ilatgrp.gi"
##  for an explanation.
##
DeclareOperation( "GGLMenuOperation", [ IsGraphicSheet, IsMenu, IsString ]);


############################################################################
##
#O  GGLUseBlackWhite . . . . . . . . . . . called if user selects bw in menu
##
##  This is called if the user selects "Use Black and White" in the menu.
##
DeclareOperation( "GGLUseBlackWhite", [ IsGraphicSheet, IsMenu, IsString ] );


############################################################################
##
#O  GGLRightClickPopup . . . . . . . . . . called if user does a right click
##
##  This is called if the user does a right click on a vertex or somewhere
##  else on the sheet. This operation is highly configurable with respect
##  to the Attributes of groups it can display/calculate. See the 
##  configuration section in "ilatgrp.gi" for an explanation.
##
DeclareOperation( "GGLRightClickPopup", 
                  [ IsGraphicSheet, IsGPVertex, IsInt, IsInt ] );

