USE PharmacyStoreDB;
GO
EXEC sp_changedbowner 'sa';
GO

create or alter function nofprescripedmidicines(@pid int)
returns int
  begin 
     declare @num int
	 select @num = count( pr.Drug_ID)
	 from  Prescription pr
	 where pr.PID=@pid
	 

	 RETURN @num
  end 

 select dbo.nofprescripedmidicines(2)


 create or alter TRIGGER autoupdatet_p
on dbo.patient
AFTER update
AS
update P set pid = i.PID , name =i.name , sex=i.sex , address=i.address,contact_no=i.contact_no,insurance_info=i.insurance_info
				from  dbo.Patient p inner join inserted i 
				on p.PID=i.PID or p.name =i.name or p.sex=i.sex or p.address=i.address or p.contact_no=i.contact_no or p.insurance_info=i.insurance_info

with drug_order as (select s.Sale_ID, s.Drug_ID ,d.Trade_Name,count(s.Sale_ID)over(partition by s.drug_id order by s.drug_id) as c
					from Sale s , Drug d
					where s.Drug_ID=d.Drug_ID)

select  do.Drug_ID , do.Trade_Name , ROW_NUMBER()over(partition by do.drug_id order by do.c ) as n_of_sales
from drug_order do 	



create rule prescription_date as @x< getdate()+1
go
sp_bindrule  prescription_date, '[dbo].[prescription].[Date]'


insert into Prescription(Pres_ID,PID,Phys_ID,Drug_ID,Date,Quantity,Price) values (70,14,4,14,'12-12-2025',40,40)

create or alter proc delete_patient @dpid int
as
delete from  prescription
where PID=@dpid
delete from patient 
where PID=@dpid
execute delete_patient 130

declare doc_with_more_than_4_patients cursor
for 
    select distinct d.Phys_ID,d.D_name,count(p.PID)over(partition by p.phys_id order by p.phys_id) as nop
	from Prescription p , Doctor d
	where p.Phys_ID = d.Phys_ID

for READ ONLY
declare @Phys_ID varchar(10) , @D_name varchar(50),@nop int , @doc_names_with_more_than_4 varchar(50)
open doc_with_more_than_4_patients

fetch doc_with_more_than_4_patients into  @Phys_ID,@D_name , @nop
while @@FETCH_STATUS=0
begin
if  @nop > 4
set @doc_names_with_more_than_4 = @D_name

   fetch doc_with_more_than_4_patients into @Phys_ID,@D_name , @nop
end
select @doc_names_with_more_than_4
close doc_with_more_than_4_patients
deallocate doc_with_more_than_4_patients 

