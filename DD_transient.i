[GlobalParams]
  #displacements = 'disp_x disp_y disp_z'
  diffusivity = 1.18e-5 # [m^2/s], diffusion coefficient pre-exponential
  Uvd = 0.61   # [eV], vacancy migration energy
  Uvf = 0.67  # [eV], vacancy formation energy
  kB = 1.3806e-23  # [m^2kg/s^2/K], Boltzmann constant
  eV2J = 1.60218e-19   # [J/eV], convert eV to Joules
  Omega = 16.3e-30  # [m^3], atomic volume
  T = 600     # [K], temperature
  burgers = 0.28567e-9 # [m], burger's vector magnitude
  family = LAGRANGE # for the stress tensor
  order = FIRST
[]

[Mesh]
  # optionsl Type
  # type=<FileMesh | GeneratedMesh>
  # FileMesh
#  type = GeneratedMesh     # import mesh from file
#  dim = 3
#  xmin = -1e-6
#  xmax = 1e-6
#  ymin = -1e-6
#  ymax = 1e-6
#  zmin = -1e-6
#  zmax = 1e-6
#  nx = 8
#  ny = 8
#  nz = 8
#  elem_type = HEX8

  type = FileMesh
  file = './mesh/block.msh'
  # The MultiAppInterpolationTransfer object only works with ReplicatedMesh
  parallel_type = replicated
  #second_order = true
[]

[AuxVariables]
#  [./c_fromMaster]
#    family = LAGRANGE
#    order = FIRST
#  [../]
  [./stress_xx_from]
  [../]
  [./stress_xy_from]
  [../]
  [./stress_xz_from]
  [../]
  [./stress_yx_from]
  [../]
  [./stress_yy_from]
  [../]
  [./stress_yz_from]
  [../]
  [./stress_zx_from]
  [../]
  [./stress_zy_from]
  [../]
  [./stress_zz_from]
  [../]
[]

[Problem]
  type = DummyExternalProblem
[]

[UserObjects]
  [./dd]
    type = DDObject
    execute_on = timestep_end
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 10
  dt = 1e-4
[]

[Outputs]
  # execute_on = 'timestep_end'
   exodus = true # Output Exodus format
  # use_displaced_mesh = true
[]
