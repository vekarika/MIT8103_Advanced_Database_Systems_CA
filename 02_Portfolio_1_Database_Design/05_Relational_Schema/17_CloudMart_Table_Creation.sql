-- ============================================================
-- Project: CloudMart E-Commerce Management System
-- Course: MIT 8103 - Advanced Database Systems
-- Portfolio: 1 - Database Design and Modelling
-- Database: cloudmart_db
-- DBMS: PostgreSQL 18
-- Purpose: Create the relational database tables and constraints
-- ============================================================

-- 1. CUSTOMER
CREATE TABLE customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(30),
    password_hash TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL DEFAULT 'active',

    CONSTRAINT chk_customer_status
        CHECK (status IN ('active', 'inactive', 'suspended'))
);

-- 2. ADDRESS
CREATE TABLE address (
    address_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state_region VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) NOT NULL,
    address_type VARCHAR(20) NOT NULL DEFAULT 'shipping',

    CONSTRAINT uq_address_id_customer
        UNIQUE (address_id, customer_id),

    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_address_type
        CHECK (address_type IN ('shipping', 'billing', 'both'))
);

-- 3. CATEGORY
CREATE TABLE category (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- 4. PRODUCT
CREATE TABLE product (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id BIGINT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    description TEXT,
    selling_price NUMERIC(12, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES category (category_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_product_price
        CHECK (selling_price >= 0),

    CONSTRAINT chk_product_status
        CHECK (status IN ('active', 'inactive', 'discontinued'))
);

-- 5. INVENTORY
CREATE TABLE inventory (
    inventory_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id BIGINT NOT NULL UNIQUE,
    quantity_available INTEGER NOT NULL DEFAULT 0,
    reorder_level INTEGER NOT NULL DEFAULT 0,
    last_updated TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id)
        REFERENCES product (product_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_inventory_quantity
        CHECK (quantity_available >= 0),

    CONSTRAINT chk_inventory_reorder_level
        CHECK (reorder_level >= 0)
);

-- 6. CUSTOMER ORDER
CREATE TABLE customer_order (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    delivery_address_id BIGINT NOT NULL,
    order_date TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(20) NOT NULL DEFAULT 'pending',

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_delivery_address_owner
        FOREIGN KEY (delivery_address_id, customer_id)
        REFERENCES address (address_id, customer_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_status
        CHECK (
            order_status IN (
                'pending',
                'confirmed',
                'processing',
                'shipped',
                'delivered',
                'cancelled',
                'refunded'
            )
        )
);

-- 7. ORDER ITEM
CREATE TABLE order_item (
    order_item_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    product_id BIGINT NOT NULL,
    quantity INTEGER NOT NULL,
    unit_price NUMERIC(12, 2) NOT NULL,

    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id)
        REFERENCES customer_order (order_id)
        ON DELETE RESTRICT,

    CONSTRAINT fk_order_item_product
        FOREIGN KEY (product_id)
        REFERENCES product (product_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_item_unit_price
        CHECK (unit_price >= 0),

    CONSTRAINT uq_order_item_product
        UNIQUE (order_id, product_id)
);

-- 8. PAYMENT
CREATE TABLE payment (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    amount NUMERIC(12, 2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    transaction_reference VARCHAR(150) UNIQUE,
    payment_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    payment_date TIMESTAMPTZ,

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES customer_order (order_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_payment_amount
        CHECK (amount > 0),

    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN (
                'card',
                'bank_transfer',
                'cash_on_delivery',
                'wallet',
                'other'
            )
        ),

    CONSTRAINT chk_payment_status
        CHECK (
            payment_status IN (
                'pending',
                'successful',
                'failed',
                'refunded'
            )
        )
);

-- 9. DELIVERY
CREATE TABLE delivery (
    delivery_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL,
    tracking_number VARCHAR(100) UNIQUE,
    delivery_status VARCHAR(20) NOT NULL DEFAULT 'pending',
    dispatch_date TIMESTAMPTZ,
    delivery_date TIMESTAMPTZ,

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id)
        REFERENCES customer_order (order_id)
        ON DELETE RESTRICT,

    CONSTRAINT chk_delivery_status
        CHECK (
            delivery_status IN (
                'pending',
                'dispatched',
                'in_transit',
                'delivered',
                'failed',
                'returned'
            )
        ),

    CONSTRAINT chk_delivery_dates
        CHECK (
            delivery_date IS NULL
            OR dispatch_date IS NULL
            OR delivery_date >= dispatch_date
        )
);

-- ============================================================
-- END OF TABLE CREATION SCRIPT
-- ============================================================