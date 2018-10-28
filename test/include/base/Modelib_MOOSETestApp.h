//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef MODELIB_MOOSETESTAPP_H
#define MODELIB_MOOSETESTAPP_H

#include "MooseApp.h"

class Modelib_MOOSETestApp;

template <>
InputParameters validParams<Modelib_MOOSETestApp>();

class Modelib_MOOSETestApp : public MooseApp
{
public:
  Modelib_MOOSETestApp(InputParameters parameters);
  virtual ~Modelib_MOOSETestApp();

  static void registerApps();
  static void registerAll(Factory & f, ActionFactory & af, Syntax & s, bool use_test_objs = false);
};

#endif /* MODELIB_MOOSETESTAPP_H */
