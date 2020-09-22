filename nat2015 url "https://uofi.box.com/shared/static/4133zicq6vjuceoy00nmotaqynbg7d4t.csv" termstr=crlf;

proc import datafile=nat2015 out=nat2015(keep = NO_MMORB RF_PDIAB RF_GDIAB RF_PHYPE RF_GHYPE RF_EHYPE RF_PPTERM RF_ARTEC RF_CESAR OEGest_R3 MAGER previs CIG_REC WTGAIN DMETH_REC dbwt) replace dbms=csv;
run;

data nat;
    set nat2015;
    if NO_MMORB = 9 then delete;
    if NO_MMORB = . then delete;
    if RF_PDIAB = "U" then delete;
    if RF_GDIAB = "U" then delete;
    if RF_PHYPE = "U" then delete;
    if RF_GHYPE = "U" then delete;
    if RF_EHYPE = "U" then delete;
    if RF_PPTERM = "U" then delete;
    if RF_ARTEC = "X" then delete;
    if RF_ARTEC = "U" then delete;
    if RF_CESAR = "U" then delete;
    if OEGest_R3 = 3 then delete;
    if previs = 99 then delete;
    if previs = . then delete;
    if CIG_REC = "U" then delete;
    if WTGAIN = 99 then delete;
    if DMETH_REC = 9 then delete;
    if dbwt = 9999 then delete;
run;

proc delete data=nat2015;
run;

proc means data=nat nmiss;
run;


proc freq data=nat;
    table no_mmorb;
run;

/* For my second data challenge I decided to analyze the morbidity rate of mothers.  */
/* The preceding code is my data input and minor cleaning.  */
/* I removed all missing and unknown values in the dataset in order to only analyze  */
/* full records for the variables I selected. */



data nat_generalized_graph;
    set nat;
    length morbidity $3 riskfactorbin $3 premature $3 delivery $9 smoker $3;
    morbidity = "No";
    riskfactorbin = "No";
    premature = "No";
    delivery = 'No';
    smoker = "No";
    
    if NO_MMORB = 0 then morbidity = "Yes";
    
    if RF_PDIAB = "Y" then riskfactorbin = "Yes";
    if riskfactorbin = "No" then do;
        if RF_GDIAB = "Y" then riskfactorbin = "Yes";
    end;
    if riskfactorbin = "No" then do;
        if RF_PHYPE = "Y" then riskfactorbin = "Yes";
    end; 
    if riskfactorbin = "No" then do;
        if RF_GHYPE = "Y" then riskfactorbin = "Yes";
    end; 
    if riskfactorbin = "No" then do;
        if RF_EHYPE = "Y" then riskfactorbin = "Yes";
    end; 
    if riskfactorbin = "No" then do;
        if RF_PPTERM = "Y" then riskfactorbin = "Yes";
    end; 
    if riskfactorbin = "No" then do;
        if RF_CESAR = "Y" then riskfactorbin = "Yes";
    end;
    
    if OEGest_R3 = 1 then premature = "Yes";
    if OEGest_R3 = 2 then premature = "No";
    
    if DMETH_REC = 1 then delivery = "Normal";
    if DMETH_REC = 2 then delivery = "C-Section";
    
    if CIG_REC = "Y" then smoker = "Yes";
    if CIG_REC = "N" then smoker = "No";
    
    drop NO_MMORB OEGEST_R3 CIG_REC DMETH_REC;
run;

/* The precedeing code was used to classify the vairables  */
/* I chose in order to analyze the dataset for possible trends within the data. */


ods exclude Moments BasicMeasures TestsForLocation 
Quantiles MissingValues ExtremeObs ParameterEstimates GoodnessOfFit FitQuantiles;
proc univariate data=nat_generalized_graph (keep=mager morbidity MAGER riskfactorbin);
    class riskfactorbin morbidity;
    histogram MAGER / normal (color = lig w=2 l=1);
run;
ods exclude Moments BasicMeasures TestsForLocation 
Quantiles MissingValues ExtremeObs ParameterEstimates GoodnessOfFit FitQuantiles;
proc univariate data=nat_generalized_graph (keep=mager morbidity dbwt riskfactorbin);
    class riskfactorbin morbidity;
    histogram dbwt / normal (color = lig w=2 l=1);
