create database sales_opportunity;
use sales_opportunity;

-- 1. accounts
create table accounts (
account varchar(100) primary key,
sector varchar(50),
year_established int,
revenue decimal(12,2),
employees int,
office_location varchar(50),
subsidiary_of  varchar(100)
);

-- 2. products
CREATE TABLE products (
product varchar(50) primary key,
series varchar(20),
sales_price decimal(10,2)
);

-- 3. sales_teams
CREATE TABLE sales_teams (
sales_agent varchar(50) primary key,
manager varchar(50),
regional_office varchar(20)
);

-- 4. sales_pipeline (main table)
CREATE TABLE sales_pipeline (
opportunity_id varchar(20) primary key,
sales_agent varchar(50),
product varchar(50),
account varchar(100),
deal_stage varchar(20),
engage_date date,
close_date date,
close_value decimal(12,2)
);

-- created a temporary table to insert null values 
CREATE TABLE sales_pipeline_temp (
    opportunity_id varchar(50),
    sales_agent varchar(50),
    product varchar(50),
    account varchar(100),
    deal_stage varchar(20),
    engage_date varchar(20),
    close_date  varchar(20),
    close_value varchar(20)
);

-- Inserting values into table
insert into sales_pipeline ( opportunity_id, sales_agent, product, account,  
deal_stage, engage_date, close_date, close_value
)
select opportunity_id, sales_agent, product,
nullif(account, ''), deal_stage,
nullif(engage_date, ''),
nullif(close_date, ''),
nullif(close_value, '')
from sales_pipeline_temp;

-- Checking the table / counting to total rows
select count(*) from sales_pipeline;
select * from sales_pipeline;

select deal_stage, COUNT(*) 
from sales_pipeline 
group by  deal_stage 
order by COUNT(*) desc;

-- Deleting the temporary created table 
DROP TABLE sales_pipeline_temp;

--  Total number opportunities 
select count(*) as total_opportunities
from sales_pipeline;

-- Number of opportunities for each deal stage
select deal_stage , 
count(*) as num_opportunities 
from sales_pipeline
group by deal_stage
order by num_opportunities desc;

-- Total and avg close value for each stage
select deal_stage, 
count(*) as num_opportunities,
sum(close_value) as total_close_value,
round(avg(close_value),2) as avg_close_value
from sales_pipeline
group by deal_stage
order by num_opportunities;

-- Number of opportunities handled by each sales agent
select sales_agent,
count(*) as num_opportunities
from sales_pipeline
group by sales_agent
order by num_opportunities desc;

-- Won opportunity rate 
select round(sum(case when deal_stage = 'Won' then 1 else 0 end) * 100.0 / count(*),2) as won_rate
from sales_pipeline;

-- Lost opportunity rate
select round(sum(case when deal_stage = 'Lost' then 1 else 0 end) * 100.0 / count(*), 2) as lost_rate
from sales_pipeline;

-- Total revenue by sales agent 
select sales_agent, 
sum(close_value) as revenue_generated 
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
order by revenue_generated desc;

-- Avg won deal value by product
select product ,
avg(close_value) as avg_won_deal_value
from sales_pipeline
where deal_stage = 'Won'
group by product
order by avg_won_deal_value desc;

-- Accounts, opportunities, revenue generated
select a.account,
count(sp.opportunity_id) as total_opportunities,
sum(case when deal_stage = 'Won' then sp.close_value
else 0 end) as revenue_generated
from sales_pipeline sp
left join accounts a on sp.account = a.account
group by a.account
order by revenue_generated desc;

-- Product performance
select p.product,
count(sp.opportunity_id) as total_opportunities,
sum(case when sp.deal_stage = 'Won' then 1 else 0 end) as won_opportunities,
sum(case when sp.deal_stage = 'Won' then sp.close_value
else 0 end) as revenue_generated
from sales_pipeline sp
left join products p on sp.product = p.product
group by p.product
order by revenue_generated desc;  

