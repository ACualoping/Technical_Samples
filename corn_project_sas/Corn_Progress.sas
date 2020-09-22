libname STAT443 "~/corn_project_sas";


data corn_progress_D30_W;
	infile "~/corn_project_sas/data/illinois-corn-districts-D30.csv" dlm=',' firstobs=2 dsd;
	input Commodity $ State $ Location $ Year Date
	Planted Emerged Silking Dough Dented Mature Harvested;
	informat Year 4. Date mmddyy.
	Planted Emerged Silking Dough Dented Mature Harvested 3.;
	format Year 4. Date mmddyy.
	Planted Emerged Silking Dough Dented Mature Harvested 3.;
run; 

data corn_progress_D80_SW;
	infile "/corn_project_sas/data/illinois-corn-districts-D80.csv" dlm=',' firstobs=2 dsd;
	input Commodity $ State $ Location $ Year Date
	Planted Emerged Silking Dough Dented Mature Harvested;
	informat Year 4. Date mmddyy.
	Planted Emerged Silking Dough Dented Mature Harvested 3.;
	format Year 4. Date mmddyy.
	Planted Emerged Silking Dough Dented Mature Harvested 3.;
run;

data corn_progress_Illinois;
	infile "/corn_project_sas/data/illinois-corn-districts-illinois.csv" dlm=',' firstobs=2 dsd;
	input Commodity $ State $ Location $ Year Date
	Planted Emerged Silking Dough Dented Mature Harvested;
	informat Year 4. Date mmddyy.
	Planted Emerged Silking Dough Dented Mature Harvested 3.;
	format Year 4. Date mmddyy.
	Planted Emerged Silking Dough Dented Mature Harvested 3.;
run;


/* Use SQL to create new table with only years, max and min progress values with corresponding dates */
/* Most of the work is done in the subquiries being used to select the data from */
proc sql;
	create table Max_Min_D30_W as
	select P1.Year, 
		P1.Date as Min_P_Date, P1.P as Min_P,
		P2.Date as Max_P_Date, P2.P as Max_P,
		E1.Date as Min_E_Date, E1.E as Min_E,
		E2.Date as Max_E_Date, E2.E as Max_E, 
		S1.Date as Min_S_Date, S1.S as Min_S,
		S2.Date as Max_S_Date, S2.S as Max_S,
		Do1.Date as Min_Do_Date, Do1.Do as Min_Do,
		Do2.Date as Max_Do_Date, Do2.Do as Max_Do,
		De1.Date as Min_De_Date, De1.De as Min_De,
		De2.Date as Max_De_Date, De2.De as Max_De,
		M1.Date as Min_M_Date, M1.M as Min_M,
		M2.Date as Max_M_Date, M2.M as Max_M,
		H1.Date as Min_H_Date, H1.H as Min_H,
		H2.Date as Max_H_Date, H2.H as Max_H

/* 		Planted */
/* First part self explanatory */
		from (select Year, Date, Planted as P
				from corn_progress_D30_W
/* 				Use the subquiry to only select dates are the first date of 
				each year with the max/min value of the varible we need, match using year */
				where Date in (select min(Date)
								from (select Date, Year, Planted
										from corn_progress_D30_W 
										group by Year 
										having Planted = min(Planted))
										group by Year)) as P1
		join (select Year, Date, Planted as P
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Planted
										from corn_progress_D30_W 
										group by Year 
										having Planted = max(Planted))
										group by Year)) as P2 on P1.Year = P2.Year
		
/* 		Emerged */
		join (select Year, Date, Emerged as E
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Emerged
										from corn_progress_D30_W 
										group by Year 
										having Emerged = min(Emerged))
										group by Year)) as E1 on P1.Year = E1.Year
		join (select Year, Date, Emerged as E
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Emerged
										from corn_progress_D30_W 
										group by Year 
										having Emerged = max(Emerged))
										group by Year)) as E2 on P1.Year = E2.Year
				
/* 		Silking */
		join (select Year, Date, Silking as S
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Silking
										from corn_progress_D30_W 
										group by Year 
										having Silking = min(Silking))
										group by Year)) as S1 on P1.Year = S1.Year
		join (select Year, Date, Silking as S
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Silking
										from corn_progress_D30_W 
										group by Year 
										having Silking = max(Silking))
										group by Year)) as S2 on P1.Year = S2.Year
										
/* 		Dough */
		join (select Year, Date, Dough as Do
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Dough
										from corn_progress_D30_W 
										group by Year 
										having Dough = min(Dough))
										group by Year)) as Do1 on P1.Year = Do1.Year
		join (select Year, Date, Dough as Do
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Dough
										from corn_progress_D30_W 
										group by Year 
										having Dough = max(Dough))
										group by Year)) as Do2 on P1.Year = Do2.Year

