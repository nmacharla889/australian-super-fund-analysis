// Query name: DimFund  (one row per ABN)
// Some funds were renamed over the years (5 ABNs have more than one name), so take the name from the latest year.
let
    Source = FundYearStaging,
    #"Grouped by ABN" = Table.Group(
        Source,
        {"ABN"},
        {
            {"Fund Name", each Table.Max(_, "Year")[#"Fund Name (as reported)"], type text},
            {"Latest Year", each List.Max([Year]), Int64.Type}
        }
    ),
    #"Renamed key" = Table.RenameColumns(#"Grouped by ABN", {{"ABN", "FundKey"}})
in
    #"Renamed key"
