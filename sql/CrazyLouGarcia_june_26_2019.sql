-- phpMyAdmin SQL Dump
-- version 4.7.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 25, 2019 at 11:30 PM
-- Server version: 5.6.35
-- PHP Version: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `CrazyLouGarcia`
--

DELIMITER
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `album_get_artist`
(IN `artid` INT)
    READS SQL DATA
SELECT *
FROM album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
  AND album.artistgroupid = artid$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `album_load_all`
(IN `sortval` VARCHAR
(100))
    READS SQL DATA
SELECT *
FROM album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
ORDER BY sortval ASC$$
DELIMITER ;

DELIMITER
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `album_load_by_catid`
(IN `ord` VARCHAR
(100), IN `catid` INT)
    NO SQL
SELECT *
FROM album, albumcreation, category, artistgroup
WHERE album.albumid = albumcreation.albumid
  AND artistgroup.artistgroupid = album.artistgroupid
  AND albumcreation.categoryid = category.categoryid
  AND category.categoryid = catid
ORDER BY ord$$
DELIMITER ;

DELIMITER
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `album_get_price`
(IN `num` INT)
    READS SQL DATA
SELECT album.albumid, album.price as price, album.albumname as album, artistgroup.artistgroupname as artist
from album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
  AND album.albumid = num$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `category_load`
()
    NO SQL
SELECT *
FROM category
ORDER BY sortid ASC$$
DELIMITER ;

DELIMITER
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `album_get_tracks`
(IN `id` INT)
    READS SQL DATA
SELECT tracks.trackname
FROM album, tracks, trackcreation
WHERE album.tracklistid = trackcreation.tracklistid
  AND trackcreation.trackid = tracks.trackid
  AND album.tracklistid = id$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `countries_load`
()
    NO SQL
SELECT *
FROM country$$
DELIMITER
;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_get_inserted_id`
(IN `emailval` VARCHAR
(50))
    NO SQL
Select Max(id) as lastid, email
from customer
where email = emailval$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `creditcard_load`
()
    NO SQL
SELECT *
FROM creditcard$$
DELIMITER
;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `history_load`
(IN `custid` INT
(11))
    NO SQL
SELECT DISTINCT orders.id as ordernum, orders.date as date, orderpayment.id as invnum, orderpayment.total as total
FROM orders, orderpayment
WHERE orders.id = orderpayment.orderid
  AND orders.customerid = custid$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_address`
(IN `str` VARCHAR
(100), IN `ste` VARCHAR
(100), IN `cty` VARCHAR
(100), IN `prov` VARCHAR
(100), IN `post` VARCHAR
(100), IN `ctry` VARCHAR
(100), IN `lastid` INT)
    MODIFIES SQL DATA
INSERT INTO address
  (street, suite, city, province, postal, country, customerid, active)
VALUES(str, ste, cty, prov, post, ctry, lastid, 1)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_cust`
(IN `fname` VARCHAR
(100), IN `lname` VARCHAR
(100), IN `email` VARCHAR
(100), IN `pass` VARCHAR
(100))
    MODIFIES SQL DATA
INSERT INTO customer
  (id, firstname, lastname, email, password, active)
VALUES(NULL, fname, lname, email, pass, 1)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_new_phone`
(IN `num` VARCHAR
(20), IN `extVal` VARCHAR
(20), IN `typeVal` VARCHAR
(20), IN `custid` INT)
    MODIFIES SQL DATA
INSERT INTO phone
  (number, ext, type, customerid, active)
VALUES(num, extVal, typeVal, custid, 1)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `login_check`
(IN `login` VARCHAR
(100), IN `pword` VARCHAR
(100))
    READS SQL DATA
SELECT customer.id as loginid
FROM customer
WHERE customer.email = login AND customer.password = pword
  AND customer.active = 1
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `logout_clear_prev`
(IN `custid` INT)
    MODIFIES SQL DATA
UPDATE session SET isloggedin = 0
WHERE customerid = custid$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ordcomplete_get_order_info`
(IN `idnum` INT
(11))
    NO SQL
SELECT *
FROM orders
WHERE id = idnum$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ordcomplete_get_pay_info`
(IN `idnum` INT
(11))
    NO SQL
SELECT *
FROM orderpayment
WHERE orderid = idnum$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `order_get_lastid`
(IN `custid` INT)
    NO SQL
SELECT MAX(id) as lastid, date, customerid
from orders
WHERE customerid = custid$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `order_insert`
(IN `custid` INT)
    MODIFIES SQL DATA
INSERT INTO orders
  (date, customerid, active)
