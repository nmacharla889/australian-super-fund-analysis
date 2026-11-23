let
  Source = Csv.Document(File.Contents(DataFolder & "fund_level_clean.csv"), [Delimiter = ",", QuoteStyle = QuoteStyle.None]),
  #"Promoted headers" = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
  #"Changed column type" = Table.TransformColumnTypes(#"Promoted headers", {{"period", type text}, {"year", Int64.Type}, {"fund_name", type text}, {"abn", Int64.Type}, {"fund_type", type text}, {"fund_type_group", type text}, {"regulatory_class", type text}, {"membership_base", type text}, {"licensee", type text}, {"rse_licensee_profit_status", type text}, {"balance_date_group", type text}, {"duration_months", Int64.Type}, {"wind_up_date", type date}, {"total_assets_k", Int64.Type}, {"member_accounts", Int64.Type}, {"members_benefits_k", Int64.Type}, {"avg_balance_k", Int64.Type}, {"assets_per_member", type number}, {"return_1y", type number}, {"return_5y", type number}, {"return_10y", type number}, {"operating_expense_ratio", type number}, {"investment_expenses_ratio", type number}, {"total_expense_ratio", type number}, {"net_outflow_ratio", type number}, {"masked_field_count", Int64.Type}, {"dq_issue_count", Int64.Type}, {"dq_flag", type logical}, {"is_primary_record", type logical}, {"apm_outlier", type logical}, {"fee_z", type number}, {"fee_outlier", type logical}, {"chk_missing_assets", type logical}, {"chk_any_masked_field", type logical}, {"chk_negative_assets", type logical}, {"chk_dup_abn_period", type logical}, {"chk_members_but_no_assets", type logical}, {"chk_return_out_of_range", type logical}, {"chk_expense_ratio_high", type logical}, {"chk_avg_balance_mismatch", type logical}, {"chk_non_12_month_duration", type logical}, {"chk_missing_fund_type", type logical}}, "en-US"),
  #"Filtered rows" = Table.SelectRows(#"Changed column type", each [is_primary_record] = true),
  #"Assets in dollars" = Table.TransformColumns(#"Filtered rows", {{"total_assets_k", each _ * 1000, Int64.Type}}),
  #"Renamed columns" = Table.RenameColumns(
        #"Assets in dollars",
        {
            {"year", "Year"}, {"abn", "ABN"}, {"fund_name", "Fund Name (as reported)"},
            {"fund_type_group", "Fund Type"}, {"balance_date_group", "Balance Date Group"},
            {"duration_months", "Duration Months"}, {"total_assets_k", "Total Assets"},
            {"member_accounts", "Member Accounts"}, {"return_1y", "Return 1Y"},
            {"return_5y", "Return 5Y"}, {"operating_expense_ratio", "Operating Expense Ratio"},
            {"investment_expenses_ratio", "Investment Expense Ratio"},
            {"total_expense_ratio", "Total Expense Ratio"}, {"assets_per_member", "Assets per Member"},
            {"dq_issue_count", "DQ Issue Count"}, {"dq_flag", "DQ Flag"}, {"apm_outlier", "APM Outlier"}
        }
    )
in
  #"Renamed columns"