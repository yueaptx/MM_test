/* This file is part of MODEL, the Mechanics Of Defect Evolution Library.
 *
 * Copyright (C) 2011 by Giacomo Po <gpo@ucla.edu>.
 *
 * model is distributed without any warranty under the
 * GNU General Public License (GPL) v2 <http://www.gnu.org/licenses/>.
 */

#ifndef model_MOOSEvalue_H_
#define model_MOOSEvalue_H_

namespace model
{
    
    template <int dim>
    class MOOSEvalues
    {
        
    public:
        typedef Eigen::Matrix<double, dim, dim> StressMatrixType;
        typedef Eigen::Matrix<double, dim, 1> pointVectorType;
        /*
         typedef Eigen::SparseMatrix<double> SparseMatrixType;
         
         const SimplicialMesh<dim>& mesh;
         size_t gSize;
         */
        // static bool apply_DD_displacement;
        static bool use_MOOSE;
        
        void setDDobject(std::vector<System *> MOOSE_sys_sig, std::vector<MooseVariable *> MOOSE_var_sig);
        
    private:
        StressMatrixType MOOSEstress;    // matrix of stress tensor
        std::vector<System *> _sys_sig;
        std::vector<MooseVariable *> _var_sig;
        
    public:
        
        /**********************************************************************/
        StressMatrixType stress(const Point P) const
        {
            StressMatrixType tempS;
            for (int i = 0; i < dim; i++)
            {
                for (int j = 0; j < dim; j++)
                {
                    tempS(i, j) = _sys_sig[i * dim + j]->point_value(_var_sig[i * dim + j]->number(), P, false)/161.0e9;
                    std::cout << tempS(i, j) << ", ";
                }
                std::cout << std::endl;
            }
            std::cout << std::endl;
            return tempS;
        }
        
    };
    
    
    template <int dim>
    bool MOOSEvalues<dim>::use_MOOSE=true;
    
    template <int dim>
    void MOOSEvalues<dim>::setDDobject(std::vector<System *> MOOSE_sys_sig, std::vector<MooseVariable *> MOOSE_var_sig)
    {
        _sys_sig = MOOSE_sys_sig;
        _var_sig = MOOSE_var_sig;
    }
    
} // namespace model
#endif