VALUES(CURRENT_DATE, custid, 1)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ordercc_insert`
(IN `name` VARCHAR
(100), IN `num` INT
(11), IN `type` VARCHAR
(20), IN `exp` VARCHAR
(20), IN `csvnum` INT
(11), IN `subt` DECIMAL
(10,2), IN `taxnum` DECIMAL
(10,2), IN `totalnum` DECIMAL
(10,2), IN `orderidnum` INT
(11))
    MODIFIES SQL DATA
INSERT INTO orderpayment
  (ccname, ccnum, cctype, expiry, csv, subtotal, tax, total, orderid)
VALUES(name, num, type, exp, csvnum, subt, taxnum, totalnum, orderidnum)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `orderdetails_insert`
(IN `orderidnum` INT
(11), IN `albumidnum` INT
(11), IN `price` DECIMAL
(10,2), IN `qtynum` INT
(11))
    MODIFIES SQL DATA
INSERT INTO orderdetails
  (orderid, albumid, albumprice, qty)
VALUES(orderidnum, albumidnum, price, qtynum)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ordershipto_insert`
(IN `adrs` VARCHAR
(100), IN `ste` VARCHAR
(10), IN `cty` VARCHAR
(25), IN `prov` VARCHAR
(25), IN `post` VARCHAR
(10), IN `ctry` VARCHAR
(25), IN `orderidnum` INT
(11))
    MODIFIES SQL DATA
INSERT INTO ordership
  (address, suite, city, province, postal, country, orderid)
VALUES(adrs, ste, cty, prov, post, ctry, orderidnum)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `payment_load_address`
(IN `shipid` INT)
    NO SQL
SELECT *
FROM address
WHERE customerid = shipid$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `phonetype_load`
()
    NO SQL
SELECT *
FROM phonetype
ORDER BY display ASC$$
DELIMITER ;

DELIMITER
$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_address`
(IN `idnum` INT)
    READS SQL DATA
SELECT *
FROM address
WHERE customerid = idnum$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_phone`
(IN `idnum` INT)
    READS SQL DATA
SELECT *
FROM phone
WHERE customerid = idnum
  AND active = 1
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_load_user`
(IN `getid` INT)
    READS SQL DATA
SELECT *
FROM customer
WHERE id = getid$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_address`
(IN `idnum` INT, IN `str` VARCHAR
(40), IN `ste` VARCHAR
(40), IN `cty` VARCHAR
(40), IN `post` VARCHAR
(10), IN `prov` VARCHAR
(10), IN `ctry` VARCHAR
(10))
    MODIFIES SQL DATA
    COMMENT '** make sure is customerid from address not id'
UPDATE address SET street = str, suite = ste, city = cty, postal = post, province = prov, country = ctry
WHERE customerid = idnum AND active = 1
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_name`
(IN `fname` VARCHAR
(100), IN `lname` VARCHAR
(100), IN `eml` VARCHAR
(100), IN `idnum` INT)
    MODIFIES SQL DATA
UPDATE customer SET firstname = fname, lastname = lname, email = eml
WHERE id = idnum AND active = 1
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_pass`
(IN `pword` VARCHAR
(100), IN `idnum` INT)
    MODIFIES SQL DATA
UPDATE customer SET password = pword
WHERE id = idnum AND active = 1
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `profile_update_phone`
(IN `idnum` INT, IN `phonenum` VARCHAR
(20), IN `extnum` VARCHAR
(10), IN `ptype` VARCHAR
(2))
    MODIFIES SQL DATA
    COMMENT 'id instead of customerid to because of 2 phnums'
UPDATE phone SET number = phonenum, ext = extnum, type = ptype
WHERE id = idnum$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `provinces_load`
()
    NO SQL
SELECT *
FROM province$$
DELIMITER
;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `session_check`
(IN `id` INT, IN `sessval` VARCHAR
(100))
    NO SQL
SELECT *
FROM session
WHERE customerid = id AND sessionval = sessval$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `session_insert`
(IN `id` INT, IN `sessval` VARCHAR
(100))
    MODIFIES SQL DATA
INSERT INTO session
  (customerid, sessionval, logindate, logintime, isloggedin)
VALUES(id, sessval, CURRENT_DATE, CURRENT_TIME, 1)
$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `session_update_logout_date`
(IN `idnumber` INT)
    MODIFIES SQL DATA
UPDATE session SET logoutdate = CURRENT_DATE, logouttime = CURRENT_TIME, isloggedin = 0
WHERE id = idnumber$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `test_albums_load`
()
    NO SQL
