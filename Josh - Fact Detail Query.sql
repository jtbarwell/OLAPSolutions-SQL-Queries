-- Note to reader: I created this "query" (though it may be closer in definition to a stored procedure but I am unsure) so that
--                 as myself or any of my coworkers needed to get a closer look at the specifics of the client's data, they could
--                 run this query, with their specifications, and get the key for the item, name, and description of whatever they
--                 wanted to look at. This way we aren't scrolling through (literally) hundreds of thousands, if not millions of records





-- ========================================================
-- Detailed FactDetail Query
-- Contains Key, Name, Desc. of all dimensions
-- Joshua Barwell:	15/07/2024
-- ========================================================
set nocount on;

-- --------------------------------------------------------
-- Implementation Config
-- --------------------------------------------------------
declare @Seg1Alias			nvarchar(100) = 'GL Unit'
declare @Seg2Alias			nvarchar(100) = 'Unit Local'
declare @Seg3Alias			nvarchar(100) = 'GL Natural'
declare @Seg4Alias			nvarchar(100) = 'GL Office'
declare @Seg5Alias			nvarchar(100) = 'GL Department'
declare @Seg6Alias			nvarchar(100) = 'GL Activity'
declare @Seg7Alias			nvarchar(100) = 'Seg7'
declare @Seg8Alias			nvarchar(100) = 'Seg8'
declare @Seg9Alias			nvarchar(100) = 'Seg9'
declare @Seg10Alias			nvarchar(100) = 'Seg10'
declare @CustomSeg1Alias	nvarchar(100) = 'Title'
declare @CustomSeg2Alias	nvarchar(100) = 'CustomSeg2'
declare @CustomSeg3Alias	nvarchar(100) = 'CustomSeg3'
declare @CustomSeg4Alias	nvarchar(100) = 'CustomSeg4'
declare @CustomSeg5Alias	nvarchar(100) = 'CustomSeg5'
-- ========================================================



-- --------------------------------------------------------
-- Declaration of Variables
-- --------------------------------------------------------
declare @tables			nvarchar(100) = '(All Tables)'
declare @topNumRows		int			  = 100
										
declare @FiscalYear		nvarchar(100) = 'Total Fiscal Year'
declare @Period			nvarchar(100) = 'Total Period'
declare @Currency		nvarchar(100) = 'Total Currency'
declare @Scenario		nvarchar(100) = 'Total Scenario'
declare @Value			nvarchar(100) = 'Total Value'
declare @Version		nvarchar(100) = 'Total Version'
declare @Calendar		nvarchar(100) = 'Total Calendar'
declare @GLBook			nvarchar(100) = 'Total GL Book'
declare @Seg1			nvarchar(100) = 'Total GL Unit'
declare @Seg2			nvarchar(100) = 'Total Unit Local'
declare @Seg3			nvarchar(100) = 'Total GL Natural'
declare @Seg4			nvarchar(100) = 'Total GL Office'
declare @Seg5			nvarchar(100) = 'Total GL Department'
declare @Seg6			nvarchar(100) = 'Total GL Activity'
declare @Seg7			nvarchar(100) = 'NA'						
declare @Seg8			nvarchar(100) = 'NA'						
declare @Seg9			nvarchar(100) = 'NA'						
declare @Seg10			nvarchar(100) = 'NA'						
declare @CustomSeg1		nvarchar(100) = 'Total Title'	
declare @CustomSeg2		nvarchar(100) = 'NA'						
declare @CustomSeg3		nvarchar(100) = 'NA'						
declare @CustomSeg4		nvarchar(100) = 'NA'						
declare @CustomSeg5		nvarchar(100) = 'NA'					
-- ========================================================



