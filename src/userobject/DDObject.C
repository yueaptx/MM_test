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
    _DN(argc,argv),
    _sys_c(&_fe_problem.getSystem("c_fromMaster")),
    _var_c(&_fe_problem.getStandardVariable(0, "c_fromMaster")),
    _stressCompNames(_fe_problem.getVariableNames()),
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
    _c0(exp(- _Uvf * _eV2J / _kB / _T))
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
    
    _stressCompNames.erase(_stressCompNames.begin());     // remove the first element which is "c_master"
    for (const auto & _stressCompName : _stressCompNames)
    {
        _sys_sig.push_back(&_fe_problem.getSystem(_stressCompName));
        _var_sig.push_back(&_fe_problem.getStandardVariable(0, _stressCompName));
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
    _DN.runSteps();
    
    Eigen::Matrix<double, _dim, 1> p1 = {0,0,0};
    Point p2(p1(0,0), p1(1,0), p1(2,0));
    
    /*
     Read the data from MoDELib
     */
    Eigen::Matrix<double, _dim, _dim> stress = this->spatialValues(p1);
    std::cout << "The stress tensor from MoDELib is : unit[shear modulus]" << std::endl;
    for (int i = 0; i < _dim; i++)
    {
        for (int j = 0; j < _dim; j++)
        {
            std::cout << stress(i,j) << ", ";
        }
        std::cout << std::endl;
    }

    /*
     Read the data from MOOSE
    */
    Number c_field = _sys_c->point_value(_var_c->number(), p2, false);
    std::cout << "The concentration at Point " << p2 << " is " << c_field << std::endl;
    
    Eigen::Matrix<double, _dim, _dim> stress_MOOSE;
    std::cout << "The stress tensor from MOOSE at " << p2 << "is : unit[Pa]" << std::endl;
    for (int i = 0; i < _dim; i++)
    {
        for (int j = 0; j < _dim; j++)
        {
            stress_MOOSE(i, j) = _sys_sig[i * _dim + j]->point_value(_var_sig[i * _dim + j]->number(), p2, false);
            std::cout << stress_MOOSE(i, j) << ", ";
        }
        std::cout << std::endl;
    }
    
    
    std::cout << "The DDObject is executed!" << std::endl;
}

DDObject::stressMatrix
DDObject::spatialValues(const DDObject::pointVector & p)
{
    return _DN.extStressController.externalStress(p);
}
