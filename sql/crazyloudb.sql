-- phpMyAdmin SQL Dump
-- version 4.7.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Sep 13, 2019 at 03:47 AM
-- Server version: 5.6.35
-- PHP Version: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `php_project3`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `admin_check` (IN `idnum` INT(2))  NO SQL
    COMMENT 'used in: discussion/comments, nav'
SELECT id, admin, expert FROM customer WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `album_get_artist` (IN `artid` INT)  READS SQL DATA
SELECT *
FROM album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
  AND album.artistgroupid = artid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `album_get_price` (IN `num` INT)  READS SQL DATA
SELECT album.albumid, album.price as price, album.albumname as album, artistgroup.artistgroupname as artist
from album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
  AND album.albumid = num$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `album_get_tracks` (IN `id` INT)  READS SQL DATA
SELECT tracks.trackname
FROM album, tracks, trackcreation
WHERE album.tracklistid = trackcreation.tracklistid
  AND trackcreation.trackid = tracks.trackid
  AND album.tracklistid = id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `album_load_all` (IN `sortval` VARCHAR(100))  NO SQL
SELECT *
FROM album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
ORDER BY sortval ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `album_load_by_catid` (IN `catid` INT(11), IN `ord` VARCHAR(20))  NO SQL
SELECT *
FROM album, albumcreation, category, artistgroup
WHERE album.albumid = albumcreation.albumid
  AND artistgroup.artistgroupid = album.artistgroupid
  AND albumcreation.categoryid = category.categoryid
  AND category.categoryid = catid
ORDER BY ord$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `category_load` ()  NO SQL
SELECT *
FROM category
ORDER BY sortid ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `comment_insert_new` (IN `useridnum` INT(11), IN `textval` VARCHAR(400), IN `postidnum` INT(11))  MODIFIES SQL DATA
INSERT INTO comments(userid, text, date, time, postid)
	VALUES(useridnum, textval, CURRENT_DATE, CURRENT_TIME, postidnum)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `comment_load_based_on_postid` (IN `postidnum` INT)  NO SQL
SELECT * FROM comments
WHERE postid = postidnum
AND active = 1
ORDER BY date DESC, time DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `comment_remove` (IN `commentid` INT(2))  MODIFIES SQL DATA
UPDATE comments SET active = 0 WHERE id = commentid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `countries_load` ()  NO SQL
SELECT *
FROM country$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `create_get_inserted_id` (IN `emailval` VARCHAR(50))  NO SQL
Select Max(id) as lastid, email
from customer
where email = emailval$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `creditcard_load` ()  NO SQL
SELECT *
FROM creditcard$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discussion_based_on_subj` (IN `subjid` INT(11))  NO SQL
SELECT * FROM discussion, subject
	WHERE discussion.subjectid = subject.id
    AND discussion.active = 1
    AND subject.id = subjid
    	ORDER BY discussion.postdate ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discussion_get_username` (IN `idnum` INT(11))  NO SQL
SELECT firstname, lastname, expert FROM customer WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discussion_insert_new` (IN `subid` INT(11), IN `titleparam` VARCHAR(55), IN `bodyparam` VARCHAR(400), IN `useridnum` INT(11))  MODIFIES SQL DATA
INSERT INTO discussion(subjectid, title, body, postdate, posttime, userid)
	VALUES(subid, titleparam, bodyparam, CURRENT_DATE, CURRENT_TIME, useridnum)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discussion_load_all` ()  NO SQL
SELECT * FROM discussion, subject
	WHERE discussion.subjectid = subject.id
    AND discussion.active = 1
    	ORDER BY discussion.postdate ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discussion_load_based_on_subj` (IN `idnum` INT(11))  NO SQL
SELECT * FROM discussion, subject
	WHERE discussion.subjectid = subject.id
    AND subject.id = idnum
    	ORDER BY discussion.postdate ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `discussion_post_remove` (IN `postidnum` INT)  MODIFIES SQL DATA
UPDATE discussion SET active = 0 WHERE postid = postidnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `history_load` (IN `custid` INT(11))  NO SQL
SELECT DISTINCT orders.id as ordernum, orders.date as date, orderpayment.id as invnum, orderpayment.total as total
FROM orders, orderpayment
WHERE orders.id = orderpayment.orderid
  AND orders.customerid = custid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_address` (IN `str` VARCHAR(100), IN `ste` VARCHAR(100), IN `cty` VARCHAR(100), IN `prov` VARCHAR(100), IN `post` VARCHAR(100), IN `ctry` VARCHAR(100), IN `lastid` INT)  MODIFIES SQL DATA
INSERT INTO address
  (street, suite, city, province, postal, country, customerid, active)