-- --------------------------------------------------------
-- Create temp tables from dimensions
-- --------------------------------------------------------
drop table if exists #TMP_FiscalYear;	select DimFiscalYear.FiscalYearKey, DimFiscalYear.MemberName,	DimFiscalYear.MemberDescription		into #TMP_FiscalYear	from DimFiscalYear	where DimFiscalYear.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants('Fiscal Year',		@FiscalYear))
drop table if exists #TMP_Period;		select DimPeriod.PeriodKey,			DimPeriod.MemberName,		DimPeriod.MemberDescription			into #TMP_Period		from DimPeriod		where DimPeriod.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants('Period',			@Period))
drop table if exists #TMP_Currency;		select DimCurrency.CurrencyKey,		DimCurrency.MemberName,		DimCurrency.MemberDescription		into #TMP_Currency		from DimCurrency	where DimCurrency.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants('Currency',			@Currency))
drop table if exists #TMP_Scenario;		select DimScenario.ScenarioKey,		DimScenario.MemberName,		DimScenario.MemberDescription		into #TMP_Scenario		from DimScenario	where DimScenario.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants('Scenario',			@Scenario))
drop table if exists #TMP_Value;		select DimValue.ValueKey,			DimValue.MemberName,		DimValue.MemberDescription			into #TMP_Value			from DimValue		where DimValue.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants('Value',			@Value))
drop table if exists #TMP_Version;		select DimVersion.VersionKey,		DimVersion.MemberName,		DimVersion.MemberDescription		into #TMP_Version		from DimVersion		where DimVersion.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants('Version',			@Version))
drop table if exists #TMP_GLBook;		select DimGLBook.GLBookKey,			DimGLBook.MemberName,		DimGLBook.MemberDescription			into #TMP_GLBook		from DimGLBook		where DimGLBook.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants('GL Book',			@GLBook))
drop table if exists #TMP_Calendar;		select DimCalendar.CalendarKey,		DimCalendar.MemberName,		DimCalendar.MemberDescription		into #TMP_Calendar		from DimCalendar	where DimCalendar.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants('Calendar',			@Calendar))
drop table if exists #TMP_Seg1;			select DimSeg1.Seg1Key,				DimSeg1.MemberName,			DimSeg1.MemberDescription			into #TMP_Seg1			from DimSeg1		where DimSeg1.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg1Alias,			@Seg1))
drop table if exists #TMP_Seg2;			select DimSeg2.Seg2Key,				DimSeg2.MemberName,			DimSeg2.MemberDescription			into #TMP_Seg2			from DimSeg2		where DimSeg2.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg2Alias,			@Seg2))
drop table if exists #TMP_Seg3;			select DimSeg3.Seg3Key,				DimSeg3.MemberName,			DimSeg3.MemberDescription			into #TMP_Seg3			from DimSeg3		where DimSeg3.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg3Alias,			@Seg3))
drop table if exists #TMP_Seg4;			select DimSeg4.Seg4Key,				DimSeg4.MemberName,			DimSeg4.MemberDescription			into #TMP_Seg4			from DimSeg4		where DimSeg4.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg4Alias,			@Seg4))
drop table if exists #TMP_Seg5;			select DimSeg5.Seg5Key,				DimSeg5.MemberName,			DimSeg5.MemberDescription			into #TMP_Seg5			from DimSeg5		where DimSeg5.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg5Alias,			@Seg5))
drop table if exists #TMP_Seg6;			select DimSeg6.Seg6Key,				DimSeg6.MemberName,			DimSeg6.MemberDescription			into #TMP_Seg6			from DimSeg6		where DimSeg6.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg6Alias,			@Seg6))
drop table if exists #TMP_Seg7;			select DimSeg7.Seg7Key,				DimSeg7.MemberName,			DimSeg7.MemberDescription			into #TMP_Seg7			from DimSeg7		where DimSeg7.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg7Alias,			@Seg7))
drop table if exists #TMP_Seg8;			select DimSeg8.Seg8Key,				DimSeg8.MemberName,			DimSeg8.MemberDescription			into #TMP_Seg8			from DimSeg8		where DimSeg8.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg8Alias,			@Seg8))
drop table if exists #TMP_Seg9;			select DimSeg9.Seg9Key,				DimSeg9.MemberName,			DimSeg9.MemberDescription			into #TMP_Seg9			from DimSeg9		where DimSeg9.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg9Alias,			@Seg9))
drop table if exists #TMP_Seg10;		select DimSeg10.Seg10Key,			DimSeg10.MemberName,		DimSeg10.MemberDescription			into #TMP_Seg10			from DimSeg10		where DimSeg10.MemberName		in (select MemberName from dbo.fnc_Metadata_Descendants(@Seg10Alias,		@Seg10))
drop table if exists #TMP_CustomSeg1;	select DimCustomSeg1.CustomSeg1Key, DimCustomSeg1.MemberName,	DimCustomSeg1.MemberDescription		into #TMP_CustomSeg1	from DimCustomSeg1	where DimCustomSeg1.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants(@CustomSeg1Alias,	@CustomSeg1))
drop table if exists #TMP_CustomSeg2;	select DimCustomSeg2.CustomSeg2Key, DimCustomSeg2.MemberName,	DimCustomSeg2.MemberDescription		into #TMP_CustomSeg2	from DimCustomSeg2	where DimCustomSeg2.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants(@CustomSeg2Alias,	@CustomSeg2))
drop table if exists #TMP_CustomSeg3;	select DimCustomSeg3.CustomSeg3Key, DimCustomSeg3.MemberName,	DimCustomSeg3.MemberDescription		into #TMP_CustomSeg3	from DimCustomSeg3	where DimCustomSeg3.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants(@CustomSeg3Alias,	@CustomSeg3))
drop table if exists #TMP_CustomSeg4;	select DimCustomSeg4.CustomSeg4Key, DimCustomSeg4.MemberName,	DimCustomSeg4.MemberDescription		into #TMP_CustomSeg4	from DimCustomSeg4	where DimCustomSeg4.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants(@CustomSeg4Alias,	@CustomSeg4))
drop table if exists #TMP_CustomSeg5;	select DimCustomSeg5.CustomSeg5Key, DimCustomSeg5.MemberName,	DimCustomSeg5.MemberDescription		into #TMP_CustomSeg5	from DimCustomSeg5	where DimCustomSeg5.MemberName	in (select MemberName from dbo.fnc_Metadata_Descendants(@CustomSeg5Alias,	@CustomSeg5))
drop table if exists #TMP_GLSecurity;	select DimGLSecurity.GLSecurityKey,	DimGLSecurity.MemberName,	DimGLSecurity.MemberDescription		into #TMP_GLSecurity	from DimGLSecurity
-- ========================================================



-- --------------------------------------------------------
-- Create Index for Temp Tables
-- --------------------------------------------------------
create index #IX_FiscalYear		on #TMP_FiscalYear(FiscalYearKey)
create index #IX_Period			on #TMP_Period(PeriodKey)
create index #IX_Currency		on #TMP_Currency(CurrencyKey)
create index #IX_Scenario		on #TMP_Scenario(ScenarioKey)
create index #IX_Value			on #TMP_Value(ValueKey)
create index #IX_Version		on #TMP_Version(VersionKey)
create index #IX_GLBook			on #TMP_GLBook(GLBookKey)
create index #IX_Calendar		on #TMP_Calendar(CalendarKey)
create index #IX_Seg1			on #TMP_Seg1(Seg1Key)
create index #IX_Seg2			on #TMP_Seg2(Seg2Key)
create index #IX_Seg3			on #TMP_Seg3(Seg3Key)
create index #IX_Seg4			on #TMP_Seg4(Seg4Key)
create index #IX_Seg5			on #TMP_Seg5(Seg5Key)
create index #IX_Seg6			on #TMP_Seg6(Seg6Key)
create index #IX_Seg7			on #TMP_Seg7(Seg7Key)
create index #IX_Seg8			on #TMP_Seg8(Seg8Key)
create index #IX_Seg9			on #TMP_Seg9(Seg9Key)
create index #IX_Seg10			on #TMP_Seg10(Seg10Key)
create index #IX_CustomSeg1		on #TMP_CustomSeg1(CustomSeg1Key)
create index #IX_CustomSeg2		on #TMP_CustomSeg2(CustomSeg2Key)
create index #IX_CustomSeg3		on #TMP_CustomSeg3(CustomSeg3Key)
create index #IX_CustomSeg4		on #TMP_CustomSeg4(CustomSeg4Key)
create index #IX_CustomSeg5		on #TMP_CustomSeg5(CustomSeg5Key)
create index #IX_GLSecurity		on #TMP_GLSecurity(GLSecurityKey)
-- ========================================================



