[GlobalParams]
  family = MONOMIAL # for the stress tensor
  order = CONSTANT
  displacements = 'disp_x disp_y disp_z'
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
  file = './mesh/block_structured1.msh'
  # The MultiAppInterpolationTransfer object only works with ReplicatedMesh
  parallel_type = replicated
  displacements = 'disp_x disp_y disp_z'
  #second_order = true
[]

[AuxVariables]
#  [./c_fromMaster]
#    family = LAGRANGE
#    order = FIRST
#  [../]
  [./stress_xx]
  [../]
  [./stress_xy]
  [../]
  [./stress_xz]
  [../]
  [./stress_yx]
  [../]
  [./stress_yy]
  [../]
  [./stress_yz]
  [../]
  [./stress_zx]
  [../]
  [./stress_zy]
  [../]
  [./stress_zz]
  [../]
[]

[Modules/TensorMechanics/Master]
  [./block1]
    strain = SMALL #Small linearized strain, automatically set to XY coordinates
    add_variables = true #Add the variables from the displacement string in GlobalParams
    #displacements = 'disp_x disp_y disp_z'
    #generate_output = 'stress_xx stress_xy stress_xz
		#                   stress_yx stress_yy stress_yz
 		#                   stress_zx stress_zy stress_zz' #automatically creates the auxvariables and auxkernels
                                                      #needed to output these stress quanities
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    variable = stress_xx
    rank_two_tensor = stress
    index_i = 0
    index_j = 0
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    variable = stress_xy
    rank_two_tensor = stress
    index_i = 0
    index_j = 1
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_xz]
    type = RankTwoAux
    variable = stress_xz
    rank_two_tensor = stress
    index_i = 0
    index_j = 2
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_yx]
    type = RankTwoAux
    variable = stress_yx
    rank_two_tensor = stress
    index_i = 1
    index_j = 0
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_yy]
    type = RankTwoAux
    variable = stress_yy
    rank_two_tensor = stress
    index_i = 1
    index_j = 1
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_yz]
    type = RankTwoAux
    variable = stress_yz
    rank_two_tensor = stress
    index_i = 1
    index_j = 2
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_zx]
    type = RankTwoAux
    variable = stress_zx
    rank_two_tensor = stress
    index_i = 2
    index_j = 0
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_zy]
    type = RankTwoAux
    variable = stress_zy
    rank_two_tensor = stress
    index_i = 2
    index_j = 1
    execute_on = timestep_end
    #block = 0
  [../]
  [./stress_zz]
    type = RankTwoAux
    variable = stress_zz
    rank_two_tensor = stress
    index_i = 2
    index_j = 2
    execute_on = timestep_end
    #block = 0
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 71e9
    poissons_ratio = 0.345
  [../]
  [./stress]
    type = ComputeLinearElasticStress
  [../]
[]

[BCs]
  [./backx]
    type = PresetBC
    variable = disp_x
    boundary = back
    value = 0.0
  [../]
  [./backy]
    type = PresetBC
    variable = disp_y
    boundary = back
    value = 0.0
  [../]
  [./backz]
    type = PresetBC
    variable = disp_z
    boundary = back
    value = 0.0
  [../]
  [./front]
    type = FunctionPresetBC
    variable = disp_z
    boundary = front
    function = '1e-5*t'
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  #type = Steady
  type = Transient
  #end_time = 5e-5            # the simulation will end at t=5
  num_steps = 10
  dt = 1e-4
  solve_type = 'PJFNK'
  #solve_type = 'NEWTON'

  petsc_options = -snes_ksp_ew
  petsc_options_iname = '-pc_type -sub_pc_type -pc_asm_overlap -ksp_gmres_restart'
  petsc_options_value = 'asm lu 1 101'
[]

[Outputs]
  exodus = true
  perf_graph = true
  #csv = true
[]

[MultiApps]
  [./modelib]
    type = TransientMultiApp
    execute_on = timestep_end
    positions = '0 0 0'
    input_files = 'DD_transient.i'
    sub_cycling = true
    output_sub_cycles = true
    output_in_position = true
  [../]
[]

[Transfers]
  [./tosub]
    #type =MultiAppCopyTransfer
    type =MultiAppMeshFunctionTransfer
    direction = to_multiapp
    multi_app = modelib
    source_variable = '
				               stress_xx stress_xy stress_xz
				               stress_yx stress_yy stress_yz
			      	         stress_zx stress_zy stress_zz'
    variable = '
			          stress_xx_from stress_xy_from stress_xz_from
			          stress_yx_from stress_yy_from stress_yz_from
			          stress_zx_from stress_zy_from stress_zz_from'
    execute_on = SAME_AS_MULTIAPP
  [../]
[]
