/********************************************************************************/
/*	Author: Aathira Puthenpurayil						Date: 15/5/23		    */
/*	Title:	P2736418-CODE.sas						    Version: 1.0		    */
/*	email: P2736418@my365.dmu.ac.uk						Course: IMAT5168	    */
/*																				*/
/*          Assessment 2 Tasks 	                                                */  
/*			1. Importing the data as well as identifying any anomalies          */
/*          2. Exploratory data analysis                                        */
/*          3. Appropriate methods for summarizing the data                     */
/*          4. Implementing and validating appropriate statistical model(s)	    */							   	
/*                                                                              */
/*use of infile to import the data.Use of Sgplot,correlation matrix,Scatter     */
/*Plot,Proc means,Proc freq,Proc univariate,proc glm.							*/ 
/********************************************************************************/

/* Imported the two data files, IMAT5168-6FORM.csv and IMAT5168-FE.csv, into SAS.*/

Libname proj '/home/u62475537/aathira';
Filename Form6 '/home/u62475537/aathira/IMAT5168-6FORM.csv';
Filename FE '/home/u62475537/aathira/IMAT5168-FE.csv';

/* create SAS Dataset for Form6 */
DATA proj.Form6;
    LENGTH
        InstitutionType    $ 25
        Region         $ 25
        TotalGLHYear1  8
        LearnersYear1  8
        TotalGLHYear2  8
        LearnersYear2  8
        TotalGLHYear3  8
        LearnersYear3  8
        ;

    FORMAT
        InstitutionType      $CHAR25.
        Region           $CHAR25.
        TotalGLHYear1    BEST8.
        LearnersYear1    BEST8.
        TotalGLHYear2    BEST8.
        LearnersYear2    BEST8.
        TotalGLHYear3    BEST8.
        LearnersYear3    BEST8.
        
        ;

    INFILE Form6
        LRECL=108
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM=','
        MISSOVER
        DSD 
		firstobs=2;

    INPUT
 
		InstitutionType     : $CHAR25.
        Region          : $CHAR25.
        TotalGLHYear1    : BEST8.
        LearnersYear1   : BEST8.
        TotalGLHYear2   : BEST8.
        LearnersYear2   : BEST8.
        TotalGLHYear3   : BEST8.
        LearnersYear3   : BEST8.
        

;


	label 
        InstitutionType		= 'Institution Type' 
        Region      = 'Region'
        TotalGLHYear1      = 'Total GLH Year1'
        LearnersYear1 = 'Learners Year1'
        TotalGLHYear2      = 'Total GLH Year2'
        LearnersYear2 = 'Learners Year2'
        TotalGLHYear3      = 'Total GLH Year3'
        LearnersYear3 = 'Learners Year3'
        


;
RUN;


/* 	check contents */
ods exclude enginehost ;
proc contents data= proj.Form6 varnum ;
run; 
ods exclude none ;

/* From Form 6 created a seperate SAS Dataset regiontot6Form 
which only contains total for each region in each year for Sixth Form*/

data proj.regiontot6Form;
  
  set proj.Form6;
  where upcase(InstitutionType) like '%EAST MIDLANDS%' or upcase(InstitutionType) like '%EAST OF ENGLAND%'
  or upcase(InstitutionType) like '%NORTH EAST%' or upcase(InstitutionType) like '%NORTH WEST%'
  or upcase(InstitutionType) like '%SOUTH EAST%' or upcase(InstitutionType) like '%SOUTH WEST%'
  or upcase(InstitutionType) like '%WEST MIDLANDS%' or upcase(InstitutionType) like '%GREATER LONDON%' 
  or upcase(InstitutionType) like'%YORKSHIRE AND THE HUMBER%';
run;

/* Rename the InstitutionType column to Region and format it as 'Sixth Form College' */
data proj.regiontot6Form;
    set proj.regiontot6Form;
    Region = 'Sixth Form College';
    rename InstitutionType=Region Region=InstitutionType;    
run;



proc print data=proj.regiontot6Form;
TITLE "Total GLH and Learners for Sixth Form per region";
run;

ods exclude enginehost ;
proc contents data= proj.regiontot6Form varnum ;
TITLE "Sixth form Region Total Contents";
run; 
ods exclude none ;

/* Form6 excluding region total*/
data proj.Form6;
   set proj.Form6;
   where upcase(InstitutionType) not in ('EAST MIDLANDS', 'EAST OF ENGLAND', 'GREATER LONDON', 'NORTH EAST', 'NORTH WEST', 'SOUTH EAST', 'SOUTH WEST', 'WEST MIDLANDS', 'YORKSHIRE AND THE HUMBER','TOTAL');