-- --------------------------------------------------------
-- Create temporary results table
-- --------------------------------------------------------
drop table if exists #TMP_Result

create table #TMP_Result (
	SourceTable			nvarchar(100),
	FactId				int,
	Amount				float,
	FiscalYearKey		int ,		FiscalYearName	nvarchar(100),		FiscalYearDescription	nvarchar(100),
	PeriodKey			int ,		PeriodName		nvarchar(100),		PeriodDescription		nvarchar(100),
	CurrencyKey			int ,		CurrencyName	nvarchar(100),		CurrencyDescription		nvarchar(100),
	ScenarioKey			int ,		ScenarioName	nvarchar(100),		ScenarioDescription		nvarchar(100),
	ValueKey			int ,		ValueName		nvarchar(100),		ValueDescription		nvarchar(100),
	VersionKey			int ,		VersionName		nvarchar(100),		VersionDescription		nvarchar(100),
	GLBookKey			int ,		GLBookName		nvarchar(100),		GLBookDescription		nvarchar(100),
	CalendarKey			int ,		CalendarName	nvarchar(100),		CalendarDescription		nvarchar(100),
	Seg1Key				int ,		Seg1Name		nvarchar(100),		Seg1Description			nvarchar(100),
	Seg2Key				int ,		Seg2Name		nvarchar(100),		Seg2Description			nvarchar(100),
	Seg3Key				int ,		Seg3Name		nvarchar(100),		Seg3Description			nvarchar(100),
	Seg4Key				int ,		Seg4Name		nvarchar(100),		Seg4Description			nvarchar(100),
	Seg5Key				int ,		Seg5Name		nvarchar(100),		Seg5Description			nvarchar(100),
	Seg6Key				int ,		Seg6Name		nvarchar(100),		Seg6Description			nvarchar(100),
	Seg7Key				int ,		Seg7Name		nvarchar(100),		Seg7Description			nvarchar(100),
	Seg8Key				int ,		Seg8Name		nvarchar(100),		Seg8Description			nvarchar(100),
	Seg9Key				int ,		Seg9Name		nvarchar(100),		Seg9Description			nvarchar(100),
	Seg10Key			int ,		Seg10Name		nvarchar(100),		Seg10Description		nvarchar(100),
	CustomSeg1Key		int ,		CustomSeg1Name	nvarchar(100),		CustomSeg1Description	nvarchar(100),
	CustomSeg2Key		int ,		CustomSeg2Name	nvarchar(100),		CustomSeg2Description	nvarchar(100),
	CustomSeg3Key		int ,		CustomSeg3Name	nvarchar(100),		CustomSeg3Description	nvarchar(100),
	CustomSeg4Key		int ,		CustomSeg4Name	nvarchar(100),		CustomSeg4Description	nvarchar(100),
	CustomSeg5Key		int ,		CustomSeg5Name	nvarchar(100),		CustomSeg5Description	nvarchar(100),
	GLSecurityKey		int ,		GLSecurityName	nvarchar(100),		GLSecurityDescription	nvarchar(100),
	AuditTime			datetime,		AuditUser		nvarchar(100),		RefID nvarchar(100), BitMask nvarchar(100) -- this line is specifically for FactWriteback
)
-- ========================================================





-- --------------------------------------------------------
-- Process FactActual
-- --------------------------------------------------------