-- Sales agent performance
with agent_stats as (
select sales_agent,
count(*) as total_opportunities,
sum(case when deal_stage = 'Won' then 1 else 0 end) as won_opportunities,
sum(case when deal_stage = 'Lost' then 1 else 0 end) as lost_opportunities,
sum(close_value) as revenue_generated
from sales_pipeline
group by sales_agent
)
select sales_agent, total_opportunities, won_opportunities, lost_opportunities, revenue_generated,
round(won_opportunities * 100 / total_opportunities) as win_rate
from agent_stats
order by win_rate desc;

-- Product performance 
with product_stats as (
select product,
count(*) as total_opportunities,
sum(case when deal_stage = 'Won' then 1 else 0 end) as won_opportunities,
sum(Case when deal_stage = 'Lost' then 1 else 0 end) as lost_opportunities,
sum(close_value) as Revenue_generated
from sales_pipeline
group by product
) 
select product, total_opportunities, won_opportunities, lost_opportunities, Revenue_generated,
round(won_opportunities * 100 / total_opportunities) as win_rate
from product_stats
order by win_rate desc;

-- High Value opportunities
select * from sales_pipeline
where close_value > (
select avg(close_value)
from sales_pipeline
where close_value is not null 
) 
order by close_value desc;

-- Agents who generated revenue above avg 
select sales_agent,
sum(close_value) as revenue_generated
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
having sum(close_value) > (
select avg(agent_revenue)
from(
select sum(close_value) as agent_revenue
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
)
as avg_table
)
order by revenue_generated desc;

-- Ranking sales agent by revenue generated
select sales_agent,
sum(close_value) as revenue_generated,
rank() over(order by sum(close_value) desc) as revenue_rank
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent;

-- Ranking agents by location
select st.regional_office, sp.sales_agent,
sum(sp.close_value) as revenue_generated,
rank() over ( partition by st.regional_office 
order by sum(sp.close_value) desc
) as regional_rank
from sales_pipeline sp
join sales_teams st on sp.sales_agent = st.sales_agent
where sp.deal_stage = 'Won'
group by st.regional_office, sp.sales_agent;

-- Top 3 agents
select * from 
( select sales_agent, 
sum(close_value) as revenue_generated,
dense_rank() over( order by sum(close_value) desc) as dense_ranking
from sales_pipeline
where deal_stage = 'Won'
group by sales_agent
) ranked
where dense_ranking <=3;

-- Lost rate by product 
select product,
count(*) as total_opportunitites,
sum(case when deal_stage = 'Lost' then 1 else 0 end) as lost_opportunities,
sum(case when deal_stage = 'Lost' then 1 else 0 end) * 100/ count(*) as loss_rate
from sales_pipeline
group by product
order by loss_rate desc;

-- Sales agent conversion 
select sales_agent,
count(*) as total_opportunities,
sum(case when deal_stage = 'Won' then 1 else 0 end) as won,
sum(case when deal_stage = 'Lost' then 1 else 0 end) as lost,
sum(case when deal_stage = 'Won' then 1 else 0 end) *100/ count(*) as win_rate,
sum(case when deal_stage = 'Lost' then 1 else 0 end) *100/ count(*) as lost_rate
from sales_pipeline
group by sales_agent
order by win_rate desc;

-- Managers performance with rank by revenue generated
select st.manager,
count(*) as total_opportunities,
sum(case when sp.deal_stage = 'Won' then 1 else 0 end) as won_opportunities,
sum(case when sp.deal_stage = 'Lost' then 1 else 0 end) as lost_opportunities,
sum(case when sp.deal_stage = 'Won' then sp.close_value else 0 end) as revenue_generated,
round(sum(case when sp.deal_stage = 'Won' then 1 else 0 end) * 100.0 / COUNT(*), 2) as win_rate,
rank() over (order by SUM(case when sp.deal_stage = 'Won' then sp.close_value else 0 end) desc) as revenue_rank
from sales_pipeline sp
join sales_teams st on sp.sales_agent = st.sales_agent
group by st.manager
order by  revenue_generated desc;

-- Top 10 accounts by revenue generated
select account,
count(*) as total_opportuinties,
sum(close_value) as revenue_generated,
avg(close_value) as avg_deal_value
from sales_pipeline
where deal_stage = 'Won'
group by account
order by revenue_generated desc
limit 10;

