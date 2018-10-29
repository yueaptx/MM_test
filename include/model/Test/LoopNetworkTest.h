/* This file is part of MODEL, the Mechanics Of Defect Evolution Library.
 *
 * Copyright (C) 2011 by Giacomo Po <gpo@ucla.edu>.
 *
 * model is distributed without any warranty under the
 * GNU General Public License (GPL) v2 <http://www.gnu.org/licenses/>.
 */

#include <iostream>

#include <Eigen/Dense>
#include "TypeTraits.h"
#include "StaticID.h"


namespace model
{
    struct Dnetwork;
    struct Dnode;
//    struct DLnode;
    struct Dlink;
    struct Dloop;
    
    template<>
    struct TypeTraits<Dnetwork>
    {
        typedef Dnetwork LoopNetworkType;
        typedef Dnode  NodeType;
//        typedef DLnode LoopNodeType;
        typedef Dlink LinkType;
        typedef Dloop LoopType;
        typedef double FlowType;
        
        static constexpr FlowType zeroFlow=0.0;
    };
    
    template<>
    struct TypeTraits<Dnode> : public TypeTraits<Dnetwork>
    {
        
    };
    
    template<>
    struct TypeTraits<Dlink> : public TypeTraits<Dnetwork>
    {
        
    };
    
    template<>
    struct TypeTraits<Dloop> : public TypeTraits<Dnetwork>
    {
        
    };
    
//    template<>
//    struct TypeTraits<DLnode> : public TypeTraits<Dnetwork>
//    {
//        
//    };
}




#include "LoopNetwork.h"


namespace model
{
    struct Dnetwork : public LoopNetwork<Dnetwork>
    {
	~Dnetwork()
	{
	std::cout <<"Destroying Dnetwork" <<std::endl;	
	}
    };
    
    struct Dnode : public LoopNode<Dnode>
    {
    
        Dnode(Dnetwork* const net) :
        /* init */LoopNode<Dnode>(net)
        {
            
        }
        
	~Dnode()
	{
	std::cout<<"Destroying Dnode "<<this->sID<<std::endl;
	}
  
    };


    struct Dlink : public NetworkLink<Dlink>
    {
    
        Dlink(const std::shared_ptr<Dnode>& Ni,
              const std::shared_ptr<Dnode>& Nj) : NetworkLink<Dlink>(Ni,Nj){}
	~Dlink()
	{
	std::cout<<"Destroying Dlink "<<this->sID<<std::endl;
	}
  
        
    };
    
    
    struct Dloop : public Loop<Dloop>
    {
    
        Dloop(Dnetwork* const net, const double& flow) : Loop<Dloop>(net,flow){}
	~Dloop()
	{
	std::cout<<"Destroying Dloop "<<this->sID<<std::endl;
	}
  
    };


}