if @tables in ('(All Tables)', 'FactActual')
begin
	insert into #TMP_Result
		select top(@topNumRows)
			'FactActual',
			FactActual.FactID,
			FactActual.Amount,
			#TMP_FiscalYear.FiscalYearKey,		#TMP_FiscalYear.MemberName		, #TMP_FiscalYear.MemberDescription		,
			#TMP_Period.PeriodKey,				#TMP_Period.MemberName			, #TMP_Period.MemberDescription			,
			#TMP_Currency.CurrencyKey,			#TMP_Currency.MemberName		, #TMP_Currency.MemberDescription		,
			#TMP_Scenario.ScenarioKey,			#TMP_Scenario.MemberName		, #TMP_Scenario.MemberDescription		,
			#TMP_Value.ValueKey,				#TMP_Value.MemberName			, #TMP_Value.MemberDescription			,
			#TMP_Version.VersionKey,			#TMP_Version.MemberName			, #TMP_Version.MemberDescription		,
			#TMP_GLBook.GLBookKey,				#TMP_GLBook.MemberName			, #TMP_GLBook.MemberDescription			,
			#TMP_Calendar.CalendarKey,			#TMP_Calendar.MemberName		, #TMP_Calendar.MemberDescription		,
			#TMP_Seg1.Seg1Key,					#TMP_Seg1.MemberName			, #TMP_Seg1.MemberDescription			,
			#TMP_Seg2.Seg2Key,					#TMP_Seg2.MemberName			, #TMP_Seg2.MemberDescription 			,
			#TMP_Seg3.Seg3Key,					#TMP_Seg3.MemberName			, #TMP_Seg3.MemberDescription 			,
			#TMP_Seg4.Seg4Key,					#TMP_Seg4.MemberName			, #TMP_Seg4.MemberDescription 			,
			#TMP_Seg5.Seg5Key,					#TMP_Seg5.MemberName			, #TMP_Seg5.MemberDescription 			,
			#TMP_Seg6.Seg6Key,					#TMP_Seg6.MemberName			, #TMP_Seg6.MemberDescription 			,
			#TMP_Seg7.Seg7Key,					#TMP_Seg7.MemberName			, #TMP_Seg7.MemberDescription 			,
			#TMP_Seg8.Seg8Key,					#TMP_Seg8.MemberName			, #TMP_Seg8.MemberDescription 			,
			#TMP_Seg9.Seg9Key,					#TMP_Seg9.MemberName			, #TMP_Seg9.MemberDescription 			,
			#TMP_Seg10.Seg10Key,				#TMP_Seg10.MemberName			, #TMP_Seg10.MemberDescription			,
			#TMP_CustomSeg1.CustomSeg1Key,		#TMP_CustomSeg1.MemberName		, #TMP_CustomSeg1.MemberDescription		,
			#TMP_CustomSeg2.CustomSeg2Key,		#TMP_CustomSeg2.MemberName		, #TMP_CustomSeg2.MemberDescription		,
			#TMP_CustomSeg3.CustomSeg3Key,		#TMP_CustomSeg3.MemberName		, #TMP_CustomSeg3.MemberDescription		,
			#TMP_CustomSeg4.CustomSeg4Key,		#TMP_CustomSeg4.MemberName		, #TMP_CustomSeg4.MemberDescription		,
			#TMP_CustomSeg5.CustomSeg5Key,		#TMP_CustomSeg5.MemberName		, #TMP_CustomSeg5.MemberDescription		,
			#TMP_GLSecurity.GLSecurityKey,		#TMP_GLSecurity.MemberName		, #TMP_GLSecurity.MemberDescription		,
			Null as 'AuditTime',	Null as 'AuditUser',	Null as 'RefID',	Null as 'BitMask'
		from
			FactActual
		inner join #TMP_FiscalYear		on		#TMP_FiscalYear.FiscalYearKey	=	FactActual.FiscalYearKey
		inner join #TMP_Period			on		#TMP_Period.PeriodKey			=	FactActual.PeriodKey
		inner join #TMP_Currency		on		#TMP_Currency.CurrencyKey		=	FactActual.CurrencyKey
		inner join #TMP_Scenario		on		#TMP_Scenario.ScenarioKey		=	FactActual.ScenarioKey
		inner join #TMP_Value			on		#TMP_Value.ValueKey				=	FactActual.ValueKey
		inner join #TMP_Version			on		#TMP_Version.VersionKey			=	FactActual.VersionKey
		inner join #TMP_GLBook			on		#TMP_GLBook.GLBookKey			=	FactActual.GLBookKey
		inner join #TMP_Calendar		on		#TMP_Calendar.CalendarKey		=	FactActual.CalendarKey
		inner join #TMP_Seg1			on		#TMP_Seg1.Seg1Key				=	FactActual.Seg1Key
		inner join #TMP_Seg2			on		#TMP_Seg2.Seg2Key				=	FactActual.Seg2Key
		inner join #TMP_Seg3			on		#TMP_Seg3.Seg3Key				=	FactActual.Seg3Key
		inner join #TMP_Seg4			on		#TMP_Seg4.Seg4Key				=	FactActual.Seg4Key
		inner join #TMP_Seg5			on		#TMP_Seg5.Seg5Key				=	FactActual.Seg5Key
		inner join #TMP_Seg6			on		#TMP_Seg6.Seg6Key				=	FactActual.Seg6Key
		inner join #TMP_Seg7			on		#TMP_Seg7.Seg7Key				=	FactActual.Seg7Key
		inner join #TMP_Seg8			on		#TMP_Seg8.Seg8Key				=	FactActual.Seg8Key
		inner join #TMP_Seg9			on		#TMP_Seg9.Seg9Key				=	FactActual.Seg9Key
		inner join #TMP_Seg10			on		#TMP_Seg10.Seg10Key				=	FactActual.Seg10Key
		inner join #TMP_CustomSeg1		on		#TMP_CustomSeg1.CustomSeg1Key	=	FactActual.CustomSeg1Key
		inner join #TMP_CustomSeg2		on		#TMP_CustomSeg2.CustomSeg2Key	=	FactActual.CustomSeg2Key
		inner join #TMP_CustomSeg3		on		#TMP_CustomSeg3.CustomSeg3Key	=	FactActual.CustomSeg3Key
		inner join #TMP_CustomSeg4		on		#TMP_CustomSeg4.CustomSeg4Key	=	FactActual.CustomSeg4Key
		inner join #TMP_CustomSeg5		on		#TMP_CustomSeg5.CustomSeg5Key	=	FactActual.CustomSeg5Key
		inner join #TMP_GLSecurity		on		#TMP_GLSecurity.GLSecurityKey	=	FactActual.GLSecurityKey
		order by
			FactActual.FactID
	-- create index #IX_FactActual on #TMP_FactActual(FactID)
end;
-- ========================================================



-- --------------------------------------------------------
-- Process FactBudget
-- --------------------------------------------------------

