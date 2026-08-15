import holidays
from snowflake.snowpark.functions import col, lit


def model(dbt, session):
    dbt.config(materialized="table", packages=["holidays"], enabled=False)

    # Get the Snowpark DataFrame for the seed (no Pandas conversion).
    sf_df = dbt.ref("seed_full_moon_dates")

    # Collect the distinct "FULL_MOON_DATE" values to Python so we can evaluate which ones are German holidays.
    rows = sf_df.select(col("FULL_MOON_DATE")).distinct().collect()
    dates = [r[0] for r in rows]

    holiday_dates = [d for d in dates if d in holidays.Germany()]

    # If no holidays found, add a constant False column.
    if not holiday_dates:
        return sf_df.with_column("IS_HOLIDAY", lit(False))

    # Use `.isin(...)` so the boolean check executes in Snowflake SQL.
    return sf_df.with_column("IS_HOLIDAY", col("FULL_MOON_DATE").isin(holiday_dates))
