-- (a) creation of all entities
CREATE TABLE
    Users (
        id INT PRIMARY KEY,
        fullname VARCHAR(120),
        username VARCHAR(50),
        address VARCHAR(255),
        email VARCHAR(255),
        password VARCHAR(255),
        role enum ('user', 'admin'),
        created_at TIMESTAMP
    );

CREATE TABLE
    Categories (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255)
    );

CREATE TABLE
    Items (
        id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(120),
        description VARCHAR(255),
        price DECIMAL(10, 2),
        category_id int,
        size varchar,
        FOREIGN key (category_id) REFERENCES Categories (id),
        created_at TIMESTAMP
    );

CREATE TABLE
    Orders (
        id INT PRIMARY KEY AUTO_INCREMENT,
        user_id INT,
        item_id INT,
        status enum ('pending', 'completed', 'cancelled'),
        FOREIGN KEY (user_id) REFERENCES Users (id),
        FOREIGN KEY (item_id) REFERENCES Items (id),
        created_at TIMESTAMP
    );

-- (b) show commands for inserting records into the entities
-- create an admin 
INSERT INTO
    Users (
        id,
        fullname,
        username,
        address,
        email,
        password,
        role
    )
VALUES
    (
        1,
        'Ade James',
        'adjames',
        'No.4 db lane, Sql road ',
        'adjames@email.com',
        'jamespasswordhere',
        'admin'
    );

-- create a user(customer)
INSERT INTO
    Users (
        id,
        fullname,
        username,
        address,
        email,
        password,
        role
    )
VALUES
    (
        2,
        'Miriam Nosa',
        'mnosa',
        'No.94 link road ',
        'mnosa@mail.com',
        'nosapass',
        'user'
    );

-- insert into categories
INSERT INTO
    Categories (name)
VALUES
    ('clothing'),
    ('electronics'),
    ('books'),
    ('cars');

-- Insert into Items
INSERT INTO
    Items (name, description, price, size, category_id)
VALUES
    (
        'Nigerian Jersey',
        'The newest Nigerian jersey design',
        25000,
        'L',
        1
    ),
    (
        'Mechanical Keyboard',
        'Porodo mech keyboard',
        40000,
        '10x20cm',
        2
    );

-- create an order
INSERT INTO
    Orders (user_id, item_id, status)
VALUES
    (2, 1, 'pending');

-- (c) getting records from two or more entities
-- get all items and their categories
SELECT
    Items.name,
    Items.description,
    Items.price,
    Items.size,
    Categories.name
from
    Items
    JOIN Categories ON Categories.id = Items.category_id;

-- get all admins
SELECT
    fullname,
    username,
    email,
    password
FROM
    USERS
WHERE
    role = 'admin';

-- get all customers
SELECT
    fullname,
    username,
    address,
    email,
    password,
    created_at
FROM
    USERS
WHERE
    role = 'user';

-- get all categories
SELECT
    *
FROM
    Categories;

-- (d) updating records from two or more entities
-- update the category of an item
UPDATE Orders
SET
    status = 'completed'
WHERE
    user_id = 2
    and item_id = 1
    -- update the email of a user
UPDATE Users
SET
    email = 'newmail@mail.com'
WHERE
    id = 2
    and role = 'user';

-- (e) show commands for deleting records from two or more entities
-- delete a category
DELETE FROM Categories
WHERE
    id = 3;

-- delete an item
DELETE FROM Items
WHERE
    id = 2;

-- (f) show commands for query records from multiple entities using joins
-- get all items and their respective categories
SELECT
    Items.name,
    Items.description,
    Items.price,
    Items.size,
    Categories.name
from
    Items
    JOIN Categories ON Categories.id = Items.category_id;

-- get full details about all orders
SELECT
    Orders.id AS order_id,
    Users.fullname AS user_name,
    Users.email AS user_email,
    Items.name AS item_name,
    Items.price AS item_price,
    Orders.status,
    Categories.name AS category,
    Orders.created_at
FROM
    Orders
    JOIN Users ON Orders.user_id = Users.id
    JOIN Items ON Orders.item_id = Items.id
    JOIN Categories ON Items.category_id = Categories.id;