/* Recreating code from Rikki Tanner, PhD at UAB - for Visit 2*/

libname meds 'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit2\1-data';


proc sort data=meds.medcodes  out=medcodes_id nodupkey; by subjid; run; 

data msrb;
set meds.msrb;
format _all_;
run;

data htmeds;
set meds.medcodes; *(keep=subjid tccode);
by subjid;

  tccode2 = (substr(tccode, 1, 2) + 0); *First two digits;
  tccode3 = (substr(tccode, 1, 3) + 0); *First three digits;
  tccode4 = (substr(tccode, 1, 4) + 0); *First four digits;
  tccode6 = (substr(tccode, 1, 6) + 0); *First six digits;
  tccode10 = (substr(tccode, 1, 10) + 0); *All ten digits;



ace= (tccode6=361000 |  
      tccode6=369915 | 
	  tccode6=369985 | 
	  tccode6=369918)*1; *ACE inhibitors, ACE inhibitor/Ca channel blocker combinations, ACE inhibitor/Nutritional suppl combinations, ACE inhibitors & thiazide/thiazide-like;



aldo= (tccode6=362500)*1; *selective aldosterone receptor antagonists;

alpha= (tccode6=362020) *1; *antiadrenergics-- peripherally acting;

alpha_beta= (tccode6=333000 |
			 tccode6=339990) *1; *alpha-beta blocker combinations, alpha-beta blocker/nutritional suppl combinations ;


arb= (tccode6=361500 |
	  tccode6=369945 |
	  tccode6=369930 |
	  tccode6=369940 |
	  tccode6=369965) *1; *angiotensin II receptor antagonists, angiotensin II receptor antag/Ca channel blocker/thiazide combination, angiotension II receptor antagonist/Ca channel blocker combination, angiotensin II receptor antagonist & thiazide/thiazide-like combination, direct renin inhibitors/angiotensin II receptor antagonist combination;


beta_cardio_nonselect= (tccode6=369920 |
	   					tccode6=369988 |
	   					tccode6=332000 |
	   					tccode6=331000) *1; *beta blocker/diuretic combinations, beta blocker/nutritional suppl combinations, beta blockers-- cardioselective, beta blockers-- non-selective;



ccb= (tccode6=340000 |
      tccode6=409925 |
	  tccode6=349990 |
	  tccode6=641540 |
	  tccode6=369915 |
	  tccode6=369945 |
	  tccode6=369930 |
	  tccode6=369967 |
	  tccode6=369968) *1; *calcium channel blockers, calcium channel blocker/HMG CoA reductase inhibitor combination, calcium channel blocker/nutritional suppl combinations, selective n-type neuronal calcium channel blockers, ace-inhibitor/ca channel blocker combinations, arb/ca chaneel blocker/thiazide combination, arb/ca channel blocker combination, direct renin inhibitors/ca channel blocker combination, direct renin inhibitors/ca channel blocker/thiazide combination;

central= (tccode6=369950 |
		  tccode6=362010) *1; *antiadrenergics-- centrally acting, adrenolytics- central & thiazide/thiazide-like combination;


diuretic_loop= (tccode4=3720) *1; *loop diuretics;


diuretic_potass= (tccode4=3750) *1; *potassium-sparing diuretics;


diuretic_thztype= (tccode4=3799 |
			   tccode4=3790 | tccode6=376000 |
               tccode6=369918 |
			   tccode6=369920 |
			   tccode6=369945 |
			   tccode6=369940 |
			   tccode6=369950 |
			   tccode6=369990 |
			   tccode6=369960 |
			   tccode6=369968 | tccode10=9656881150) *1; *diuretic combinations, diuretics--misc, thiazide and thiazide-like diuretics, ACE inhibitors & thiazide/thiazide-like, beta blocker & thiazide combinations, arb/ca channel blocker/thiazides, ARB & thiazide/thiazide-like, central & thiazide/thiazide-like combination, vasodilators/thiazide combinations, direct renin inhibitors & thiazide/thiazide-like combination, direct renin inhibitors/ca channel blocker/thiazide comb, hydroflumethiazide;