SELECT album.albumid, album.albumname, artistgroup.artistgroupid, artistgroup.artistgroupname, album.tracklistid
FROM album, artistgroup
WHERE album.artistgroupid = artistgroup.artistgroupid
ORDER BY album.albumname
ASC$$
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
(3, '1122 Yonge St', '22', 'Toronto', 'ON', 'M6K 3J4', 'CA', 5, 1),
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
(29, '888 Macbook Ave', '', 'Ajax', 'AB', 'M2N 5H3', 'CA', 47, 1);

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
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id`, `firstname`, `lastname`, `email`, `password`, `active`) VALUES
(1, 'Patrick', 'Garcia', 'patrick@garcia.com', 'password', 1),
(2, 'Claire', 'Dunphy', 'claire@dunphy.com', 'e65e0707774c11ff1ca15f6e27b67769', 1),
(3, 'Phil', 'Dunphy333', 'phil@dunphy.com', '112233', 1),
(5, 'Alex', 'Dunphy', 'alex@dunphy.com', '888888', 1),
(6, 'Haley', 'Dunphy', 'haley@dunphy.com', 'duckfeet', 1),
(37, 'Manny', 'Delgado', 'manny@delgado.com', 'password8800', 1),
(38, 'Mitchell', 'Pritchett', 'mitchell@pritchett.com', 'password9900', 1),
(42, 'Cameron', 'Tucker', 'cameron@tucker.com', 'tucker4444', 1),
(47, 'Gloria', 'Delgado-Pritchett', 'gloria@pritchett.com', 'ec92d00d7c130df82512548cbc2b4701', 1);

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
(48, 5014, 9, '19.99', 2, 1);

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
(1017, 'gloria pritchett', 77663377, 'visa', 'jan/2023', 7733, '39.98', '5.20', '45.18', 5014, 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `customerid` int(11) NOT NULL,
  `active` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `date`, `customerid`, `active`) VALUES
(1, '2019-06-02', 38, 1),
(2, '2019-06-03', 38, 1),
(3, '2019-06-03', 3, 1),
(4, '2019-06-03', 37, 1),
(5, '2019-06-03', 37, 1),
(6, '2019-06-03', 37, 1),
(7, '2019-06-03', 37, 1),
(8, '2019-06-03', 37, 1),
(9, '2019-06-03', 37, 1),
(19, '2019-06-04', 37, 1),
(26, '2019-06-10', 2, 1),
(27, '2019-06-10', 2, 1),
(30, '2019-06-13', 2, 1),
(34, '2019-06-16', 2, 1),
(35, '2019-06-16', 2, 1),
(36, '2019-06-16', 2, 1),
(5001, '2019-06-18', 2, 1),
(5002, '2019-06-18', 2, 1),
(5003, '2019-06-18', 2, 1),
(5005, '2019-06-18', 2, 1),
(5006, '2019-06-18', 2, 1),
(5007, '2019-06-18', 2, 1),
(5009, '2019-06-19', 2, 1),
(5010, '2019-06-20', 2, 1),
(5011, '2019-06-21', 2, 1),
(5012, '2019-06-22', 2, 1),
(5013, '2019-06-24', 2, 1),
(5014, '2019-06-25', 47, 1);

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
(22, '888 Macbook Ave', '', 'Ajax', 'AB', 'M2N 5H3', 'CA', 5014, 1);

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
(53, '4167770077', '', 'H', 47, 1);

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
(199, 47, '51f2ba27bc2aa41810afe4eef9d81eb7', '2019-06-25', '16:51:35', '2019-06-25', '17:28:01', 0);

-- --------------------------------------------------------

--
-- Table structure for table `test_table`
--

CREATE TABLE `test_table` (
  `custid` int(11) NOT NULL,
  `fname` varchar(100) NOT NULL,
  `lname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `test_table`
--

INSERT INTO `test_table` (`custid`, `fname`, `lname`, `email`) VALUES
(23, '', 'Dunphyxxx', 'phil@dunphy.com');

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
-- Indexes for table `session`
--
ALTER TABLE `session`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tracks`
--
ALTER TABLE `tracks`
  ADD PRIMARY KEY (`trackid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address`
--
ALTER TABLE `address`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;
--
-- AUTO_INCREMENT for table `email`
--
ALTER TABLE `email`
  MODIFY `emailaddressid` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `orderdetails`
--
ALTER TABLE `orderdetails`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;
--
-- AUTO_INCREMENT for table `orderpayment`
--
ALTER TABLE `orderpayment`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1018;
--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5015;
--
-- AUTO_INCREMENT for table `ordership`
--
ALTER TABLE `ordership`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT for table `phone`
--
ALTER TABLE `phone`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;
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
-- AUTO_INCREMENT for table `session`
--
ALTER TABLE `session`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=200;
--
-- AUTO_INCREMENT for table `tracks`
--
ALTER TABLE `tracks`
  MODIFY `trackid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
