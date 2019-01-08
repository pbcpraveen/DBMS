SQL> REM ***SSN COLLEGE OF ENGINEERING***
SQL> REM ***DEPARTMENT OF COMPUTER SCIENCE ENGINEERING***
SQL> REM ***DATABASE MANAGEMENT SYSTEMS LAB***
SQL> REM ***Assignment 2: DML Fundamentals***
SQL> 
SQL> REM ***Drop nobel table***
SQL> drop table nobel;

Table dropped.

SQL> 
SQL> 
SQL> REM ***Creating nobel relation***
SQL> create table nobel(
  2  laureate_id number(3) constraint laur_pk PRIMARY KEY,
  3  name varchar2(30) constraint name_nn NOT NULL,
  4  gender char(1) constraint gen_ch check (gender in('m','f')),
  5  category char(3) constraint cat_ch check (category in('Phy','Che','Med','Lit','Pea','Eco','Lit')),
  6  field varchar2(25),
  7  year_award number(4),
  8  aff_role varchar2(30),
  9  dob date,
 10  country varchar2(10)
 11  );

Table created.

SQL> 
SQL> 
SQL> REM ***Populate nobel relation***
SQL> insert into nobel values(100,'Robert B. Laughlin','m','Phy','Condensed matter',1998,'Stanford University','01-nov-1950','USA');

1 row created.

SQL> insert into nobel values(101,'Horst L Stormer','m','Phy','Condensed matter',1998,'Columbia University','06-apr-1949','Germany');

1 row created.

SQL> insert into nobel values(102,'Daniel C. Tsui','m','Phy','Condensed matter',1998,'Princeton University','28-feb-1939','China');

1 row created.

SQL> insert into nobel values(103,'Walter Kohn','m','Che','Theoretical Chemistry',1998,'University of California','09-mar-1923','Austria');

1 row created.

SQL> insert into nobel values(104,'John Pople','m','Che','Theoretical Chemistry',1998,'North Western University','31-oct-1925','UK');

1 row created.

SQL> insert into nobel values(106,'John Hume','m','Pea','Negotiation',1998,'Labour party Leader','18-jan-1937','Ireland');

1 row created.

SQL> insert into nobel values(107,'David Trimble','m','Pea','Negotiation',1998,'Ulster Unionist party Leader','15-oct-1944','Ireland');

1 row created.

SQL> insert into nobel values(108,'Louis J Ignaroo','m','Med','Cardiovascular system',1998,'University of California','31-may-1941','USA');

1 row created.

SQL> insert into nobel values(109,'Amartya Sen','m','Eco','Welfare Economics',1998,'Trinity College','03-nov-1933','India');

1 row created.

SQL> insert into nobel values(110,'Jose Saramago','m','Lit','Portuguese',1998,null,'16-nov-1922','Portugal');

1 row created.

SQL> 
SQL> insert into nobel values(111,'Eric A Cornell','m','Phy','Atomic physics',2001,'University of Colorado','19-dec-1961','USA');

1 row created.

SQL> insert into nobel values(112,'Carl E Wieman','m','Phy','Atomic physics',2001,'University of Colorado','26-mar-1951','USA');

1 row created.

SQL> insert into nobel values(113,'Ryoji Noyori','m','Che','Organic Chemistry',2001,'Nagoya University','03-sep-1938','Japan');

1 row created.

SQL> insert into nobel values(114,'K Barry Sharpless','m','Che','Organic Chemistry',2001,'Scripps Research Institute','28-apr-1941','USA');

1 row created.

SQL> insert into nobel values(115,'Kofi Annan','m','Pea','World organizing',2001,'UN General','08-apr-1938','Ghana');

1 row created.

SQL> insert into nobel values(116,'Joerge A Akeriof','m','Eco','Economic of Information',2001,'University of California','17-jun-1940','USA');

1 row created.

SQL> insert into nobel values(117,'V S Naipaul','m','Lit','English',2001,null,'17-aug-1932','UK');

1 row created.

SQL> 
SQL> insert into nobel values(118,'Charles A Kao','m','Phy','Fiber technology',2009,'University of Hongkong','04-nov-1933','China');

1 row created.

