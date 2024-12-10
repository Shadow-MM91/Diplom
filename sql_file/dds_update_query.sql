--Запросы добовления новых значений в таблицы фактов и измерений

  --Обновление таблиц измерений

insert into dds.branch (branch)
  (select branch 
   from nds.nds_branch 
   where branch not in (select branch from dds.branch));
----------------------------------------------------------------------------------
insert into dds.city (city)
   (select city 
    from nds.city 
    where city not in (select city from dds.city));
----------------------------------------------------------------------------------
insert into dds.customer_type (customer_type)
   (select customer_type 
    from nds.customer_type 
    where customer_type not in (select customer_type from dds.customer_type));
----------------------------------------------------------------------------------
insert into dds.dim_gender (gender)
    (select gender 
     from nds.gender 
     where gender not in (select gender from dds.dim_gender));
----------------------------------------------------------------------------------
insert into dds.dim_product_line (product_line)
    (select product_line 
     from nds.product_line 
     where product_line not in (select product_line from dds.product_line));
----------------------------------------------------------------------------------
insert into dds.fact_sales (invoice_id, branch, city, customer_type, gender, product_line, unit_price, quantity, "tax_5%",
     total, date, time, payment, cogs, gross_margin_percentage, gross_income, rating)
     (select distinct 
          invoice_id, branch, city, customer_type, gender, 
            product_line, unit_price, quantity, "tax_5%", total, date::date,
            time, payment, cogs, gross_margin_percentage, gross_income, rating 
      from nds.fact_sales 
      where invoice_id not in (select distinct invoice_id FROM dds.fact_sales));
----------------------------------------------------------------------------------
