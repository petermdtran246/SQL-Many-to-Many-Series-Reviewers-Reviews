📖 Overview
This project demonstrates a many-to-many relationship in SQL using three tables:

Series – TV shows

Reviewers – People who leave reviews

Reviews – A junction table linking series and reviewers with ratings

The project covers:

Designing schema with primary keys and foreign keys

Practicing many-to-many joins through a junction table

Writing SQL queries with JOIN, LEFT JOIN, GROUP BY, aggregates, and conditional logic

🗂️ Schema

reviewers (1) ──< (N) reviews (N) >── (1) series

reviewers: list of reviewers

series: list of TV shows

reviews: junction table storing one review per (series, reviewer) pair

📊 Challenges & Solutions
🔎 1. List all reviews with series
SELECT s.title, r.rating
FROM series s
JOIN reviews r ON s.id = r.series_id;

📈 2. Average rating per series (ascending)
SELECT s.title, ROUND(AVG(r.rating),2) AS avg_rating
FROM series s
JOIN reviews r ON s.id = r.series_id
GROUP BY s.id, s.title
ORDER BY avg_rating ASC;

🧑‍💻 3. Reviews by each reviewer
SELECT v.first_name, v.last_name, r.rating
FROM reviewers v
JOIN reviews r ON v.id = r.reviewer_id;

❌ 4. Series with no reviews
SELECT s.title AS unreviewed_series
FROM series s
LEFT JOIN reviews r ON s.id = r.series_id
WHERE r.id IS NULL;

🎭 5. Average rating by genre
SELECT s.genre, AVG(r.rating) AS avg_rating
FROM series s
JOIN reviews r ON s.id = r.series_id
GROUP BY s.genre;

🏆 6. Reviewer statistics (count, min, max, avg, status)
SELECT 
  v.first_name, 
  v.last_name, 
  COUNT(r.rating) AS review_count,
  IFNULL(MIN(r.rating), 0) AS min_rating,
  IFNULL(MAX(r.rating), 0) AS max_rating,
  IFNULL(ROUND(AVG(r.rating), 2), 0) AS avg_rating,
  CASE WHEN COUNT(r.rating) > 0 THEN 'ACTIVE' ELSE 'INACTIVE' END AS status
FROM reviewers v
LEFT JOIN reviews r ON v.id = r.reviewer_id
GROUP BY v.id, v.first_name, v.last_name;

📝 7. Table: series title | rating | reviewer name
SELECT 
  s.title,
  r.rating,
  CONCAT(v.first_name, ' ', v.last_name) AS reviewer
FROM reviews r
INNER JOIN series    s ON r.series_id   = s.id
INNER JOIN reviewers v ON r.reviewer_id = v.id
ORDER BY s.title, v.last_name, v.first_name;