vasod= (tccode4=8925 |
	    tccode4=3640 | tccode6=369990) *1; *vasodilating agents, vasodilators, vasodilators/thiazide combinations;


renini= (tccode6=361700 |
	     tccode6=369965 |
		 tccode6=369967 |
		 tccode6=369960 |
		 tccode6=369968) *1; *direct renin inhibitors, direct renin inhibitors/angiotensin II receptor antagonist combination, direct renin inhibitors/ca channel blocker combination, direct renin inhibitors & thiazide/thiazide-like combination, direct renin inhibitors/ca channel blocker/ thiazide combination;


if tccode10=3750002000 then diuretic=0;
if tccode10=3750002000 then diuretic_thztype=0;
if tccode10=3750002000 then diuretic_loop=0;
if tccode10=3750002000 then diuretic_potass=0;
if tccode10=3750002000 then aldo=1; *categorize spironolactone as aldosterone antagonist, rather than diuretic;

if tccode10=3625003000 then diuretic=0;
if tccode10=3625003000 then diuretic_thztype=0;
if tccode10=3625003000 then diuretic_loop=0;
if tccode10=3625003000 then diuretic_potass=0;
if tccode10=3625003000 then aldo=1; *categorize eplerenone as aldosterone antagonist, rather than diuretic;


/*4/26/17: re-classify some beta blockers based on JNC-7*/
*code new classes-- beta blockers with intrinsic sympathomimetic activity, beta blockers-- cardioselective and vasodilatory; 
if tccode10=3320001010 then beta_cardio_nonselect=0;
if tccode10=3320001010 then beta_cardio_vasod=0;
if tccode10=3320001010 then beta_int_sym=1;  *acebutolol;

if tccode10=3310000500 then beta_cardio_nonselect=0;
if tccode10=3310000500 then beta_cardio_vasod=0;
if tccode10=3310000500 then beta_int_sym=1;  *carteolol;

if tccode10=3310002510 then beta_cardio_nonselect=0;
if tccode10=3310002510 then beta_cardio_vasod=0;
if tccode10=3310002510 then beta_int_sym=1;  *penbutolol;

if tccode10=3310003000 then beta_cardio_nonselect=0;
if tccode10=3310003000 then beta_cardio_vasod=0;
if tccode10=3310003000 then beta_int_sym=1;  *pindolol;

if tccode10=3320004010 then beta_cardio_nonselect=0;
if tccode10=3320004010 then beta_int_sym=0;
if tccode10=3320004010 then beta_cardio_vasod=1;  *nebivolol;

/*exclude sotalol as a beta blocker*/
if tccode10=3310004512 or tccode10=3310004510 then beta_cardio_nonselect=0;
if tccode10=3310004512 or tccode10=3310004510 then beta_cardio_vasod=0;
if tccode10=3310004512 or tccode10=3310004510 then beta_int_sym=0;

/*code bulk amlodipine as a CCB*/
if tccode10=9642663445 then ccb=1;

/*create CCB subclasses*/
if ccb=1 then ccb_subtype_DHP=1;
if ccb=1 and tccode10=3400001010 or tccode10=3400001011 or tccode10=3400001012 then ccb_subtype_DHP=0; 
if ccb=1 and tccode10=3400001010 or tccode10=3400001011 or tccode10=3400001012 then ccb_subtype_NDHP=1; *diltiazem;

if ccb=1 and tccode10=3400003010 then ccb_subtype_DHP=0;
if ccb=1 and tccode10=3400003010 then ccb_subtype_NDHP=1; *verapamil;

if ccb=1 and tccode10=3699150270 then ccb_subtype_DHP=0; *trandolapril/verapamil combo therapy;
if ccb=1 and tccode10=3699150270 then ccb_subtype_NDHP=1; *trandolapril/verapamil combo therapy;


