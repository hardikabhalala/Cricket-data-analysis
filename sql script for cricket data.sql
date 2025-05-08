use food_db;


SELECT * FROM food_db.batting_stats;


update batting_stats
set Player = trim(Player)
where Player is not null;

select * from batting_stats
where player = 'RG Sharma';

select * from bowling_stats;

# remove special character from column name 
alter table bowling_stats
rename column `ï»¿Bowlers` to Bowlers;

select * from bowling_stats
where Bowlers = "Mohammed Shami";

# rmove space from each rows from bowler column

Update bowling_stats
set Bowlers = trim(Bowlers);

# 1.Retrieve the names of all bowlers from the table.
select Bowlers from bowling_stats;

# Aggregate and group by function
# MAX, min, sum, average

# To change the data type of run column from text to integer

# name of the bowler who bowled max no. of balls
SELECT MAX(CAST(Runs AS SIGNED)) 
FROM bowling_stats;

select max(Runs) from bowling_stats;

select Bowlers, max(balls) from bowling_stats group by Bowlers;
select Bowlers, balls from bowling_stats where balls = (select max(balls) from bowling_stats);

# 2.Find the countries represented in the table and count how many bowlers are from each country.
select 
      country,
      count(Bowlers) as no_of_bowlers
from bowling_stats
group by country;

# Bowler name with minimum and maximum average 
select Bowlers, Average from bowling_stats
where Average=(select max(Average)from bowling_stats) or Average =  (select min(Average) from bowling_stats);

select * from bowling_stats;

# repacing - with zero in maiden
update bowling_stats
set maiden = 0 where maiden = '-';

# find the bowlers with highest number of maidens
select Bowlers, Maiden from bowling_stats
where maiden = (select max(maiden) from bowling_stats);

# 4.Identify the bowler(s) with the best economy rate (lowest economy).
select Bowlers, Economy from Bowling_stats where Economy = (select min(Economy) from Bowling_stats where match_played >5);

select Bowlers, Economy,Match_played from Bowling_stats where match_played >5 order by Economy limit 5;

# 5.Find the bowler(s) with the best strike rate (lowest strike rate).
#Change column name remove space and _ added
ALTER TABLE bowling_stats
CHANGE `Strike Rate` Strike_rate DECIMAL(10, 2);

select Bowlers, Strike_Rate from bowling_stats where Strike_Rate = (select min(Strike_Rate) from bowling_stats);

select Bowlers, Strike_Rate from bowling_stats order by Strike_rate limit 5;

# 6.Determine the number of bowlers who have taken four or more wickets in a match.
select Bowlers, Wkts, Match_Played from Bowling_stats where Wkts >= 4;

# 7.Find the number of hundreds scored by V Kohli
select * from batting_stats;

alter table batting_stats
change `100` hundreds numeric(10);

select Player, hundreds from batting_stats where Player = "V Kohli";

# 8.Find the player who scored maximum runs of thr country NZ

select Player, Country, Runs from batting_stats where Country = "NZ" order by Runs desc;
select Player, Runs,Country from batting_stats where Runs = (select max(Runs) from batting_stats where Country = 'NZ');


# 9.Find the player who score lowest run from country Australia.
select Player, Country, Runs from batting_stats where Country = "AUS" order by Runs;
select Player, Runs,Country from batting_stats where Runs = (select min(Runs) from batting_stats where Country = 'AUS');

#10.Find the player who have highest average in the tournament.
select * from batting_stats;
select Player, Average from batting_stats where Average = (select max(Average) from batting_stats);

#11.Find the player who have lowest srike rate (Sr) in the tournament.
alter table batting_stats
change `SR` Strike_rate integer;

select Player, Strike_rate from batting_stats where strike_rate = (select min(Strike_rate) from batting_stats);
select Player, Strike_rate from batting_stats order by Strike_rate limit 3;

#12.Find the player who have scored maximum runs from country India.
select Player, Runs, Country from batting_stats where Runs=(select max(Runs) from batting_stats where Country = 'IND');
select Player, Runs, Country from batting_stats where Country="IND" order by Runs desc limit 3;

#13.Find the bolwer name who have taken maximum wickets in the tournament.
select * from bowling_stats;
select Bowlers, max(Wkts) from bowling_stats group by Bowlers limit 3;
select Bowlers, Wkts from bowling_stats where Wkts = (select max(Wkts) from bowling_stats);

#14.Find the bolwer name who have taken maximum four wickets haul in the tournament.
alter table bowling_stats
change `4 W` four_wicket integer;

select Bowlers, four_wicket, Match_Played from bowling_stats where Match_Played >5 order by four_wicket desc;
select Bowlers, four_wicket from bowling_stats where four_wicket = (select max(four_wicket) from bowling_stats);
select Bowlers, max(four_wicket) from bowling_stats group by bowlers;


#15.Find the bowlers from South Africa who have bowled more than 3 maiden in the tournaments.
select Bowlers, Country, maiden from bowling_stats where maiden >3 and Country = "SA";


create table partnership (
             partners varchar(100),
			 Runs varchar(100),	
             Wkt varchar(100),
             Team varchar(100),
             Opposition varchar(100),	
             Ground varchar (100));
             
select * from partnership;
alter table partnership
change `ï»¿Partners` partners varchar(100);

alter table partnership
add column player_1 varchar(100),
add column player_2 varchar(100);



set SQL_SAFE_UPDATES = 0;
update partnership
set player_1 = trim(substring_index(partners,',', 1)),
	player_2 = trim(substring_index(partners,',', -1))
where partners is not null;

set SQL_SAFE_UPDATES = 1;

select * from partnership;

alter table partnership
drop column partners;

#leading and trailing
set sql_safe_updates = 0;
update partnership
set Opposition = trim(leading 'v ' from Opposition);
set sql_safe_updates = 1;

#lpad and rpad
select rpad('mina',5,'D');

select * from best_team;
alter table best_team
change column `ï»¿Team` Team varchar(100);

alter table best_team
add column total_score int,
add column wicket int;

set SQL_SAFE_UPDATES =0;
update best_team
set Score = rpad(Score, length(score)+3,'/10') where Score not like '%/%';
set SQL_SAFE_UPDATES = 1;

select * from best_team where Score not like '%/%';

set SQL_SAFE_UPDATES =0;
update best_team
set total_score = substring_index(Score, '/',1),
wicket = substring_index(Score, '/',-1);
set SQL_SAFE_UPDATES =1;

select * from best_team where total_score >300 and Team = 'India';

select Team, sum(total_score) from best_team group by team;
select count(Team), Team from best_team where total_score > 300 group by team having count(team)>3;

# players who score more then 100 runs  and more then 5 wickets
select * from batting_stats ba
join bowling_stats bo
on ba.player = bo.bowlers
where ba.Runs>100 and bo.Wkts >5;

#info of players who have score more then 200 and player name start with 'R'

select * from batting_stats 
where Runs>200 and player like 'R%';

