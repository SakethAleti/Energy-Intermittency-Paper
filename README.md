# Efficient Pollution Abatement in Electricity Markets with Intermittent Renewable Energy

> In this article, we present a model of the electricity sector where generation technologies are intermittent. The economic value of an electricity generation technology is given by integrating its production profile with the market price of electricity. We use estimates of the consumer's intertemporal elasticity of substitution for electricity consumption while parameterizing the model empirically to numerically calculate the elasticity between renewables and fossil energy. We find that there is a non-constant elasticity of substitution between renewable and fossil energy that depends on prices and intermittency. This suggests that the efficacy and welfare effects of carbon taxes and renewable subsidies vary geographically. Subsidizing research into battery technology and tailoring policy for local energy markets can mitigate these distributional side effects while complementing traditional policies used to promote renewable energy.*

The [paper](documents/draft.pdf) along with [slides](documents/workshop_presentation.pdf) are available in the documents folder. 

## Data

All the data used for the paper can be found in the [data folder](data); the references for each data source can be found in the [paper](documents/draft.pdf) itself. 

## Replication

Each link redirects to the code used to produce the respective figure/table.

### Paper

* [Table 1:  Descriptive Statistics](notebooks/Data_Prep.ipynb)
* [Table 2:  OLS Regression Results](code/regressions/parametric_regressions.R)
* [Table 3:  IV (2SLS) Regression Results](code/regressions/parametric_regressions.R)
* [Table 4:  Partially Linear IV Regression Results](code/regressions/semiparametric_regressions.ipynb)
* [Table 5:  The Effect of Battery Storage on the Elasticity of Demand for Coal Power](code/simulation/sim_battery_elas.m)
* [Figure 1: The Elasticity of Substitution between Solar and Coal](code/simulation/sim_eos.m)
* [Figure 2: The Price Elasticity of Demand for Coal Power](code/simulation/sim_elasticity.m)
* [Figure 3: The Effect of Battery Storage on the Elasticity of Substitution between Solar and Coal](code/simulation/sim_batteries.m)
* [Figure 4: The VES Approximation of the Elasticity of Substitution between Solar and Coal](code/simulation/sim_ves.m)
* [Figure 5: Partially Linear IV Regression Estimates with State Drop Outs](code/simulation/semiparametric_regressions.ipynb)
* [Figure 6: The Elasticity of Substitution Between Two Minimally Intermittent Technologies](code/simulation/sim_eos_range.m)
* [Figure 7: The VES Approximation of the Elasticity of Substitution between Highly Intermittent Solar and Coal](code/simulation/sim_ves_int.m)


### Presentation

The tables and figures used in the presentation are the same as those from the paper. 

* [Motivation - ERCOT Hourly Load and Solar Generation](code/graphs/workshop_graphs.R)
* [Results    - Partially Linear IV Regression Results](code/regressions/semiparametric_regressions.ipynb)
* [Discussion - "The elasticity of substitution between technologies is not constant"](code/simulation/sim_eos_workshop.m)
* [Discussion - "Demand for base load capacity becomes more inelastic with its price"](code/simulation/sim_elasticity_workshop.m)
* [Discussion - Distribution of Hydrothermal and Geothermal Plants](code/graphs/workshop_graphs.R)
* [Discussion - "Using batteries to shift solar output greatly increases its substitutability"](code/simulation/sim_batteries_workshop.m)
* [Appendix   - "VES approximation of the relationship between solar and coal"](code/simulation/sim_ves_workshop.m)
* [Appendix   - OLS Results](code/regressions/parametric_regressions.R)
* [Appendix   - IV Results](code/regressions/parametric_regressions.R)