/*recode reserpine as a central acting agent, rather than a vasodilator*/
if tccode10=3620300000 then vasod=0;
if tccode10=3620300000 then central=1; *reserpine;

if tccode10=3699100000 then vasod=0;
if tccode10=3699100000 then central=1; *reserpine combinations;

/*code deserpine & methychlothiazide combination as a central acting agent and thiazide diuretic*/
if tccode10=3699100220 then diuretic_thztype=1;
if tccode10=3699100220 then central=1;

/*correct error in JHS medcodes -- 3310000700 is not a correct TCCODE-- this is meant to be carvedilol 3330000700*/
if tccode='3310000700' then beta_cardio_nonselect=0;
if tccode='3310000700' then alpha_beta=1;

/*exclude buchu-cornsilk-chair grass-hydrangea as a diuretic*/
if tccode10=3799200410 then diuretic_thztype=0;

/*manually code reserpine as a central acting agent*/
if tccode10=3620304000 then central=1;

/*code bulk captopril as an ace inhibitor*/
if tccode10=9646425060 then ace=1;

/*10/26/2018: Recode thiazide-like diuretics into a subclass apart from thiazide-type*/
if tccode10=3699200210 or tccode10=3760002500 or tccode10=3760005000 or tccode10=3699500220 or tccode10=3760006000 then diuretic_thztype=0;
if tccode10=3699200210 or tccode10=3760002500 or tccode10=3760005000 or tccode10=3699500220 or tccode10=3760006000 then diuretic_thzlike=1;
run;


/*check timolol use*/
proc print data=htmeds; where tccode="3310005010"; run; *3 drops, 1 oral?, 3 indeterminate;

proc print data=save.beta_cardio_nonselect; where subjid="J245504"; run; *timolol drops-- see field msrb4c;
proc print data=save.beta_cardio_nonselect; where subjid="J519559"; run; *drops-- see field msrb11c;
proc print data=save.beta_cardio_nonselect; where subjid="J552593"; run; *drops-- see field msrb11c;

/*confirm oral timolol*/
proc print data=save.beta_cardio_nonselect; where subjid="J227498"; run; *not oral-- see field msrb7c;

/*exclude timolol as a beta blocker*/
data htmeds;
set htmeds;
if tccode="3310005010" then beta_cardio_nonselect=0;
if tccode="3310005010" then beta_cardio_vasod=0;
if tccode="3310005010" then beta_int_sym=0;
IF tccode10=3799000220 then aldo=1; *categorize spironolactone-HCTZ as aldosterone antagonist (in addition to a thz diuretic);
IF tccode10=3799000230 then diuretic_potass=1; *categorize triamterene-HCTZ as K-sparing diuretic (in addition to thiazide diuretic);
IF tccode10=3799000210 then diuretic_potass=1; */*categorize amiloride-HCTZ as K-sparing diuretic (in addition to thiazide diuretic);
run;




data htmeds;
set htmeds;
htmeds=1;
if ace^=1 and aldo^=1 and alpha^=1 and alpha_beta^=1 and arb^=1 and beta_cardio_nonselect^=1 and ccb^=1 and central^=1 and diuretic_loop^=1 and diuretic_potass^=1 and diuretic_thztype^=1
and diuretic_thzlike^=1 and vasod^=1 and renini^=1 and beta_cardio_vasod^=1 and beta_int_sym^=1 then htmeds=0;
run;


proc contents data=htmeds;  run;




/*print tccodes for ace inhibitors*/
proc freq data=htmeds; where ace=1; tables tccode tcname; run;

/*print tccodes for aldosterone antagonists*/
proc freq data=htmeds; where aldo=1; tables tccode tcname; run;

/*print tccodes for alpha blockers*/
proc freq data=htmeds; where alpha=1; tables tccode tcname; run;