/* 		Dented */
		join (select Year, Date, Dented as De
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Dented
										from corn_progress_D30_W 
										group by Year 
										having Dented = min(Dented))
										group by Year)) as De1 on P1.Year = De1.Year
		join (select Year, Date, Dented as De
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Dented
										from corn_progress_D30_W 
										group by Year 
										having Dented = max(Dented))
										group by Year)) as De2 on P1.Year = De2.Year

/* 		Mature */
		join (select Year, Date, Mature as M
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Mature
										from corn_progress_D30_W 
										group by Year 
										having Mature = min(Mature))
										group by Year)) as M1 on P1.Year = M1.Year
		join (select Year, Date, Mature as M
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Mature
										from corn_progress_D30_W 
										group by Year 
										having Mature = max(Mature))
										group by Year)) as M2 on P1.Year = M2.Year
										
/* 		Harvested */
		join (select Year, Date, Harvested as H
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Harvested
										from corn_progress_D30_W 
										group by Year 
										having Harvested = min(Harvested))
										group by Year)) as H1 on P1.Year = H1.Year
		join (select Year, Date, Harvested as H
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Harvested
										from corn_progress_D30_W 
										group by Year 
										having Harvested = max(Harvested))
										group by Year)) as H2 on P1.Year = H2.Year
		group by P1.Year
	 	order by P1.Date, P2.Date, E1.Date, E2.Date, S1.Date, S2.Date, 
	 	Do1.Date, Do2.Date, De1.Date, De2.Date, M1.Date, M2.Date, H1.Date, H2.Date;
quit; 

/* Clean dates and progress numbers to output, days in each stage and progress made by year */
data progress_days_D30_W (keep=Year Planted Planted_Progress Emerged Emerged_Progress Silking Silking_Progress
	Dough Dough_Progress Dented Dented_Progress Mature Mature_Progress Harvested Harvested_Progress);
	set Max_Min_D30_W;
	Planted = Max_P_Date - Min_P_Date;
	Planted_Progress = Max_P - Min_P;
	Emerged = Max_E_Date - Min_E_Date;
	Emerged_Progress = Max_E - Min_E;
	Silking = Max_S_Date - Min_S_Date;
	Silking_Progress = Max_S - Min_S;
	Dough = Max_Do_Date - Min_Do_Date;
	Dough_Progress = Max_Do - Min_Do;
	Dented = Max_De_Date - Min_De_Date;
	Dented_Progress = Max_De - Min_De;
	Mature = Max_M_Date - Min_M_Date;
	Mature_Progress = Max_M - Min_M;
	Harvested = Max_H_Date - Min_H_Date;
	Harvested_Progress = Max_H - Min_H;
run;

/* Export new data as csv file */
proc export data=progress_days_d30_w 
	outfile = "~/sasuser.v94/STAT443/progress_days_d30_w.csv"
	dbms = csv
	replace;
run;



/* Repeat for D_80_SW */
proc sql;
	create table Max_Min_D80_SW as
	select P1.Year, 
		P1.Date as Min_P_Date, P1.P as Min_P,
		P2.Date as Max_P_Date, P2.P as Max_P,
		E1.Date as Min_E_Date, E1.E as Min_E,
		E2.Date as Max_E_Date, E2.E as Max_E, 
		S1.Date as Min_S_Date, S1.S as Min_S,
		S2.Date as Max_S_Date, S2.S as Max_S,
		Do1.Date as Min_Do_Date, Do1.Do as Min_Do,
		Do2.Date as Max_Do_Date, Do2.Do as Max_Do,
		De1.Date as Min_De_Date, De1.De as Min_De,
		De2.Date as Max_De_Date, De2.De as Max_De,
		M1.Date as Min_M_Date, M1.M as Min_M,
		M2.Date as Max_M_Date, M2.M as Max_M,
		H1.Date as Min_H_Date, H1.H as Min_H,
		H2.Date as Max_H_Date, H2.H as Max_H

/* 		Planted */
/* First part self explanatory */
		from (select Year, Date, Planted as P
				from corn_progress_D80_SW
/* 				Use the subquiry to only select dates are the first date of 
				each year with the max/min value of the varible we need, match using year */
				where Date in (select min(Date)
								from (select Date, Year, Planted
										from corn_progress_D80_SW 
										group by Year 
										having Planted = min(Planted))
										group by Year)) as P1
		join (select Year, Date, Planted as P
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Planted
										from corn_progress_D80_SW 
										group by Year 
										having Planted = max(Planted))
										group by Year)) as P2 on P1.Year = P2.Year
		