if @tables in ('(All Tables)', 'FactBudget')
begin
	insert into #TMP_Result
		select top(@topNumRows)
			'FactBudget',
			FactBudget.FactID,
			FactBudget.Amount,
			#TMP_FiscalYear.FiscalYearKey,		#TMP_FiscalYear.MemberName		, #TMP_FiscalYear.MemberDescription		,
			#TMP_Period.PeriodKey,				#TMP_Period.MemberName			, #TMP_Period.MemberDescription			,
			#TMP_Currency.CurrencyKey,			#TMP_Currency.MemberName		, #TMP_Currency.MemberDescription		,
			#TMP_Scenario.ScenarioKey,			#TMP_Scenario.MemberName		, #TMP_Scenario.MemberDescription		,
			#TMP_Value.ValueKey,				#TMP_Value.MemberName			, #TMP_Value.MemberDescription			,
			#TMP_Version.VersionKey,			#TMP_Version.MemberName			, #TMP_Version.MemberDescription		,
			#TMP_GLBook.GLBookKey,				#TMP_GLBook.MemberName			, #TMP_GLBook.MemberDescription			,
			#TMP_Calendar.CalendarKey,			#TMP_Calendar.MemberName		, #TMP_Calendar.MemberDescription		,
			#TMP_Seg1.Seg1Key,					#TMP_Seg1.MemberName			, #TMP_Seg1.MemberDescription			,
			#TMP_Seg2.Seg2Key,					#TMP_Seg2.MemberName			, #TMP_Seg2.MemberDescription 			,
			#TMP_Seg3.Seg3Key,					#TMP_Seg3.MemberName			, #TMP_Seg3.MemberDescription 			,
			#TMP_Seg4.Seg4Key,					#TMP_Seg4.MemberName			, #TMP_Seg4.MemberDescription 			,
			#TMP_Seg5.Seg5Key,					#TMP_Seg5.MemberName			, #TMP_Seg5.MemberDescription 			,
			#TMP_Seg6.Seg6Key,					#TMP_Seg6.MemberName			, #TMP_Seg6.MemberDescription 			,
			#TMP_Seg7.Seg7Key,					#TMP_Seg7.MemberName			, #TMP_Seg7.MemberDescription 			,
			#TMP_Seg8.Seg8Key,					#TMP_Seg8.MemberName			, #TMP_Seg8.MemberDescription 			,
			#TMP_Seg9.Seg9Key,					#TMP_Seg9.MemberName			, #TMP_Seg9.MemberDescription 			,
			#TMP_Seg10.Seg10Key,				#TMP_Seg10.MemberName			, #TMP_Seg10.MemberDescription			,
			#TMP_CustomSeg1.CustomSeg1Key,		#TMP_CustomSeg1.MemberName		, #TMP_CustomSeg1.MemberDescription		,
			#TMP_CustomSeg2.CustomSeg2Key,		#TMP_CustomSeg2.MemberName		, #TMP_CustomSeg2.MemberDescription		,
			#TMP_CustomSeg3.CustomSeg3Key,		#TMP_CustomSeg3.MemberName		, #TMP_CustomSeg3.MemberDescription		,
			#TMP_CustomSeg4.CustomSeg4Key,		#TMP_CustomSeg4.MemberName		, #TMP_CustomSeg4.MemberDescription		,
			#TMP_CustomSeg5.CustomSeg5Key,		#TMP_CustomSeg5.MemberName		, #TMP_CustomSeg5.MemberDescription		,
			#TMP_GLSecurity.GLSecurityKey,		#TMP_GLSecurity.MemberName		, #TMP_GLSecurity.MemberDescription		,
			Null as 'AuditTime',	Null as 'AuditUser',	Null as 'RefID',	Null as 'BitMask'
		from
			FactBudget
		inner join #TMP_FiscalYear		on		#TMP_FiscalYear.FiscalYearKey	=	FactBudget.FiscalYearKey
		inner join #TMP_Period			on		#TMP_Period.PeriodKey			=	FactBudget.PeriodKey
		inner join #TMP_Currency		on		#TMP_Currency.CurrencyKey		=	FactBudget.CurrencyKey
		inner join #TMP_Scenario		on		#TMP_Scenario.ScenarioKey		=	FactBudget.ScenarioKey
		inner join #TMP_Value			on		#TMP_Value.ValueKey				=	FactBudget.ValueKey
		inner join #TMP_Version			on		#TMP_Version.VersionKey			=	FactBudget.VersionKey
		inner join #TMP_GLBook			on		#TMP_GLBook.GLBookKey			=	FactBudget.GLBookKey
		inner join #TMP_Calendar		on		#TMP_Calendar.CalendarKey		=	FactBudget.CalendarKey
		inner join #TMP_Seg1			on		#TMP_Seg1.Seg1Key				=	FactBudget.Seg1Key
		inner join #TMP_Seg2			on		#TMP_Seg2.Seg2Key				=	FactBudget.Seg2Key
		inner join #TMP_Seg3			on		#TMP_Seg3.Seg3Key				=	FactBudget.Seg3Key
		inner join #TMP_Seg4			on		#TMP_Seg4.Seg4Key				=	FactBudget.Seg4Key
		inner join #TMP_Seg5			on		#TMP_Seg5.Seg5Key				=	FactBudget.Seg5Key
		inner join #TMP_Seg6			on		#TMP_Seg6.Seg6Key				=	FactBudget.Seg6Key
		inner join #TMP_Seg7			on		#TMP_Seg7.Seg7Key				=	FactBudget.Seg7Key
		inner join #TMP_Seg8			on		#TMP_Seg8.Seg8Key				=	FactBudget.Seg8Key
		inner join #TMP_Seg9			on		#TMP_Seg9.Seg9Key				=	FactBudget.Seg9Key
		inner join #TMP_Seg10			on		#TMP_Seg10.Seg10Key				=	FactBudget.Seg10Key
		inner join #TMP_CustomSeg1		on		#TMP_CustomSeg1.CustomSeg1Key	=	FactBudget.CustomSeg1Key
		inner join #TMP_CustomSeg2		on		#TMP_CustomSeg2.CustomSeg2Key	=	FactBudget.CustomSeg2Key
		inner join #TMP_CustomSeg3		on		#TMP_CustomSeg3.CustomSeg3Key	=	FactBudget.CustomSeg3Key
		inner join #TMP_CustomSeg4		on		#TMP_CustomSeg4.CustomSeg4Key	=	FactBudget.CustomSeg4Key
		inner join #TMP_CustomSeg5		on		#TMP_CustomSeg5.CustomSeg5Key	=	FactBudget.CustomSeg5Key
		inner join #TMP_GLSecurity		on		#TMP_GLSecurity.GLSecurityKey	=	FactBudget.GLSecurityKey
		order by 
			FactBudget.FactID
		--create index #IX_FactBudget on #TMP_FactBudget(FactID)