/*print tccodes for alpha/beta blockers*/
proc freq data=htmeds; where alpha_beta=1; tables tccode tcname; run;

/*print tccodes for ARBs*/
proc freq data=htmeds; where arb=1; tables tccode tcname; run;

/*print tccodes for beta blockers*/
proc freq data=htmeds; where beta_cardio_nonselect=1; tables tccode tcname; run;
proc freq data=htmeds; where beta_int_sym=1; tables tccode tcname; run;
proc freq data=htmeds; where beta_cardio_vasod=1; tables tccode tcname; run;

/*print tccodes for calcium channel blockers*/
proc freq data=htmeds; where ccb=1; tables tccode tcname; run;
proc freq data=htmeds; where ccb_subtype_DHP=1; tables tccode tcname; run;
proc freq data=htmeds; where ccb_subtype_NDHP=1; tables tccode tcname; run;

/*print tccodes for central acting agents*/
proc freq data=htmeds; where central=1; tables tccode tcname; run;

/*print tccodes for loop diuretics*/
proc freq data=htmeds; where diuretic_loop=1; tables tccode tcname; run;

/*print tccodes for potassium-sparing diuretics*/
proc freq data=htmeds; where diuretic_potass=1; tables tccode tcname; run;

/*print tccodes for thiazide type diuretics*/
proc freq data=htmeds; where diuretic_thztype=1; tables tccode tcname; run;

/*print tccodes for thiazide like diuretics*/
proc freq data=htmeds; where diuretic_thzlike=1; tables tccode tcname; run;

/*print tccodes for vasodilators*/
proc freq data=htmeds; where vasod=1; tables tccode tcname; run;

/*print tccodes for renin inhibitors*/
proc freq data=htmeds; where renini=1; tables tccode tcname; run;





/*check tccodes not getting coding as htmeds*/
proc freq data=htmeds; where htmeds=0; tables tccode tcname; run; *check some;

*proc freq data=htmeds; *where htmeds=0 and tcname="*ANTIHYPERTENSIVES*"; *tables tccode; *run;

*proc freq data=htmeds; *where htmeds=0 and tcname="Amlodipine Besylate (Bulk)"; *tables tccode; *run;








libname save 'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit2';

%macro mec;
%let n=1;
%let var=%scan(&varlist, &n.);

%do %while (&var ne );
	data &var.(keep=subjid tccode tccode4 tccode6 &var.);
	set htmeds;
	if &var.=1;
	run;

	proc sort data=&var. out=&var._id nodupkey; by subjid; run;

	data save.&var;
	merge &var._id (in=a keep=subjid &var.) msrb(in=b);
	by subjid;
	if a*b;
	run;

%let n=%eval(&n+1);
 %let var=%scan(&varlist,&n);
%end;

%mend;

%let varlist= ace aldo alpha alpha_beta arb beta_cardio_nonselect beta_int_sym beta_cardio_vasod ccb ccb_subtype_DHP ccb_subtype_NDHP diuretic_loop diuretic_potass diuretic_thztype diuretic_thzlike renini central vasod;
%mec;






/*Create single dataset with all classes*/
data t1;
set save.ace;
keep subjid ace;
run;

data t2;
set save.aldo;
keep subjid aldo;
run;

data t3;
set save.alpha;
keep subjid alpha;
run;

data t4;
set save.alpha_beta;
keep subjid alpha_beta;
run;

data t5;
set save.arb;
keep subjid arb;
run;

data t6;
set save.beta_cardio_nonselect;
keep subjid beta_cardio_nonselect;
run;

data t7;
set save.beta_cardio_vasod;
keep subjid beta_cardio_vasod;
run;

data t8;
set save.beta_int_sym;
keep subjid beta_int_sym;
run;

data t9;
set save.ccb;
keep subjid ccb;
run;

data t9b;
set save.ccb_subtype_dhp;
keep subjid ccb_subtype_dhp;
run;