run;

proc print data=proj.Form6;
TITLE "Sixth Form Colleges";
run;

/* create SAS Dataset for FE */
DATA proj.FE;
    LENGTH
        InstitutionType    $ 25
        Region         $ 25
        TotalGLHYear1  8
        LearnersYear1  8
        TotalGLHYear2  8
        LearnersYear2  8
        TotalGLHYear3  8
        LearnersYear3  8
        ;

    FORMAT
        InstitutionType      $CHAR25.
        Region           $CHAR25.
        TotalGLHYear1    BEST8.
        LearnersYear1    BEST8.
        TotalGLHYear2    BEST8.
        LearnersYear2    BEST8.
        TotalGLHYear3    BEST8.
        LearnersYear3    BEST8.
        
        ;

    INFILE FE
        LRECL=108
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM=','
        MISSOVER
        DSD 
		firstobs=2;

    INPUT
 
		InstitutionType     : $CHAR25.
        Region          : $CHAR25.
        TotalGLHYear1    : BEST8.
        LearnersYear1   : BEST8.
        TotalGLHYear2   : BEST8.
        LearnersYear2   : BEST8.
        TotalGLHYear3   : BEST8.
        LearnersYear3   : BEST8.
        

;

	label 
        InstitutionType		= 'College Name' 
        Region      = 'Region'
        TotalGLHYear1      = 'Total GLH Year1'
        LearnersYear1 = 'Learners Year1'
        TotalGLHYear2      = 'Total GLH Year2'
        LearnersYear2 = 'Learners Year2'
        TotalGLHYear3      = 'Total GLH Year3'
        LearnersYear3 = 'Learners Year3'
        


;
RUN;


/* 	check contents */
ods exclude enginehost ;
proc contents data= proj.FE varnum ;
TITLE "FE Contents";
run; 
ods exclude none ;

/* From FE created a seperate SAS Dataset regiontotFE 
which only contains total for each region in each year for FE*/

data proj.regiontotFE;
  set proj.FE;
  where upcase(InstitutionType) like '%EAST MIDLANDS%' or upcase(InstitutionType) like '%EAST OF ENGLAND COLLEGES%'
  or upcase(InstitutionType) like '%NORTH EAST COLLEGES%' or upcase(InstitutionType) like '%NORTH WEST COLLEGES%'
  or upcase(InstitutionType) like '%SOUTH EAST COLLEGES%' or upcase(InstitutionType) like '%SOUTH WEST COLLEGES%'
  or upcase(InstitutionType) like '%WEST MIDLANDS COLLEGES%' or upcase(InstitutionType) like'%YORKSHIRE AND THE HUMBER%';
run;

/* Rename the CollegeName column to Region and format it as 'Further Education' */
data proj.regiontotFE;
    set proj.regiontotFE;
    Region = 'FE College';    
    rename InstitutionType=Region Region=InstitutionType;        
run;


proc print data=proj.regiontotFE;
TITLE "Total GLH and Learners for Further Education per region";
run;

ods exclude enginehost ;
proc contents data= proj.regiontotFE varnum ;
TITLE "FE Region Total Contents";
run; 
ods exclude none ;

/* FE excluding region total*/
data proj.FE;
   set proj.FE (firstobs=2);
   where upcase(InstitutionType) not in ('EAST MIDLANDS COLLEGES', 'EAST OF ENGLAND COLLEGES', 'NORTH EAST COLLEGES', 'NORTH WEST COLLEGES', 'SOUTH EAST COLLEGES', 'SOUTH WEST COLLEGES', 'WEST MIDLANDS COLLEGES', 'YORKSHIRE AND THE HUMBER',);
run;

proc print data=proj.FE;
TITLE "Further Education Colleges";

run;

/* Sort FE data by InstitutionType and region */
proc sort data=proj.FE;
  by InstitutionType region; 
run;

/* Sort Form6 data by InstitutionType and region */
proc sort data=proj.Form6;
  by InstitutionType region;
run;

/* Mergerd Form6 and FE Datasets*/
/* Found the institution size*/
/* Calculated the Total_GLH,Total_Learners,Avg_GLHPerLearner for further analysis*/
/* Calculated the GLHPerLearnerYear1,GLHPerLearnerYear2,GLHPerLearnerYear3 for further analysis*/