/* 		Emerged */
		join (select Year, Date, Emerged as E
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Emerged
										from corn_progress_D80_SW 
										group by Year 
										having Emerged = min(Emerged))
										group by Year)) as E1 on P1.Year = E1.Year
		join (select Year, Date, Emerged as E
				from corn_progress_D30_W
				where Date in (select min(Date)
								from (select Date, Year, Emerged
										from corn_progress_D80_SW 
										group by Year 
										having Emerged = max(Emerged))
										group by Year)) as E2 on P1.Year = E2.Year
				
/* 		Silking */
		join (select Year, Date, Silking as S
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Silking
										from corn_progress_D80_SW 
										group by Year 
										having Silking = min(Silking))
										group by Year)) as S1 on P1.Year = S1.Year
		join (select Year, Date, Silking as S
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Silking
										from corn_progress_D80_SW 
										group by Year 
										having Silking = max(Silking))
										group by Year)) as S2 on P1.Year = S2.Year
										
/* 		Dough */
		join (select Year, Date, Dough as Do
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Dough
										from corn_progress_D80_SW 
										group by Year 
										having Dough = min(Dough))
										group by Year)) as Do1 on P1.Year = Do1.Year
		join (select Year, Date, Dough as Do
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Dough
										from corn_progress_D80_SW 
										group by Year 
										having Dough = max(Dough))
										group by Year)) as Do2 on P1.Year = Do2.Year

/* 		Dented */
		join (select Year, Date, Dented as De
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Dented
										from corn_progress_D80_SW 
										group by Year 
										having Dented = min(Dented))
										group by Year)) as De1 on P1.Year = De1.Year
		join (select Year, Date, Dented as De
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Dented
										from corn_progress_D80_SW 
										group by Year 
										having Dented = max(Dented))
										group by Year)) as De2 on P1.Year = De2.Year

/* 		Mature */
		join (select Year, Date, Mature as M
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Mature
										from corn_progress_D80_SW 
										group by Year 
										having Mature = min(Mature))
										group by Year)) as M1 on P1.Year = M1.Year
		join (select Year, Date, Mature as M
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Mature
										from corn_progress_D80_SW 
										group by Year 
										having Mature = max(Mature))
										group by Year)) as M2 on P1.Year = M2.Year
										
/* 		Harvested */
		join (select Year, Date, Harvested as H
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Harvested
										from corn_progress_D80_SW 
										group by Year 
										having Harvested = min(Harvested))
										group by Year)) as H1 on P1.Year = H1.Year
		join (select Year, Date, Harvested as H
				from corn_progress_D80_SW
				where Date in (select min(Date)
								from (select Date, Year, Harvested
										from corn_progress_D80_SW 
										group by Year 
										having Harvested = max(Harvested))
										group by Year)) as H2 on P1.Year = H2.Year
		group by P1.Year
	 	order by P1.Date, P2.Date, E1.Date, E2.Date, S1.Date, S2.Date, 
	 	Do1.Date, Do2.Date, De1.Date, De2.Date, M1.Date, M2.Date, H1.Date, H2.Date;
quit; 

/* Clean dates and progress numbers to output, days in each stage and progress made by year */
data progress_days_D80_SW (keep=Year Planted Planted_Progress Emerged Emerged_Progress Silking Silking_Progress
	Dough Dough_Progress Dented Dented_Progress Mature Mature_Progress Harvested Harvested_Progress);
	set Max_Min_D80_SW;
	Planted = Max_P_Date - Min_P_Date;
	Planted_Progress = Max_P - Min_P;
	Emerged = Max_E_Date - Min_E_Date;
	Emerged_Progress = Max_E - Min_E;
	Silking = Max_S_Date - Min_S_Date;
	Silking_Progress = Max_S - Min_S;
	Dough = Max_Do_Date - Min_Do_Date;
	Dough_Progress = Max_Do - Min_Do;
	Dented = Max_De_Date - Min_De_Date;
	Dented_Progress = Max_De - Min_De;
	Mature = Max_M_Date - Min_M_Date;
	Mature_Progress = Max_M - Min_M;
	Harvested = Max_H_Date - Min_H_Date;
	Harvested_Progress = Max_H - Min_H;
run;

/* Export new data as csv file */
proc export data=progress_days_d80_sw 
	outfile = "~/sasuser.v94/STAT443/progress_days_d80_sw.csv"
	dbms = csv
	replace;
run;
