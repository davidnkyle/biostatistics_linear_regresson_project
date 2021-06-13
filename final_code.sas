/*Group_3_Final_Project_Code*/
/*PROBLEM 1*/

libname mydata "~/my_shared_file_links/u49935143/Biostatistics_I/Final";

ods graphics on;

/*Import data set*/
data final_data;
	 set mydata.final_data;
	 female = (sex = 'F');
run;

/*Examine data set*/
title "Original Data Set";
proc print data=final_data;
run;

title "Frequencies by Sex";
proc freq data=final_data;
	      tables sex;
run;

title "Descriptive Statistics";
proc means data=final_data q1 median q3;
	       var age bmi sbp chol hdl ldl tg;
run;

title 'Scatter plot of SBP vs age';
proc sgplot data= final_data;
 	        hbox age;
run;

title 'Scatter plot of SBP vs BMI';
proc sgplot data= final_data;
 	        hbox bmi;
run;

title 'Scatter plot of SBP vs chol';
proc sgplot data= final_data;
 	        hbox chol;
run;

title 'Scatter plot of SBP vs HDL';
proc sgplot data= final_data;
 	        hbox hdl;
run;

title 'Scatter plot of SBP vs LDL';
proc sgplot data= final_data;
 	        hbox ldl;
run;

title 'Scatter plot of SBP vs Tg';
proc sgplot data= final_data;
 	        hbox tg;
run;

/*Pairwise correlations with outliers*/
title "Multiple Correlation between SBP and Several Variables";
proc reg data=final_data;
	     model sbp = female age bmi chol hdl ldl Tg;
	     where ID not in (123);
run;

title "Pairwise Correlations, Using PROC CORR";
proc corr data=final_data NOMISS;
	      var sbp female age bmi chol hdl ldl Tg;
	      where ID not in (123);
run;

/*PROBLEM 2*/

/*sections*/
/*- Influential Analysis/Removing Outliers*/
/*- Residual Analysis/Evaluating 5 Assumptions of Linear Regression*/
/*- Interaction/Confounding Effect of Each Variable:*/
/*	- Sex*/
/*	- Age*/
/*	- BMI*/
/*- Build Final Multi-variate Regression Model*/


/*Import data set*/	
data final_data;
	 set mydata.final_data;
	 female = (sex = 'F');
	 if sbp >= 800 then sbp = .;
run;


/*INFLUENTIAL ANALYSIS/REMOVING OUTLIER*/

/*Generate residuals for influence analysis*/
title "Influential Analysis";
proc reg data=final_data;
	     model sbp = tg female age bmi /r influence; 
	     id id;
	     ods output OutputStatistics = OutputStatistics nobs=nobs;
run;

data _null_;
	  set nobs;
	  call symput ('N', nobsused);
run;

/*Evaluate metrics of influence and flag each observation where at least 5 metrics mark the observation as an outlier.*/
%let k=4;	
data diagnostics;
			set OutputStatistics;
			jackknife_flag = abs(RStudent)>2;
			leverage_flag =HatDiagonal>2*&k/&N;
			CooksD_flag = CooksD>4/&N;
			DFFITS_flag = abs(DFFITS)>2*sqrt(&k/&N);
			DFB_Intercept_flag = abs(DFB_Intercept) > 2/sqrt(&N);
			DFB_tg_flag = abs(DFB_tg) > 2/sqrt(&N);
			DFB_female_flag = abs(DFB_female) > 2/sqrt(&N);
			DFB_age_flag = abs(DFB_age) > 2/sqrt(&N);
			DFB_bmi_flag = abs(DFB_bmi) > 2/sqrt(&N);
			flag_sum = sum(jackknife_flag, leverage_flag, CooksD_flag, DFFITS_flag,
				DFB_Intercept_flag, DFB_female_flag, DFB_age_flag, DFB_bmi_flag, DFB_tg_flag);
			keep id RStudent jackknife_flag HatDiagonal leverage_flag CooksD CooksD_flag
				DFFITS DFFITS_flag DFB_Intercept DFB_Intercept_flag DFB_bmi DFB_bmi_flag
				DFB_female DFB_female_flag DFB_tg DFB_tg_flag DFB_age DFB_age_flag flag_sum;
run;

title "Remove Outliers";
proc print data=diagnostics ;
	       where flag_sum >=5;
