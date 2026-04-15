with source as (

    select * from {{ ref('raw_customers') }}

),

renamed as (

    select
        cast(customer_id as integer) as customer_id,
        trim(first_name) as first_name,
        trim(last_name) as last_name,
        trim(first_name) || ' ' || trim(last_name) as customer_name,
        lower(trim(email)) as email,
        cast(signup_date as date) as signup_date,
        upper(trim(country)) as country
    from source

)

select * from renamed
