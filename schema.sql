-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
CREATE TABLE subcontractor(
    id INTEGER AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address TEXT,
    postal_code INTEGER,
    email VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);

CREATE TABLE material(
    id INTEGER AUTO_INCREMENT,
    type VARCHAR(255),
    availability BOOLEAN DEFAULT 0,
    stock VARCHAR(255),
    subcontractor_id INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(subcontractor_id) REFERENCES subcontractor(id)
);

CREATE TABLE product(
    id INTEGER AUTO_INCREMENT,
    material_id INTEGER,
    type VARCHAR(255),
    availability BOOLEAN DEFAULT 0,
    stock TEXT,
    subcontractor_id INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(material_id) REFERENCES material(id),
    FOREIGN KEY(subcontractor_id) REFERENCES subcontractor(id)
);

CREATE TABLE `order`(
    id INTEGER AUTO_INCREMENT,
    order_type VARCHAR(100),
    product_type VARCHAR(100),
    product_location TEXT,
    product_id INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(product_id) REFERENCES product(id)
);

CREATE TABLE invoice(
    id INTEGER AUTO_INCREMENT,
    price INTEGER,
    tax INTEGER,
    `date` DATE,
    due_date DATE,
    total INTEGER,
    PRIMARY KEY(id)
);

CREATE TABLE customer(
    costumer_id INTEGER AUTO_INCREMENT,
    name VARCHAR(255),
    surname VARCHAR(255),
    address TEXT,
    age TINYINT,
    postal_code INTEGER,
    email VARCHAR(255),
    gender VARCHAR(255),
    invoice_id INTEGER,
    order_id INTEGER,
    PRIMARY KEY (costumer_id),
    FOREIGN KEY(invoice_id) REFERENCES invoice(id),
    FOREIGN KEY(order_id) REFERENCES `order`(id)
);


CREATE TABLE event(
    id INTEGER AUTO_INCREMENT,
    location TEXT,
    `date` DATE,
    address_id INTEGER,
    PRIMARY KEY(id),
    FOREIGN KEY(address_id) REFERENCES customer(costumer_id)
);


--INDEX FOR DATABASE

CREATE INDEX sub_idx
ON subcontractor(`id`, `name`);


CREATE INDEX material_idx
ON material(`id`, `subcontractor_id`);

CREATE INDEX product_idx
ON product(`id`, `material_id`, `subcontractor_id`);

CREATE INDEX order_idx
ON order(`id`, `product_id`);

CREATE INDEX customer_idx
ON customer(`costumer_id`, `invoice_id`, `name`, `surname`,`address`,`order_id`);

CREATE INDEX invoice_idx
ON invoice(`id`, `price`, `total`);

CREATE INDEX event_idx
ON `event`(`id`, `address_id`);

--VIEW FOR DATABASE
CREATE VIEW subcontractor_invoices AS
SELECT s.subcontractor_id, s.name, s.material, i.invoice_id, i.date
FROM subcontractor s
LEFT JOIN invoice i ON s.subcontractor_id = i.subcontractor_id
ORDER BY s.subcontractor_id;


CREATE VIEW customer_orders AS
SELECT c.customer_id, c.name, c.location, o.order_id, o.date, o.items
FROM customer c
JOIN order o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


CREATE VIEW active_high_value_customers AS
SELECT c.customer_id, c.name, c.location, SUM(o.total_price) AS total_spend
FROM customer c
JOIN order o ON c.customer_id = o.customer_id
WHERE o.status = 'Active'
GROUP BY c.customer_id, c.name, c.location
HAVING SUM(o.total_price) > 1000; -- Adjust threshold as needed
ORDER BY total_spend DESC;


CREATE VIEW overdue_invoices AS
SELECT i.invoice_id, s.name AS subcontractor, i.date, i.due_date
FROM invoice i
JOIN subcontractor s ON i.subcontractor_id = s.subcontractor_id
WHERE i.due_date < CURRENT_DATE
AND i.payment_status = 'Unpaid';