data merge_test;
  merge proj.Form6 proj.FE;
  by InstitutionType region;
  LENGTH Institution_Size $ 25;
   Total_GLH = TotalGLHYear1 + TotalGLHYear2 + TotalGLHYear3;
   Total_Learners = LearnersYear1 + LearnersYear2 + LearnersYear3;
   Avg_GLHPerLearner = Total_GLH / Total_Learners;
   
   GLHPerLearnerYear1 = TotalGLHYear1 / LearnersYear1;
   GLHPerLearnerYear2 = TotalGLHYear2 / LearnersYear2;
   GLHPerLearnerYear3 = TotalGLHYear3 / LearnersYear3;
   
  if Total_GLH >= 3000000 then Institution_Size = 'Large';
  else if Total_GLH >= 2000000 then Institution_Size = 'Large-medium';
  else if Total_GLH >= 1000000 then Institution_Size = 'Medium';
  else if Total_GLH >= 500000 then Institution_Size = 'Small-medium';
  else Institution_Size = 'Small';
  RUN;
  
proc print data=merge_test;
title "Summary Table for all institution Types";
run; 

ods exclude enginehost ;
proc contents data= merge_test varnum ;
TITLE "Merge table Contents";
run; 
ods exclude none ;


/*Use of macros for data anomalies & Data Exploration- means, freq,  
sgplot, scatterplot,correlation*/

%macro means_analysis(data, var1, var2, var3, maxdec=0);
   proc means data=&data maxdec=&maxdec n nmiss min q1 median q3 max range stackodsoutput;
      class &var1 &var2 &var3;
      var Avg_GLHPerLearner;
      ods output Summary=Lr_colleges;
   run;
%mend;

%macro freq_analysis(data, var1, var2, title);
   title "&title";
   proc freq data=&data;
      tables &var1 &var2 / missing;
      tables &var1*&var2 / chisq nopercent;
   run;
   title;
%mend;


%macro sgplot_vbox(data, xvar, category, group, title);
   proc sgplot data=&data;
      vbox &xvar / category=&category group=&group;
      keylegend / title="&title";
   run;
%mend;


%macro correlation_analysis(vars);
   proc corr data=merge_test;
      var &vars;
   run;
%mend;

%macro scatterplot(data,xvar, yvar, xlabel, ylabel);
   proc sgplot data=&data;
      scatter x=&xvar y=&yvar / markerattrs=(symbol=circlefilled) 
                                 group=&xvar 
                                 jitter;
      xaxis label="&xlabel";
      yaxis label="&ylabel";
   run;
%mend;


/* Check for missing values for numeric variables by Region InstitutionType and Institution_Size
obs:-small instituion sizes have missing values */

%means_analysis(data=merge_test, var1=Region, var2=InstitutionType, var3=Institution_Size, maxdec=0);

/* Check for missing values for character variables by InstitutionType and region */

%freq_analysis(data=merge_test, var1=InstitutionType, var2=Region, title='Total colleges in each year');


/* Check for outliers for numeric variables */

%sgplot_vbox(data=merge_test, xvar=Avg_GLHPerLearner, category=Region, group=InstitutionType, title='Distribution of Avg_GLHPerLearner vs InstitutionType');


/*Macros for Explorator data analysis and statistical model(s) :- scatterplot,correlation,means,
univariate,glm,sort*/


%macro univariate_histogram(data, var, byvar, title);
   title "&title";
   proc univariate data=&data normal noprint;
      var &var;
      by &byvar;
      histogram / KERNEL normal(mu=est sigma=est);
      qqplot / normal(mu=est sigma=est);
      ppplot / normal(mu=est sigma=est);
      inset n nmiss min q1 median q3 max skew kurt / position=SE;
   run;
   title;
%mend;


%macro calculate_means_by_class(data, class_vars, var_list);
    proc means data=&data mean n mean stddev clm maxdec=3;
        class &class_vars;
        var &var_list;
    run;
%mend;

%macro run_glm_analysis(data, class_vars, var_list, means_vars);
    proc glm data=&data;
        class &class_vars;
        model &var_list = &class_vars;
        means &means_vars / tukey;
    run;
%mend;

%macro compute_means(data, classvar, var, outdata, meanvar, countvar);
   proc means data=&data mean n mean stddev clm maxdec=3;
      class &classvar;
      var &var;
      output out=&outdata mean=&meanvar n=&countvar;
   run;
%mend;

%macro compute_meanRegion(data, class_vars, var_vars);
    proc means data=&data;
        class &class_vars;
        var &var_vars;
    run;
%mend;



%macro calculate_summary_stats(data, output);
   proc means data=&data n mean stddev clm maxdec=3;
      class InstitutionType Institution_Size;
      var Avg_GLHPerLearner;
      output out=&output mean=Avg_GLHPerLearner n=N;
   run;
%mend;

%macro sort_summary_stats(data, output, byvar);
   proc sort data=&data;
      by &byvar descending Avg_GLHPerLearner;
   run;
%mend;


