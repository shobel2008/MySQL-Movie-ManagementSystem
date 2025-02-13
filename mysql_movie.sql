-- create database
create database movieManagementDB;

-- use the database
use movieManagementDB;

-- create the tables 
-- parent tables movies,users,theatres
-- Movies Table
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    genre VARCHAR(100),
    duration_minutes INT NOT NULL,
    release_date DATE,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    language VARCHAR(100),
    director VARCHAR(255)
);
-- Theaters Table
CREATE TABLE Theaters (
    theater_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    city VARCHAR(100)
);
-- Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'customer') DEFAULT 'customer'
);

-- child tables with Foreign Keys

-- Screens Table
CREATE TABLE screens (
    screen_id INT PRIMARY KEY AUTO_INCREMENT,
    theater_id INT NOT NULL,
    screen_number INT NOT NULL,
    total_seats INT NOT NULL,
    FOREIGN KEY (theater_id) REFERENCES Theaters(theater_id) ON DELETE CASCADE,
    UNIQUE (theater_id, screen_number)
);


-- Showtimes Table
CREATE TABLE showtimes (
    showtime_id INT PRIMARY KEY AUTO_INCREMENT,
    movie_id INT NOT NULL,
    screen_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (screen_id) REFERENCES Screens(screen_id) ON DELETE CASCADE,
    CHECK (start_time < end_time)
);

-- Seats Table
CREATE TABLE seats (
    seat_id INT PRIMARY KEY AUTO_INCREMENT,
    screen_id INT NOT NULL,
    seat_number INT NOT NULL,
    seat_type ENUM('Standard', 'Premium', 'VIP') NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (screen_id) REFERENCES Screens(screen_id) ON DELETE CASCADE,
    UNIQUE (screen_id, seat_number)
);

