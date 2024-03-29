sensitivity_min_SSU <- function (samp_frame, 
                                 errors, 
                                 id_PSU, 
                                 id_SSU, 
                                 strata_var, 
                                 target_vars, 
                                 deff_var, 
                                 domain_var, 
                                 delta = 1, 
                                 deff_sugg = 1,
                                 min, 
                                 max, 
                                 plot = TRUE) 
{
  grid <- seq(min, max, (max - min)/10)
  k <- 0
  PSU <- rep(NA, 10)
  SSU <- rep(NA, 10)
  minimum <- grid[1]
  inp <- prepareInputToAllocation1(samp_frame, 
                                   id_PSU, 
                                   id_SSU, 
                                   strata_var, 
                                   target_vars, 
                                   deff_var, 
                                   domain_var, 
                                   minimum, 
                                   delta, 
                                   deff_sugg)
  k <- 0
  for (i in grid) {
    k <- k + 1
    cat("\n", k)
    inp$des_file$MINIMUM = i
    alloc <- beat.2st(stratif = inp$strata, 
                      errors = errors, 
                      des_file = inp$des_file, 
                      psu_file = inp$psu_file, 
                      rho = inp$rho, 
                      deft_start = NULL, 
                      effst = inp$effst, 
                      epsilon1 = 5, 
                      mmdiff_deft = 1, 
                      maxi = 15, 
                      epsilon = 10^(-11), 
                      minPSUstrat = 2,
                      minnumstrat = 2, 
                      maxiter = 200, 
                      maxiter1 = 25)
    PSU[k] <- alloc$iterations$`PSU Total`[length(alloc$iterations$iterations)]
    SSU[k] <- alloc$iterations$SSU[length(alloc$iterations$iterations)]
  }
  two_stage_allocation <- list(PSU, SSU)
  if (plot == TRUE) 
    plot_sens(two_stage_allocation, min, max)
  return(two_stage_allocation)
}
