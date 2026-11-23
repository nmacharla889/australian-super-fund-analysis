// PRACTICE ONLY (not used by the report): clean the raw APRA Excel in Power Query,
// the same steps notebook 02 does in pandas.
let
    Source = Excel.Workbook(File.Contents(DataFolder & "fund_level_back_series_2004_2025.xlsx"), null, true),
    Table2a = Source{[Item = "Table 2a", Kind = "Sheet"]}[Data],
    #"Removed title rows" = Table.Skip(Table2a, 4),
    #"Promoted headers" = Table.PromoteHeaders(#"Removed title rows", [PromoteAllScalars = true]),
    #"Removed form and unit rows" = Table.Skip(#"Promoted headers", 2),
    #"Kept real dates only" = Table.SelectRows(#"Removed form and unit rows", each [Period] is datetime or [Period] is date),
    #"Replaced privacy masks" = Table.ReplaceValue(
        #"Kept real dates only", "*", null, Replacer.ReplaceValue,
        {"Total assets", "Total number of member accounts", "One-year#(lf)rate of return", "Operating expense ratio"}
    ),
    #"Set types" = Table.TransformColumnTypes(
        #"Replaced privacy masks",
        {
            {"Period", type date}, {"Fund name", type text}, {"Fund type", type text},
            {"Total assets", type number}, {"Total number of member accounts", Int64.Type},
            {"One-year#(lf)rate of return", type number}, {"Operating expense ratio", type number}
        }
    )
in
    #"Set types"
