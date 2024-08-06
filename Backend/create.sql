##Base de datos que sustituye a la base de datos de kigo de las naps
create database kigo_nap;
use kigo_nap;
CREATE TABLE naps_name (
    nap_id INT PRIMARY KEY auto_increment,
    firstName VARCHAR(50),
    lastName VARCHAR(50),
    organizationName VARCHAR(100),
    email VARCHAR(100),
    zoneId INT
);

##########
##########

create database api_test;
use api_test;
CREATE TABLE pv_zones (
    zone_id INT NOT NULL AUTO_INCREMENT ,
    zone_name VARCHAR(255) NOT NULL,
    city_id INT NOT NULL,
    b_active TINYINT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (zone_id)
    
);

CREATE TABLE ko_promotions (
    promotion_id INT NOT NULL AUTO_INCREMENT,
    promotion_name VARCHAR(255) NOT NULL,
    promotion_type ENUM('Discount', 'Porcetaje', 'Num') NOT NULL,
    promotion_value CHAR(10) NOT NULL,
    promotion_description VARCHAR(255),
    b_active TINYINT NOT NULL,
    zone_id INT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (promotion_id),
    FOREIGN KEY (zone_id) REFERENCES pv_zones (zone_id));


CREATE TABLE ko_operators (
    operator_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    operator_email VARCHAR(255) NOT NULL,
    area_code CHAR(15) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    operator_type ENUM('FullTime', 'PartTime', 'Contractor') NOT NULL,
    b_active TINYINT NOT NULL,
    kigo_userId BINARY(16) NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    password_hash VARCHAR(255) NOT NULL,
    PRIMARY KEY (operator_id)
);



CREATE TABLE ko_operator_wallet (
    operator_wallet_id INT NOT NULL AUTO_INCREMENT,
    funds DECIMAL(10, 2) NOT NULL,
    currency CHAR(5) NOT NULL,
    operator_id INT NOT NULL,
    kigo_accountNumber VARCHAR(255) NOT NULL,
    updated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (operator_wallet_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id)
);

CREATE TABLE ko_operator_balance_sale (
    sale_id INT NOT NULL AUTO_INCREMENT,
    sale_number VARCHAR(255),
    sale_type ENUM('credito', 'contado') NOT NULL,
    sales_amount DECIMAL(10, 2) NOT NULL,
    balance_sold DECIMAL(10, 2) NOT NULL,
    reference VARCHAR(255), 
    deposit_account VARCHAR(255),
    promotion_id INT,
    operator_id INT NOT NULL,
    operator_wallet_id INT,
    wallet_previous_funds DECIMAL(10, 2),
    wallet_final_funds DECIMAL(10, 2),
    sale_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    legacy_reseller_id INT,
    PRIMARY KEY (sale_id),
    FOREIGN KEY (promotion_id) REFERENCES ko_promotions(promotion_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id),
    FOREIGN KEY (operator_wallet_id) REFERENCES ko_operator_wallet(operator_wallet_id)
);


CREATE TABLE ko_operator_zone (
    operator_zone_id INT NOT NULL AUTO_INCREMENT,
    operator_id INT NOT NULL,
    zone_id INT NOT NULL,
    b_active TINYINT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (operator_zone_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id),
    FOREIGN KEY (zone_id) REFERENCES pv_zones(zone_id)
);


CREATE TABLE ko_operator_zone_bank_account (
    bank_account_id INT NOT NULL AUTO_INCREMENT,
    bank_name VARCHAR(255) NOT NULL,
    account_number VARCHAR(255) NOT NULL,
    CLABE VARCHAR(18) NOT NULL,
    bank_account_alias VARCHAR(255),
    b_active TINYINT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    operator_zone_id INT NOT NULL,
    PRIMARY KEY (bank_account_id),
    FOREIGN KEY (operator_zone_id) REFERENCES ko_operator_zone(operator_zone_id)
);

CREATE TABLE ko_operator_bank_deposit (
    deposit_id INT NOT NULL AUTO_INCREMENT,
    deposit_amount DECIMAL(10, 2) NOT NULL,
    amount_year YEAR NOT NULL,
    amount_month TINYINT NOT NULL,
    deposit_receipt TEXT,
    deposit_date DATE,
    deposit_notes VARCHAR(255),
    operator_id INT NOT NULL,
    bank_account_id INT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (deposit_id),
    FOREIGN KEY (operator_id) REFERENCES ko_operators(operator_id),
    FOREIGN KEY (bank_account_id) REFERENCES ko_operator_zone_bank_account(bank_account_id)
);


CREATE TABLE Payments (
    idpayment INT NOT NULL AUTO_INCREMENT,
    sale_id INT NOT NULL,
    payment INT NOT NULL,
    create_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    note VARCHAR(255),
    PRIMARY KEY (idpayment),
    FOREIGN KEY (sale_id) REFERENCES ko_operator_balance_sale(sale_id)
);