end;
-- ========================================================



-- =======================================================================				Query FactLegal			===================================================================== --
if @tables in ('(All Tables)', 'FactLegal')
begin
	insert into #TMP_Result
		select top(@topNumRows)
			'FactLegal',
			FactLegal.FactID,
			FactLegal.Amount,
			#TMP_FiscalYear.FiscalYearKey,		#TMP_FiscalYear.MemberName		, #TMP_FiscalYear.MemberDescription		,
			#TMP_Period.PeriodKey,				#TMP_Period.MemberName			, #TMP_Period.MemberDescription			,
			#TMP_Currency.CurrencyKey,			#TMP_Currency.MemberName		, #TMP_Currency.MemberDescription		,
			#TMP_Scenario.ScenarioKey,			#TMP_Scenario.MemberName		, #TMP_Scenario.MemberDescription		,
			#TMP_Value.ValueKey,				#TMP_Value.MemberName			, #TMP_Value.MemberDescription			,
			#TMP_Version.VersionKey,			#TMP_Version.MemberName			, #TMP_Version.MemberDescription		,
			#TMP_GLBook.GLBookKey,				#TMP_GLBook.MemberName			, #TMP_GLBook.MemberDescription			,
			#TMP_Calendar.CalendarKey,			#TMP_Calendar.MemberName		, #TMP_Calendar.MemberDescription		,
			#TMP_Seg1.Seg1Key,					#TMP_Seg1.MemberName			, #TMP_Seg1.MemberDescription			,
			#TMP_Seg2.Seg2Key,					#TMP_Seg2.MemberName			, #TMP_Seg2.MemberDescription 			,
			#TMP_Seg3.Seg3Key,					#TMP_Seg3.MemberName			, #TMP_Seg3.MemberDescription 			,
			#TMP_Seg4.Seg4Key,					#TMP_Seg4.MemberName			, #TMP_Seg4.MemberDescription 			,
			#TMP_Seg5.Seg5Key,					#TMP_Seg5.MemberName			, #TMP_Seg5.MemberDescription 			,
			#TMP_Seg6.Seg6Key,					#TMP_Seg6.MemberName			, #TMP_Seg6.MemberDescription 			,
			#TMP_Seg7.Seg7Key,					#TMP_Seg7.MemberName			, #TMP_Seg7.MemberDescription 			,
			#TMP_Seg8.Seg8Key,					#TMP_Seg8.MemberName			, #TMP_Seg8.MemberDescription 			,
			#TMP_Seg9.Seg9Key,					#TMP_Seg9.MemberName			, #TMP_Seg9.MemberDescription 			,
			#TMP_Seg10.Seg10Key,				#TMP_Seg10.MemberName			, #TMP_Seg10.MemberDescription			,
			#TMP_CustomSeg1.CustomSeg1Key,		#TMP_CustomSeg1.MemberName		, #TMP_CustomSeg1.MemberDescription		,
			#TMP_CustomSeg2.CustomSeg2Key,		#TMP_CustomSeg2.MemberName		, #TMP_CustomSeg2.MemberDescription		,
			#TMP_CustomSeg3.CustomSeg3Key,		#TMP_CustomSeg3.MemberName		, #TMP_CustomSeg3.MemberDescription		,
			#TMP_CustomSeg4.CustomSeg4Key,		#TMP_CustomSeg4.MemberName		, #TMP_CustomSeg4.MemberDescription		,
			#TMP_CustomSeg5.CustomSeg5Key,		#TMP_CustomSeg5.MemberName		, #TMP_CustomSeg5.MemberDescription		,
			#TMP_GLSecurity.GLSecurityKey,		#TMP_GLSecurity.MemberName		, #TMP_GLSecurity.MemberDescription		,
			Null as 'AuditTime',	Null as 'AuditUser',	Null as 'RefID',	Null as 'BitMask'
		from
			FactLegal
		inner join #TMP_FiscalYear		on		#TMP_FiscalYear.FiscalYearKey	=	FactLegal.FiscalYearKey
		inner join #TMP_Period			on		#TMP_Period.PeriodKey			=	FactLegal.PeriodKey
		inner join #TMP_Currency		on		#TMP_Currency.CurrencyKey		=	FactLegal.CurrencyKey
		inner join #TMP_Scenario		on		#TMP_Scenario.ScenarioKey		=	FactLegal.ScenarioKey
		inner join #TMP_Value			on		#TMP_Value.ValueKey				=	FactLegal.ValueKey
		inner join #TMP_Version			on		#TMP_Version.VersionKey			=	FactLegal.VersionKey
		inner join #TMP_GLBook			on		#TMP_GLBook.GLBookKey			=	FactLegal.GLBookKey
		inner join #TMP_Calendar		on		#TMP_Calendar.CalendarKey		=	FactLegal.CalendarKey
		inner join #TMP_Seg1			on		#TMP_Seg1.Seg1Key				=	FactLegal.Seg1Key
		inner join #TMP_Seg2			on		#TMP_Seg2.Seg2Key				=	FactLegal.Seg2Key
		inner join #TMP_Seg3			on		#TMP_Seg3.Seg3Key				=	FactLegal.Seg3Key
		inner join #TMP_Seg4			on		#TMP_Seg4.Seg4Key				=	FactLegal.Seg4Key
		inner join #TMP_Seg5			on		#TMP_Seg5.Seg5Key				=	FactLegal.Seg5Key
		inner join #TMP_Seg6			on		#TMP_Seg6.Seg6Key				=	FactLegal.Seg6Key
		inner join #TMP_Seg7			on		#TMP_Seg7.Seg7Key				=	FactLegal.Seg7Key
		inner join #TMP_Seg8			on		#TMP_Seg8.Seg8Key				=	FactLegal.Seg8Key
		inner join #TMP_Seg9			on		#TMP_Seg9.Seg9Key				=	FactLegal.Seg9Key
		inner join #TMP_Seg10			on		#TMP_Seg10.Seg10Key				=	FactLegal.Seg10Key
		inner join #TMP_CustomSeg1		on		#TMP_CustomSeg1.CustomSeg1Key	=	FactLegal.CustomSeg1Key
		inner join #TMP_CustomSeg2		on		#TMP_CustomSeg2.CustomSeg2Key	=	FactLegal.CustomSeg2Key
		inner join #TMP_CustomSeg3		on		#TMP_CustomSeg3.CustomSeg3Key	=	FactLegal.CustomSeg3Key
		inner join #TMP_CustomSeg4		on		#TMP_CustomSeg4.CustomSeg4Key	=	FactLegal.CustomSeg4Key
		inner join #TMP_CustomSeg5		on		#TMP_CustomSeg5.CustomSeg5Key	=	FactLegal.CustomSeg5Key
		inner join #TMP_GLSecurity		on		#TMP_GLSecurity.GLSecurityKey	=	FactLegal.GLSecurityKey
		order by 
			FactLegal.FactID
		--create index #IX_FactLegal on #TMP_FactLegal(FactID)
