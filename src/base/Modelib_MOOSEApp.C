#include "Modelib_MOOSEApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<Modelib_MOOSEApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

Modelib_MOOSEApp::Modelib_MOOSEApp(InputParameters parameters) : MooseApp(parameters)
{
  Modelib_MOOSEApp::registerAll(_factory, _action_factory, _syntax);
}

Modelib_MOOSEApp::~Modelib_MOOSEApp() {}

void
Modelib_MOOSEApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"Modelib_MOOSEApp"});
  Registry::registerActionsTo(af, {"Modelib_MOOSEApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
Modelib_MOOSEApp::registerApps()
{
  registerApp(Modelib_MOOSEApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
Modelib_MOOSEApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  Modelib_MOOSEApp::registerAll(f, af, s);
}
extern "C" void
Modelib_MOOSEApp__registerApps()
{
  Modelib_MOOSEApp::registerApps();
}
