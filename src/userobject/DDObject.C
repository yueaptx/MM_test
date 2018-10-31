//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "DDObject.h"

// MOOSE includes

registerMooseObject("Modelib_MOOSEApp", DDObject);

template <>
InputParameters validParams<DDObject>()

{
  InputParameters params = validParams<GeneralUserObject>();
  params.addParam<Real>("diffusivity", 1.18e-5, "[m^2/s], diffusion coefficient pre-exponential");
  params.addParam<Real>("Uvd", "[eV], vacancy migration energy");
  params.addParam<Real>("Uvf", "[eV], vacancy formation energy");
  params.addParam<Real>("kB", 1.3806e-23 ,"m^2kg/s^2/K], Boltzmann constant");
  params.addParam<Real>("eV2J", 1.60218e-19 ,"[J/eV], convert eV to Joules");
  params.addParam<Real>("Omega", "[m^3], atomic volume");
  params.addParam<Real>("T", "[K], temperature");
  params.addParam<Real>("burgers", "[m], burger's vector magnitude");
  /*
  // Since we are inheriting from a Postprocessor we override this to make sure
  // That MOOSE (and Peacock) know that this object is _actually_ a UserObject
  params.set<std::string>("built_by_action") = "add_user_object";
  */
  return params;
}

DDObject::DDObject(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    //loop0({0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19}),
    _sys(NULL),
    _var_c(NULL),
    // Set our member scalar value from InputParameters (read from the input file)
    _diffusivity(getParam<Real>("diffusivity")),
    _Uvd(getParam<Real>("Uvd")),
    _Uvf(getParam<Real>("Uvf")),
    _kB(getParam<Real>("kB")),
    _eV2J(getParam<Real>("eV2J")),
    _Omega(getParam<Real>("Omega")),
    _T(getParam<Real>("T")),
    _Dv(_diffusivity * exp(- _Uvd * _eV2J / _kB / _T)),
    _burgers(getParam<Real>("burgers")),
    _c0(exp(- _Uvf * _eV2J / _kB / _T)),
    DN(argc,argv)
{
}


void
DDObject::initialSetup()
{
  /*
  Empty the node vectors
  */
  loopNodes = {};
  loop0 = {};

  using namespace model;
  // Create the nodes
  int nNodes = 20;
  for (int i=0; i<nNodes; ++i)
  {
    loop0.push_back(i);
  }

  /*
  insert the loop nodes
  */
  double loopRadius = 5e-7;
  for (int i = 0; i < nNodes; i++)
  {
  	Point temp(loopRadius * std::cos(2*PI/nNodes*i), loopRadius * -std::sin(2*PI/nNodes*i),0);
  	loopNodes.push_back(temp);
  }
}

void
DDObject::initialize()
{
//std::cout << "The DDObject is initialized!" << std::endl;
}

void
DDObject::execute()
{
    // Empty the velocity vector
    nodalClimbVelocity = {};
    
    // Run the DDD code
    DN.runSteps();
    
    std::cout << "The DDObject is executed!" << std::endl;
}
