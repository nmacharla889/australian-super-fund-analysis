// Query name: FactDQCheck  (one row per failed check per fund-year; feeds the Data quality page)
let
    Source = FundYearStaging,
    #"Kept key and check columns" = Table.SelectColumns(
        Source,
        {"ABN", "Year", "Fund Type"} & List.Select(Table.ColumnNames(Source), each Text.StartsWith(_, "chk_"))
    ),
    #"Unpivoted checks" = Table.UnpivotOtherColumns(
        #"Kept key and check columns", {"ABN", "Year", "Fund Type"}, "Check", "Failed"
    ),
    #"Kept failures only" = Table.SelectRows(#"Unpivoted checks", each [Failed] = true),
    #"Cleaned check names" = Table.TransformColumns(
        #"Kept failures only",
        {{"Check", each Text.Proper(Text.Replace(Text.AfterDelimiter(_, "chk_"), "_", " ")), type text}}
    ),
    #"Removed Failed column" = Table.RemoveColumns(#"Cleaned check names", {"Failed"})
in
    #"Removed Failed column"
