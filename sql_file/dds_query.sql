-- Создание (слои) схем для DWH хранилеща в DB
    create schema if not exists nds; --содержит таблицы фактов и измерений без ключей
    create schema if not exists dds; --содержит детальные данные по таблицам фактов и измерений с ключами
 
--Создание таблиц в dds слое
    
    --Таблица филиалов магазина
    create table if not exists dds.branch( 
        id serial primary key,
        branch varchar(2) not null
    );
    
    --Таблица городов, где находятся филиалы магазина
    create table if not exists dds.city(
        id serial primary key,
        city varchar(100) not null
    );
    
    --Таблица типа клиентов ( с картой, без карты)
    create table if not exists dds.customer_type(
        id serial primary key,
        customer_type varchar(10) not null
    );
    
    --Таблица пол клиентов
    create table if not exists dds.gender(
        id serial primary key,
        gender varchar(10) not null
    );
    
    --Таблица категории продуктов
    create table if not exists dds.product_line(
        id serial primary key,
        product_line varchar(150) not null
    ); 
    
    --Таблица оплата (наличные,кредитка, электронный кошелёк)
    create table if not exists dds.payment(
        id serial primary key,
        payment varchar(150) not null
    );
 --Таблица измерения сгенерированные даты от 2000-01-01 до 2050-01-01 с интервалом в 1 день
 --для последующей аналитики данных
    create table if not exists dds.date as
      with array_date as (
            select dd::date as dt
            from generate_series('2000-01-01'::timestamp,'2050-01-01'::timestamp,'1 day'::interval) dd
        )
        select
            dt as date,
            date_part('week', dt)::int as week_of_year,
            date_trunc('week', dt)::date as week_start,
            date_part('isodow', dt)::int as day_of_week,
            to_char(dt::timestamp, 'day') as day_name,
            date_part('month', dt)::int as month_number,
            to_char(dt::timestamp, 'Month') as month_name,
            extract(quarter from dt) as quarter,
            date_part('isoyear', dt)::int as year
        from array_date;
 		alter table dds.date drop constraint if exists date_pkey cascade;
    alter table dds.date add constraint date_pkey primary key (date);

--Таблица фактов по магазинам    
    create table if not exists dds.fact_branch(
        invoice_id varchar(15) PRIMARY KEY,
        branch int not null references dds.branch(id),               -- установка внешнего ключа
        city int not null references dds.city(id),                   -- установка внешнего ключа
        customer_type int not null references dds.customer_type(id), -- установка внешнего ключа
        gender int not null references dds.gender(id),               -- установка внешнего ключа
        product_line int not null references dds.product_line(id),   -- установка внешнего ключа
        unit_price double precision,
        quantity double precision,
        "tax_5%" double precision,
        total double precision,
        date date not null,
        time time not null,
        payment int not null references dds.payment(id),
        cogs double precision,
        gross_margin_percentage double precision,
        gross_income double precision,
        rating double precision
    );
    alter table dds.fact_branch add constraint fact_branch_date_fkey foreign key (date) references dds.date(date); 