SQL> insert into nobel values(119,'Willard S Boyle','m','Phy','Semiconductor technology',2009,'Bell Laboratories','19-aug-1924','Canada');

1 row created.

SQL> insert into nobel values(120,'George E Smith','m','Phy','Semiconductor technology',2009,'Bell Laboratories','10-may-1930','USA');

1 row created.

SQL> insert into nobel values(121,'Venkatraman Ramakrishnan','m','Che','Biochemistry',2009,'MRC Laboratory','19-aug-1952','India');

1 row created.

SQL> insert into nobel values(122,'Ada E Yonath','f','Che','Biochemistry',2009,'Weizmann Institute of Science','22-jun-1939','Isreal');

1 row created.

SQL> insert into nobel values(123,'Elizabeth H Blackburn','f','Med','Enzymes',2009,'University of California','26-nov-1948','Australia');

1 row created.

SQL> insert into nobel values(124,'Carol W Greider','f','Med','Enzymes',2009,'Johns Hopkins University','15-apr-1961','USA');

1 row created.

SQL> insert into nobel values(125,'Barack H Obama','m','Pea','World organizing',2009,'President of USA','04-aug-1961','USA');

1 row created.

SQL> insert into nobel values(126,'Oliver E Williamson','m','Eco','Economic governance',2009,'University of California','27-sep-1932','USA');

1 row created.

SQL> insert into nobel values(127,'Elinor Ostrom','m','Eco','Economic governance',2009,'Indiana University','07-aug-1933','USA');

1 row created.

SQL> insert into nobel values(128,'Herta Muller','f','Lit','German',2009,null,'17-aug-1953','Romania');

1 row created.

SQL> 
SQL> REM ***************************END OF INSERT****************************************
SQL> REM 1. Display the nobel laureate(s) who born after 1-Jul-1960.
SQL> 
SQL> select *
  2  from nobel
  3  where dob > '01-jul-1960';

LAUREATE_ID NAME                           G CAT FIELD                          
----------- ------------------------------ - --- -------------------------      
YEAR_AWARD AFF_ROLE                       DOB       COUNTRY                     
---------- ------------------------------ --------- ----------                  
        111 Eric A Cornell                 m Phy Atomic physics                 
      2001 University of Colorado         19-DEC-61 USA                         
                                                                                
        124 Carol W Greider                f Med Enzymes                        
      2009 Johns Hopkins University       15-APR-61 USA                         
                                                                                
        125 Barack H Obama                 m Pea World organizing               
      2009 President of USA               04-AUG-61 USA                         
                                                                                

SQL> REM 2. Display the Indian laureate (name, category, field, country, year awarded) who was awarded in the Chemistry category.
SQL> 
SQL> select name,category,field,country,year_award
  2  from nobel
  3  where country = 'India' and category = 'Che';

NAME                           CAT FIELD                     COUNTRY            
------------------------------ --- ------------------------- ----------         
YEAR_AWARD                                                                      
----------                                                                      
Venkatraman Ramakrishnan       Che Biochemistry              India              
      2009                                                                      
                                                                                

SQL> 
SQL> REM 3. Display the laureates (name, category,field and year of award) who was awarded
SQL> REM    between 2000 and 2005 for the Physics or Chemistry category.
SQL> 
SQL> select name,category,field,year_award
  2  from nobel
  3  where  year_award between 2000 and 2005;

NAME                           CAT FIELD                     YEAR_AWARD         
------------------------------ --- ------------------------- ----------         
Eric A Cornell                 Phy Atomic physics                  2001         
Carl E Wieman                  Phy Atomic physics                  2001         
Ryoji Noyori                   Che Organic Chemistry               2001         
K Barry Sharpless              Che Organic Chemistry               2001         
Kofi Annan                     Pea World organizing                2001         
Joerge A Akeriof               Eco Economic of Information         2001         
V S Naipaul                    Lit English                         2001         

7 rows selected.

SQL> REM 4. Display the laureates name with their age at the time of award for the Peace category.
SQL> 
SQL> select name, (year_award - extract(year from dob)) as age
  2  from nobel
  3  where category = 'Pea';