run;
/*Conclusion: remove all outliers where 5 or more influential criteria are met.*/

data final_data_edited;
	 set work.final_data;
	 logtg = log(tg);
	 where id not in (2, 3, 16, 31, 42, 54, 73, 106, 115, 194);
run;


/*RESIDUAL ANALYSIS/EVALUATING 5 ASSUMPTIONS OF LINEAR REGRESSION*/
/*Evaluate association with tg alone after removing outliers*/
title "Residual Analysis of SBP = TG";
proc reg data=final_data_edited plots(only) = diagnostics (unpack);
	     model sbp = tg;
	     output out=modeltst r=resid;
run;
/*conclusion: tg is associated with sbp (p<0.0001) but other variables may be confounding the association*/

/*Evaluate 5 assumptions of linear regression*/
title "Evaluate Assumptions of Linear Regression";
proc univariate data=modeltst normal;
	            var resid;
	            HISTOGRAM/NORMAL;
run;
/*conclusion: linear regression assumptions pass*/
/*1. The distribution is finite: apparent from the data*/
/*2. Independence: Yes, the expirament is set up so that each observation respresents a distinct patient*/
/*3. linearity: Yes, the residual vs predicted plot shows a horizontal trend*/
/*4. homescedasticity: Yes, the residual vs predicted plot shows similar variance across all predicted values*/
/*5. normal residuals: Yes, the q-q plot is strongly linear*/
/*another conclusion: since the residuals are already normal, no other permutations of tg (log(tg), sqrt(tg), etc.) need to be considered*/


/*INTERACTION/COUNDING EFFECT OF SEX*/

/*include sex in model*/
title "Confounding Effect of Sex";
proc glm data= final_data_edited;
	     class sex;
	     model sbp = sex tg/solution;
run;
/*conclusion: sex has no association with sbp on it's own (p=0.1740), or even after accounting for tg (p=0.1072). 
Sex does not confound the relationship between tg and sbp. Slope is only 2.3% different
After accounting for sex, tg is still associated with SBP(p<0.0001)*/

/*test for interaction*/
title "Interaction Effect of Sex";
proc glm data= final_data_edited;
	     class sex;
	     model sbp = sex tg sex*tg/solution;
run;
/*conclusion: there is no interaction between sex and tg (p=0.2850)*/


/*INTERACTION/COUNFDING EFFECT OF AGE*/


/*include age in model*/
title "Confounding Effect of Age";
proc glm data= final_data_edited;
	     model sbp = age tg/solution;
run;
/*conclusion: age has an association with sbp on it's own (p<0.0001), and even after accounting for tg (p<0.0001). 
Age confounds the relationship between tg and sbp. Slope is  62% different.
After accounting for age, tg has no association with sbp (p=0.0960)*/

/*test for interaction*/
title "Interaction Effect of Age";
proc glm data= final_data_edited;
	     model sbp = age tg age*tg/solution;
run;
/*conclusion: there is no interaction between age and tg (p=0.7388)*/


/*INTERACTION/COUNDING EFFECT OF BMI*/


/*include bmi in the model*/
title "Confounding Effect of BMI";
proc glm data= final_data_edited;
	     model sbp = bmi tg/solution;
run;
/*conclusion: bmi has an association with sbp on it's own (p<0.0001), and even after accounting for tg (p<0.0001). 
Bmi confounds the relationship between tg and sbp. Slope is  51% different
After accounting for bmi, tg still has an association with sbp (p=0.0325)*/

/*test for interaction*/
title "Interaction Effect of BMI";
proc glm data= final_data_edited;
	     model sbp = bmi tg bmi*tg/solution;
run;
/*conclusion: there is no interaction between bmi and tg (p=0.8895)*/


/*BUILD FINAL MULTI-VARIATE REGRESSION MODEL*/

title "Final Regression Model SBP = AGE BMI TG";
proc glm data= final_data_edited;
	     model sbp = age bmi tg/solution;
run;

/*final conclusion: The association between tg and sbp is confounded by other variables, namely age and bmi. Tg is positively correlated with age and 
age is positively correlated with sbp. Likewise Tg is positively correlated with bmi which is positively correlated with sbp.
Tg is not associated with sbp after accounting for age and bmi (p=0.2250)*/





