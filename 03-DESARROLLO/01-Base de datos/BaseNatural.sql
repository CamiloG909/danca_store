CREATE SCHEMA natu;

SET search_path TO natu;

CREATE TABLE rol (
    name VARCHAR(40),
    CONSTRAINT pk_rol PRIMARY KEY (name)
);

CREATE TABLE user_ (
    login VARCHAR(90),
    password VARCHAR(90)NOT NULL,
    email VARCHAR(90)NOT NULL,
    phone_number BIGINT NOT NULL,
    town VARCHAR(100)NOT NULL,
    address VARCHAR(90)NOT NULL,
    image_url VARCHAR,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_user PRIMARY KEY (login),
    CONSTRAINT uk_user UNIQUE (email)
);

CREATE TABLE user_rol (
    rol_name VARCHAR(40)NOT NULL,
    login VARCHAR(90) NOT NULL,
    CONSTRAINT pk_user_rol PRIMARY KEY (rol_name,login),
    CONSTRAINT fk_rol_user_rol FOREIGN KEY (rol_name) REFERENCES rol(name)on update cascade on delete restrict,
    CONSTRAINT fk_user_user_rol FOREIGN KEY (login) REFERENCES user_(login)on update cascade on delete restrict
);

CREATE TABLE document_type (
    initials VARCHAR(10)NOT NULL,
    document_name VARCHAR(40)NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_document_type PRIMARY KEY (initials)
);

CREATE TABLE client (
    document_number BIGINT NOT NULL,
    name VARCHAR(90)NOT NULL,
    last_name VARCHAR(90)NOT NULL,
    initials VARCHAR(10)NOT NULL,
	login VARCHAR(90)NOT NULL,
	CONSTRAINT pk_client PRIMARY KEY (document_number,initials),
    CONSTRAINT uk_client UNIQUE (login),
    CONSTRAINT fk_docu_type_clie FOREIGN KEY (initials) REFERENCES document_type(initials)on update cascade on delete restrict,
    CONSTRAINT fk_user_clie FOREIGN KEY (login) REFERENCES user_(login)on update cascade on delete restrict
);

CREATE TABLE supplier (
	company_name VARCHAR(50)NOT NULL,
    phone_number BIGINT NOT NULL,
	town VARCHAR(100)NOT NULL,
    address VARCHAR(90)NOT NULL,
    email VARCHAR(90)NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_supplier PRIMARY KEY (company_name)
);

CREATE TABLE product_category (
    category_name VARCHAR(40)NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_product_category PRIMARY KEY (category_name)
);

CREATE TABLE product (
    reference VARCHAR(100)NOT NULL,
    name VARCHAR(40)NOT NULL,
    price numeric(19,0)NOT NULL,
    picture VARCHAR NOT NULL,
	specs VARCHAR NOT NULL,
    information VARCHAR NOT NULL,
    color VARCHAR(150),
    stock int NOT NULL,
	category_name VARCHAR(40)NOT NULL,
    company_name_supplier VARCHAR(50)NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_product PRIMARY KEY (reference),
    CONSTRAINT fk_prod_cate_prod FOREIGN KEY (category_name) REFERENCES product_category(category_name)on update cascade on delete restrict,
    CONSTRAINT fk_supp_prod FOREIGN KEY (company_name_supplier) REFERENCES supplier(company_name)on update cascade on delete restrict
);

CREATE TABLE order_ (
    order_number serial NOT NULL,
	document_number BIGINT NOT NULL,
	initials VARCHAR(10) NOT NULL,
    order_date TIMESTAMP NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_order PRIMARY KEY (order_number),
	CONSTRAINT uk_order UNIQUE (document_number,initials),
	CONSTRAINT fk_clie_orde FOREIGN KEY (document_number, initials) REFERENCES client(document_number, initials)on update cascade on delete restrict
);

CREATE TABLE order_details (
    code serial NOT NULL,
	reference varchar(100)NOT NULL,
    order_number INTEGER NOT NULL,
    total_value numeric(19,0)NOT NULL,
    amount int NOT NULL,
    color VARCHAR(150),
	CONSTRAINT pk_order_details PRIMARY KEY (code),
	CONSTRAINT uk_order_details UNIQUE (reference,order_number),
    CONSTRAINT fk_prod_orde_deta FOREIGN KEY (reference) REFERENCES product(reference)on update cascade on delete restrict,
    CONSTRAINT fk_orde_orde_deta FOREIGN KEY (order_number) REFERENCES order_(order_number)on update cascade on delete restrict
);

CREATE TABLE method_payment (
    method_payment VARCHAR(40)NOT NULL,
	CONSTRAINT pk_method_payment PRIMARY KEY (method_payment)
);

CREATE TABLE payment (
	payment_number serial NOT NULL,
	method_payment VARCHAR(40)NOT NULL,
	order_number INTEGER NOT NULL,
    bill_date TIMESTAMP NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_payment PRIMARY KEY (payment_number),
	CONSTRAINT uk_payment UNIQUE (bill_date),
    CONSTRAINT fk_meth_paym_paym FOREIGN KEY (method_payment) REFERENCES method_payment(method_payment)on update cascade on delete restrict,
    CONSTRAINT fk_orde_paym FOREIGN KEY (order_number) REFERENCES order_(order_number)on update cascade on delete restrict
);

CREATE TABLE shipping (
	shipping_number serial NOT NULL,
	order_number INTEGER NOT NULL,
    shipping_company_name VARCHAR(40)NOT NULL,
    town VARCHAR(100)NOT NULL,
    address VARCHAR(90)NOT NULL,
    shipping_date TIMESTAMP NOT NULL,
    delivery_date TIMESTAMP NOT NULL,
    status VARCHAR(100)NOT NULL,
	CONSTRAINT pk_shipping PRIMARY KEY (shipping_number),
	CONSTRAINT uk_shipping UNIQUE (order_number),
    CONSTRAINT fk_orde_ship FOREIGN KEY (order_number) REFERENCES order_(order_number)on update cascade on delete restrict
);