VALUES(str, ste, cty, prov, post, ctry, lastid, 1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_cust` (IN `fname` VARCHAR(100), IN `lname` VARCHAR(100), IN `email` VARCHAR(100), IN `pass` VARCHAR(100))  MODIFIES SQL DATA
INSERT INTO customer
  (id, firstname, lastname, email, password, active)
VALUES(NULL, fname, lname, email, pass, 1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_phone` (IN `num` VARCHAR(20), IN `extVal` VARCHAR(20), IN `typeVal` VARCHAR(20), IN `custid` INT(11))  MODIFIES SQL DATA
INSERT INTO phone(number, ext, type, customerid, active)
	VALUES(num, extVal, typeVal, custid, 1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `login_check` (IN `login` VARCHAR(100), IN `pword` VARCHAR(100))  READS SQL DATA
SELECT customer.id as loginid
FROM customer
WHERE customer.email = login AND customer.password = pword
  AND customer.active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `logout_clear_prev` (IN `custid` INT)  MODIFIES SQL DATA
UPDATE session SET isloggedin = 0
WHERE customerid = custid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ordcomplete_get_order_info` (IN `idnum` INT(11))  NO SQL
SELECT *
FROM orders
WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ordcomplete_get_pay_info` (IN `idnum` INT(11))  NO SQL
SELECT *
FROM orderpayment
WHERE orderid = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ordercc_insert` (IN `name` VARCHAR(100), IN `num` INT(11), IN `type` VARCHAR(20), IN `exp` VARCHAR(20), IN `csvnum` INT(11), IN `subt` DECIMAL(10,2), IN `taxnum` DECIMAL(10,2), IN `totalnum` DECIMAL(10,2), IN `orderidnum` INT(11))  MODIFIES SQL DATA
INSERT INTO orderpayment
  (ccname, ccnum, cctype, expiry, csv, subtotal, tax, total, orderid)
VALUES(name, num, type, exp, csvnum, subt, taxnum, totalnum, orderidnum)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `orderdetails_insert` (IN `orderidnum` INT(11), IN `albumidnum` INT(11), IN `price` DECIMAL(10,2), IN `qtynum` INT(11))  MODIFIES SQL DATA
INSERT INTO orderdetails
  (orderid, albumid, albumprice, qty)
VALUES(orderidnum, albumidnum, price, qtynum)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ordershipto_insert` (IN `adrs` VARCHAR(100), IN `ste` VARCHAR(10), IN `cty` VARCHAR(25), IN `prov` VARCHAR(25), IN `post` VARCHAR(10), IN `ctry` VARCHAR(25), IN `orderidnum` INT(11))  MODIFIES SQL DATA
INSERT INTO ordership
  (address, suite, city, province, postal, country, orderid)
VALUES(adrs, ste, cty, prov, post, ctry, orderidnum)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_get_lastid` (IN `custid` INT)  NO SQL
SELECT MAX(id) as lastid, date, customerid
from orders
WHERE customerid = custid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `order_insert` (IN `custid` INT)  MODIFIES SQL DATA
INSERT INTO orders
  (date, customerid, active)
VALUES(CURRENT_DATE, custid, 1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `payment_load_address` (IN `shipid` INT)  NO SQL
SELECT *
FROM address
WHERE customerid = shipid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `phonetype_load` ()  NO SQL
SELECT *
FROM phonetype
ORDER BY display ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_address` (IN `idnum` INT)  READS SQL DATA
SELECT *
FROM address
WHERE customerid = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_phone` (IN `idnum` INT)  READS SQL DATA
SELECT *
FROM phone
WHERE customerid = idnum
  AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_securityquestion` (IN `custidnum` INT(11))  NO SQL
SELECT * from userquestions, securityquestions
WHERE userquestions.questionid = securityquestions.id
	AND userquestions.custid = custidnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_user` (IN `getid` INT)  READS SQL DATA
SELECT *
FROM customer
WHERE id = getid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_subscriber_check` (IN `idnum` INT(2))  NO SQL
SELECT subscriber FROM customer WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_address` (IN `idnum` INT, IN `str` VARCHAR(40), IN `ste` VARCHAR(40), IN `cty` VARCHAR(40), IN `post` VARCHAR(10), IN `prov` VARCHAR(10), IN `ctry` VARCHAR(10))  MODIFIES SQL DATA
    COMMENT '** make sure is customerid from address not id'
UPDATE address SET street = str, suite = ste, city = cty, postal = post, province = prov, country = ctry
WHERE customerid = idnum AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_name` (IN `fname` VARCHAR(100), IN `lname` VARCHAR(100), IN `eml` VARCHAR(100), IN `idnum` INT)  MODIFIES SQL DATA
UPDATE customer SET firstname = fname, lastname = lname, email = eml
WHERE id = idnum AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_pass` (IN `pword` VARCHAR(100), IN `idnum` INT)  MODIFIES SQL DATA
UPDATE customer SET password = pword
WHERE id = idnum AND active = 1$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_phone` (IN `idnum` INT, IN `phonenum` VARCHAR(20), IN `extnum` VARCHAR(10), IN `ptype` VARCHAR(2))  MODIFIES SQL DATA
    COMMENT 'id instead of customerid to because of 2 phnums'
UPDATE phone SET number = phonenum, ext = extnum, type = ptype
WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_question` (IN `questionval` INT(11), IN `answerval` VARCHAR(155), IN `userid` INT(11))  MODIFIES SQL DATA
UPDATE userquestions
SET questionid = questionval, answer = answerval
WHERE custid = userid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `provinces_load` ()  NO SQL
SELECT *
FROM province$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_check_email` (IN `useremail` VARCHAR(155))  NO SQL
SELECT * from customer
WHERE email = useremail$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_get_userquestion` (IN `custidnum` INT(11))  NO SQL
SELECT * FROM userquestions
WHERE custid = custidnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_show_question` (IN `questionid` INT(2))  NO SQL
SELECT * FROM securityquestions
WHERE id = questionid$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `reset_update_pass` (IN `idnum` INT(11), IN `newpass` VARCHAR(155))  MODIFIES SQL DATA
UPDATE customer SET password = newpass WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `securityquestions_load` ()  NO SQL
SELECT * from securityquestions$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_check` (IN `id` INT, IN `sessval` VARCHAR(100))  NO SQL
SELECT *
FROM session
WHERE customerid = id AND sessionval = sessval$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_insert` (IN `id` INT, IN `sessval` VARCHAR(100))  MODIFIES SQL DATA
INSERT INTO session
  (customerid, sessionval, logindate, logintime, isloggedin)
VALUES(id, sessval, CURRENT_DATE, CURRENT_TIME, 1)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `session_update_logout_date` (IN `idnumber` INT)  MODIFIES SQL DATA
UPDATE session SET logoutdate = CURRENT_DATE, logouttime = CURRENT_TIME, isloggedin = 0
WHERE id = idnumber$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `subject_insert_new` (IN `subj` VARCHAR(55), IN `sortvalnum` INT(2))  MODIFIES SQL DATA
    COMMENT 'create new subject option'
INSERT INTO subject(subjectname, datecreated, sortval)
	VALUES(subj, CURRENT_DATE, sortvalnum)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `subject_load_all` ()  NO SQL
    COMMENT 'see all from table'
SELECT id, subjectname, sortval FROM subject
ORDER BY sortval ASC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `subject_max_sortval` ()  NO SQL
SELECT MAX(sortval) as max_sortval from subject$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `subject_posts_count` ()  NO SQL
SELECT subject.id, subject.subjectname, COUNT(discussion.postid) AS post_count
	FROM subject
	LEFT JOIN discussion ON discussion.subjectid = subject.id
	GROUP BY 1
    ORDER BY post_count DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `test_procedure` ()  NO SQL
SELECT discussion.id, discussion.title, subject.subjectname FROM discussion, subject
	WHERE discussion.subjectid = subject.id$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usermanage_admin_check` (IN `idnum` INT(2))  NO SQL
SELECT id, admin FROM customer WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usermanage_get_all_customers` ()  NO SQL
SELECT * FROM customer$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usermanage_load_discussion` ()  NO SQL
SELECT discussion.*, customer.firstname, customer.lastname from discussion
INNER JOIN customer ON discussion.userid = customer.id
    WHERE discussion.active = 1
        ORDER BY discussion.postdate DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usermanage_update_expert` (IN `idnum` INT(2), IN `expnum` INT(2))  MODIFIES SQL DATA
UPDATE customer SET expert = expnum
WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usermanage_update_subscriber` (IN `idnum` INT(2), IN `subnum` INT(2))  MODIFIES SQL DATA
UPDATE customer SET subscriber = subnum
WHERE id = idnum$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userquestion_insert` (IN `custidnum` INT(11), IN `questionidnum` INT(11), IN `ans` VARCHAR(155))  MODIFIES SQL DATA
INSERT INTO userquestions(custid, questionid, answer)
	VALUES(custidnum, questionidnum, ans)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address`
--

CREATE TABLE `address` (
  `id` int(11) NOT NULL,
  `street` varchar(125) NOT NULL,
  `suite` varchar(8) NOT NULL,
  `city` varchar(35) NOT NULL,
  `province` varchar(3) NOT NULL,
  `postal` varchar(7) NOT NULL,
  `country` varchar(3) NOT NULL,
  `customerid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `address`
--

INSERT INTO `address` (`id`, `street`, `suite`, `city`, `province`, `postal`, `country`, `customerid`, `active`) VALUES
(1, '1369 Bloor St W', '408', 'Toronto', 'ON', 'M6P4J4', 'CA', 1, 1),
(2, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 2, 1),
(3, '2222 Yonge St', '201', 'Toronto', '', 'M6K 3J4', 'CA', 5, 1),
(4, '1200 Lakeshore', '1212', 'North York', 'ON', 'M7M 3J4', 'US', 3, 1),
(5, '333 King St East', '333', 'Toronto', 'ON', 'M6H 4T5', 'CA', 4, 1),
(6, '444 Lansdowne Ave', '404', 'Hamilton', 'CA', 'L4H 6K5', 'CA', 6, 1),
(19, '333 Front St', '300', 'Ajax', 'ON', 'M2N 4G4', 'US', 37, 1),
(20, '555 Main St', '', 'Ajax', 'ON', 'M1M 4M4', 'CA', 38, 1),
(24, '55 Starbucks Road', '505', 'Etobicoke', 'ON', 'M4N H3K', 'CA', 42, 1),
(25, '888 Macbook Ave', '', 'Ajax', 'ON', 'M2N 5H3', 'CA', 43, 1),
(26, '888 Macbook Ave', '', 'Ajax', 'ON', 'M2N 5H3', 'CA', 44, 1),
(27, '888 Macbook Ave', '', 'Ajax', 'ON', 'M2N 5H3', 'CA', 45, 1),
(28, '888 Macbook Ave', '', 'Ajax', 'ON', 'M2N 5H3', 'CA', 46, 1),
(29, '888 Macbook Ave', '', 'Ajax', 'AB', 'M2N 5H3', 'CA', 47, 1),
(32, '555 Main St', '', 'Ajax', 'AB', 'M1M 4M4', 'CA', 50, 1),
(41, '777 Emerson St', '', 'Milton', 'ON', 'G5G J7J', 'CA', 63, 1);

-- --------------------------------------------------------

--
-- Table structure for table `album`
--

CREATE TABLE `album` (
  `albumid` int(11) NOT NULL,
  `albumname` varchar(55) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `tracklistid` int(11) NOT NULL,
  `artistgroupid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `album`
--

INSERT INTO `album` (`albumid`, `albumname`, `price`, `tracklistid`, `artistgroupid`, `active`) VALUES
(1, 'Magna Carta', '19.99', 1, 1, 1),
(2, 'The Blueprint 3', '19.99', 2, 1, 1),
(3, 'Good Kid, M.A.A.D City', '21.99', 3, 2, 1),
(4, 'To Pimp a Butterfly', '21.99', 4, 2, 1),
(5, 'Nothing Was the Same', '18.99', 5, 3, 1),
(6, 'Views', '18.99', 6, 3, 1),
(7, 'Divide', '19.99', 7, 4, 1),
(8, 'Doo-Wops & Hooligans', '17.99', 8, 5, 1),
(9, 'Back to Black', '19.99', 9, 6, 1),
(10, 'Hot Fuss', '17.99', 10, 7, 1),
(11, 'Sam\'s Town', '17.99', 11, 7, 1),
(12, '18 Months', '19.99', 12, 8, 1);

-- --------------------------------------------------------

--
-- Table structure for table `albumcreation`
--

CREATE TABLE `albumcreation` (
  `albumid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `albumcreation`
--

INSERT INTO `albumcreation` (`albumid`, `categoryid`, `active`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(4, 1, 1),
(5, 1, 1),
(6, 1, 1),
(7, 3, 1),
(8, 3, 1),
(5, 3, 1),
(6, 3, 1),
(9, 3, 1),
(10, 2, 1),
(10, 3, 1),
(11, 2, 1),
(11, 3, 1),
(12, 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `artistgroup`
--

CREATE TABLE `artistgroup` (
  `artistgroupid` int(11) NOT NULL,
  `artistgroupname` varchar(55) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `artistgroup`
--

INSERT INTO `artistgroup` (`artistgroupid`, `artistgroupname`, `active`) VALUES
(1, 'Jay-Z', 1),
(2, 'Kendrick Lamar', 1),
(3, 'Drake', 1),
(4, 'Ed Sheeran', 1),
(5, 'Bruno Mars', 1),
(6, 'Amy Winehouse', 1),
(7, 'The Killers', 1),
(8, 'Calvin Harris', 1);

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `categoryid` int(11) NOT NULL,
  `categoryname` varchar(35) NOT NULL,
  `sortid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`categoryid`, `categoryname`, `sortid`, `active`) VALUES
(1, 'rap', 2, 1),
(2, 'rock', 3, 1),
(3, 'pop', 4, 1),
(4, 'country', 6, 1),
(5, 'electronic', 5, 1),
(6, 'all', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `text` varchar(400) NOT NULL,
  `date` date NOT NULL,
  `time` datetime NOT NULL,
  `postid` int(11) NOT NULL,
  `active` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `userid`, `text`, `date`, `time`, `postid`, `active`) VALUES
(1, 2, 'No honey.... your teacher said you couldn\'t A-D-D.... that\'s because she also knew you couldn\'t S-P-E-L-L.', '2019-08-06', '2019-08-06 15:24:42', 1, 1),
(2, 47, 'For the first year of his life, I made up Manny to be like a girl and told everyone he was my daughter. Just a few times, I didn\'t want to mess with his head. When he found the pictures I told him it was his twin sister who died.', '2019-08-06', '2019-08-06 15:25:58', 2, 1),
(3, 2, 'If I say something that everybody else is thinking, does that make me a mean person? Or, does it make me a brave person, one who is courageous enough to stand up and say something, behind someone\'s back to a ten-year-old?', '2019-08-06', '2019-08-06 15:26:33', 3, 1),
(4, 5, 'test comment, reply to postid 4', '2019-08-06', '2019-08-06 15:26:53', 4, 1),
(5, 5, 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Architecto eaque ad fugit totam rerum officia vitae, eligendi culpa?  test comment, reply to postid 5', '2019-08-06', '2019-08-06 15:27:26', 5, 1),
(6, 5, 'test comment, reply to postid 6', '2019-08-06', '2019-08-06 15:27:26', 6, 1),
(7, 6, 'Did my 3rd grade teacher say I have ADD or something?', '2019-08-06', '2019-08-06 16:15:02', 1, 1),
(8, 5, 'second comment test for postid 2', '2019-08-06', '2019-08-06 16:15:33', 2, 1),
(9, 3, 'The iPad comes out on my actual birthday. It’s like Steve Jobs and God got together to say, \"We love you, Phil\".', '2019-08-07', '2019-08-07 14:58:32', 6, 1),
(10, 3, 'Success is 1% inspiration, 98% perspiration, and 2% attention to detail.', '2019-08-07', '2019-08-07 15:00:20', 6, 1),
(11, 3, 'I’m the cool dad, that’s my thang. I’m hip, I surf the web, I text. LOL: laugh out loud. OMG: oh my God. WTF: why the face.', '2019-08-07', '2019-08-07 15:03:27', 7, 1),
(16, 2, 'Your kids don\'t need to know who you were before you had them; they need to know who you wish you were, and try to live up to that person. They\'re gonna fall short, but better they fall short of the fake you than the real you.', '2019-08-07', '2019-08-07 16:49:03', 2, 1),
(34, 3, 'Cheerleading in my college was cool. The football players were so jealous they wouldn’t even let me and my buddies – Trevor, Scotty, and Ling – go to their parties', '2019-08-07', '2019-08-07 18:02:56', 1, 1),
(35, 3, 'I always felt bad for people with emotionally distant fathers; it turns out I’m one of them. It’s a miracle I didn’t end up a stripper.', '2019-08-07', '2019-08-07 18:06:48', 6, 1),
(36, 2, 'I was out of control growing up, there you know, I said it. I just don\'t want my kids to make the same bad mistakes I made. If Hailey never wakes up on a beach in Florida half naked, I\'ve done my job.', '2019-08-07', '2019-08-07 18:07:14', 8, 1),
(37, 3, 'I’ll admit it – I’m turned on by powerful women. Michelle Obama, Oprah, Condolezza Rice, Serena Williams...Wait a minute.', '2019-08-07', '2019-08-07 18:07:27', 7, 1),
(38, 2, 'I had to undress a mannequin while a creepy guy filmed it, so we have that to look forward to on the Internet.', '2019-08-07', '2019-08-07 18:14:19', 9, 1),
(39, 3, 'I am brave. Roller coasters? Love ‘em. Scary movies? I’ve seen Ghostbusters, like, seven times. I regularly drive through neighborhoods that have only recently been gentrified. So, yeah, I’m pretty much not afraid of anything.', '2019-08-07', '2019-08-07 18:19:49', 3, 1),
(42, 5, 'test comment on postid # 18', '2019-08-12', '2019-08-12 10:53:15', 18, 1);

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `countryid` int(11) NOT NULL,
  `display` varchar(35) NOT NULL,
  `shortval` varchar(3) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`countryid`, `display`, `shortval`, `active`) VALUES
(1, 'Canada', 'CA', 1),
(2, 'United States', 'US', 1);

-- --------------------------------------------------------

--
-- Table structure for table `creditcard`
--

CREATE TABLE `creditcard` (
  `id` int(11) NOT NULL,
  `name` varchar(25) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `creditcard`
--

INSERT INTO `creditcard` (`id`, `name`, `status`) VALUES
(1, 'visa', 1),
(2, 'mastercard', 1);

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id` int(11) NOT NULL,
  `firstname` varchar(40) NOT NULL,
  `lastname` varchar(40) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(56) NOT NULL,
  `subscriber` int(2) NOT NULL DEFAULT '0',
  `expert` int(2) NOT NULL DEFAULT '0',
  `admin` int(2) NOT NULL DEFAULT '0',
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `firstname`, `lastname`, `email`, `password`, `subscriber`, `expert`, `admin`, `active`) VALUES
(1, 'Patrick', 'Garcia', 'patrick@garcia.com', 'password', 1, 0, 0, 1),
(2, 'Claire', 'Dunphy', 'claire@dunphy.com', 'e65e0707774c11ff1ca15f6e27b67769', 1, 1, 0, 1),
(3, 'Phil', 'Dunphy', 'phil@dunphy.com', '112233', 1, 1, 0, 1),
(5, 'Alex', 'Dunphy', 'alex@dunphy.com', 'e65e0707774c11ff1ca15f6e27b67769', 1, 1, 1, 1),
(6, 'Haley', 'Dunphy', 'haley@dunphy.com', 'e65e0707774c11ff1ca15f6e27b67769', 0, 1, 0, 1),
(37, 'Manny', 'Delgado', 'manny@delgado.com', 'password8800', 0, 0, 0, 1),
(38, 'Mitchell', 'Pritchett', 'mitchell@pritchett.com', 'password9900', 0, 0, 0, 1),
(42, 'Cameron', 'Tucker', 'cameron@tucker.com', 'tucker4444', 0, 0, 0, 1),
(47, 'Gloria', 'Pritchett', 'gloria@pritchett.com', 'ec92d00d7c130df82512548cbc2b4701', 0, 0, 0, 1),
(50, 'Jay', 'Pritchett', 'jay@pritchett.com', '5f4dcc3b5aa765d61d8327deb882cf99', 0, 0, 0, 1),
(63, 'Gil', 'Thorpe', 'gil@thorpe.com', '4edfc924721abb774d5447bade86ea5d', 0, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `discussion`
--

CREATE TABLE `discussion` (
  `postid` int(11) NOT NULL,
  `subjectid` int(11) NOT NULL,
  `title` varchar(55) NOT NULL,
  `body` text NOT NULL,
  `postdate` date NOT NULL,
  `posttime` time NOT NULL,
  `tstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `userid` int(11) NOT NULL,
  `active` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `discussion`
--

INSERT INTO `discussion` (`postid`, `subjectid`, `title`, `body`, `postdate`, `posttime`, `tstamp`, `userid`, `active`) VALUES
(1, 3, 'Pop Music', 'Vivamus a sodales lacus, ut tristique elit. Suspendisse metus ante, laoreet ullamcorper purus in, consectetur commodo libero. Cras vulputate gravida posuere. Donec et purus in orci ultricies dapibus. Fusce ultrices aliquet elementum. Cras ut consequat urna.', '2019-07-30', '12:30:25', '2019-07-30 22:23:37', 2, 1),
(2, 1, 'Rap', 'Suspendisse aliquet urna non ex consequat porttitor. In hac habitasse platea dictumst. Proin eget molestie orci. Phasellus bibendum mauris pharetra sem molestie, ut facilisis tellus sollicitudin. ', '2019-07-30', '12:41:21', '2019-07-30 22:23:37', 2, 1),
(3, 6, '90s Music', 'Phasellus bibendum mauris pharetra sem molestie, ut facilisis tellus sollicitudin. Morbi tincidunt ante ut nunc cursus, eget sodales nisi condimentum. Nulla efficitur accumsan lacinia', '2019-07-30', '13:19:54', '2019-07-30 22:23:37', 3, 1),
(5, 1, 'Kendrick Lamar', 'Etiam commodo eu leo id rhoncus. Mauris id felis eget erat vestibulum vehicula blandit sit amet urna. Suspendisse ac interdum justo. Sed et urna a mi dignissim interdum. Morbi maximus eros in tortor imperdiet rhoncus.', '2019-07-30', '13:26:13', '2019-07-30 22:23:37', 2, 1),
(6, 2, 'Let\'s Rock and / or Roll :)', 'Interdum et malesuada fames ac ante ipsum primis in faucibus. Suspendisse lacinia tempus neque eget ullamcorper. Ut sit amet condimentum erat. Mauris luctus quam ac elit tincidunt ullamcorper.', '2019-07-30', '18:27:40', '2019-07-30 22:27:40', 3, 1),
(7, 1, 'Jay Z vs Kanye', 'Maecenas et augue eu tellus venenatis porttitor ut a lorem. Aliquam pulvinar non turpis vel interdum. Nam egestas mattis egestas. Ut molestie lectus feugiat nibh gravida interdum.', '2019-08-03', '14:44:37', '2019-08-03 18:44:37', 6, 1),
(8, 5, 'Potpourri', 'Totam facilis eligendi ad quisquam ea quos sequi architecto sed, animi accusamus!', '2019-08-03', '14:45:00', '2019-08-03 18:45:00', 5, 1),
(9, 3, 'Music Cities', 'Nuis sit amet interdum enim. Nulla commodo mollis nunc, ac sollicitudin justo placerat non. Suspendisse ipsum quam, porttitor ut aliquet ac, dapibus interdum turpis. Proin mattis at neque ut egestas.', '2019-08-03', '14:45:13', '2019-08-03 18:45:13', 6, 1),
(18, 6, 'beethoven vs mozart', 'Fusce non porta eros. Ut quis turpis a libero facilisis convallis eget at lectus. Aliquam eu sollicitudin libero. Duis faucibus ipsum pulvinar posuere consequat. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '2019-08-08', '17:07:03', '2019-08-08 21:07:03', 5, 1),
(26, 1, 'Ice T vs Ice Cube', 'Pellentesque a justo arcu. Proin maximus magna nulla, non ultrices felis auctor auctor. Pellentesque molestie tempor placerat.', '2019-08-12', '10:21:04', '2019-08-12 14:21:04', 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `email`
--

CREATE TABLE `email` (
  `emailaddressid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `email` varchar(255) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `orderdetails`
--

CREATE TABLE `orderdetails` (
  `id` int(11) NOT NULL,
  `orderid` int(11) NOT NULL,
  `albumid` int(11) NOT NULL,
  `albumprice` decimal(10,2) NOT NULL,
  `qty` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orderdetails`
--

INSERT INTO `orderdetails` (`id`, `orderid`, `albumid`, `albumprice`, `qty`, `active`) VALUES
(1, 3, 3, '20.00', 1, 1),
(3, 3, 2, '20.00', 1, 1),
(7, 14, 9, '19.99', 2, 1),
(8, 15, 7, '20.00', 4, 1),
(10, 19, 7, '20.00', 4, 1),
(13, 26, 12, '20.00', 2, 1),
(14, 26, 9, '19.99', 2, 1),
(21, 30, 1, '19.99', 2, 1),
(22, 30, 11, '17.99', 1, 1),
(29, 34, 1, '19.99', 1, 1),
(30, 34, 12, '19.99', 2, 1),
(31, 34, 9, '19.99', 1, 1),
(32, 35, 4, '21.99', 2, 1),
(33, 35, 2, '19.99', 1, 1),
(34, 36, 9, '19.99', 2, 1),
(35, 5001, 3, '21.99', 1, 1),
(36, 5002, 11, '17.99', 2, 1),
(37, 5003, 7, '19.99', 1, 1),
(38, 5005, 3, '21.99', 1, 1),
(39, 5006, 4, '21.99', 1, 1),
(40, 5007, 11, '17.99', 2, 1),
(42, 5009, 5, '18.99', 1, 1),
(43, 5010, 5, '18.99', 3, 1),
(44, 5011, 12, '19.99', 1, 1),
(45, 5011, 9, '19.99', 1, 1),
(46, 5012, 12, '19.99', 1, 1),
(47, 5013, 2, '19.99', 1, 1),
(48, 5014, 9, '19.99', 2, 1),
(49, 5015, 9, '19.99', 6, 1),
(50, 5016, 9, '19.99', 1, 1),
(51, 5017, 3, '21.99', 2, 1),
(52, 5018, 2, '19.99', 1, 1),
(53, 5019, 1, '19.99', 2, 1),
(54, 5021, 1, '19.99', 1, 1),
(55, 5022, 12, '19.99', 1, 1),
(62, 5029, 3, '21.99', 1, 1),
(63, 5029, 12, '19.99', 1, 1),
(64, 5030, 4, '21.99', 1, 1),
(66, 5032, 1, '19.99', 1, 1),
(67, 5032, 3, '21.99', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orderpayment`
--

CREATE TABLE `orderpayment` (
  `id` int(11) NOT NULL,
  `ccname` varchar(100) NOT NULL,
  `ccnum` int(25) NOT NULL,
  `cctype` varchar(25) NOT NULL,
  `expiry` varchar(25) NOT NULL,
  `csv` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `tax` decimal(10,2) NOT NULL,
  `total` decimal(10,2) NOT NULL,
  `orderid` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orderpayment`
--

INSERT INTO `orderpayment` (`id`, `ccname`, `ccnum`, `cctype`, `expiry`, `csv`, `subtotal`, `tax`, `total`, `orderid`, `active`) VALUES
(1, 'hello', 11223344, 'visa', 'june/2020', 222, '0.00', '0.00', '21.00', 5, 1),
(3, 'Manny Delgado', 44332211, 'visa', 'oct/2020', 333, '0.00', '0.00', '90.40', 19, 1),
(1001, 'manny delgado', 11223344, 'visa', 'june/2020', 555, '10.00', '1.30', '11.30', 20, 1),
(1002, 'claire dunphy', 11332244, 'visa', 'jan/2021', 333, '79.96', '10.39', '90.35', 34, 1),
(1003, 'claire dunphy', 33224411, 'mastercard', 'feb/2023', 333, '63.97', '8.32', '72.29', 35, 1),
(1004, 'claire dunphy', 33445566, 'visa', 'mar/2021', 444, '39.98', '5.20', '45.18', 36, 1),
(1005, 'claire dunphy', 22772277, 'mastercard', 'jan/2021', 333, '21.99', '2.86', '24.85', 5001, 1),
(1006, 'claire dunphy', 44332244, 'visa', 'jan/2021', 444, '35.98', '4.68', '40.66', 5002, 1),
(1007, 'claire dunphy', 55445544, 'visa', 'jan/2021', 777, '19.99', '2.60', '22.59', 5003, 1),
(1008, 'claire dunphy', 44115511, 'visa', 'jan/2021', 4455, '21.99', '2.86', '24.85', 5005, 1),
(1009, 'claire dunphy', 11771188, 'visa', 'jan/2021', 1177, '21.99', '2.86', '24.85', 5006, 1),
(1010, 'claire dunphy', 11881199, 'visa', 'jan/2023', 1188, '35.98', '4.68', '40.66', 5007, 1),
(1012, 'claire dunphy', 22332233, 'visa', 'jan/2023', 233, '18.99', '2.47', '21.46', 5009, 1),
(1013, 'claire dunphy', 88338811, 'visa', 'jan/2023', 1188, '56.97', '7.41', '64.38', 5010, 1),
(1014, 'claire dunphy', 33224455, 'visa', 'jan/2022', 3344, '39.98', '5.20', '45.18', 5011, 1),
(1015, 'claire dunphy', 111225566, 'visa', 'jan/2022', 444, '19.99', '2.60', '22.59', 5012, 1),
(1016, 'claire dunphy', 2147483647, 'visa', 'jan/2023', 444, '19.99', '2.60', '22.59', 5013, 1),
(1017, 'gloria pritchett', 77663377, 'visa', 'jan/2023', 7733, '39.98', '5.20', '45.18', 5014, 1),
(1018, 'claire dunphy', 33228811, 'visa', 'jan/2022', 3322, '119.94', '15.59', '135.53', 5015, 1),
(1019, 'claire dunphy', 33445566, 'visa', 'jan/2021', 222, '19.99', '2.60', '22.59', 5016, 1),
(1020, 'alex dunphy', 2147483647, 'visa', 'mar/2020', 333, '43.98', '5.72', '49.70', 5017, 1),
(1021, 'alex dunphy', 2147483647, 'visa', 'may/2021', 777, '39.98', '5.20', '45.18', 5019, 1),
(1022, 'alex dunphy', 2147483647, 'visa', 'apr/2020', 444, '19.99', '2.60', '22.59', 5021, 1),
(1023, 'alex dunphy', 2147483647, 'visa', 'jan/2021', 555, '19.99', '2.60', '22.59', 5022, 1),
(1026, 'alex dunphy', 2147483647, 'visa', 'jan/2022', 444, '41.98', '5.46', '47.44', 5029, 1),
(1027, 'alex dunphy', 2147483647, 'visa', 'jan/2023', 377, '21.99', '2.86', '24.85', 5030, 1),
(1029, 'alex dunphy', 2147483647, 'visa', 'jan/2021', 333, '41.98', '5.46', '47.44', 5032, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `tstamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `customerid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `date`, `tstamp`, `customerid`, `active`) VALUES
(1, '2019-06-02', '2019-08-14 23:03:28', 38, 1),
(2, '2019-06-03', '2019-08-14 23:03:28', 38, 1),
(3, '2019-06-03', '2019-08-14 23:03:28', 3, 1),
(4, '2019-06-03', '2019-08-14 23:03:28', 37, 1),
(5, '2019-06-03', '2019-08-14 23:03:28', 37, 1),
(6, '2019-06-03', '2019-08-14 23:03:28', 37, 1),
(7, '2019-06-03', '2019-08-14 23:03:28', 37, 1),
(8, '2019-06-03', '2019-08-14 23:03:28', 37, 1),
(9, '2019-06-03', '2019-08-14 23:03:28', 37, 1),
(19, '2019-06-04', '2019-08-14 23:03:28', 37, 1),
(26, '2019-06-10', '2019-08-14 23:03:28', 2, 1),
(27, '2019-06-10', '2019-08-14 23:03:28', 2, 1),
(30, '2019-06-13', '2019-08-14 23:03:28', 2, 1),
(34, '2019-06-16', '2019-08-14 23:03:28', 2, 1),
(35, '2019-06-16', '2019-08-14 23:03:28', 2, 1),
(36, '2019-06-16', '2019-08-14 23:03:28', 2, 1),
(5001, '2019-06-18', '2019-08-14 23:03:28', 2, 1),
(5002, '2019-06-18', '2019-08-14 23:03:28', 2, 1),
(5003, '2019-06-18', '2019-08-14 23:03:28', 2, 1),
(5005, '2019-06-18', '2019-08-14 23:03:28', 2, 1),
(5006, '2019-06-18', '2019-08-14 23:03:28', 2, 1),
(5007, '2019-06-18', '2019-08-14 23:03:28', 2, 1),
(5009, '2019-06-19', '2019-08-14 23:03:28', 2, 1),
(5010, '2019-06-20', '2019-08-14 23:03:28', 2, 1),
(5011, '2019-06-21', '2019-08-14 23:03:28', 2, 1),
(5012, '2019-06-22', '2019-08-14 23:03:28', 2, 1),
(5013, '2019-06-24', '2019-08-14 23:03:28', 2, 1),
(5014, '2019-06-25', '2019-08-14 23:03:28', 47, 1),
(5015, '2019-07-08', '2019-08-14 23:03:28', 2, 1),
(5016, '2019-07-29', '2019-08-14 23:03:28', 2, 1),
(5017, '2019-08-08', '2019-08-14 23:03:28', 5, 1),
(5018, '2019-08-08', '2019-08-14 23:03:28', 5, 1),
(5019, '2019-08-08', '2019-08-14 23:03:28', 5, 1),
(5020, '2019-08-10', '2019-08-14 23:03:28', 5, 1),
(5021, '2019-08-10', '2019-08-14 23:03:28', 5, 1),
(5022, '2019-08-10', '2019-08-14 23:03:28', 5, 1),
(5029, '2019-08-14', '2019-08-14 23:03:28', 5, 1),
(5030, '2019-08-14', '2019-08-14 23:03:28', 5, 1),
(5032, '2019-08-14', '2019-08-14 23:07:22', 5, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ordership`
--

CREATE TABLE `ordership` (
  `id` int(11) NOT NULL,
  `address` varchar(100) NOT NULL,
  `suite` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `postal` varchar(100) NOT NULL,
  `country` varchar(100) NOT NULL,
  `orderid` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `ordership`
--

INSERT INTO `ordership` (`id`, `address`, `suite`, `city`, `province`, `postal`, `country`, `orderid`, `active`) VALUES
(1, '222 Library St', '', 'Toronto', 'ON', 'M4M G3G', 'Canada', 5, 1),
(2, '555 Main St', '', 'Ajax', 'ON', 'M1M 4M4', 'CA', 19, 1),
(3, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 30, 1),
(7, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 34, 1),
(8, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 35, 1),
(9, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 36, 1),
(10, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5001, 1),
(11, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5002, 1),
(12, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5003, 1),
(13, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5005, 1),
(14, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5006, 1),
(15, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5007, 1),
(17, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5009, 1),
(18, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5010, 1),
(19, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5011, 1),
(20, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5012, 1),
(21, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5013, 1),
(22, '888 Macbook Ave', '', 'Ajax', 'AB', 'M2N 5H3', 'CA', 5014, 1),
(23, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5015, 1),
(24, '111 Modern St', '', 'Toronto', 'ON', 'M6P3H3', 'CA', 5016, 1),
(25, '1122 Yonge St', '22', 'Toronto', 'ON', 'M6K 3J4', 'CA', 5017, 1),
(27, '1122 Yonge St', '22', 'Toronto', 'ON', 'M6K 3J4', 'CA', 5019, 1),
(28, '2222 Yonge St', '20', 'Toronto', 'AB', 'M6K 3J4', 'CA', 5021, 1),
(29, '2222 Yonge St', '20', 'Toronto', 'AB', 'M6K 3J4', 'CA', 5022, 1),
(33, '2222 Yonge St', '201', 'Toronto', 'AB', 'M6K 3J4', 'CA', 5029, 1),
(34, '2222 Yonge St', '201', 'Toronto', 'AB', 'M6K 3J4', 'CA', 5030, 1),
(36, '2222 Yonge St', '201', 'Toronto', 'AB', 'M6K 3J4', 'CA', 5032, 1);

-- --------------------------------------------------------

--
-- Table structure for table `phone`
--

CREATE TABLE `phone` (
  `id` int(11) NOT NULL,
  `number` varchar(14) NOT NULL,
  `ext` varchar(6) NOT NULL,
  `type` varchar(2) NOT NULL,
  `customerid` int(11) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `phone`
--

INSERT INTO `phone` (`id`, `number`, `ext`, `type`, `customerid`, `active`) VALUES
(1, '2892427858', '', 'C', 1, 1),
(2, '4165551111', '', 'H', 1, 1),
(3, '9053337700', '77', 'H', 2, 1),
(4, '9055557799', '77', 'C', 3, 1),
(5, '9055558888', '88', 'H', 3, 1),
(6, '9057771717', '', 'C', 6, 1),
(7, '9058881818', '18', 'W', 6, 1),
(36, '9057772211', '', 'C', 37, 1),
(37, '9052223322', '', 'C', 37, 1),
(38, '9051115511', '', 'C', 38, 1),
(45, '4167778800', '', 'C', 42, 1),
(46, '4167779999', '91', 'W', 42, 1),
(47, '4168880088', '', 'C', 43, 1),
(48, '4168880088', '', 'C', 44, 1),
(49, '4168880088', '', 'C', 45, 1),
(50, '4168880088', '', 'C', 46, 1),
(51, '4167770077', '', 'H', 46, 1),
(52, '4168880088', '', 'C', 47, 1),
(53, '4167770077', '', 'H', 47, 1),
(56, '9053333300', '', 'C', 50, 1),
(59, '4167778888', '14', 'W', 5, 1),
(60, '4167778877', '', 'C', 5, 1),
(70, '6479990000', '', 'H', 63, 1),
(71, '6479990011', '', 'C', 63, 1);

-- --------------------------------------------------------

--
-- Table structure for table `phonetype`
--

CREATE TABLE `phonetype` (
  `id` int(11) NOT NULL,
  `display` varchar(20) NOT NULL,
  `shortval` varchar(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `phonetype`
--

INSERT INTO `phonetype` (`id`, `display`, `shortval`) VALUES
(1, 'home', 'H'),
(2, 'cell', 'C'),
(3, 'work', 'W');

-- --------------------------------------------------------

--
-- Table structure for table `province`
--

CREATE TABLE `province` (
  `provinceid` int(11) NOT NULL,
  `display` varchar(35) NOT NULL,
  `shortval` varchar(3) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `province`
--

INSERT INTO `province` (`provinceid`, `display`, `shortval`, `active`) VALUES
(1, 'Alberta', 'AB', 1),
(2, 'British Columbia', 'BC', 1),
(3, 'Manitoba', 'MB', 1),
(4, 'New Brunswick', 'NB', 1),
(5, 'Newfoundland', 'NL', 1),
(6, 'Nova Scotia', 'NS', 1),
(7, 'Northwest Territories', 'NW', 1),
(8, 'Nunavut', 'NU', 1),
(9, 'Ontario', 'ON', 1),
(10, 'Prince Edward Island', 'PE', 1),
(11, 'Quebec', 'QC', 1),
(12, 'Sasketchewan', 'SK', 1),
(13, 'Yukon', 'YT', 1);

-- --------------------------------------------------------

--
-- Table structure for table `securityquestions`
--

CREATE TABLE `securityquestions` (
  `id` int(11) NOT NULL,
  `question` varchar(155) NOT NULL,
  `status` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `securityquestions`
--

INSERT INTO `securityquestions` (`id`, `question`, `status`) VALUES
(1, 'what is your favourite colour?', 1),
(2, 'what is the name of your first pet?', 1),
(3, 'what was the name of your high school?', 1),
(4, 'where is your favourite vacation spot?', 1);

-- --------------------------------------------------------

--
-- Table structure for table `session`
--

CREATE TABLE `session` (
  `id` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `sessionval` varchar(100) NOT NULL,
  `logindate` date NOT NULL,
  `logintime` time NOT NULL,
  `logoutdate` date NOT NULL,
  `logouttime` time NOT NULL,
  `isloggedin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `session`
--

INSERT INTO `session` (`id`, `customerid`, `sessionval`, `logindate`, `logintime`, `logoutdate`, `logouttime`, `isloggedin`) VALUES
(3, 2, '988f996042dbdd8cdc635dc92108e0c5', '2019-05-14', '13:20:46', '2019-05-16', '13:06:39', 0),
(4, 3, '2a6edaee12622dcbba3ed81a32de7e08', '2019-05-14', '13:21:54', '2019-05-14', '13:22:07', 0),
(5, 5, '0c9dffa73d49ce53a60d7615d5f8f568', '2019-05-14', '14:06:03', '2019-05-15', '14:22:31', 0),
(6, 5, '259910d3cf9dede744cb5b1e3a554773', '2019-05-14', '16:05:15', '2019-05-15', '14:22:31', 0),
(8, 2, 'cc4608206c5564aabed7cb50912b2275', '2019-05-15', '14:28:33', '2019-05-16', '13:06:39', 0),
(14, 2, 'df65c6899a7e4caf0347d288a877d498', '2019-05-15', '15:34:41', '2019-05-16', '13:06:39', 0),
(15, 2, '8ac08e57ba340c73995c6247f2187d3c', '2019-05-15', '18:13:20', '2019-05-16', '13:06:39', 0),
(35, 2, '91c946eaa2644a87a9c626c3c3cb7fc4', '2019-05-16', '14:22:14', '2019-05-16', '14:38:06', 0),
(63, 6, 'e8f6c573017544cf8b271a3d909c66dd', '2019-05-17', '18:16:37', '2019-05-17', '19:13:41', 0),
(64, 3, '3abe03032c75699d9ace051c089c39c5', '2019-05-18', '01:30:47', '2019-05-18', '12:16:46', 0),
(101, 37, '7d4d7a2bf6ba281297113e86d7ee7dc6', '2019-06-05', '12:50:55', '2019-06-05', '13:02:20', 0),
(102, 37, 'd72664ede30c4a5a16a25d6dfb6b89ec', '2019-06-05', '13:08:19', '2019-06-05', '13:08:21', 0),
(103, 2, '8813a1fe24b298fefa40f518cce9c947', '2019-06-05', '13:09:09', '2019-06-05', '13:09:42', 0),
(104, 2, '2d1d24e728940ce41a181724e5256c42', '2019-06-05', '13:11:05', '2019-06-05', '13:11:14', 0),
(105, 2, '283233c17a2842af629565e52e8e2e6c', '2019-06-05', '13:13:15', '2019-06-05', '13:13:28', 0),
(107, 2, '513907d646f3d6ec583c9ac35c77f353', '2019-06-05', '13:14:35', '2019-06-05', '13:14:52', 0),
(108, 2, 'cd58737796f6185c9c3d0c5b7eed7cf6', '2019-06-05', '13:15:41', '2019-06-05', '13:16:29', 0),
(110, 2, 'e2109bd013207155cad5ee044331ea1e', '2019-06-06', '12:29:27', '0000-00-00', '00:00:00', 0),
(111, 2, 'e3461cd689396503ff629a50aca8dedd', '2019-06-07', '12:52:45', '2019-06-07', '20:36:34', 0),
(115, 2, '10a432e267847fe32c9d557da58c87c1', '2019-06-10', '13:14:54', '2019-06-10', '13:15:03', 0),
(116, 2, '15c694fe5c1caa4577d02b94d8dcdf59', '2019-06-10', '13:15:12', '2019-06-10', '14:28:51', 0),
(117, 2, 'c9b7fc82fdc9c89a0af37cf79618bc9f', '2019-06-10', '14:31:02', '2019-06-10', '14:31:07', 0),
(118, 2, '8e6dc349fdbd07d625ad15ff2e83cbcc', '2019-06-10', '14:37:26', '2019-06-10', '14:37:28', 0),
(119, 2, 'ec974868e17660389e632bf4b72efb59', '2019-06-10', '16:01:32', '2019-06-10', '16:22:35', 0),
(120, 2, '657835c57758ee82f16754b104fd84f1', '2019-06-10', '16:22:44', '2019-06-10', '16:26:03', 0),
(121, 2, 'daaeeac470d43d0aada73c619f231981', '2019-06-10', '16:26:10', '2019-06-11', '15:30:19', 0),
(122, 2, 'd14679a162a2ff290b25e0350bb28fbe', '2019-06-11', '15:30:29', '2019-06-11', '15:31:33', 0),
(123, 2, '73759bd6c95bb56f5f55235d03dda4a9', '2019-06-11', '16:59:03', '2019-06-11', '17:09:45', 0),
(124, 2, '679e25f57c7b743c5a1e3675e9b91ac1', '2019-06-12', '12:28:06', '2019-06-12', '12:28:08', 0),
(125, 2, 'a0125b416b03b478f124aa9f67fe4764', '2019-06-12', '12:28:19', '2019-06-12', '12:28:22', 0),
(126, 2, '5e5bfee15d050573b05562e928936a33', '2019-06-12', '12:29:28', '2019-06-12', '12:29:31', 0),
(127, 2, '31e1f90c65d1c7440f6f3213c1c81a6f', '2019-06-13', '02:48:00', '2019-06-13', '03:01:31', 0),
(128, 2, '2a4faf43071c456ee8a4d8eae57a8625', '2019-06-13', '03:01:37', '2019-06-13', '03:14:16', 0),
(129, 2, '8280fe21825c8678486c89cdfc43be40', '2019-06-13', '03:14:27', '0000-00-00', '00:00:00', 0),
(130, 2, '756663e0ff385779e8fe5af4a5d9601e', '2019-06-13', '17:42:14', '0000-00-00', '00:00:00', 0),
(178, 2, 'e6af48e16068abc0ecc0864200edd15f', '2019-06-24', '02:21:19', '2019-06-24', '02:21:52', 0),
(179, 2, '524a7f2be681010fa50c91e59fa1585f', '2019-06-24', '02:22:16', '2019-06-24', '02:22:26', 0),
(180, 2, '6e778808733a9926a7cbd9f9c4b214ad', '2019-06-24', '03:04:33', '2019-06-24', '11:53:01', 0),
(181, 2, 'e907cf5bc0c3bf1471124fd0f27b16ac', '2019-06-24', '11:53:59', '2019-06-24', '12:16:08', 0),
(182, 2, '81cb231eda85d7d71595e0139dd722cb', '2019-06-24', '12:23:20', '2019-06-24', '12:40:47', 0),
(183, 2, '4fc52d68ea18ef8afd2c6ac204f24819', '2019-06-25', '13:36:45', '0000-00-00', '00:00:00', 0),
(184, 2, '42cc753fd8675db523464026af415b79', '2019-06-25', '13:57:50', '2019-06-25', '14:03:05', 0),
(185, 2, '1421c0e20f518a9b62b5d81d69e91919', '2019-06-25', '14:03:42', '2019-06-25', '15:27:12', 0),
(186, 2, '814a608b18bc19c270a1b26601f4a3aa', '2019-06-25', '15:31:02', '2019-06-25', '15:31:42', 0),
(187, 2, 'db05764d0ff7f7824b02886b5ca0bdcd', '2019-06-25', '15:34:25', '2019-06-25', '16:08:02', 0),
(188, 2, 'ac995abb0e0cb1f80aff418592913254', '2019-06-25', '16:08:07', '2019-06-25', '16:22:40', 0),
(189, 2, '603523cb7de9c008ef1c7ba6f86f8bcb', '2019-06-25', '16:22:56', '2019-06-25', '16:24:08', 0),
(190, 2, '1aa172e726e93809c81938480839aae9', '2019-06-25', '16:24:30', '0000-00-00', '00:00:00', 0),
(191, 2, '87f1c818d4b85dd5931ab8948b47b5cb', '2019-06-25', '16:27:46', '0000-00-00', '00:00:00', 0),
(192, 2, '8c9f6a890e5e0b671c0b776ed45e9fa2', '2019-06-25', '16:29:48', '0000-00-00', '00:00:00', 0),
(193, 2, 'f6231aa410259c23dd270177213ab147', '2019-06-25', '16:33:22', '0000-00-00', '00:00:00', 0),
(194, 2, 'f6231aa410259c23dd270177213ab147', '2019-06-25', '16:34:51', '0000-00-00', '00:00:00', 0),
(195, 2, 'f6231aa410259c23dd270177213ab147', '2019-06-25', '16:36:23', '0000-00-00', '00:00:00', 0),
(196, 2, 'f6231aa410259c23dd270177213ab147', '2019-06-25', '16:39:56', '0000-00-00', '00:00:00', 0),
(197, 2, 'ee8954e2d4b8d4619a3274378bf940df', '2019-06-25', '16:41:24', '0000-00-00', '00:00:00', 0),
(198, 2, '8160a4ea0223f5859ee51c7cb1c10cf8', '2019-06-25', '16:43:17', '2019-06-25', '16:45:13', 0),
(199, 47, '51f2ba27bc2aa41810afe4eef9d81eb7', '2019-06-25', '16:51:35', '2019-06-25', '17:28:01', 0),
(200, 2, 'c54ab482145b0a553a2039c58ac06af8', '2019-06-26', '14:44:15', '2019-06-26', '14:44:50', 0),
(201, 2, 'c9ecedc7e6e87d3fb4547d86f00a16a5', '2019-06-26', '17:50:12', '2019-06-27', '15:30:38', 0),
(202, 2, '67078fc08b46e6571468730b28d8e7a4', '2019-06-28', '13:57:50', '2019-06-28', '15:04:43', 0),
(203, 2, '44a4b328c2ca37623fed88c8dc461dfa', '2019-06-28', '15:31:11', '2019-07-04', '16:29:23', 0),
(204, 2, '2bec103f872bac32b3ec91495572e3d6', '2019-07-04', '17:07:49', '2019-07-04', '17:07:53', 0),
(205, 2, '750724891ac223d8931ee2399ef1b2f5', '2019-07-04', '18:18:16', '2019-07-04', '19:38:31', 0),
(206, 2, '229092424f1a999fc95e1af5a24ed63f', '2019-07-04', '19:51:43', '2019-07-04', '20:07:15', 0),
(207, 2, 'b3c172456ab1ed4842d8bdbe6db9a09e', '2019-07-08', '16:08:18', '2019-07-08', '16:20:54', 0),
(208, 2, '2eec2d82e9ac5f67e58bf4a9cb5cb2b4', '2019-07-08', '16:21:01', '2019-07-08', '16:22:38', 0),
(209, 2, 'ae9a18cce6cbbcfc603bfbea39a3f7c3', '2019-07-08', '16:22:50', '2019-07-08', '17:46:05', 0),
(210, 2, '5aca7fc0f400353b0b7e962c59e8b895', '2019-07-08', '17:46:11', '2019-07-08', '18:26:50', 0),
(211, 2, '07b7c68dbce44bc05ecc0235d93f7b38', '2019-07-28', '14:03:09', '2019-07-28', '14:27:57', 0),
(212, 2, '2766b0d389a8bb77954ee64c8f403e04', '2019-07-28', '14:38:29', '2019-07-28', '14:38:33', 0),
(213, 2, '6a98d31a03d39b85941f4c1da6512354', '2019-07-28', '14:47:18', '2019-07-28', '14:47:20', 0),
(214, 2, '9076c14a1198e5ae9b8a9b1530f3ce2a', '2019-07-28', '15:00:18', '2019-07-28', '15:00:20', 0),
(215, 2, 'ae8521e428da124b0af19fe9370d2dff', '2019-07-28', '15:34:23', '2019-07-28', '15:34:24', 0),
(216, 2, '2ca660e98fccb22c535e864082bc7a46', '2019-07-28', '15:36:42', '2019-07-28', '15:36:43', 0),
(217, 2, 'a06a65aee9fa90716e0664fc56fa0bed', '2019-07-28', '15:40:26', '2019-07-28', '15:40:27', 0),
(218, 2, '058f95bef1504bf598c98776c20c9364', '2019-07-28', '15:40:46', '2019-07-28', '15:40:47', 0),
(219, 2, 'f386ab5ad920246cac7ebb2eb21170d3', '2019-07-28', '15:48:41', '2019-07-28', '15:48:58', 0),
(220, 2, 'd4cae9a6ca77d557a4d0d43fd1de1a6c', '2019-07-28', '16:11:08', '2019-07-28', '16:12:30', 0),
(221, 2, '2d2f48ed4417f7a3dcd50ec196b7f021', '2019-07-29', '16:22:33', '2019-07-29', '16:27:06', 0),
(223, 2, '41aa5e0098ff478402c3a89d8a76f95f', '2019-07-29', '18:24:17', '2019-07-29', '18:24:19', 0),
(224, 2, 'd20a5a1c22200865f397c1ef3d35c297', '2019-07-29', '18:27:30', '2019-07-29', '18:27:32', 0),
(225, 2, '650de83540862a1313049e701a958035', '2019-07-29', '18:27:59', '2019-07-29', '18:28:01', 0),
(226, 2, '1d275b22128d71fdb74dfcc0b27e6bef', '2019-07-30', '13:31:48', '2019-07-30', '13:40:07', 0),
(227, 2, '94e784100ce1114be9c324530bbb9e0a', '2019-07-30', '15:10:21', '2019-07-30', '15:10:24', 0),
(228, 2, 'e12a0322353a62bd7c2503150ba14e87', '2019-07-31', '14:10:58', '2019-07-31', '16:25:23', 0),
(229, 2, '2994ff910dc0418df1c16c1f4868b558', '2019-07-31', '16:26:40', '2019-07-31', '16:26:42', 0),
(230, 2, '249ea4eed40b8bee2f6ffbdac48b0779', '2019-07-31', '16:26:48', '2019-07-31', '16:37:02', 0),
(231, 5, '54952c425c7b7a9bfb4580b63bba3c30', '2019-08-03', '15:44:05', '2019-08-03', '16:02:31', 0),
(232, 5, '5e61e3c70ba8192bf7f750354803a350', '2019-08-04', '13:07:46', '2019-08-04', '13:19:29', 0),
(233, 5, '6342d770d5f82c8ce7ffdfe290dc88f0', '2019-08-08', '15:59:21', '2019-08-08', '16:21:12', 0),
(234, 5, '11a2aea83deb57c7dcf7540342cf7552', '2019-08-08', '16:21:39', '2019-08-08', '18:33:21', 0),
(235, 2, '30e678c4b975be7be291a1f902a0b978', '2019-08-08', '18:33:32', '2019-08-08', '18:35:32', 0),
(236, 2, 'e58660f16cd5a6eaabe767b40228b718', '2019-08-08', '19:09:44', '2019-08-08', '19:09:45', 0),
(237, 2, '9c298ced38c93c62276aa22196e448ce', '2019-08-08', '19:11:49', '2019-08-08', '19:11:51', 0),
(238, 5, '8924237b0d9bf7cdae29ef3793e645d1', '2019-08-08', '19:18:28', '2019-08-09', '14:44:35', 0),
(239, 5, '17157d8bba12c4b806033c1cec8779cf', '2019-08-09', '14:44:48', '2019-08-09', '15:19:07', 0),
(240, 5, '2f78715dc48dcc0c992bb9cd6de5befd', '2019-08-09', '15:19:24', '2019-08-09', '15:21:44', 0),
(241, 5, '4aec4484962ab6d984f019a786c9a0e3', '2019-08-09', '15:21:50', '2019-08-09', '15:47:46', 0),
(242, 2, '172bef768162103e362556750f047877', '2019-08-09', '15:47:51', '2019-08-09', '15:50:51', 0),
(243, 5, 'c0463dd6e8a2b375936bb2a28eff8afc', '2019-08-09', '15:51:02', '2019-08-09', '16:36:35', 0),
(244, 5, 'af359e9602992fe3dc40da18e8dfffc0', '2019-08-09', '16:36:53', '2019-08-09', '16:47:24', 0),
(245, 58, '958c55fb6acfd776c2ed606d4cf9d529', '2019-08-10', '14:00:14', '2019-08-10', '14:00:19', 0),
(246, 5, 'ad24bf749b9b4a7076aea37e02023aa1', '2019-08-10', '14:10:41', '2019-08-10', '23:16:42', 0),
(248, 2, '2b2a882394598785b56c57297812fce1', '2019-08-11', '15:07:07', '0000-00-00', '00:00:00', 0),
(249, 2, 'a876cacd44c1dac01516c1cb6fa8c5fa', '2019-08-11', '15:11:43', '0000-00-00', '00:00:00', 0),
(250, 2, '3a3a7553557f38bbf78da4da394ae2b9', '2019-08-11', '15:24:23', '0000-00-00', '00:00:00', 0),
(252, 2, '1ed5fe115530c3411e8ac9faf1bcb4ad', '2019-08-11', '15:30:14', '0000-00-00', '00:00:00', 0),
(253, 2, '8aafaead9b169ec9a2bd6da5666aa9c1', '2019-08-11', '15:34:58', '0000-00-00', '00:00:00', 0),
(255, 2, 'f3cdb0970626fed614d85e4a720f3dbf', '2019-08-11', '15:39:18', '0000-00-00', '00:00:00', 0),
(256, 63, '572bc9570b9f73224bffd6c81a8a5d83', '2019-08-11', '16:10:00', '2019-08-11', '16:10:13', 0),
(257, 63, '9ed9a6d729e3f881f6d62ab2101c38f8', '2019-08-12', '00:42:31', '0000-00-00', '00:00:00', 1),
(258, 5, 'f430da1d2d55cc70a5c24b9932322c02', '2019-08-12', '01:43:55', '2019-08-12', '16:45:58', 0),
(259, 5, 'acc4bace8045d97170f7c46aa8396ea5', '2019-08-13', '15:43:23', '0000-00-00', '00:00:00', 0),
(260, 5, 'aaf7a1ad647782b5710559c58e499125', '2019-08-14', '17:26:00', '2019-08-14', '18:18:54', 0),
(261, 5, '40bebc4ce553204b821c172516e2b97b', '2019-08-14', '18:21:34', '2019-08-15', '10:33:07', 0),
(262, 5, '204c04fddd914e6e3110656b85dacf2c', '2019-08-15', '13:43:39', '2019-08-15', '17:07:05', 0),
(263, 5, '934b199634ca8113d20b1960f3fb0c7b', '2019-08-15', '17:13:40', '2019-08-15', '18:40:32', 0),
(264, 5, '0eb0e547d610dc4f53b05c631c49326e', '2019-08-15', '19:03:30', '2019-08-16', '14:25:46', 0),
(265, 5, '8545d6fc571ed3e5018375577a39b60f', '2019-08-16', '15:26:31', '2019-08-16', '16:04:26', 0),
(266, 5, 'e0881a98bd31e6c857876593b87ef5a2', '2019-08-16', '16:05:07', '0000-00-00', '00:00:00', 0),
(267, 5, '0c2f5304b075d65ac361a2ea36ae9403', '2019-08-17', '15:25:27', '0000-00-00', '00:00:00', 0),
(268, 2, '5766a2550b51c9953de40b49576ccd49', '2019-08-20', '13:47:12', '0000-00-00', '00:00:00', 0),
(269, 2, '73e81cabea4be855aff18ff80b214a0e', '2019-08-20', '14:34:48', '2019-08-22', '14:39:28', 0),
(270, 2, '14964f9361a3357726d12444a45d3e77', '2019-08-22', '16:07:24', '0000-00-00', '00:00:00', 0),
(271, 5, '82f767a5d1b56257a1fdb8c58b5490d7', '2019-08-23', '14:07:03', '2019-08-26', '15:51:27', 0),
(272, 5, 'a0038ed1bd2c664288419f45bdae7ddd', '2019-08-26', '15:51:35', '2019-08-26', '15:57:18', 0),
(273, 5, 'd4e07f050c6815be5ebd400284ae3627', '2019-08-26', '16:00:27', '2019-08-27', '13:49:28', 0),
(274, 5, 'd654403de3348e8e95cf04a76facae03', '2019-08-27', '15:38:54', '2019-08-27', '21:05:08', 0),
(275, 5, '14f7a2f58d35f4ecff498694519d6ef4', '2019-08-27', '21:05:13', '0000-00-00', '00:00:00', 0),
(276, 5, 'fda7536d31c17ed7be46eef04e4011d0', '2019-08-27', '21:07:13', '0000-00-00', '00:00:00', 0),
(277, 5, 'ec3114d8ead19d2989526bf3c708b685', '2019-08-28', '19:29:41', '0000-00-00', '00:00:00', 0),
(278, 5, 'bc1dad89fbdfa555599b1516f4c8deb1', '2019-09-01', '13:29:27', '2019-09-01', '15:37:50', 0),
(279, 5, 'b43462db67ca84432ea9bcdc73149221', '2019-09-01', '15:37:55', '0000-00-00', '00:00:00', 0),
(280, 5, 'c23224a3cf11be0bc99b343270b4bf87', '2019-09-02', '13:50:00', '2019-09-03', '13:43:35', 0),
(281, 5, 'ecf1c3a90892511a65348522f1e79711', '2019-09-03', '13:59:35', '0000-00-00', '00:00:00', 0),
(282, 5, '6e01ef4d2b96450badf3c3f9520f51ed', '2019-09-03', '15:55:59', '0000-00-00', '00:00:00', 0),
(283, 5, '71916b8a0e5c2392cc5ec3cb9fc774fa', '2019-09-03', '19:03:26', '2019-09-03', '20:38:46', 0),
(284, 2, '252841811a898325515a3bca501baee8', '2019-09-03', '20:38:53', '2019-09-03', '20:39:06', 0),
(285, 5, 'aff58b9cfacde3440336c8ff4ab7fe24', '2019-09-03', '20:39:11', '2019-09-03', '20:44:46', 0),
(286, 2, '255e71c5a97394be68d68ecb7162e52d', '2019-09-03', '20:44:50', '2019-09-03', '20:54:04', 0),
(287, 5, '5f59be2113cd28e23baa044b043c71bf', '2019-09-03', '20:54:10', '0000-00-00', '00:00:00', 0),
(288, 5, '68b951df6f364823451a73e4114ac693', '2019-09-04', '14:06:23', '2019-09-04', '18:19:05', 0),
(289, 6, 'a1d993379be0acd5ba138b5fcdd76c89', '2019-09-04', '18:19:21', '2019-09-04', '21:47:14', 0),
(290, 6, 'a9d37955f7f89dfebff7b7c0971026a1', '2019-09-04', '21:58:48', '2019-09-04', '22:00:10', 0),
(291, 5, '1f9e29b7eaac4ccf512b3c5eff400753', '2019-09-08', '13:18:28', '2019-09-08', '13:23:33', 0),
(292, 5, '2d97b34aeecd2f44f7f65b130946353b', '2019-09-12', '19:22:38', '2019-09-12', '19:22:49', 0),
(293, 2, '610eb7a8c3308cb41b284f9f787a8b3b', '2019-09-12', '20:28:39', '2019-09-12', '20:50:41', 0),
(294, 5, '3a5a112940af091c4fbb4f128b2e3077', '2019-09-12', '20:50:46', '2019-09-12', '20:53:44', 0),
(295, 6, '2c447769ecf4284e647b24e6c8162f88', '2019-09-12', '21:03:33', '0000-00-00', '00:00:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `subject`
--

CREATE TABLE `subject` (
  `id` int(11) NOT NULL,
  `subjectname` varchar(55) NOT NULL,
  `datecreated` date NOT NULL,
  `sortval` int(11) NOT NULL,
  `status` int(2) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `subject`
--

INSERT INTO `subject` (`id`, `subjectname`, `datecreated`, `sortval`, `status`) VALUES
(1, 'rap', '2019-07-30', 2, 1),
(2, 'rock', '2019-07-30', 3, 1),
(3, 'pop', '2019-07-30', 4, 1),
(4, 'country', '2019-08-03', 6, 1),
(5, 'electronic', '2019-08-03', 5, 1),
(6, 'history', '2019-08-03', 7, 1),
(7, 'all', '2019-08-03', 1, 1),
(22, 'jazz', '2019-09-03', 8, 1);

-- --------------------------------------------------------

--
-- Table structure for table `trackcreation`
--

CREATE TABLE `trackcreation` (
  `trackid` int(11) NOT NULL,
  `tracklistid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `trackcreation`
--

INSERT INTO `trackcreation` (`trackid`, `tracklistid`, `active`) VALUES
(1, 1, 1),
(2, 1, 1),
(3, 1, 1),
(4, 2, 1),
(5, 2, 1),
(6, 3, 1),
(7, 3, 1),
(8, 4, 1),
(9, 4, 1),
(10, 5, 1),
(11, 5, 1),
(12, 6, 1),
(13, 6, 1),
(14, 7, 1),
(15, 7, 1),
(16, 8, 1),
(17, 8, 1),
(18, 9, 1),
(19, 9, 1),
(20, 10, 1),
(21, 10, 1),
(22, 10, 1),
(23, 11, 1),
(24, 11, 1),
(25, 12, 1),
(26, 12, 1);

-- --------------------------------------------------------

--
-- Table structure for table `tracks`
--

CREATE TABLE `tracks` (
  `trackname` varchar(55) NOT NULL,
  `trackid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tracks`
--

INSERT INTO `tracks` (`trackname`, `trackid`, `active`) VALUES
('Holy Grail', 1, 1),
('Picasso', 2, 1),
('Tom Ford', 3, 1),
('Run This Town', 4, 1),
('Empire State of Mind', 5, 1),
('Backseat Freestyle', 6, 1),
('Swimming Pools', 7, 1),
('King Kunta', 8, 1),
('Institutionalized', 9, 1),
('Started from the Bottom', 10, 1),
('Hold On, We\'re Going Home', 11, 1),
('Still Here', 12, 1),
('Once Dance', 13, 1),
('Castle on the Hill', 14, 1),
('Perfect', 15, 1),
('Just the Way You Are', 16, 1),
('Marry You', 17, 1),
('Rehab', 18, 1),
('Back to Black', 19, 1),
('Mr. Brightside', 20, 1),
('Somebody Told Me', 21, 1),
('All These Things That I\'ve Done', 22, 1),
('When You Were Young', 23, 1),
('Read My Mind', 24, 1),
('Feel So Close', 25, 1),
('We Found Love', 26, 1);

-- --------------------------------------------------------

--
-- Table structure for table `userquestions`
--

CREATE TABLE `userquestions` (
  `id` int(11) NOT NULL,
  `custid` int(11) NOT NULL,
  `questionid` int(11) NOT NULL,
  `answer` varchar(155) NOT NULL,
  `status` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `userquestions`
--

INSERT INTO `userquestions` (`id`, `custid`, `questionid`, `answer`, `status`) VALUES
(1, 2, 2, 'ralph', 1),
(2, 3, 1, 'black', 1),
(4, 52, 2, 'lucy', 1),
(5, 5, 4, 'italy', 1),
(14, 63, 4, 'mexico', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address`
--
ALTER TABLE `address`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `album`
--
ALTER TABLE `album`
  ADD PRIMARY KEY (`albumid`);

--
-- Indexes for table `artistgroup`
--
ALTER TABLE `artistgroup`
  ADD PRIMARY KEY (`artistgroupid`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryid`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`countryid`);

--
-- Indexes for table `creditcard`
--
ALTER TABLE `creditcard`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `discussion`
--
ALTER TABLE `discussion`
  ADD PRIMARY KEY (`postid`);

--
-- Indexes for table `email`
--
ALTER TABLE `email`
  ADD PRIMARY KEY (`emailaddressid`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orderpayment`
--
ALTER TABLE `orderpayment`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ordership`
--
ALTER TABLE `ordership`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `phone`
--
ALTER TABLE `phone`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `phonetype`
--
ALTER TABLE `phonetype`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `province`
--
ALTER TABLE `province`
  ADD PRIMARY KEY (`provinceid`);

--
-- Indexes for table `securityquestions`
--
ALTER TABLE `securityquestions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subject`
--
ALTER TABLE `subject`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tracks`
--
ALTER TABLE `tracks`
  ADD PRIMARY KEY (`trackid`);

--
-- Indexes for table `userquestions`
--
ALTER TABLE `userquestions`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;
--
-- AUTO_INCREMENT for table `album`
--
ALTER TABLE `album`
  MODIFY `albumid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `artistgroup`
--
ALTER TABLE `artistgroup`
  MODIFY `artistgroupid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `categoryid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;
--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `countryid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `creditcard`
--
ALTER TABLE `creditcard`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;
--
-- AUTO_INCREMENT for table `discussion`
--
ALTER TABLE `discussion`
  MODIFY `postid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `email`
--
ALTER TABLE `email`
  MODIFY `emailaddressid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;
--
-- AUTO_INCREMENT for table `orderpayment`
--
ALTER TABLE `orderpayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1030;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5033;
--
-- AUTO_INCREMENT for table `ordership`
--
ALTER TABLE `ordership`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;
--
-- AUTO_INCREMENT for table `phone`
--
ALTER TABLE `phone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=72;
--
-- AUTO_INCREMENT for table `phonetype`
--
ALTER TABLE `phonetype`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `province`
--
ALTER TABLE `province`
  MODIFY `provinceid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT for table `securityquestions`
--
ALTER TABLE `securityquestions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `session`
--
ALTER TABLE `session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=296;
--
-- AUTO_INCREMENT for table `subject`
--
ALTER TABLE `subject`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT for table `tracks`
--
ALTER TABLE `tracks`
  MODIFY `trackid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT for table `userquestions`
--
ALTER TABLE `userquestions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