end;
-- ========================================================



-- =======================================================================				Query FactWriteback			===================================================================== --
if @tables in ('(All Tables)', 'FactWriteback')
begin
	insert into #TMP_Result
		select top(@topNumRows)
			'FactWriteback',
			Null, -- FactWriteback doesn't have FactID
			FactWriteback.Amount_0,
			#TMP_FiscalYear.FiscalYearKey,		#TMP_FiscalYear.MemberName		, #TMP_FiscalYear.MemberDescription		,
			#TMP_Period.PeriodKey,				#TMP_Period.MemberName			, #TMP_Period.MemberDescription			,
			#TMP_Currency.CurrencyKey,			#TMP_Currency.MemberName		, #TMP_Currency.MemberDescription		,
			#TMP_Scenario.ScenarioKey,			#TMP_Scenario.MemberName		, #TMP_Scenario.MemberDescription		,
			#TMP_Value.ValueKey,				#TMP_Value.MemberName			, #TMP_Value.MemberDescription			,
			#TMP_Version.VersionKey,			#TMP_Version.MemberName			, #TMP_Version.MemberDescription		,
			#TMP_GLBook.GLBookKey,				#TMP_GLBook.MemberName			, #TMP_GLBook.MemberDescription			,
			#TMP_Calendar.CalendarKey,			#TMP_Calendar.MemberName		, #TMP_Calendar.MemberDescription		,
			#TMP_Seg1.Seg1Key,					#TMP_Seg1.MemberName			, #TMP_Seg1.MemberDescription			,
			#TMP_Seg2.Seg2Key,					#TMP_Seg2.MemberName			, #TMP_Seg2.MemberDescription 			,
			#TMP_Seg3.Seg3Key,					#TMP_Seg3.MemberName			, #TMP_Seg3.MemberDescription 			,
			#TMP_Seg4.Seg4Key,					#TMP_Seg4.MemberName			, #TMP_Seg4.MemberDescription 			,
			#TMP_Seg5.Seg5Key,					#TMP_Seg5.MemberName			, #TMP_Seg5.MemberDescription 			,
			#TMP_Seg6.Seg6Key,					#TMP_Seg6.MemberName			, #TMP_Seg6.MemberDescription 			,
			#TMP_Seg7.Seg7Key,					#TMP_Seg7.MemberName			, #TMP_Seg7.MemberDescription 			,
			#TMP_Seg8.Seg8Key,					#TMP_Seg8.MemberName			, #TMP_Seg8.MemberDescription 			,
			#TMP_Seg9.Seg9Key,					#TMP_Seg9.MemberName			, #TMP_Seg9.MemberDescription 			,
			#TMP_Seg10.Seg10Key,				#TMP_Seg10.MemberName			, #TMP_Seg10.MemberDescription			,
			#TMP_CustomSeg1.CustomSeg1Key,		#TMP_CustomSeg1.MemberName		, #TMP_CustomSeg1.MemberDescription		,
			#TMP_CustomSeg2.CustomSeg2Key,		#TMP_CustomSeg2.MemberName		, #TMP_CustomSeg2.MemberDescription		,
			#TMP_CustomSeg3.CustomSeg3Key,		#TMP_CustomSeg3.MemberName		, #TMP_CustomSeg3.MemberDescription		,
			#TMP_CustomSeg4.CustomSeg4Key,		#TMP_CustomSeg4.MemberName		, #TMP_CustomSeg4.MemberDescription		,
			#TMP_CustomSeg5.CustomSeg5Key,		#TMP_CustomSeg5.MemberName		, #TMP_CustomSeg5.MemberDescription		,
			#TMP_GLSecurity.GLSecurityKey,		#TMP_GLSecurity.MemberName		, #TMP_GLSecurity.MemberDescription		,
			FactWriteback.MS_AUDIT_TIME_27 as 'AuditTime',
			FactWriteback.MS_AUDIT_USER_28 as 'AuditUser',
			FactWriteback.RefID_1 as 'RefID',
			FactWriteback.BitMask_2 as 'BitMask'
		from 
			FactWriteback
		inner join #TMP_FiscalYear		on		#TMP_FiscalYear.FiscalYearKey	=	FactWriteback.FiscalYearKey_3
		inner join #TMP_Period			on		#TMP_Period.PeriodKey			=	FactWriteback.PeriodKey_4
		inner join #TMP_Currency		on		#TMP_Currency.CurrencyKey		=	FactWriteback.CurrencyKey_5
		inner join #TMP_Scenario		on		#TMP_Scenario.ScenarioKey		=	FactWriteback.ScenarioKey_6
		inner join #TMP_Value			on		#TMP_Value.ValueKey				=	FactWriteback.ValueKey_8
		inner join #TMP_Version			on		#TMP_Version.VersionKey			=	FactWriteback.VersionKey_7
		inner join #TMP_GLBook			on		#TMP_GLBook.GLBookKey			=	FactWriteback.GLBookKey_9
		inner join #TMP_Calendar		on		#TMP_Calendar.CalendarKey		=	FactWriteback.CalendarKey_26
		inner join #TMP_Seg1			on		#TMP_Seg1.Seg1Key				=	FactWriteback.Seg1Key_10
		inner join #TMP_Seg2			on		#TMP_Seg2.Seg2Key				=	FactWriteback.Seg2Key_11
		inner join #TMP_Seg3			on		#TMP_Seg3.Seg3Key				=	FactWriteback.Seg3Key_12
		inner join #TMP_Seg4			on		#TMP_Seg4.Seg4Key				=	FactWriteback.Seg4Key_13
		inner join #TMP_Seg5			on		#TMP_Seg5.Seg5Key				=	FactWriteback.Seg5Key_14
		inner join #TMP_Seg6			on		#TMP_Seg6.Seg6Key				=	FactWriteback.Seg6Key_15
		inner join #TMP_Seg7			on		#TMP_Seg7.Seg7Key				=	FactWriteback.Seg7Key_16
		inner join #TMP_Seg8			on		#TMP_Seg8.Seg8Key				=	FactWriteback.Seg8Key_17
		inner join #TMP_Seg9			on		#TMP_Seg9.Seg9Key				=	FactWriteback.Seg9Key_18
		inner join #TMP_Seg10			on		#TMP_Seg10.Seg10Key				=	FactWriteback.Seg10Key_19
		inner join #TMP_CustomSeg1		on		#TMP_CustomSeg1.CustomSeg1Key	=	FactWriteback.CustomSeg1Key_20
		inner join #TMP_CustomSeg2		on		#TMP_CustomSeg2.CustomSeg2Key	=	FactWriteback.CustomSeg2Key_21
		inner join #TMP_CustomSeg3		on		#TMP_CustomSeg3.CustomSeg3Key	=	FactWriteback.CustomSeg3Key_22
		inner join #TMP_CustomSeg4		on		#TMP_CustomSeg4.CustomSeg4Key	=	FactWriteback.CustomSeg4Key_23
		inner join #TMP_CustomSeg5		on		#TMP_CustomSeg5.CustomSeg5Key	=	FactWriteback.CustomSeg5Key_24
		inner join #TMP_GLSecurity		on		#TMP_GLSecurity.GLSecurityKey	=	FactWriteback.GLSecurityKey_25
		order by 
			FactWriteback.Amount_0