run;
ods exclude Moments BasicMeasures TestsForLocation 
Quantiles MissingValues ExtremeObs ParameterEstimates GoodnessOfFit FitQuantiles;
proc univariate data=nat_generalized_graph (keep=mager morbidity previs riskfactorbin);
    class riskfactorbin morbidity;
    histogram previs / normal (color = lig w=2 l=1);
run;


/* I graphed the distirbution of my numeric variables within the classes of whether or not  */
/* the mother experienced conplciations, morbidity, during or after childbirth.  */
/* The histograms revealed that the only factor that casued the distributions to differ  */
/* were that mothers who experienced morbidity tended to be slightly older and had some sort */
/*  of previous risk factor than those who did not.  */

data nat_risk_factors_morb (keep=risk multirisk);
    set nat_generalized_graph;
    length risk $20 multirisk $3;
    risk = "None";
    multirisk = "No";

    if risk = "None" then 
        do;
            if RF_PDIAB = "Y" then risk="Diabetes";
            if RF_GDIAB = "Y" then risk="Diabetes";
        end;
    else 
        do;
            if RF_PDIAB = "Yes" then multirisk="Yes";
            if RF_GDIAB = "Yes" then multirisk="Yes";
        end;

    if risk = "None" then 
        do;
            if RF_PHYPE = "Y" then risk="Hypertension";
            if RF_GHYPE = "Y" then risk="Hypertension";
            if RF_EHYPE = "Y" then risk="Hypertension";
        end;
    else 
        do;
            if RF_PHYPE = "Y" then multirisk="Yes";
            if RF_GHYPE = "Y" then multirisk="Yes";
            if RF_EHYPE = "Y" then multirisk="Yes";
        end;

    if risk = "None" then 
        do;
            if RF_PPTERM = "Y" then risk="Prev Preterm Birth";
        end;
    else 
        do;
            if RF_PPTERM = "Y" then multirisk="Yes";
        end;

    if risk = "None" then 
        do;
            if RF_ARTEC = "Y" then risk="Ast Repro Tech";
        end; 
    else
        do;
            if RF_ARTEC = "Y" then multirisk="Yes";
        end;

    if risk = "None" then 
        do;
            if RF_CESAR = "Y" then risk="Prev C-Section";
        end;
    else 
        do;
            if RF_CESAR = "Y" then multirisk="Yes";
        end;
    where morbidity = "Yes";
run;

proc freq data=nat_risk_factors_morb;
    table risk multirisk / NOCUM;
run;

/* Upon determining if there was a trend in my numeric variables and morbidity  */
/* I looked into the impact of specific risk factors.  */
/* I found that the majority of mothers only had one risk factor prior to birth.  */
/* Futhermore, approximately half of those mothers who experienced morbidity and  */
/* had the prior risk factor of using Assistive Reproductive Technology. */

data nat_asst_repro_tech (keep=morbidity Asst_Repro_Tech M_Age_Bin MAGER);
    set nat_generalized_graph;
    length Asst_Repro_Tech $3 M_Age_Bin $4;
    Asst_Repro_Tech = "No";
    M_Age_Bin = "<35";

    if RF_ARTEC = "Y" then Asst_Repro_Tech = "Yes";
    if MAGER > 34 then M_Age_Bin = ">=35";
run;

ods exclude Moments BasicMeasures TestsForLocation 
Quantiles MissingValues ExtremeObs ParameterEstimates GoodnessOfFit FitQuantiles;
proc univariate data=nat_asst_repro_tech;
    class Asst_Repro_Tech;
    histogram MAGER / normal (color = lig w=2 l=1);
run;


proc freq data=nat_asst_repro_tech;
    table M_Age_Bin*Asst_Repro_Tech / NOCOL;
    where morbidity = "Yes";
run;


/* The final step I took in my analysis was to cross reference mothers using assistive  */
/* reproductive technology with their age. When looking at specific ages there was not  */
/* much of a difference between the distirbution of mothers across the levels of  */
/* morbidity and their use of assistive reproductive technology.  */
/* However, I looked directly at those mothers with morbidity and found that the  */
/* majority of mothers over 35 had used assistive reproductive technology. */


