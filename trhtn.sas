/* Run the code to find the uncontrolled and untreated hypertension cases
   90% of the code from Rikki Tanner,PhD, UAB School of Public Health*/

%macro htnwork (libanal, libmeds, libsave, msrin, quest,analdata,htmeds,trhtn);
	libname anal &libanal;
	libname meds &libmeds;
	libname save &libsave; 

	data msr;
       set meds.&msrin;
       format _all_;
    run;

	data analysis;
        set anal.&analdata;
        format _all_;
    run;

	data htmeds;
		set save.&htmeds;
	run;

	data temp;
        merge htmeds msr analysis;
	    antihtnclass2 = sum(of ace aldo alpha arb beta ccb central renini vasod);
        diuretic = sum(of diuretic_loop diuretic_potass diuretic_thzlike diuretic_thztype);
        htmeds01=.;
		if &msrin = msra then do;
            if &quest="N" then htmeds01=0; 
            if &quest="Y" then htmeds01=1; 
            if &quest=" " and msra2="T" then htmeds01=0; 
            if &quest="Y" and msra2="T" then htmeds01=.;
			datatemp = 5;
        end;
 
        if &msrin = msrb then do;
            if &quest=2 then htmeds01=0; 
            if &quest=1 then htmeds01=1; 
            if &quest=" " and msrb2="T" then htmeds01=0; 
            if &quest=1 and msrb2="T" then htmeds01=.;
			datatemp = 10;
        end;

		if &msrin = msrc then do;
            if &quest=2 then htmeds01=0; 
            if &quest=1 then htmeds01=1; 
            if &quest=" " and msrc2="T" then htmeds01=0; 
            if &quest=1 and msrc2="T" then htmeds01=.;
			datatemp = 15;
        end;
		uncontrolledbp = 0;
        if sbp > 130 OR dbp > 80 then uncontrolledbp = 1;

        /*treated for htn at baseline*/
        htntx=0;
        if htmeds01=1 and antihtnclass2>0 then htntx=1; 
        /*prevalent atrh at baseline*/
        prevatrh=0;
        if htmeds01=. then prevatrh=.;
        if uncontrolledbp=1 and antihtnclass2>=2 and diuretic=1 then prevatrh=1;
        if antihtnclass2>=3 and diuretic=1 then prevatrh=1;

	run;

	proc freq data = temp; 
		tables htmeds01 datatemp diuretic prevatrh beta ccb;
	run;

	data save.&trhtn;
		set temp;
		keep subjid htmeds01 diuretic prevatrh uncontrolledbp;
	run;

%mend;

%htnwork ('C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\AnalysisData\1-data',
          'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit1\1-data',
          'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit1',
		   msra,msra30a,analysis1,htmeds_v1,trhtn_v1);

%htnwork ('C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\AnalysisData\1-data',
          'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit2\1-data',
          'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit2',
           msrb,msrb29a,analysis2,htmeds_v2,trhtn_v2);

%htnwork ('C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\AnalysisData\1-data',
          'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit3\1-data',
          'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit3',
           msrc,msrc29a,analysis3,htmeds_v3,trhtn_v3);

libname savev1 'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit1';
libname savev2 'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit2';
libname savev3 'C:\Users\litkowse\Desktop\Vanguard_2016\Vanguard_2016\data\Visit3';

proc freq data = savev1.trhtn_v1; tables diuretic prevatrh uncontrolledbp; run;
proc freq data = savev2.trhtn_v2; tables diuretic prevatrh uncontrolledbp; run;
proc freq data = savev3.trhtn_v3; tables diuretic prevatrh uncontrolledbp; run;

proc contents data = savev1.trhtn_v1; run;
proc contents data = savev2.trhtn_v2; run;
proc contents data = savev3.trhtn_v3; run;
