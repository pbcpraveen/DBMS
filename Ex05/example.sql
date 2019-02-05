set serveroutput on;


DECLARE
   mgr_no departments.manager_id%type;
  BEGIN
    mgr_no:=&m_no;
    DELETE FROM departments WHERE manager_id = mgr_no;
     DBMS_OUTPUT.PUT_LINE
       ('Number of employees deleted: ' || TO_CHAR(SQL%ROWCOUNT));
   END;
/


Enter value for m_no: 2
old   4:     mgr_no:=&m_no;
new   4:     mgr_no:=2;

PL/SQL procedure successfully completed.



declare
        ename employees.first_name%type;
        esal employees.salary%type;
        num employees.employee_id%type;
        inc number(6);
        begin
          num:=&eno;
          inc:=&increment;
         update employees set salary=salary+inc where employee_id=num;
       if sql%NotFound then
         select employee_id,first_name,salary into num,ename,esal from employees where        employee_id=num;
         dbms_output.put_line('Number:'||num||' Name'||ename||' Salary is.'||esal);
        else
         dbms_output.put_line('Record NOT FOUND !!!');
       end if;
     end;


Enter value for eno: 103
old   7:       num:=&eno;
new   7:       num:=103;
Enter value for increment: 1000
old   8:       inc:=&increment;
new   8:       inc:=1000;
Number:103 NameAlexander Salary is.10000


declare
         eno employees.employee_id%type;
         ename employees.first_name%type;
         esal employees.salary%type;
          jid employees.job_id%type;
          inc number(6);
         begin
            jid:='&jobid';
            inc:=&increment;
          update employees set salary=salary+inc where job_id=jid;
        if sql%found then
           dbms_output.put_line('Number of Rows Affected:'||SQL%ROWCOUNT);
       else
          dbms_output.put_line('Record NOT FOUND !!!');
       end if;
    end;
/
       

Enter value for jobid: ST_CLERK
old   8:             jid:='&jobid';
new   8:             jid:='ST_CLERK';
Enter value for increment: 500
old   9:             inc:=&increment;
new   9:             inc:=500;
Number of Rows Affected:4

PL/SQL procedure successfully completed.




 DECLARE
      dept_no dept_temp.DEPARTMENT_ID%type;
       dept_no1 dept_temp. DEPARTMENT_ID%type;
     BEGIN
        dept_no:=&dno;
        DELETE FROM dept_temp WHERE department_id = dept_no;
        IF SQL%FOUND THEN
           dbms_output.put_line('Number of Rows Affected:'||SQL%ROWCOUNT);
            else
         INSERT INTO dept_temp VALUES (270, 'Personnel', 200, 1700);
      END IF;
  END;


Enter value for dno: 60
old   5:        dept_no:=&dno;
new   5:        dept_no:=60;
Number of Rows Affected:1

PL/SQL procedure successfully completed.

SQL> select * from dept_temp;

DEPARTMENT_ID DEPARTMENT_NAME                MANAGER_ID LOCATION_ID
------------- ------------------------------ ---------- -----------
           10 Administration                        200        1700
           20 Marketing                             201        1800
           50 Shipping                              121        1500
           80 Sales                                 145        2500
           90 Executive                             100        1700
          100 Finance                               108        1700
          110 Accounting                            205        1700
          190 Contracting                                      1700
           70 public relations                      100        1700
           30 public relations
          120 public relations


  declare
     emp employees%rowtype;
      cursor c1 is select employee_id,first_name,salary from employees order by salary desc;
      counter number(2);
      begin
     open c1;
     for count in 1..10 loop
            fetch c1 into emp.employee_id,emp.first_name, emp.salary;
            dbms_output.put_line(' Emp Number'||emp.employee_id||' Name '||emp.first_name||' Salary is '||emp.salary);
    end loop;
   end;
 /
Number100 Name Steven Salary is 24000
Number101 Name Neena Salary is 17000
Number102 Name Lex Salary is 17000
Number206 Name William Salary is 13000
Number201 Name Michael Salary is 13000
Number205 Name Shelley Salary is 12000
Number174 Name Ellen Salary is 11000
Number149 Name Eleni Salary is 10500
Number103 Name Alexander Salary is 9000
Number176 Name Jonathon Salary is 8600



create or replace procedure emp_det(eno IN employees.employee_id%type, name OUT employees.first_name%type, sal OUT employees.salary%type) is
    begin
    select first_name,salary into name,sal from employees where employee_id=eno;
   end;



 declare
    eno employees.employee_id%type;
    name employees.first_name%type;
    sal employees.salary%type;
    begin
    eno:=&eno;
    emp_det(eno,name,sal);
    dbms_output.put_line('Eno: '||eno||' Name is: '||name||' Salary. '||sal);
   end;

Enter value for eno: 100
old   6:     eno:=&eno;
new   6:     eno:=100;
Eno: 100 Name is: Steven Salary. 24000




function:

 create or replace function emp_sal(eno employees.employee_id%type) return real is
    sal employees.salary%type;
    begin
    select salary into sal from employees where employee_id=eno;
    dbms_output.put_line('salary '||sal);
    return sal;
   end;


  1  declare
  2      eno employees.employee_id%type;
  3     name employees.first_name%type;
  4      sal employees.salary%type;
  5      begin
  6      eno:=&eno;
  7     sal:= emp_sal(eno);
  8      dbms_output.put_line('Eno: '||eno||'  '||name||' Salary. '||sal);
  9*    end;
 10  /
Enter value for eno: 100
old   6:     eno:=&eno;
new   6:     eno:=100;
salary 24000
Eno: 100   Salary. 24000

PL/SQL procedure successfully completed.

/