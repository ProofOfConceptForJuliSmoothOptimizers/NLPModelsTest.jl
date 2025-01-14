export check_nls_dimensions

"""
    check_nls_dimensions(nlp; exclude_hess=false)

Make sure NLS API functions will throw DimensionError if the inputs are not the correct dimension.
To make this assertion in your code use

    @lencheck size input [more inputs separated by spaces]
"""
function check_nls_dimensions(nls)
  n, m = nls.meta.nvar, nls_meta(nls).nequ
  nnzh, nnzj = nls_meta(nls).nnzh, nls_meta(nls).nnzj

  x, badx   = nls.meta.x0, zeros(n + 1)
  Fx, badFx = zeros(m), zeros(m + 1)
  v, badv   = ones(n), zeros(n + 1)
  w, badw     = ones(m), zeros(m + 1)
  Jv, badJv   = zeros(m), zeros(m + 1)
  Jtw, badJtw = zeros(n), zeros(n + 1)
  Hv, badHv = zeros(n), zeros(n + 1)
  jrows, badjrows = zeros(Int, nnzj), zeros(Int, nnzj + 1)
  jcols, badjcols = zeros(Int, nnzj), zeros(Int, nnzj + 1)
  jvals, badjvals = zeros(nnzj), zeros(nnzj + 1)
  hrows, badhrows = zeros(Int, nnzh), zeros(Int, nnzh + 1)
  hcols, badhcols = zeros(Int, nnzh), zeros(Int, nnzh + 1)
  hvals, badhvals = zeros(nnzh), zeros(nnzh + 1)

  @test_throws DimensionError residual(nls, badx)
  @test_throws DimensionError residual!(nls, badx, Fx)
  @test_throws DimensionError residual!(nls, x, badFx)
  @test_throws DimensionError jac_residual(nls, badx)
  @test_throws DimensionError jac_structure_residual!(nls, badjrows, jcols)
  @test_throws DimensionError jac_structure_residual!(nls, jrows, badjcols)
  @test_throws DimensionError jac_coord_residual(nls, badx)
  @test_throws DimensionError jac_coord_residual!(nls, badx, jvals)
  @test_throws DimensionError jac_coord_residual!(nls, x, badjvals)
  @test_throws DimensionError jprod_residual(nls, badx, v)
  @test_throws DimensionError jprod_residual(nls, x, badv)
  @test_throws DimensionError jprod_residual!(nls, badx, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, x, badv, Jv)
  @test_throws DimensionError jprod_residual!(nls, x, v, badJv)
  @test_throws DimensionError jprod_residual!(nls, badjrows, jcols, jvals, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, jrows, badjcols, jvals, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, jrows, jcols, badjvals, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, jrows, jcols, jvals, badv, Jv)
  @test_throws DimensionError jprod_residual!(nls, jrows, jcols, jvals, v, badJv)
  @test_throws DimensionError jprod_residual!(nls, badx, jrows, jcols, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, x, badjrows, jcols, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, x, jrows, badjcols, v, Jv)
  @test_throws DimensionError jprod_residual!(nls, x, jrows, jcols, badv, Jv)
  @test_throws DimensionError jprod_residual!(nls, x, jrows, jcols, v, badJv)
  @test_throws DimensionError jtprod_residual(nls, badx, w)
  @test_throws DimensionError jtprod_residual(nls, x, badw)
  @test_throws DimensionError jtprod_residual!(nls, badx, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, x, badw, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, x, w, badJtw)
  @test_throws DimensionError jtprod_residual!(nls, badjrows, jcols, jvals, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, jrows, badjcols, jvals, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, jrows, jcols, badjvals, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, jrows, jcols, jvals, badw, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, jrows, jcols, jvals, w, badJtw)
  @test_throws DimensionError jtprod_residual!(nls, badx, jrows, jcols, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, x, badjrows, jcols, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, x, jrows, badjcols, w, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, x, jrows, jcols, badw, Jtw)
  @test_throws DimensionError jtprod_residual!(nls, x, jrows, jcols, w, badJtw)
  @test_throws DimensionError jac_op_residual(nls, badx)
  @test_throws DimensionError jac_op_residual!(nls, badx, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, x, badJv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, x, Jv, badJtw)
  @test_throws DimensionError jac_op_residual!(nls, badjrows, jcols, jvals, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, jrows, badjcols, jvals, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, jrows, jcols, badjvals, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, jrows, jcols, jvals, badJv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, jrows, jcols, jvals, Jv, badJtw)
  @test_throws DimensionError jac_op_residual!(nls, badx, jrows, jcols, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, x, badjrows, jcols, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, x, jrows, badjcols, Jv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, x, jrows, jcols, badJv, Jtw)
  @test_throws DimensionError jac_op_residual!(nls, x, jrows, jcols, Jv, badJtw)
  @test_throws DimensionError hess_residual(nls, badx, Fx)
  @test_throws DimensionError hess_residual(nls, x, badFx)
  @test_throws DimensionError hess_structure_residual!(nls, badhrows, hcols)
  @test_throws DimensionError hess_structure_residual!(nls, hrows, badhcols)
  @test_throws DimensionError hess_coord_residual(nls, badx, Fx)
  @test_throws DimensionError hess_coord_residual(nls, x, badFx)
  @test_throws DimensionError hess_coord_residual!(nls, badx, Fx, hvals)
  @test_throws DimensionError hess_coord_residual!(nls, x, badFx, hvals)
  @test_throws DimensionError hess_coord_residual!(nls, x, Fx, badhvals)
  @test_throws DimensionError jth_hess_residual(nls, badx, 1)
  @test_throws DimensionError hprod_residual(nls, badx, 1, v)
  @test_throws DimensionError hprod_residual(nls, x, 1, badv)
  @test_throws DimensionError hprod_residual!(nls, badx, 1, v, Hv)
  @test_throws DimensionError hprod_residual!(nls, x, 1, badv, Hv)
  @test_throws DimensionError hprod_residual!(nls, x, 1, v, badHv)
  @test_throws DimensionError hess_op_residual(nls, badx, 1)
  @test_throws DimensionError hess_op_residual!(nls, badx, 1, Hv)
  @test_throws DimensionError hess_op_residual!(nls, x, 1, badHv)
end