-- Bookings Table
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    showtime_id INT NOT NULL,
    seat_id INT NOT NULL,
    booking_date DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (showtime_id) REFERENCES Showtimes(showtime_id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES Seats(seat_id) ON DELETE CASCADE,
    UNIQUE (showtime_id, seat_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed') DEFAULT 'pending',
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE,
    CHECK (amount >= 0)
);


ALTER TABLE Payments 
MODIFY COLUMN payment_status ENUM('pending', 'completed', 'failed', 'cancelled') DEFAULT 'pending';


-- insert into tables
-- Movies Table Inserts
INSERT INTO Movies (name, genre, duration_minutes, release_date, rating, language, director) VALUES

('Vidaamuyarchi', 'Drama', 162, '2025-02-7', 4, 'Tamil', 'Magizh thirumeni'),
('Kanguva', 'Action', 165, '2024-04-12', 5, 'Tamil', 'Siva'),
('Captain Miller', 'Period', 157, '2024-01-12', 4, 'Tamil', 'Arun Matheswaran'),
('Leo', 'Action', 168, '2023-10-19', 5, 'Tamil', 'Lokesh Kanagaraj'),

('KGF Chapter 2', 'Drama', 168, '2022-04-14', 5, 'Kannada', 'Prashanth Neel'),
('Kantara', 'Drama', 150, '2022-09-30', 5, 'Kannada', 'Rishab Shetty'),

('RRR', 'Action', 182, '2022-03-25', 5, 'Tamil', 'S.S. Rajamouli'),
('Salaar', 'Thriller', 175, '2023-12-22', 4, 'Tamil', 'Prashanth Neel');

select * from Movies ;

-- Theaters Table Inserts 
INSERT INTO Theaters (name, city) VALUES
('PVR', 'velachery'),
('AGS Cinemas', 'whitefield'),
('Rohini Silver Screens', 'koyambedu');
 select * from Theaters;

INSERT INTO Screens (theater_id, screen_number, total_seats) VALUES
(1, 1, 25), -- PVR Screen 1 (Premium Screen)
(1, 2, 25), -- PVR Screen 2 (Standard Screen)
(2, 1, 25), -- AGS Screen 1 (IMAX Screen)
(3, 1, 25); -- Rohini Screen 1 (Standard Screen)
INSERT INTO Screens (theater_id, screen_number, total_seats) VALUES
(2, 2, 25); -- AGS Screen 1 (IMAX Screen)
 select * from screens;

-- Seats Table with various types and special pricing
INSERT INTO Seats (screen_id, seat_number, seat_type, price) VALUES
-- PVR Screen 1 (Premium Screen) - Higher pricing
(1, 1, 'Standard', 200.00),
(1, 2, 'Standard', 200.00),
(1, 3, 'Premium', 350.00),
(1, 4, 'Premium', 350.00),
(1, 5, 'VIP', 500.00),
-- PVR Screen 2 (Standard Screen) - Normal pricing
(2, 1, 'Standard', 120.00),
(2, 2, 'Standard', 120.00),
(2, 3, 'Premium', 180.00),
(2, 4, 'Premium', 180.00),
(2, 5, 'VIP', 300.00),
-- AGS Screen (IMAX - Higher pricing)
(3, 1, 'Standard', 250.00),
(3, 2, 'Premium', 400.00),
(3, 3, 'VIP', 600.00),
(3, 4, 'VIP', 600.00),
(3, 5, 'VIP', 600.00);

-- AGS Screen (IMAX - Higher pricing)
INSERT INTO Seats (screen_id, seat_number, seat_type, price) VALUES
(5, 8, 'Standard', 600.00),
(5, 9, 'Standard', 600.00);


-- Users Table insert
INSERT INTO Users (name, email, password_hash, phone, role) VALUES
('Arjun ', 'arjun@email.com', 'hashed_password_1', '9876543210', 'customer'),
('Piya', 'piya@email.com', 'hashed_password_2', '9876543211', 'customer'),
('Raju', 'karthik@email.com', 'hashed_password_3', '9876543212', 'admin'),
('Arun Gowda', 'arun@email.com', 'hashed_password_4', '9876543213', 'customer'),
('Rakshith Shetty', 'rakshith@email.com', 'hashed_password_5', '9876543214', 'customer'),
('Deepa Menon', 'deepa@email.com', 'hashed_password_6', '9876543215', 'admin');

INSERT INTO Users (name, email, password_hash, phone, role) VALUES
('shoj', 'shoj@email.com', '2001', '9629772950', 'customer');

select * from users;

--  Showtimes insert
INSERT INTO Showtimes (movie_id, screen_id, start_time, end_time) VALUES
-- Regular shows
(1, 1, '2024-02-06 10:00:00', '2024-02-06 12:42:00'),
(2, 2, '2024-02-06 11:00:00', '2024-02-06 13:45:00'),
-- Kannada movies in Bangalore
(5, 3, '2024-02-06 14:00:00', '2024-02-06 16:48:00'),
(6, 3, '2024-02-06 18:00:00', '2024-02-06 20:30:00'),

(7, 1, '2024-02-06 15:00:00', '2024-02-06 18:02:00'),
(8, 2, '2024-02-06 16:00:00', '2024-02-06 18:55:00');

-- Extended Bookings with various scenarios
INSERT INTO Bookings (user_id, showtime_id, seat_id, booking_date) VALUES
-- Regular bookings
(1, 1, 1, '2024-02-05 15:30:00'),
(2, 2, 6, '2024-02-05 16:00:00'),
-- Premium/VIP bookings for Kannada movies
(4, 3, 13, '2024-02-05 17:00:00'),
(5, 4, 14, '2024-02-05 17:30:00'),

(2, 5, 5, '2024-02-05 18:00:00'),
(3, 6, 10, '2024-02-05 18:30:00');
select * from bookings;

INSERT INTO Payments (booking_id, amount, payment_date, payment_status) VALUES
-- Completed payments
(1, 200.00, '2024-02-05 15:31:00', 'completed'),
(2, 120.00, '2024-02-05 16:01:00', 'completed'),
-- Pending high-value payments for VIP seats
(3, 600.00, '2024-02-05 17:01:00', 'pending'),
(4, 600.00, '2024-02-05 17:31:00', 'pending'),
-- Failed payment attempt
(5, 500.00, '2024-02-05 18:01:00', 'failed'),
-- Completed premium booking
(6, 300.00, '2024-02-05 18:31:00', 'completed');

-- --------------------------------------------------------------------------------------------------------- --

-- indexes 
CREATE INDEX idx_movie_release ON Movies(release_date);
CREATE INDEX idx_movie_language ON Movies(language);
CREATE INDEX idx_showtime_start ON Showtimes(start_time);
CREATE INDEX idx_booking_date ON Bookings(booking_date);
CREATE INDEX idx_payment_status ON Payments(payment_status);
CREATE INDEX idx_theater_city ON Theaters(city);

-- --------------------------------------------------------------------------------------------------------- --

-- get all 7 tables data
call  Get_All_7_tables;

-- core queries

-- 1. Get All  Movies based on ratings
SELECT name, genre, language, rating 
FROM Movies 
ORDER BY rating DESC;


-- 2. Find Theaters Playing a Specific Movie
DELIMITER //

CREATE PROCEDURE GetTheatersByMovie(IN movie_name VARCHAR(255))
BEGIN
    SELECT DISTINCT t.name AS theater_name, t.city, m.name AS movie_name
    FROM Movies m
    JOIN Showtimes s ON m.movie_id = s.movie_id
    JOIN Screens sc ON s.screen_id = sc.screen_id
    JOIN Theaters t ON sc.theater_id = t.theater_id
    WHERE m.name = movie_name;
END //

DELIMITER ;

CALL GetTheatersByMovie('kanguva');

-- select * from showtimes where movie_id=(SELECT movie_id FROM Movies WHERE name = 'Captain Miller'); --

-- --------------------------------------------------------------------------------------------------------- -- 

-- Business Logic Procedure (booking a seat ,canceling a booking)
-- 3. book a seat 
DELIMITER //

CREATE PROCEDURE BookTicket(
    IN p_user_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone VARCHAR(15),
    IN p_showtime_id INT,
    IN p_seat_id INT,
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE user_id INT;
    DECLARE seat_price DECIMAL(10,2);

    -- Check if the user already exists
    SELECT user_id INTO user_id FROM Users WHERE email = p_email LIMIT 1;

    -- If user does not exist, create a new user
    IF user_id IS NULL THEN
        INSERT INTO Users (name, email, password_hash, phone, role)
        VALUES (p_user_name, p_email, 'new_password', p_phone, 'customer');
        
        SET user_id = LAST_INSERT_ID(); -- Get the new user ID
    END IF;

    -- Get the seat price based on the seat_id
    SELECT price INTO seat_price FROM Seats WHERE seat_id = p_seat_id;

    -- Check if the seat is available
    IF NOT EXISTS (
        SELECT 1 FROM Bookings WHERE showtime_id = p_showtime_id AND seat_id = p_seat_id
    ) THEN
        -- Insert a new booking
        INSERT INTO Bookings (user_id, showtime_id, seat_id, booking_date)
        VALUES (user_id, p_showtime_id, p_seat_id, NOW());

        -- Insert payment record with the correct seat price
        INSERT INTO Payments (booking_id, amount, payment_date, payment_status)
        VALUES (
            LAST_INSERT_ID(), 
            seat_price,
            NOW(), 																
            'pending'
        );

        -- Success message
        SET p_message = 'Booking successful';
    ELSE
        -- If the seat is already booked, return an error message
        SET p_message = 'Seat already taken';
    END IF;
END //

DELIMITER ;

CALL BookTicket('newuser3', 'newuser3@email.com', '9998987776', 3, 3, @message);
SELECT @message;

CALL BookTicket('newuser2', 'newuser2@email.com', '9898887776', 3, 3, @message);
SELECT @message;
drop procedure BookTicket;

-- -------------------------------------------------------------------------------------------------------- --
-- Business Logic Procedure 
-- 4. cancel a booking

DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN p_booking_id INT,
    OUT p_message VARCHAR(50)
)
BEGIN
    -- Check if the booking exists
    IF EXISTS (SELECT 1 FROM Bookings WHERE booking_id = p_booking_id) THEN
    
        -- Update the payment status to 'cancelled'
        UPDATE Payments 
        SET payment_status = 'cancelled' 
        WHERE booking_id = p_booking_id;
        
        -- Delete the booking (optional: or update status instead of deleting)
        DELETE FROM Bookings WHERE booking_id = p_booking_id;

        -- Success message
        SET p_message = 'Booking cancelled successfully';
    ELSE
        -- If the booking ID does not exist
        SET p_message = 'Booking not found';
    END IF;
END //

DELIMITER ;
CALL CancelBooking(5, @message);
SELECT @message;

select * from bookings;




-- 5. List Screens and Their Seat Count in a Theater
SELECT 
    t.name AS theater_name, 
    sc.screen_number, 
    sc.total_seats,
    COUNT(s.seat_id) AS total_screen_seats
FROM Theaters t
JOIN Screens sc ON t.theater_id = sc.theater_id
LEFT JOIN Seats s ON sc.screen_id = s.screen_id
GROUP BY t.name, sc.screen_number, sc.total_seats;


-- 6. Find Showtimes for a Movie in a City
SELECT 
    m.name AS movie_name, 
    t.name AS theater_name, 
    t.city, 
    s.start_time, 
    s.end_time
FROM Movies m
JOIN Showtimes s ON m.movie_id = s.movie_id
JOIN Screens sc ON s.screen_id = sc.screen_id
JOIN Theaters t ON sc.theater_id = t.theater_id
WHERE m.name = 'Vidaamuyarchi' AND t.city = 'Velachery';
    
-- 7. Find all Tamil movies and their showtimes in city with starting letter V
SELECT m.name, m.language, t.city, s.start_time
FROM Movies m
JOIN Showtimes s ON m.movie_id = s.movie_id
JOIN Screens sc ON s.screen_id = sc.screen_id
JOIN Theaters t ON sc.theater_id = t.theater_id
WHERE m.language LIKE '%Tamil%' AND t.city like 'V%' ;

-- 8. Check Available Seats for a Showtime
SELECT 
    s.seat_id, 
    s.seat_number, 
    s.seat_type, 
    s.price
FROM Seats s
JOIN Screens sc ON s.screen_id = sc.screen_id
JOIN Showtimes st ON sc.screen_id = st.screen_id
LEFT JOIN Bookings b ON s.seat_id = b.seat_id AND st.showtime_id = b.showtime_id
WHERE st.showtime_id = 1 AND b.booking_id IS NULL;

-- 9. Find a User's Booking History
SELECT 
    m.name AS movie_name, 
    t.name AS theater_name, 
    s.start_time, 
    se.seat_type, 
    p.amount, 
    p.payment_status
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Showtimes s ON b.showtime_id = s.showtime_id
JOIN Movies m ON s.movie_id = m.movie_id
JOIN Seats se ON b.seat_id = se.seat_id
JOIN Screens sc ON se.screen_id = sc.screen_id
JOIN Theaters t ON sc.theater_id = t.theater_id
JOIN Payments p ON b.booking_id = p.booking_id
WHERE u.user_id = 3;



-- ADVANCED QUERIES

-- 10. Rank Movies by Rating
SELECT 
    name, 
    language, 
    rating,
    RANK() OVER (ORDER BY rating DESC) AS movie_rank
FROM Movies;

-- 11. Top 5 Movies in a Specific Language
SELECT 
    name, 
    genre, 
    rating,
    DENSE_RANK() OVER (ORDER BY rating DESC) AS rating_rank
FROM Movies
WHERE language LIKE '%Tamil%'
LIMIT 5;

-- 12. Theaters with Maximum Screens
SELECT 
    t.name AS theater_name, 
    COUNT(sc.screen_id) AS screen_count
FROM Theaters t
JOIN Screens sc ON t.theater_id = sc.theater_id
GROUP BY t.name
ORDER BY screen_count DESC
LIMIT 3;

-- 13.total Revenue Generated by Each Theater


DELIMITER //
CREATE PROCEDURE GetRevenuePartitioned()
BEGIN
    SELECT 
        t.theater_id,
        t.name AS theater_name,
        t.city,
        SUM(p.amount) AS total_revenue,
        SUM(SUM(p.amount)) OVER(PARTITION BY t.city) AS city_total_revenue
    FROM Theaters t
    JOIN Screens sc ON t.theater_id = sc.theater_id
    JOIN Showtimes st ON sc.screen_id = st.screen_id
    JOIN Bookings b ON st.showtime_id = b.showtime_id
    JOIN Payments p ON b.booking_id = p.booking_id
    WHERE p.payment_status = 'completed'
    GROUP BY t.theater_id;
END //
DELIMITER ;
call  GetRevenuePartitioned;


-- 14. Find Most Popular Movie (Based on Bookings)
SELECT 
    m.name AS movie_name, 
    COUNT(b.booking_id) AS total_bookings,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS popularity_rank
FROM Movies m
JOIN Showtimes s ON m.movie_id = s.movie_id
JOIN Bookings b ON s.showtime_id = b.showtime_id
GROUP BY m.name
ORDER BY total_bookings DESC
LIMIT 1;


-- ------------------------------------------------------------------------------------------------------ --

-- views 
-- 1 kannada_movie_in_whitefield_bangalore
create view  kannada_movie_in_whitefield_bangalore as
select m.name as movie_name,m.language, t.name as theater_name, t.city ,s.start_time
from movies m
join showtimes s on m.movie_id=s.movie_id
join screens sc on s.screen_id=sc.screen_id
join theaters t  on sc.theater_id=t.theater_id
where m.language like '%kannada%' and t.city like'%whitefield';

select * from kannada_movie_in_whitefield_bangalore;

-- ------------------------------------------------------------------------------------------------------ --
-- 2 find_all_bookings
-- Show all bookings with movie names, seat types, and payment status
create view all_bookings as
SELECT 
    u.name as customer_name,
    m.name as movie_name,
    s.seat_type,
    p.amount,
    p.payment_status
FROM Bookings b
JOIN Users u ON b.user_id = u.user_id
JOIN Showtimes sh ON b.showtime_id = sh.showtime_id
JOIN Movies m ON sh.movie_id = m.movie_id
JOIN Seats s ON b.seat_id = s.seat_id
JOIN Payments p ON b.booking_id = p.booking_id
ORDER BY b.booking_date;

select * from all_bookings;
-- ------------------------------------------------------------------------------------------------------ --
-- Find all pending  payments

create view find_all_pending_payments as
SELECT u.name as username, m.name movie_name, s.seat_type, p.amount, p.payment_status
FROM Payments p
JOIN Bookings b ON p.booking_id = b.booking_id
JOIN Users u ON b.user_id = u.user_id
JOIN Seats s ON b.seat_id = s.seat_id
JOIN Showtimes sh ON b.showtime_id = sh.showtime_id
JOIN Movies m ON sh.movie_id = m.movie_id
WHERE p.payment_status = 'pending';

select * from find_all_pending_payments;

-- --------------------------------------------------------------------------------------------------------- --

-- Utility Procedure  
DELIMITER //

CREATE PROCEDURE Get_All_7_tables()
BEGIN
    -- Get all Users
    SELECT * FROM Users;

    -- Get all Movies
    SELECT * FROM Movies;

    -- Get all Theaters
    SELECT * FROM Theaters;

    -- Get all Screens
    SELECT * FROM Screens;

    -- Get all Seats
    SELECT * FROM Seats;

    -- Get all Showtimes
    SELECT * FROM Showtimes;

    -- Get all Bookings
    SELECT * FROM Bookings;

    -- Get all Payments
    SELECT * FROM Payments;

END //

DELIMITER ;