end;
-- ========================================================



-- =====================================================================						Query 					================================================================= --

declare @RetrievedRowCount   int = (select count(*) from #TMP_Result)
select
	@RetrievedRowCount as 'Retrieved Row Count',
	SourceTable		,
	FactId			,
	Amount			,
	FiscalYearName	,		FiscalYearKey	,		FiscalYearDescription	,
	PeriodName		,		PeriodKey		,		PeriodDescription		,
	CurrencyName	,		CurrencyKey		,		CurrencyDescription		,
	ScenarioName	,		ScenarioKey		,		ScenarioDescription		,
	ValueName		,		ValueKey		,		ValueDescription		,
	VersionName		,		VersionKey		,		VersionDescription		,
	GLBookName		,		GLBookKey		,		GLBookDescription		,
	CalendarName	,		CalendarKey		,		CalendarDescription		,
	Seg1Name		,		Seg1Key			,		Seg1Description			,
	Seg2Name		,		Seg2Key			,		Seg2Description			,
	Seg3Name		,		Seg3Key			,		Seg3Description			,
	Seg4Name		,		Seg4Key			,		Seg4Description			,
	Seg5Name		,		Seg5Key			,		Seg5Description			,
	Seg6Name		,		Seg6Key			,		Seg6Description			,
	Seg7Name		,		Seg7Key			,		Seg7Description			,
	Seg8Name		,		Seg8Key			,		Seg8Description			,
	Seg9Name		,		Seg9Key			,		Seg9Description			,
	Seg10Name		,		Seg10Key		,		Seg10Description		,
	CustomSeg1Name	,		CustomSeg1Key	,		CustomSeg1Description	,
	CustomSeg2Name	,		CustomSeg2Key	,		CustomSeg2Description	,
	CustomSeg3Name	,		CustomSeg3Key	,		CustomSeg3Description	,
	CustomSeg4Name	,		CustomSeg4Key	,		CustomSeg4Description	,
	CustomSeg5Name	,		CustomSeg5Key	,		CustomSeg5Description	,
	GLSecurityName	,		GLSecurityKey	,		GLSecurityDescription	,
	AuditTime		,		AuditUser		,		RefID,		BitMask		-- this line is specifically for FactWriteback
from
	#TMP_Result
order by
	SourceTable
-- ========================================================