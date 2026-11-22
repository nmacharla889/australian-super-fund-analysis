# Data dictionary

Source: APRA *Annual fund-level superannuation statistics, back series June 2004 to June 2025* (Tables 2a and 2b, fund-level profile and structure). Downloaded 21 Nov 2026 from apra.gov.au.
Reconciliation source: APRA *Annual superannuation bulletin, June 2015 to June 2025, Superannuation entities* (sheet `Tab_RSE2_Data`).

## How the raw sheet is laid out
- Rows 0-3: title and blank rows
- Row 4: column headers (`header=4` in pandas)
- Row 5: APRA reporting form reference (e.g. `SRF 320.0 item 11`), not data
- Row 6: units, e.g. `($'000)`, `(%)`, not data
- Last rows: footnotes in the Period column
- `*` = value masked by APRA to protect member privacy. Blank = not reported or can't be calculated.

## Columns used (clean names)
Example values are AustralianSuper, June 2025.

| Clean name | APRA name | Meaning | Unit | Example |
|---|---|---|---|---|
| period | Period | Reporting year end | date | 2025-06-30 |
| year | (derived) | Year of period | int | 2025 |
| fund_name | Fund name | Fund name | text | AustralianSuper |
| abn | ABN | Fund's Australian Business Number; used as the fund key | text | 65714394898 |
| fund_type | Fund type | Industry, Retail, Retail - ERF, Public Sector, Corporate | text | Industry |
| fund_type_group | (derived) | Fund type with "Retail - ERF" merged into Retail, to match the bulletin | text | Retail |
| balance_date_group | (derived) | "30 June" if from Table 2a, "Other" if from Table 2b | text | 30 June |
| balance_date | RSE Balance date | Fund's financial year end | date | 2025-06-30 |
| duration_months | Duration | Months of performance in the return | months | 12 |
| wind_up_date | RSE Wind up date | Date the fund wound up, if any | date | |
| total_assets_k | Total assets | Total assets at the end of the period | $ thousand | 412,301,040 |
| member_accounts | Total number of member accounts | Accounts (not people) | count | 3,672,060 |
| members_benefits_k | Total members' benefits | Benefits owed to members | $ thousand | 387,590,232 |
| avg_balance_k | Average member account balance | APRA-calculated average | $ thousand | 106.0 |
| return_1y / 5y / 10y | One/Five/Ten-year rate of return | Net return to members, per year | decimal (0.073 = 7.3%) | 0.095 |
| operating_expense_ratio | Operating expense ratio | Admin and operating expenses / assets | decimal | 0.003 |
| investment_expenses_ratio | Investment expenses ratio | Investment expenses / assets | decimal | 0.002 |
| net_outflow_ratio | Net members' benefits outflow ratio | Outflows vs inflows | decimal | 0.625 |

## Derived columns

| Column | How it's calculated | Why |
|---|---|---|
| total_expense_ratio | operating_expense_ratio + investment_expenses_ratio | Proxy for "fees" (fund-level fee dollars are in Table 6, which has a much messier layout) |
| assets_per_member | total_assets_k * 1000 / member_accounts | Compares fund types fairly regardless of size |
| masked_field_count | Number of `*` values in the row | Separates privacy masks from missing data |
| chk_* | One True/False column per data quality check | Shows which rule each row failed |
| dq_issue_count / dq_flag | Sum of chk_* / any failed | Row-level quality score |
| is_primary_record | False for the older row when the same ABN + period appears twice | Stops double counting funds that changed balance date |
| apm_outlier | Outside Q1 - 1.5*IQR to Q3 + 1.5*IQR on assets_per_member | Robust outlier flag for skewed data |
| fee_z / fee_outlier | z-score of total_expense_ratio; abs(z) > 3 | Compared with IQR |
