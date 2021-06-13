# biostatistics_linear_regresson_project
This was the final group project for my biostatistics linear regression course. The problem deals with finding an association between two variables in a clinical study.

# METHODS, RESULTS/CONCLUSION: GROUP 3
## METHODS:
### Study population:
Blood samples from 232 randomly sampled subjects (113 females and 119 males) were collected to evaluate the relationship between personal characteristics and several cholesterol measures. Data collected were age (yrs.), gender, weight (lbs.), height (in.), body mass index (BMI), systolic blood pressure (SBP), total cholesterol (chol; mg/dl), high-density lipid (HDL; mg/dl), low-density lipid (LDL; mg/dl), and triglyceride (Tg; mg/dl).
### Statistical analysis:
For Problem 1: Descriptive statistics were generated to understand variable distribution, and to spot data errors and missing values. Box plots were used to evaluate dependent and independent variable distribution. Forty-two subjects with missing data and one subject with data error (ID 123 with SBP = 800) were removed; consequently, the cohort included 189 subjects.

Pairwise correlations between SBP and seven other variables (age, gender, BMI, chol, HDL, LDL, Tg)  were  calculated  using  Pearson  correlation  coefficients,  with  p-values  for  testing  the  null hypothesis of no association between SBP and the variable. 

For  Problem  2:  Multivariate  linear  regression  analysis  was  used  to  examine  the  relationship between Tg and SBP. To adjust for potential confounding and to estimate the independent effect of Tg on SBP, we adjusted for certain covariates (sex, age, and BMI).  Adjustment for covariates also  helps  reduce  residual  variance  and  thereby  increases  precision  of  the  linear  model  fit.  Influential  analysis  was  conducted  to  identify  and  remove  outliers.  Residual  analysis  was performed  using  PROC  UNIVARIATE  to  assess  the  appropriateness  of  the  linear  regression model. 

Separately,  to  understand  the  effect  of  sex,  age,  and  BMI  on  the  relationship  between  Tg  and SBP, we estimated the interaction effects by including interaction terms in the model. Including an interaction term effect in the model provides a better representation and understanding of the relationship between dependent and independent variables. 

A p-value of <0.05 was considered significant. All statistical analyses were performed using SAS®Studio (version 3.8, SAS Institute, Cary, NC, USA).

## RESULTS:
For Problem 1: Of 189 subjects, 95 (50.3%) were female, and 94 (49.7%) were male. Mean age for female subjects was 22.71 ± 15.45 years, and mean SBP was 117.31 ± 20.11 (Table 1). Box plots showed a tendency of the data for age, cholesterol, HDL, LDL, and Tg levels to be slightly right-skewed, with potential outliers. The distribution for BMI appears normal (Figure 1). 

There was no significant pairwise correlation between SBP and female gender (R=-0.005, p=0.94) and  HDL  (R=0.017,  p=0.81).  SBP  has  a  statistically  significant  positive  correlation  with  age (R=0.50,  p<0.0001),  BMI  (R=0.50,  p<0.0001),  cholesterol  (R=0.22,  p=0.002),  LDL  (R=0.20, p=0.006), and Tg (R=0.31, p<0.0001).

Pearsons is probably valid because of the large sample size (N=189, after 43 observations were removed), despite the non-normal appearance of some box plots for several variables.

For  Problem  2:  Prior  to  conducting  the  multivariable  analysis,  we  used  influential  statistical analysis to identify ten outliers (ID 2, 3, 16, 31, 42, 54, 73, 106, 115, and 194) that violated five rules  of  thumb.  These  outliers  were  removed  from  the  data. After  removal  of  the  outliers,  the residuals from the Tg/SBP model appear to satisfy all the linear regression assumptions (Figure 2). 

In the crude model, Tg and SBP showed significant positive correlation (R=0.31, p<0.0001). We arrived  at  a  similar  conclusion  after  adjusting  for  other  variables  in  the  multivariate  regression. After adjusting for sex and BMI, the results showed that Tg was still associated with SBP (sex p<0.0001;  BMI  p=0.0325).  However,  after  adjusting  for  age,  Tg  was  no  longer  associated  with SBP (p=0.0960), indicating effect modification by age. 

The estimated Tg slope on SBP is 0.157; after the adjustment for sex, the slope changed very little to 0.160, and thus, sex does not confound the Tg and SBP relationship. However, adjustment for age and BMI results in a much lower slope estimate of Tg (slope=0.060 after adjusting for age and 0.077 after adjusting for BMI), indicating age and BMI do confound Tg and SBP relationship. 

In terms of interaction effect, the results showed no significant interaction between Tg and sex (p=0.2850),  Tg  and  age  (p=0.7388),  or  Tg  and  BMI  (p=0.8895).  Because  the  interaction  terms were non-significant, we removed them from the final model and re-ran the analysis without the interaction terms. 
