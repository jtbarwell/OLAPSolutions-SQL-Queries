-- Note to reader: These are queries I have stored outside of actual use. The blocked off queries are being used
--                 in an XML file on-prem of a client. I created this and a related excel workbook so the client
--                 would have simple, visual access to see what was going on behind the scenes of their Employee
--                 module procedures.




use xlLegal;
-- update EmployeeRecord set  ModifiedDate = getdate() where VersionCtrlID = 19 and EmployeeGLID = 16

-- ----------------------------------------------
-- Calculation On/Off
-- ----------------------------------------------
select
	*
from
	ScalarSettings
where
	ScalarName = 'PollChanges'
-- ==============================================



-- ----------------------------------------------
-- Show Calculation Queue
-- ----------------------------------------------
select
		CalculationQueue.InsertTimestamp,	VersionControl.VersionCtrlID,	EmployeeRecord.EmpRecID,
		Employee.LastName,					Employee.FirstName,				Employee.EmpID,
		Employee.EmployeeID,				CalculationQueue.[Status]
from 
	CalculationQueue
inner join			VersionControl	on	CalculationQueue.VersionCtrlID  =  VersionControl.VersionCtrlID
left outer join		EmployeeRecord	on	CalculationQueue.EmpRecID		=  EmployeeRecord.EmpRecID
left outer join		Employee		on	Employee.EmpID					=  EmployeeRecord.EmpID
-- ==============================================



-- ----------------------------------------------
-- Show Employee Calculation RunTime Info
-- ----------------------------------------------
select
	Item = 'Employee Calculation Status', 
	[value] = case when ScalarValue = 1 then 'Enabled' else 'Disabled' end 
from 
	ScalarSettings 
where ScalarName = 'PollChanges'

union all
	select --top 1 
		* 
	from (
			select 
				Item = 'Employee Calculation Running', 
				[value] =	case	when exists		(select top 1 'Record' as 'True check'  from CalculationQueue where isnull(status,0)  = 2) then 'True'
									else 'False'
							end
			) as T
-- ==============================================



-- ----------------------------------------------
-- Show Version Controls
-- ----------------------------------------------
select
	ModifiedDate,	VersionCtrlID,	FiscalYear,	Scenario,
	Version,		GLBook,			Status
from
	VersionControl
-- ==============================================



-- ----------------------------------------------
-- Show query datetime
-- ----------------------------------------------
select top 1
	LastCalculatedTimestamp
from
	CalculatedLog
order by LastCalculatedTimestamp desc 	-- gets most recent calculation time over all VersionCtrlID's
-- ==============================================
