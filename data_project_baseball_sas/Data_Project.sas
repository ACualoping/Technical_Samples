libname Project "~/data_project_baseball_sas";

/* batting_2019 */
PROC IMPORT DATAFILE='~/data_project_baseball_sas/data/Batting_2019.csv'
	DBMS=CSV
	OUT=Project.batting_2019;
	GETNAMES=YES;
RUN;

/* batting 1871 - 2018 as batting_other*/
PROC IMPORT DATAFILE='~/data_project_baseball_sas/data/Batting_1871-2018.csv'
	DBMS=CSV
	OUT=Project.batting_other;
	GETNAMES=YES;
RUN;

/* people */
PROC IMPORT DATAFILE='~/data_project_baseball_sas/data/People.csv'
	DBMS=CSV
	OUT=Project.people;
	GETNAMES=YES;
RUN;

/* teams */
PROC IMPORT DATAFILE='~/data_project_baseball_sas/data/Teams.csv'
	DBMS=CSV
	OUT=Project.teams;
	GETNAMES=YES;
RUN;

data batting_2019;
	set Project.batting_2019;
run; 

data batting_other;
	set Project.batting_other;
run; 

data people;
	set Project.people;
run;

data teams;
	set Project.teams;
run;

/* Clean 1871-2018 batting data for steroid era --> End with Year, Player, Team, HR, RBI, AVG, SLG
	create average and slugging percentage variables
	get player and team names 
	subset for only seasons after 1984
	know there might be duplicate values for players who player for multiple teams in a year */
proc sql;
	create table batting_other_clean as 
	select unique a.yearID as Year, catx(' ', compress(b.nameFirst), compress(b.nameLast)) as Player length 16 format $16.,
		c.name as Team, a.HR, a.RBI,(a.H/a.AB) as AVG format 4.3,
		(((a.H - a.'2B'n - a.'3B'n - a.HR) + 2*a.'2B'n + 3*a.'3B'n + 4*a.HR)/a.AB) as SLG format 4.3
		from batting_other a
		left join people b on a.playerID = b.playerID
		left join teams c on a.teamID = c.teamID
		where a.yearID > 1986 and a.HR > 29
		order by a.yearID;
quit;

/* Clean 2019 batting data --> End with Year, Player, Team, HR, RBI, AVG, SLG 
	remove all additional variables
	subset for HR or SLG above threshold*/
proc sql;
	create table batting_2019_clean as 
	select 2019 as Year, Player, Team, HR, RBI, AVG, SLG
	from batting_2019;
quit;


data batting_other_clean;
	set batting_other_clean;
	if AVG = . then AVG = 0;
	if SLG = . then SLG = 0;
	Player = strip(Player);
	Player = compress(Player, '.');
run;

data batting_2019_clean;
	set batting_2019_clean;
	Player = strip(Player);
	Player = compress(Player, '.');
run; 




/* Steroid Era
	select only players above HR or SLG threshold during steroid years
	add averages for variables from previous 3 years, 1985-1991 
	11 years of data here vs. 1 year for 2019
		could do average during era and best year to compare 
		not exactly the same, but close enough */
proc sql;
	create table steroid_era as
	select distinct a.Player, mean(HR) as steroid_avg_HR format 2., mean(RBI) as steroid_avg_rbi format 3.,
			mean(AVG) as steroid_avg_avg format 4.3, mean(SLG) as steroid_avg_slg format 4.3,
			past_avg_HR format 2., past_avg_rbi format 3., past_avg_avg format 4.3, past_avg_slg format 4.3
	from batting_other_clean a
	left join (select distinct Player, mean(HR) as past_avg_HR, mean(RBI) as past_avg_rbi,
						mean(AVG) as past_avg_avg, mean(SLG) as past_avg_slg
				from batting_other_clean
				group by Player
				having Year > 1988 and Year < 1991) b on a.Player = b.Player
	group by a.Player
	having Year > 1994 and Year < 1999 and mean(HR) > 29;
quit;	



proc sql;
	create table a as 
	select distinct Player, mean(HR) as past_avg_HR format 2., mean(RBI) as past_avg_rbi format 3.,
								mean(AVG) as past_avg_avg format 4.3, mean(SLG) as past_avg_slg format 4.3
				from batting_other_clean
				group by Player
				having Year = 2018;
quit;


/* Juiced Baseball Era
	select only players above HR or SLG threshold during 2019
	add averages for variables from previous 6 years, 2012-2018 */	
proc sql;
	create table juiced_baseball_era as
	select distinct a.Year, a.Player, a.Team, a.HR, a.RBI, a.AVG, a.SLG, 
		b.past_avg_HR, b.past_avg_rbi, b.past_avg_avg, b.past_avg_slg
	from batting_2019_clean a
	left join (select distinct Player, mean(HR) as past_avg_HR format 2., mean(RBI) as past_avg_rbi format 3.,
								mean(AVG) as past_avg_avg format 4.3, mean(SLG) as past_avg_slg format 4.3
				from batting_other_clean
				group by Player
				having Year > 2013) b on a.Player = b.Player;
quit;


proc sql;
	create table t as 
	select distinct Player, mean(HR) as past_avg_HR format 2., mean(RBI) as past_avg_rbi format 3.,
			mean(AVG) as past_avg_avg format 4.3, mean(SLG) as past_avg_slg format 4.3
		from batting_other_clean
		group by Player
		having Year > 2013;
quit;


proc sql;
	create table  as 
	select distinct Player, HR, RBI, AVG, SLG
		from batting_other_clean
/* 		group by Player */
		having Year = 2018;
quit;