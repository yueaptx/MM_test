//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef MODELIB_MOOSEAPP_H
#define MODELIB_MOOSEAPP_H

#include "MooseApp.h"

class Modelib_MOOSEApp;

template <>
InputParameters validParams<Modelib_MOOSEApp>();

class Modelib_MOOSEApp : public MooseApp
{
public:
  Modelib_MOOSEApp(InputParameters parameters);
  virtual ~Modelib_MOOSEApp();

  static void registerApps();
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s);
};

#endif /* MODELIB_MOOSEAPP_H */
