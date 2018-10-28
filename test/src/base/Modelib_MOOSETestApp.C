//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "Modelib_MOOSETestApp.h"
#include "Modelib_MOOSEApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<Modelib_MOOSETestApp>()
{
  InputParameters params = validParams<Modelib_MOOSEApp>();
  return params;
}

Modelib_MOOSETestApp::Modelib_MOOSETestApp(InputParameters parameters) : MooseApp(parameters)
{
  Modelib_MOOSETestApp::registerAll(
      _factory, _action_factory, _syntax, getParam<bool>("allow_test_objects"));
}

Modelib_MOOSETestApp::~Modelib_MOOSETestApp() {}

void
Modelib_MOOSETestApp::registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs)
{
  Modelib_MOOSEApp::registerAll(f, af, s);
  if (use_test_objs)
  {
    Registry::registerObjectsTo(f, {"Modelib_MOOSETestApp"});
    Registry::registerActionsTo(af, {"Modelib_MOOSETestApp"});
  }
}

void
Modelib_MOOSETestApp::registerApps()
{
  registerApp(Modelib_MOOSEApp);
  registerApp(Modelib_MOOSETestApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
Modelib_MOOSETestApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  Modelib_MOOSETestApp::registerAll(f, af, s);
}
extern "C" void
Modelib_MOOSETestApp__registerApps()
{
  Modelib_MOOSETestApp::registerApps();
}
