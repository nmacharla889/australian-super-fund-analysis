// Query name: FactFundYear  (one row per fund per year: the grain of the fact table)
let
    Source = FundYearStaging,
    #"Kept fact columns" = Table.SelectColumns(
        Source,
        {
            "ABN", "Year", "Fund Type", "Balance Date Group", "Duration Months",
            "Total Assets", "Member Accounts", "Return 1Y", "Return 5Y",
            "Operating Expense Ratio", "Investment Expense Ratio", "Total Expense Ratio",
            "Assets per Member", "DQ Issue Count", "DQ Flag", "APM Outlier"
        }
    )
in
    #"Kept fact columns"