data t9c;
set save.ccb_subtype_ndhp;
keep subjid ccb_subtype_ndhp;
run;

data t10;
set save.central;
keep subjid central;
run;

data t11;
set save.diuretic_loop;
keep subjid diuretic_loop;
run;

data t12;
set save.diuretic_potass;
keep subjid diuretic_potass;
run;

data t13;
set save.diuretic_thztype;
keep subjid diuretic_thztype;
run;

data t14;
set save.renini;
keep subjid renini;
run;

data t15;
set save.vasod;
keep subjid vasod;
run;

data t16;
set save.diuretic_thzlike;
keep subjid diuretic_thzlike;
run;

proc sort data=t1; by subjid; run;
proc sort data=t2; by subjid; run;
proc sort data=t3; by subjid; run;
proc sort data=t4; by subjid; run;
proc sort data=t5; by subjid; run;
proc sort data=t6; by subjid; run;
proc sort data=t7; by subjid; run;
proc sort data=t8; by subjid; run;
proc sort data=t9; by subjid; run;
proc sort data=t9b; by subjid; run;
proc sort data=t9c; by subjid; run;
proc sort data=t10; by subjid; run;
proc sort data=t11; by subjid; run;
proc sort data=t12; by subjid; run;
proc sort data=t13; by subjid; run;
proc sort data=t14; by subjid; run;
proc sort data=t15; by subjid; run;
proc sort data=t16; by subjid; run;

data t17;
merge t16 t15 t14 t13 t12 t11 t10 t9 t9b t9c t8 t7 t6 t5 t4 t3 t2 t1;
by subjid;
run;



data t17b;
set t17;
if ace=. then ace=0;
if aldo=. then aldo=0;
if alpha=. then alpha=0;
if alpha_beta=. then alpha_beta=0;
if arb=. then arb=0;
if beta_cardio_nonselect=. then beta_cardio_nonselect=0;
if beta_cardio_vasod=. then beta_cardio_vasod=0;
if beta_int_sym=. then beta_int_sym=0;
if ccb=. then ccb=0;
if ccb_subtype_dhp=. then ccb_subtype_dhp=0;
if ccb_subtype_ndhp=. then ccb_subtype_ndhp=0;
if central=. then central=0;
if diuretic_loop=. then diuretic_loop=0;
if diuretic_potass=. then diuretic_potass=0;
if diuretic_thztype=. then diuretic_thztype=0;
if diuretic_thzlike=. then diuretic_thzlike=0;
if renini=. then renini=0;
if vasod=. then vasod=0;
run;

data t18;
set t17b;
beta_num=sum(of alpha_beta beta_cardio_nonselect beta_int_sym beta_cardio_vasod);
beta_all=0;
if alpha_beta=1 or beta_cardio_nonselect=1 or beta_int_sym=1 or beta_cardio_vasod=1 then beta_all=1;
*num_classes=sum(of ace aldo alpha alpha_beta arb beta_cardio_nonselect beta_int_sym beta_cardio_vasod ccb diuretic_loop diuretic_potass diuretic_thz renini central vasod);
*num_classes2=sum(of ace aldo alpha arb beta_all ccb diuretic_loop diuretic_potass diuretic_thz renini central vasod);
run;

proc freq data=t18; 
tables ace aldo alpha alpha_beta arb beta_cardio_nonselect beta_int_sym beta_cardio_vasod ccb diuretic_loop diuretic_potass diuretic_thztype diuretic_thzlike renini central vasod; 
run;


proc freq data=t18;
tables beta_num; 
run;


data save.htmeds_v2;
set t18;
keep subjid ace aldo alpha alpha_beta arb beta_cardio_nonselect beta_cardio_vasod beta_int_sym ccb ccb_subtype_dhp ccb_subtype_ndhp central diuretic_loop diuretic_potass
diuretic_thztype diuretic_thzlike renini vasod;
run;

proc freq data=save.htmeds_v2; tables ace; run;

