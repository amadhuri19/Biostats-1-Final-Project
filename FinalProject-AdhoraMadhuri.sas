proc import
DATAFILE = "/home/u63569870/Biostats 1 Final Project/SHAPEMHdata (1).csv"
OUT = SHAPEMH
DBMS = csv
REPLACE;
GETNAMES = yes;
run;

/*Model 1*/
proc sgplot data=SHAPEMH;
histogram MHdays / group=Discrim2;
title 'Distribution of Not Good Mental Health Days by Discrimination Status';
xaxis label='Number of Not Good Mental Health Days';
yaxis label='Frequency';
keylegend / position=bottom across=1 title='Legend: (0 = not discriminated against; 1 = discriminated against)';
run;
proc sgplot data=SHAPEMH;
vbar Discrim2 / response=MHdays stat=mean group=Discrim2;
title 'Bar Plot of Mean Number of Not Good Mental Health Days by Discrimination Status';
xaxis label='Discrimination in Healthcare';
yaxis label='Mean Number of Not Good Mental Health Days';
keylegend / position=bottom across=1 title='Legend: (0 = not discriminated against; 1 = discriminated against)';
run;
proc means data=SHAPEMH n mean median std Q1 Q3;
var MHdays;
class Discrim2;
run;
proc ttest data=SHAPEMH;
class Discrim2;
var MHdays;
title 'Confidence Interval for Difference in Means or Medians';
run;

/*Model 2*/
proc sgplot data=SHAPEMH;
scatter x=Insecurity2 y=MHdays / markerattrs=(symbol=circlefilled);
title 'Relationship between Insecurity Score and Not Good Mental Health Days';
xaxis label='Insecurity Score';
yaxis label='Number of Not Good Mental Health Days';
run;
proc corr data=SHAPEMH;
var Insecurity2 MHdays;
run;
proc reg data=SHAPEMH;
model MHdays = Insecurity2;
title 'Linear Regression: MHdays ~ Insecurity2';
run;
proc sgplot data=SHAPEMH;
title 'Scatter Plot with Regression Line: Insecurity Score vs Not Good Mental Health Days';
scatter x=Insecurity2 y=MHdays / markerattrs=(symbol=circlefilled);
LINEPARM x=0 y=5.62 slope= 0.67 / lineattrs=(color=blue);
yaxis label='Not Good Mental Health Days';
run;
data SHAPEMH2;
set SHAPEMH;
log_MHDays = log(MHDays);
run;
proc reg data=SHAPEMH2;
model log_MHDays = Insecurity2;
output out=residuals_log p=residuals;
run;
proc corr data=SHAPEMH2;
var Insecurity2 log_MHDays;
run;
proc sgplot data=SHAPEMH2;
title 'Scatter Plot with Regression Line: Insecurity Score vs Log Transformed Not Good Mental Health Days';
scatter x=Insecurity2 y=log_MHdays / markerattrs=(symbol=circlefilled);
LINEPARM x=0 y=1.35 slope= 0.07 / lineattrs=(color=blue);
yaxis label='Log TransformedNot Good Mental Health Days';
run;

/*Model 3*/
proc sgplot data=SHAPEMH2;
title 'Scatter Plot: Insecurity Score vs Log-transformed Not Good Mental Health Days';
scatter x=Insecurity2 y=log_MHDays / group = Discrim2 markerattrs=(symbol=circlefilled);
xaxis label='Insecurity Score';
yaxis label='Log-transformed Not Good Mental Health Days';
keylegend / title='Discrimination Status (0 = not discriminated against; 1 = discriminated against)';
LINEPARM x=0 y=1.35 slope= 0.07/ lineattrs=(color=blue);
run;
proc reg data=SHAPEMH2;
model log_MHDays = Insecurity2 Discrim2;
output out=residuals_log p=residuals;
run;

/*Project 1*/
/*Testing for associations between demographics and the Insecurity predictor.*/
proc means data=SHAPEMH;
class Gender3;
var Insecurity2;
output out=GenderSummary n=n Mean=Mean Std=SD;
run;
proc means data=SHAPEMH;
class TransGender;
var Insecurity2;
output out=TransSummary n=n Mean=Mean Std=SD;
run;
proc means data=SHAPEMH;
class EthRace5_2022;
var Insecurity2;
output out=RaceSummary n=n Mean=Mean Std=SD;
run;
proc anova data=SHAPEMH;
class Gender3;
model Insecurity2 = Gender3;
means Gender3/ tukey;
run;
proc ttest data=SHAPEMH;
class TransGender;
var Insecurity2;
run;
proc anova data=SHAPEMH;
class EthRace5_2022;
model Insecurity2 = EthRace5_2022;
means EthRace5_2022 / tukey;
run;

/*Testing for associations between demographics and the Discrimination in health care predictor */
proc freq data=SHAPEMH;
tables Gender2 * Discrim2 / chisq expected relrisk;
exact chisq;
run;
proc format;
VALUE trans 0="nottrans" 1="Trans";
run;
proc freq data=SHAPEMH order=formatted;
FORMAT TransGender trans.;
TABLE TransGender * Discrim2 /chisq expected relrisk;
run;
proc freq data=SHAPEMH;
tables BIPOCAI * Discrim2 / chisq expected relrisk;
exact chisq;
run;

/*Testing for associations between demographics and the number of not good mental health days outcome*/
proc means data=SHAPEMH;
class Gender3;
var MHdays;
output out=GenderSummary n=n Mean=Mean Std=SD;
run;
proc means data=SHAPEMH;
class TransGender;
var MHdays;
output out=TransSummary n=n Mean=Mean Std=SD;
run;
proc means data=SHAPEMH;
class EthRace5_2022;
var MHdays;
output out=RaceSummary n=n Mean=Mean Std=SD;
run;
proc anova data=SHAPEMH;
class Gender3;
model MHdays = Gender3;
means Gender3/ tukey;
run;
proc ttest data=SHAPEMH;
class TransGender;
var MHDays;
run;
proc anova data=SHAPEMH;
class EthRace5_2022;
model MHdays = EthRace5_2022;
means EthRace5_2022 / tukey;
run;