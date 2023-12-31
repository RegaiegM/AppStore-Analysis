-- Check the number of unique apps in both tables
Select COUNT(DISTINCT id) as UniqueAppID from AppleStore

Select COUNT(DISTINCT id) as UniqueAppID from appleStore_description

-- Check for any missing value in key fields
select count(*) as MissingValues 
from AppleStore
where track_name is null or user_rating is null or prime_genre is null


select count(*) as MissingValues 
from appleStore_description
where app_desc is null

-- Find out the number of apps per genre
select prime_genre, COUNT(*) as NumOfApps
FROM AppleStore
group by prime_genre
order BY NumOfApps desc
  
-- Get an overview of the apps' rating
Select min(user_rating) as MinRating,
Max(user_rating) as MaxRating,
avg(user_rating) as AvgRating
FROM AppleStore

-- Determine whether paid apps have higher rating than free apps
Select case 
when price>0 then 'Paid'
Else 'Free'
End as AppType,
avg(user_rating) as AvgRating
from AppleStore
GROUP by AppType

-- Check if apps with more languages supported have higher rating
select CASE
when lang_num< 10 then '<10 Languages'
when lang_num BETWEEN 10 and 30 then '10-30 languages'
else '>30 Languages'
End as Language_bucket,
avg(user_rating) as AvgRating
FROM AppleStore
GROUP BY Language_bucket

-- Check genres with low ratings 
SELECT prime_genre, avg(user_rating) as AvgRating 
FROM AppleStore
GROUP by prime_genre
ORDER by AvgRating asc
limit 10

-- Check for a correlation between description length and user rating 
SELECT CASE
when length(b.app_desc)<500 then 'Short description'
when length(b.app_desc)between 500 and 1000 then 'Medium description'
else 'Long description'
end as DescriptionLengthBucket, 
Avg(a.user_rating) as AvgRating
from 
AppleStore as a 
join appleStore_description as b
on a.id = b.id
Group by DescriptionLengthBucket
Order BY AvgRating desc
  
-- Check the top rated apps for each genre 
SELECT prime_genre,track_name, user_rating
from (
  SELECT prime_genre, track_name, user_rating,
  rank() over(partition BY prime_genre ORDER by user_rating desc, rating_count_tot desc)
  as rank
  FROM AppleStore) as a
  where 
  a.rank = 1