%macro print_summary(data,title);
   proc print data=&data;
      title "&title";
      var InstitutionType Institution_Size N Avg_GLHPerLearner;
   run;
%mend;



/****************************************************************************************/
/*** 1. How does the GLH (Guided Learning Hours) per learner in each year            ***/ 
/*** vary across different regions, institution types, and institution sizes? *********/
/*                                                                                   */
/************************************************************************************/

/* compute means of GLH per learner by region
0bs: for year1 its always lower compared to other 2 years */

/* Compute means of GLH per learner by region */
%calculate_means_by_class(merge_test, Region, GLHPerLearnerYear1 GLHPerLearnerYear2 GLHPerLearnerYear3);

/* Compute means of GLH per learner by institution type */
%calculate_means_by_class(merge_test, InstitutionType, GLHPerLearnerYear1 GLHPerLearnerYear2 GLHPerLearnerYear3);

/* Compute means of GLH per learner by institution size */
%calculate_means_by_class(merge_test, Institution_Size, GLHPerLearnerYear1 GLHPerLearnerYear2 GLHPerLearnerYear3);



/***************************************************************************/
/*** 2.Is there any correlation between the total GLH and ********************/
/***the total number of learners in each institution?*****************************/
/*                                                                         */
/***************************************************************************/

/* Compute correlation between Total_GLH and Total_Learners */

%correlation_analysis(Total_GLH Total_Learners Avg_GLHPerLearner);

/***************************************************************************/
/*** 3.over all trend in GLH per learner across all institutions  type ********/
/***********                                          *********************/
/*                                                                         */
/***************************************************************************/

/* Compute means of Avg_GLHPerLearner by institution type */
%compute_means(data=merge_test, classvar=InstitutionType, var=Avg_GLHPerLearner, outdata=glh_summary, meanvar=mean_glh, countvar=n_obs);



/***************************************************************************/
/*** 4.Which region has the highest and lowest GLH per learner on average*****/
/***********                                          *********************/
/*                                                                        */
/**************************************************************************/

/* Compute means of Avg_GLHPerLearner by region */
%compute_means(data=merge_test, classvar=Region, var=Avg_GLHPerLearner, outdata=glh_summary, meanvar=mean_glh, countvar=n_obs);


/* Create scatter plot of mean GLH per learner by region */
%scatterplot(data=glh_summary, xvar=Region, yvar=mean_glh, xlabel=Region, ylabel=Mean GLH per Learner);

 
/************************************************************************/
/*** 	5.Which institution type and size have the highest and lowest  ***/
/***********        GLH per learner on average?    *********************/
/*                                                                     */
/**********************************************************************/ 

/* Summary statistics for GLH per learner by institution type and size */

%calculate_summary_stats(data=merge_test, output=means_summary);

/* Sort the summary statistics by average GLH per learner */
%sort_summary_stats(data=means_summary, output=means_summary, byvar=Avg_GLHPerLearner);


/* Print institution types and sizes with highest average GLH per learner */
%print_summary(data=means_summary, title=Institution Types and Sizes with Highest Average GLH per Learner);


/**************************************************************************/
/*** 6. what is the total number of learners each year for all FE in each region?***/
/*                                                                       **/
/*************************************************************************/

%compute_meanRegion(proj.regiontotFE, Region, LearnersYear1 LearnersYear2 LearnersYear3);

/**************************************************************************/
/*** 7.what is the total number of learners in each year for all sixth form in each region**/
/*                                                                       **/
/*************************************************************************/

%compute_meanRegion(proj.regiontot6Form, Region, LearnersYear1 LearnersYear2 LearnersYear3);

/**************************************************************************/
/*** 8.what is the total GLH in each year for all FE in each region***/
/*                                                                       **/
/*************************************************************************/

%compute_meanRegion(proj.regiontotFE, Region, TotalGLHYear1 TotalGLHYear2 TotalGLHYear3);


/**************************************************************************/
/*** 9.what is the total GLH in each year for all sixthform in each region**/
/*                                                                       **/
/*************************************************************************/ 
%compute_meanRegion(proj.regiontot6Form, Region, TotalGLHYear1 TotalGLHYear2 TotalGLHYear3);

/*statistical models*/
/*Run univariate procedure */
%univariate_histogram(data=merge_test, var=Avg_GLHPerLearner, byvar=InstitutionType, title='Histogram of Avg_GLHPerLearner with InstitutionType');
/* Run the GLM analysis */
%run_glm_analysis(merge_test, InstitutionType Institution_Size Region, GLHPerLearnerYear1 GLHPerLearnerYear2 GLHPerLearnerYear3, InstitutionType Institution_Size Region);


