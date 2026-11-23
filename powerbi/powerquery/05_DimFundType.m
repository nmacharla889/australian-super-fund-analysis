// Query name: DimFundType
// Fund type sits on the fact (not on DimFund) because 5 funds changed type over time.
// Putting it on the fact keeps each year's type correct.
let
    Source = Table.Distinct(Table.SelectColumns(FundYearStaging, {"Fund Type"})),
    #"Sorted" = Table.Sort(Source, {{"Fund Type", Order.Ascending}})
in
    #"Sorted"
