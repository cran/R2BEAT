sensitivity <- function(samp_frame,
                        errors,
                        id_PSU,
                        id_SSU,
                        strata_var,
                        target_vars,
                        deff_var,
                        domain_var,
                        minimum=50,
                        delta=1,
                        f=0.05,
                        deff_sugg=1.5,
                        search=c("deff","min_SSU","sample_fraction"),
                        min,
                        max) {
  
  if (!(search %in% c("deff","min_SSU","sample_fraction"))) {
    stop("Value for search grid not acceptable: must be one of 'deff','min_SSU','sample_fraction'")
  }

  #---------------------
  # sensitivity wrt deff
  #---------------------
  if (search=="deff") {
    deff_min <- 1
    deff_max <- 2
    grid_deff <- seq(deff_min,deff_max,(deff_max-deff_min)/10)
    
    k <- 0
    PSU <- rep(NA,10)
    SSU <- rep(NA,10)
    for (i in grid_deff) {
      k <- k+1
      cat("\n",k)
      inp <- prepareInputToAllocation(samp_frame,
                                      id_PSU,
                                      id_SSU,
                                      strata_var,
                                      target_vars,
                                      deff_var,
                                      domain_var,
                                      minimum,
                                      delta,
                                      f,
                                      deff_sugg=i)
      
      alloc <- beat.2st(stratif = inp$strata, 
                        errors = errors, 
                        des_file = inp$des_file, 
                        psu_file = inp$psu_file, 
                        rho = inp$rho, 
                        deft_start = NULL, 
                        effst = inp$effst,
                        epsilon1 = 5, 
                        mmdiff_deft = 1,maxi = 15, 
                        epsilon = 10^(-11), minnumstrat = 2, maxiter = 200, maxiter1 = 25)
      
      PSU[k] <- alloc$iterations$`PSU Total`[length(alloc$iterations$iterations)]
      SSU[k] <- alloc$iterations$SSU[length(alloc$iterations$iterations)]
      
    }
    par(mfrow=c(1,2))
    plot(grid_deff,PSU,type="l",ylab="Number of PSUs",xlab="Deft")
    title("First Stage Size")
    plot(grid_deff,SSU,type="l",ylab="Number of SSUs",xlab="Deft")
    title("Second Stage Size")
    par(mfrow=c(1,1))
  }
  
  #--------------------------------------
  # sensitivity wrt minimum number of SSU
  #--------------------------------------
  if (search=="min_SSU") {
    min_SSU <- 30
    max_SSU <- 80
    
    grid_min_SSU <- seq(min_SSU,max_SSU,(max_SSU-min_SSU)/10)
    k <- 0
    PSU <- rep(NA,10)
    SSU <- rep(NA,10)
    for (i in grid_min_SSU) {
      k <- k+1
      cat("\n",k)
      inp <- prepareInputToAllocation(samp_frame,
                                      id_PSU,
                                      id_SSU,
                                      strata_var,
                                      target_vars,
                                      deff_var,
                                      domain_var,
                                      minimum=i,
                                      delta,
                                      f,
                                      deff_sugg)
      
      alloc <- beat.2st(stratif = inp$strata, 
                        errors = errors, 
                        des_file = inp$des_file, 
                        psu_file = inp$psu_file, 
                        rho = inp$rho, 
                        deft_start = NULL, 
                        effst = inp$effst,
                        epsilon1 = 5, 
                        mmdiff_deft = 1,maxi = 15, 
                        epsilon = 10^(-11), minnumstrat = 2, maxiter = 200, maxiter1 = 25)
      
      PSU[k] <- alloc$iterations$`PSU Total`[length(alloc$iterations$iterations)]
      SSU[k] <- alloc$iterations$SSU[length(alloc$iterations$iterations)]
      
    }
    par(mfrow=c(1,2))
    plot(grid_min_SSU,PSU,type="l",ylab="Number of PSUs",xlab="Minimum # of SSU per PSU")
    title("First Stage Size")
    plot(grid_min_SSU,SSU,type="l",ylab="Number of SSUs",xlab="Minimum # of SSU per PSU")
    title("Second Stage Size")
    par(mfrow=c(1,1))
  }
  
  #----------------------------------------
  # sensitivity wrt suggested sampling rate
  #----------------------------------------
  if (search=="sample_fraction") {
    f_min <- 0.01
    f_max <- 0.10
    grid_f <- seq(f_min,f_max,(f_max-f_min)/10)
    
    k <- 0
    PSU <- rep(NA,10)
    SSU <- rep(NA,10)
    for (i in grid_f) {
      k <- k+1
      cat("\n",k)
      inp <- prepareInputToAllocation(samp_frame,
                                      id_PSU,
                                      id_SSU,
                                      strata_var,
                                      target_vars,
                                      deff_var,
                                      domain_var,
                                      minimum,
                                      delta,
                                      f=i,
                                      deff_sugg)
      
      alloc <- beat.2st(stratif = inp$strata, 
                        errors = errors, 
                        des_file = inp$des_file, 
                        psu_file = inp$psu_file, 
                        rho = inp$rho, 
                        deft_start = NULL, 
                        effst = inp$effst,
                        epsilon1 = 5, 
                        mmdiff_deft = 1,maxi = 15, 
                        epsilon = 10^(-11), minnumstrat = 2, maxiter = 200, maxiter1 = 25)
      
      PSU[k] <- alloc$iterations$`PSU Total`[length(alloc$iterations$iterations)]
      SSU[k] <- alloc$iterations$SSU[length(alloc$iterations$iterations)]
      
    }
    par(mfrow=c(1,2))
    plot(grid_f,PSU,type="l",ylab="Number of PSUs",xlab="Sampling fraction")
    title("First Stage Size")
    plot(grid_f,SSU,type="l",ylab="Number of SSUs",xlab="Sampling fraction")
    title("Second Stage Size")
    par(mfrow=c(1,1))
  }
  
}
