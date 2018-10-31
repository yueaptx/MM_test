#ifndef DDOBJECT_H
#define DDOBJECT_H

#include "GeneralUserObject.h"
//#include "LoopNetworkTest.h"
#include "DislocationNetwork.h"

//Forward Declarations
class DDObject;

template<>
InputParameters validParams<DDObject>();

class DDObject : public GeneralUserObject
{
public:
	DDObject(const InputParameters & parameters);

 	virtual void initialSetup();
	virtual void residualSetup() {}
	virtual void timestepSetup() {}

	virtual void initialize();
	virtual void execute();
	virtual void finalize(){}

	const Real PI = std::acos(-1);
    
    // Create the network
    //model::DislocationNetwork<3,0,model::Hermite> DN;
    // Create the loops
    std::vector<size_t> loop0;
    // Returns a reference to the network
    // model::Dnetwork & getNetwork(){return DN;}

    std::vector<Point> getLoopNodes() const {return loopNodes;}

    std::vector<Number> getNodalClimbVelocity() const {return nodalClimbVelocity;}

    /* argc & argv*/
    int argc = 1;
    char a = '.';
    char b = '-';
    char c = 'D';
    std::vector<char *> argVec = {&a};
    char ** argv = &argVec[0];
    
protected:
    // Pointer to the EquationSystem object
    System * _sys;
    // Pointer to the MooseVariable
    MooseVariable * _var_c;
    // Vector of variable names
    std::vector<VariableName> _stressCompName;
    // Vector of nodes in one loop
    std::vector<Point> loopNodes;
    // Vector of velocity magnitude on nodes
    std::vector<Number> nodalClimbVelocity;

    // Constants
    Real _diffusivity;
    Real _Uvd;
    Real _Uvf; //[eV], vacancy formation energy
    const Real _kB;
    const Real _eV2J;
    const Real _Omega;
    Real _T;
    Real _Dv;
    const Real _burgers;
    Real _c0; // equilibrium concentation in defect-free crystal
    model::DislocationNetwork<3,0,model::Hermite> DN;
};


#endif // DDOBJECT_H