NAME                                  AGE                                       
------------------------------ ----------                                       
John Hume                              61                                       
David Trimble                          54                                       
Kofi Annan                             63                                       
Barack H Obama                         48                                       

SQL> REM 5. Display the laureates (name,category,aff_role,country) whose name starts with A or ends with a, but not from Isreal.
SQL> 
SQL> select name,category,aff_role,country
  2  from nobel
  3  where (name like 'A%' or name like '%a' ) and country not in ('Isreal');

NAME                           CAT AFF_ROLE                       COUNTRY       
------------------------------ --- ------------------------------ ----------    
Amartya Sen                    Eco Trinity College                India         
Barack H Obama                 Pea President of USA               USA           

SQL> REM 6. Display the name, gender, affiliation, dob and country of laureates who was born in 1950's.
SQL> REM    Label the dob column as Born 1950.
SQL> 
SQL> select name, gender, aff_role, dob as born_on_1950,country
  2  from nobel
  3  where extract(year from dob) = 1950;

NAME                           G AFF_ROLE                       BORN_ON_1       
------------------------------ - ------------------------------ ---------       
COUNTRY                                                                         
----------                                                                      
Robert B. Laughlin             m Stanford University            01-NOV-50       
USA                                                                             
                                                                                

SQL> REM 7. Display the laureates (name,gender,category,aff_role,country) whose name start with
SQL> REM    A,D,or H. Remove the laureate if he/she do not have any affiliation. Sort the results in ascending
SQL> REM    order of name.
SQL> 
SQL> select name,gender,category,aff_role,country
  2  from nobel
  3  where (name like 'A%' or name like 'D%' or name like 'H%') and (aff_role is not null)
  4  order by name;

NAME                           G CAT AFF_ROLE                       COUNTRY     
------------------------------ - --- ------------------------------ ----------  
Ada E Yonath                   f Che Weizmann Institute of Science  Isreal      
Amartya Sen                    m Eco Trinity College                India       
Daniel C. Tsui                 m Phy Princeton University           China       
David Trimble                  m Pea Ulster Unionist party Leader   Ireland     
Horst L Stormer                m Phy Columbia University            Germany     

SQL> REM 8. Display the university name(s) that has to its credit by having at least 2 nobel laureate REM     with them.
SQL> 
SQL> select aff_role as University, count(*) as nobels
  2  from nobel
  3  where aff_role like '%University%'
  4  group by aff_role
  5  having count(*)>=2;

UNIVERSITY                         NOBELS                                       
------------------------------ ----------                                       
University of California                5                                       
University of Colorado                  2                                       

SQL> REM 9. List the date of birth of youngest and eldest laureates by countrywise. Label the
SQL> REM     column as  Younger, Elder respectively. Include only the country having more than one
SQL> REM     laureate. Sort the output in alphabetical order of country.
SQL> 
SQL> select country, max(dob) as Younger, min(dob) as Elder
  2  from nobel
  3  group by country
  4  having count(*) > 1
  5  order by country;

COUNTRY    YOUNGER   ELDER                                                      
---------- --------- ---------                                                  
China      28-FEB-39 04-NOV-33                                                  
India      19-AUG-52 03-NOV-33                                                  
Ireland    15-OCT-44 18-JAN-37                                                  
UK         17-AUG-32 31-OCT-25                                                  
USA        19-DEC-61 10-MAY-30                                                  

SQL> REM 9. List the date of birth of youngest and eldest laureates by countrywise. Label the
SQL> REM     column as  Younger, Elder respectively. Include only the country having more than one
SQL> REM     laureate. Sort the output in alphabetical order of country.
SQL> 
SQL> select country, max(dob) as Younger, min(dob) as Elder
  2  from nobel
  3  group by country
  4  having count(*) > 1
  5  order by country;

COUNTRY    YOUNGER   ELDER                                                      
---------- --------- ---------                                                  
China      28-FEB-39 04-NOV-33                                                  
India      19-AUG-52 03-NOV-33                                                  
Ireland    15-OCT-44 18-JAN-37                                                  
UK         17-AUG-32 31-OCT-25                                                  
USA        19-DEC-61 10-MAY-30                                                  

SQL> spool off
