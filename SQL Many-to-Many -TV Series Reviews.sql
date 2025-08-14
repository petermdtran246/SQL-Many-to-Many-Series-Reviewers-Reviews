-- ========== SCHEMA ==========
CREATE TABLE reviewers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL
);

CREATE TABLE series (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(100),
  released_year YEAR,
  genre VARCHAR(100)
);

CREATE TABLE reviews (
  id INT PRIMARY KEY AUTO_INCREMENT,
  rating DECIMAL(2,1),
  series_id INT,
  reviewer_id INT,
  FOREIGN KEY (series_id) REFERENCES series(id),
  FOREIGN KEY (reviewer_id) REFERENCES reviewers(id)
);

-- ========== SEED DATA ==========
-- Insert TV Series
INSERT INTO series (title, released_year, genre) VALUES
('Archer', 2009, 'Animation'),
('Arrested Development', 2003, 'Comedy'),
("Bob's Burgers", 2011, 'Animation'),
('Bojack Horseman', 2014, 'Animation'),
("Breaking Bad", 2008, 'Drama'),
('Curb Your Enthusiasm', 2000, 'Comedy'),
("Fargo", 2014, 'Drama'),
('Freaks and Geeks', 1999, 'Comedy'),
('General Hospital', 1963, 'Drama'),
('Halt and Catch Fire', 2014, 'Drama'),
('Malcolm In The Middle', 2000, 'Comedy'),
('Pushing Daisies', 2007, 'Comedy'),
('Seinfeld', 1989, 'Comedy'),
('Stranger Things', 2016, 'Drama');

-- Insert Reviewers
INSERT INTO reviewers (first_name, last_name) VALUES
('Thomas', 'Stoneman'),
('Wyatt',  'Skaggs'),
('Kimbra', 'Masters'),
('Domingo','Cortes'),
('Colt',   'Steele'),
('Pinkie', 'Petit'),
('Marlon', 'Crafford');

-- Insert Reviews
INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
(1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
(2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
(3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
(4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
(5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
(6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
(7,2,9.1),(7,5,9.7),
(8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
(9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
(10,5,9.9),
(13,3,8.0),(13,4,7.2),
(14,2,8.5),(14,3,8.9),(14,4,8.9);

-- ========== CHECK DATA ==========
SELECT * FROM reviewers;
SELECT * FROM series;
SELECT * FROM reviews;

-- ========== QUERIES ==========
-- 1) List all reviews with their series
SELECT s.title, r.rating
FROM series s
JOIN reviews r ON s.id = r.series_id;

-- 2) Average rating per series (group by series id and title)
SELECT s.id, s.title, AVG(r.rating) AS avg_rating
FROM series s
JOIN reviews r ON s.id = r.series_id
GROUP BY s.id, s.title
ORDER BY avg_rating ASC;

-- 2a) Average rating rounded to 2 decimals
SELECT s.id, s.title, ROUND(AVG(r.rating), 2) AS avg_rating
FROM series s
JOIN reviews r ON s.id = r.series_id
GROUP BY s.id, s.title
ORDER BY avg_rating ASC;

-- 3) Show all ratings left by each reviewer
SELECT v.first_name, v.last_name, r.rating
FROM reviewers v
JOIN reviews r ON v.id = r.reviewer_id;

-- 4) Series without any reviews
SELECT s.title AS unreviewed_series
FROM series s
LEFT JOIN reviews r ON s.id = r.series_id
WHERE r.id IS NULL;

-- 5) Average rating grouped by genre
SELECT s.genre, AVG(r.rating) AS avg_rating
FROM series s
JOIN reviews r ON s.id = r.series_id
GROUP BY s.genre;

-- 6) Reviewer statistics (count, min, max, avg, status)
SELECT 
  v.first_name, 
  v.last_name, 
  COUNT(r.rating)                    AS review_count,
  IFNULL(MIN(r.rating), 0)           AS min_rating,
  IFNULL(MAX(r.rating), 0)           AS max_rating,
  IFNULL(ROUND(AVG(r.rating), 2), 0) AS avg_rating,
  CASE WHEN COUNT(r.rating) > 0 THEN 'ACTIVE' ELSE 'INACTIVE' END AS status
FROM reviewers v
LEFT JOIN reviews r ON v.id = r.reviewer_id
GROUP BY v.id, v.first_name, v.last_name
ORDER BY v.last_name, v.first_name;

-- 7) Join all three tables: series | rating | reviewer
SELECT 
  s.title,
  r.rating,
  CONCAT(v.first_name, ' ', v.last_name) AS reviewer
FROM reviews r
INNER JOIN series    s ON r.series_id   = s.id
INNER JOIN reviewers v ON r.reviewer_id = v.id
ORDER BY s.title, v.last_name, v.first_name;

-- Alternative join orders (equivalent results)
-- Option 2: Start from series
SELECT 
  s.title, r.rating, CONCAT(v.first_name, ' ', v.last_name) AS reviewer
FROM series s
JOIN reviews r   ON r.series_id   = s.id
JOIN reviewers v ON r.reviewer_id = v.id;

-- Option 3: Start from reviewers
SELECT 
  s.title, r.rating, CONCAT(v.first_name, ' ', v.last_name) AS reviewer
FROM reviewers v
JOIN reviews r ON r.reviewer_id = v.id
JOIN series  s ON r.series_id   = s.id;
