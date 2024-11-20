-- Note to reader: I created this query as a "proof of concept" almost. We (OLAP Solutions) were finding that some of our OLAP reports
--                 were taking too long to run. So I was tasksed with creating a relational report that did the exact same thing as the OLAP report.
--                 The client wanted to have offices across the top with ALCRE down the side.
--                 Once I finished the report front end, it was significantly quicker than the OLAP version of the report.



use xlMetadata;

drop table if exists #TMP1
select
	DimSeg4.MemberDescription as 'Descript',
	DimSeg4.MemberName as 'Office',
	ROW_NUMBER() over(order by MemberName) as seq
into #TMP1
from
	DimSeg4
where
	DimSeg4.MemberDescription = 'Default'
	or DimSeg4.MemberDescription = 'Firm'
	or DimSeg4.Seg4Hierarchy1Level1Name in (select dbo.fnc_Metadata_Descendants.MemberDescription from dbo.fnc_Metadata_Descendants('GL Unit', 'Total GL Unit'))



select
	'AcctType' = case
					when AcctType = 'A' then 'Assets'
					when AcctType = 'L' then 'Liabilities'
					when AcctType = 'C' then 'Capital'
					when AcctType = 'R' then 'Revenue'
					when AcctType = 'E' then 'Expenses'
				 end,
	Natural,
	[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30]
from
	(	select
			'Natural'   = DimSeg3.MemberName + ': ' + DimSeg3.MemberDescription,
			'OfficeSeq' = #TMP1.seq,
			'AcctType'  = DimSeg3.PropAcctType,
			'Amount'    = sum(FactData.Amount)
		from
			FactData
		inner join
			#TMP1 on #TMP1.Office = FactData.Seg4
		inner join
			DimSeg3 on DimSeg3.MemberName = FactData.Seg3
		where
			FiscalYear 	= 	'2020'
		and Period 		=	'2'
		and Currency 	=	'USD'
		and Calendar 	=	'Firm'
		and GLBook 		=	'Cash'
		and Scenario 	=	'Actual'
		and factdata.seg1 in (select MemberName from dbo.fnc_Metadata_Descendants('GL Unit', 		'Total GL Unit'))
		and factdata.seg5 in (select MemberName from dbo.fnc_Metadata_Descendants('GL Department', 	'Total GL Department'))
		group by
			DimSeg3.MemberDescription,
			DimSeg3.MemberName,
			#TMP1.seq,
			DimSeg3.PropAcctType
	) as Data
pivot(
	sum(Amount)
	for OfficeSeq in(
		[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30]
		)
	) as PT
order by
	charindex(AcctType, 'ALCRE'),
	Natural
