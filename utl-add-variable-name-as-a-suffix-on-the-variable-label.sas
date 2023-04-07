%let pgm=utl-add-variable-name-as-a-suffix-on-the-variable-label;

  Add variable name as a suffix on the variable label

  For instance if the date and label are

    Variable     Label

    DATE         Order Date

  The new label will be

    DATE         Order Date (DATE)

  Two Solutions

       1. SAS SQL (original work by Paul Dorfman )
       2. WPS SQL (altering a WPD dataset)
       3, WPS SQL (Note WPS soes not support the SQL Alter statement on SAS datasets,
                   but does support the alter statement on WPS datasets.
                   I suspectthe code for operations on WPS datasets to be very clean,
                   becuse the legacy changes that SAS had to make to SAS datasets is simplified for WPS datasets.
                   SAS had to make changes and maintain backward capatability when SQL, HASH, DS2, Integrity ...
                   functionality was added to SAS datasets.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have;
  set sashelp.pricedata(drop=price1-price17) ;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                Variables in Creation Order                                                                             */
/*                                                                                                                        */
/*  Variable        Label                                                                                                 */
/*                                                                                                                        */
/*  DATE            Order Date                                                                                            */
/*  SALE            Unit Sale                                                                                             */
/*  PRICE           Unit Price                                                                                            */
/*  DISCOUNT        Price Discount                                                                                        */
/*  COST            Unit Cost                                                                                             */
/*  REGIONNAME      Sales Region                                                                                          */
/*  PRODUCTLINE     Name of product line                                                                                  */
/*  PRODUCTNAME     Product Name                                                                                          */
/*  REGION          Region ID                                                                                             */
/*  LINE            Product Line ID                                                                                       */
/*  PRODUCT         Product ID                                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

/*--- original work by Paul Dorfman ----*/

 proc sql  ;
  select
      catt (name,' label="',label,'(',name,')"')
 into
      :_modify separated by ", "
 from
      sashelp.vcolumn
 where
          libname = "WORK"
      and memname = "HAVE"
 ;
 alter
      table have
 modify
      &_modify
;quit ;

proc contents data=work.have;
run;quit;

/*                 _   _
  __ _ _   _  ___ | |_(_)_ __   __ _
 / _` | | | |/ _ \| __| | `_ \ / _` |
| (_| | |_| | (_) | |_| | | | | (_| |
 \__, |\__,_|\___/ \__|_|_| |_|\__, |
    |_|                        |___/
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/* You can work aroung quoting issues when dropping down to any of my languages ir PERL, Powershell, WPS, R or Python     */
/* by defining macro variables with outside single quotes ie ; 'label="' and then delaying resolution with NRSTR.         */
/*                                                                                                                        */
/* I use resolve to make sure a final ewsolution was done                                                                 */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                                        _ _
__      ___ __  ___   _ __   ___     __ _| | |_ ___ _ __
\ \ /\ / / `_ \/ __| | `_ \ / _ \   / _` | | __/ _ \ `__|
 \ V  V /| |_) \__ \ | | | | (_) | | (_| | | ||  __/ |
  \_/\_/ | .__/|___/ |_| |_|\___/   \__,_|_|\__\___|_|
         |_|
*/

data have;
  set sashelp.pricedata(drop=price1-price17) ;
run;quit;

%let work=%sysfunc(pathname(work));

%let _beg = ' label="';
%let _end = ')"';

%put &_beg;
%put &_end;

%utl_submit_wps64(resolve("

 libname wrk  '&work';

 proc contents data=wrk.have;
 run;quit;

 proc sql  ;
  select
      %nrstr(catt (name,&_beg,label,'(',name,&_end) )
 into
      :_modify separated by ' '
 from
      sashelp.vcolumn
 where
          libname = 'WRK'
      and memname = 'HAVE'
;quit;

data want;
  set wrk.have;
  attrib
      %nrstr(&_modify)
  ;
run;quit;

proc contents data=want;
run;quit;

"));

/**************************************************************************************************************************/
/*                                                                                                                        */
/*                                                                                                                        */
/* The WPS System                                                                                                         */
/*                                                                                                                        */
/* he CONTENTS Procedure                                                                                                  */
/*                                                                                                                        */
/* ata Set Name           WANT                                                                                            */
/* ember Type             DATA                                                                                            */
/* ngine                  WPD                                                                                             */
/* reated                 07APR2023:10:27:36                                                                              */
/* ast Modified           07APR2023:10:27:36                                                                              */
/* bservations                  1020                                                                                      */
/* ariables               11                                                                                              */
/* ndexes                 0                                                                                               */
/* bservation Length      85                                                                                              */
/* eleted Observations             0                                                                                      */
/* ata Set Type                                                                                                           */
/* abel                                                                                                                   */
/* ompressed              NO                                                                                              */
/* orted                  NO                                                                                              */
/* ata Representation     Little endian, IEEE Windows                                                                     */
/* ncoding                wlatin1 Windows-1252 Western                                                                    */
/*                                                                                                                        */
/*           Engine/Host Dependent Information                                                                            */
/*                                                                                                                        */
/* ata Set Page Size          4096                                                                                        */
/* umber of Data Set Pages    23                                                                                          */
/* irst Data Page             1                                                                                           */
/* ax Obs Per Page            48                                                                                          */
/* bs In First Data Page      48                                                                                          */
/* ata Set Diagnostic Code    0009                                                                                        */
/* ile Name                   d:\wrkwps\_TD14380\WANT.wpd                                                                 */
/* PD Engine Version          3                                                                                           */
/* arge Data Set Support      no                                                                                          */
/*                                                                                                                        */
/*                                   Alphabetic List of Variables and Attributes                                          */
/*                                                                                                                        */
/*      Number    Variable       Type             Len             Pos    Format    Label                                  */
/* _________________________________________________________________________________________________________________      */
/*           5    COST           Num                8              32              Unit Cost(COST)                        */
/*           1    DATE           Num                8               0    MONYY.    Order Date(DATE)                       */
/*           4    DISCOUNT       Num                8              24              Price Discount(DISCOUNT)               */
/*          10    LINE           Num                8              48    6.        Product Line ID(LINE)                  */
/*           3    PRICE          Num                8              16              Unit Price(PRICE)                      */
/*          11    PRODUCT        Num                8              56    6.        Product ID(PRODUCT)                    */
/*           7    PRODUCTLINE    Char               5              71              Name of product line(PRODUCTLINE)      */
/*           8    PRODUCTNAME    Char               9              76              Product Name(PRODUCTNAME)              */
/*           9    REGION         Num                8              40    6.        Region ID(REGION)                      */
/*           6    REGIONNAME     Char               7              64              Sales Region(REGIONNAME)               */
/*           2    SALE           Num                8               8              Unit Sale(SALE)                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                          _ _
__      ___ __  ___    __ _| | |_ ___ _ __
\ \ /\ / / `_ \/ __|  / _` | | __/ _ \ `__|
 \ V  V /| |_) \__ \ | (_| | | ||  __/ |
  \_/\_/ | .__/|___/  \__,_|_|\__\___|_|
         |_|
*/

data have;
  set sashelp.pricedata(drop=price1-price17) ;
run;quit;

%let work=%sysfunc(pathname(work));

%let _beg = ' label="';
%let _end = ')"';

%put &_beg;
%put &_end;

%utl_submit_wps64(resolve("

 libname wrk  '&work';
 libname wpd wpd 'd:/wpd';

 proc datasets lib=wpd nolist nodetails; ;
  delete have;
 run;quit;

 data wpd.have;
   set wrk.have;
 run;quit;

 proc contents data=wpd.have;
 run;quit;

 proc sql  ;
  select
      %nrstr(catt (name,&_beg,label,'(',name,&_end ) )
 into
      :_modify separated by ','
 from
      sashelp.vcolumn
 where
          libname = 'WRK'
      and memname = 'HAVE'
;
 alter
      table wpd.have
 modify
      %nrstr(&_modify)
;quit ;

proc contents data=wpd.have;
run;quit;

"));

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
