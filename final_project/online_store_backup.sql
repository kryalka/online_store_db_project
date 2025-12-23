--
-- PostgreSQL database dump
--

\restrict 4fHo6pnQx8391L0w2z5aMtDKea3wrXK78VtiHLpELX9k7VzHA3xKjOqyw2tDudh

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_moderated_by_fkey;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_manufacturer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_employee_id_fkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_customer_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_status_history DROP CONSTRAINT IF EXISTS order_status_history_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_status_history DROP CONSTRAINT IF EXISTS order_status_history_changed_by_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_product_id_fkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_order_id_fkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_courier_id_fkey;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_parent_category_id_fkey;
DROP TRIGGER IF EXISTS update_promo_codes_updated_at ON public.promo_codes;
DROP TRIGGER IF EXISTS trg_update_product_stock ON public.order_items;
DROP TRIGGER IF EXISTS trg_update_product_rating ON public.reviews;
DROP TRIGGER IF EXISTS trg_update_order_totals ON public.order_items;
DROP TRIGGER IF EXISTS trg_log_order_status ON public.orders;
DROP INDEX IF EXISTS public.idx_status_history_order_date;
DROP INDEX IF EXISTS public.idx_reviews_product_rating;
DROP INDEX IF EXISTS public.idx_reviews_customer;
DROP INDEX IF EXISTS public.idx_reviews_approved_only;
DROP INDEX IF EXISTS public.idx_promo_codes_code;
DROP INDEX IF EXISTS public.idx_promo_codes_active_dates;
DROP INDEX IF EXISTS public.idx_products_price;
DROP INDEX IF EXISTS public.idx_products_manufacturer_price;
DROP INDEX IF EXISTS public.idx_products_low_stock;
DROP INDEX IF EXISTS public.idx_products_discounted;
DROP INDEX IF EXISTS public.idx_products_category_price;
DROP INDEX IF EXISTS public.idx_products_active_only;
DROP INDEX IF EXISTS public.idx_orders_status_created_at;
DROP INDEX IF EXISTS public.idx_orders_paid_only;
DROP INDEX IF EXISTS public.idx_orders_number;
DROP INDEX IF EXISTS public.idx_orders_customer_created_at;
DROP INDEX IF EXISTS public.idx_order_items_product;
DROP INDEX IF EXISTS public.idx_order_items_order_product;
DROP INDEX IF EXISTS public.idx_order_items_order;
DROP INDEX IF EXISTS public.idx_deliveries_tracking;
DROP INDEX IF EXISTS public.idx_deliveries_status;
DROP INDEX IF EXISTS public.idx_customers_registration_date;
DROP INDEX IF EXISTS public.idx_customers_email_lower;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_product_id_customer_id_key;
ALTER TABLE IF EXISTS ONLY public.reviews DROP CONSTRAINT IF EXISTS reviews_pkey;
ALTER TABLE IF EXISTS ONLY public.promo_codes DROP CONSTRAINT IF EXISTS promo_codes_pkey;
ALTER TABLE IF EXISTS ONLY public.promo_codes DROP CONSTRAINT IF EXISTS promo_codes_code_key;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_sku_key;
ALTER TABLE IF EXISTS ONLY public.products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_pkey;
ALTER TABLE IF EXISTS ONLY public.orders DROP CONSTRAINT IF EXISTS orders_order_number_key;
ALTER TABLE IF EXISTS ONLY public.order_status_history DROP CONSTRAINT IF EXISTS order_status_history_pkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_pkey;
ALTER TABLE IF EXISTS ONLY public.order_items DROP CONSTRAINT IF EXISTS order_items_order_id_product_id_key;
ALTER TABLE IF EXISTS ONLY public.manufacturers DROP CONSTRAINT IF EXISTS manufacturers_pkey;
ALTER TABLE IF EXISTS ONLY public.manufacturers DROP CONSTRAINT IF EXISTS manufacturers_name_key;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_username_key;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_pkey;
ALTER TABLE IF EXISTS ONLY public.employees DROP CONSTRAINT IF EXISTS employees_email_key;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_pkey;
ALTER TABLE IF EXISTS ONLY public.deliveries DROP CONSTRAINT IF EXISTS deliveries_order_id_key;
ALTER TABLE IF EXISTS ONLY public.customers DROP CONSTRAINT IF EXISTS customers_pkey;
ALTER TABLE IF EXISTS ONLY public.customers DROP CONSTRAINT IF EXISTS customers_email_key;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_slug_key;
ALTER TABLE IF EXISTS ONLY public.categories DROP CONSTRAINT IF EXISTS categories_pkey;
ALTER TABLE IF EXISTS public.reviews ALTER COLUMN review_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.promo_codes ALTER COLUMN promo_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.products ALTER COLUMN product_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.orders ALTER COLUMN order_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.order_status_history ALTER COLUMN history_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.order_items ALTER COLUMN order_item_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.manufacturers ALTER COLUMN manufacturer_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.employees ALTER COLUMN employee_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.deliveries ALTER COLUMN delivery_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.customers ALTER COLUMN customer_id DROP DEFAULT;
ALTER TABLE IF EXISTS public.categories ALTER COLUMN category_id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.reviews_review_id_seq;
DROP TABLE IF EXISTS public.reviews;
DROP SEQUENCE IF EXISTS public.promo_codes_promo_id_seq;
DROP TABLE IF EXISTS public.promo_codes;
DROP SEQUENCE IF EXISTS public.products_product_id_seq;
DROP TABLE IF EXISTS public.products;
DROP SEQUENCE IF EXISTS public.orders_order_id_seq;
DROP TABLE IF EXISTS public.orders;
DROP SEQUENCE IF EXISTS public.orders_order_number_seq;
DROP SEQUENCE IF EXISTS public.order_status_history_history_id_seq;
DROP TABLE IF EXISTS public.order_status_history;
DROP SEQUENCE IF EXISTS public.order_items_order_item_id_seq;
DROP TABLE IF EXISTS public.order_items;
DROP SEQUENCE IF EXISTS public.manufacturers_manufacturer_id_seq;
DROP TABLE IF EXISTS public.manufacturers;
DROP SEQUENCE IF EXISTS public.employees_employee_id_seq;
DROP TABLE IF EXISTS public.employees;
DROP SEQUENCE IF EXISTS public.deliveries_delivery_id_seq;
DROP TABLE IF EXISTS public.deliveries;
DROP SEQUENCE IF EXISTS public.customers_customer_id_seq;
DROP TABLE IF EXISTS public.customers;
DROP SEQUENCE IF EXISTS public.categories_category_id_seq;
DROP TABLE IF EXISTS public.categories;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.update_stock_on_order_item();
DROP FUNCTION IF EXISTS public.update_product_stock();
DROP FUNCTION IF EXISTS public.update_product_rating();
DROP FUNCTION IF EXISTS public.update_order_totals();
DROP FUNCTION IF EXISTS public.log_order_status_change();
DROP FUNCTION IF EXISTS public.get_popular_products(limit_count integer);
DROP FUNCTION IF EXISTS public.get_customer_total_spent(p_customer_id integer);
DROP FUNCTION IF EXISTS public.get_average_order_value();
DROP FUNCTION IF EXISTS public.check_product_availability(p_product_id integer, p_requested_quantity integer);
--
-- Name: check_product_availability(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_product_availability(p_product_id integer, p_requested_quantity integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    available_quantity INTEGER;
BEGIN
    SELECT stock_quantity - reserved_quantity
    INTO available_quantity
    FROM products
    WHERE product_id = p_product_id;

    RETURN COALESCE(available_quantity, 0) >= p_requested_quantity;
END;
$$;


ALTER FUNCTION public.check_product_availability(p_product_id integer, p_requested_quantity integer) OWNER TO postgres;

--
-- Name: get_average_order_value(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_average_order_value() RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    avg_value DECIMAL(12,2);
BEGIN
    SELECT AVG(total_amount)
    INTO avg_value
    FROM orders
    WHERE payment_status = 'paid';
    
    RETURN COALESCE(avg_value, 0);
END;
$$;


ALTER FUNCTION public.get_average_order_value() OWNER TO postgres;

--
-- Name: get_customer_total_spent(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_customer_total_spent(p_customer_id integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_sum NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(total_amount), 0)
    INTO total_sum
    FROM orders
    WHERE customer_id = p_customer_id
      AND payment_status = 'paid';

    RETURN total_sum;
END;
$$;


ALTER FUNCTION public.get_customer_total_spent(p_customer_id integer) OWNER TO postgres;

--
-- Name: get_popular_products(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_popular_products(limit_count integer DEFAULT 10) RETURNS TABLE(product_id integer, product_name character varying, total_sold bigint, total_revenue numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.product_id,
        p.name,
        SUM(oi.quantity) as total_sold,
        SUM(oi.quantity * oi.unit_price) as total_revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.payment_status = 'paid'
    GROUP BY p.product_id, p.name
    ORDER BY total_sold DESC
    LIMIT limit_count;
END;
$$;


ALTER FUNCTION public.get_popular_products(limit_count integer) OWNER TO postgres;

--
-- Name: log_order_status_change(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_order_status_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF OLD.status IS DISTINCT FROM NEW.status THEN
        INSERT INTO order_status_history (
            order_id,
            old_status,
            new_status,
            changed_by_type,
            changed_by_name,
            changed_at,
            change_reason
        ) VALUES (
            NEW.order_id,
            OLD.status,
            NEW.status,
            'system',
            'system',
            CURRENT_TIMESTAMP,
            'Изменение статуса заказа'
        );
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_order_status_change() OWNER TO postgres;

--
-- Name: update_order_totals(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_order_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    target_order_id INTEGER;
BEGIN
    target_order_id := COALESCE(NEW.order_id, OLD.order_id);

    UPDATE orders
    SET subtotal_amount = (
            SELECT COALESCE(SUM(quantity * unit_price), 0)
            FROM order_items
            WHERE order_id = target_order_id
        ),
        total_amount = (
            SELECT COALESCE(SUM(quantity * unit_price), 0)
            FROM order_items
            WHERE order_id = target_order_id
        ) - discount_amount + tax_amount + shipping_amount,
        updated_at = CURRENT_TIMESTAMP
    WHERE order_id = target_order_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.update_order_totals() OWNER TO postgres;

--
-- Name: update_product_rating(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_product_rating() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    target_product_id INTEGER;
BEGIN
    target_product_id := COALESCE(NEW.product_id, OLD.product_id);

    UPDATE products
    SET average_rating = (
            SELECT AVG(rating)::NUMERIC(3,2)
            FROM reviews
            WHERE product_id = target_product_id
              AND status = 'approved'
        ),
        review_count = (
            SELECT COUNT(*)
            FROM reviews
            WHERE product_id = target_product_id
              AND status = 'approved'
        ),
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = target_product_id;

    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.update_product_rating() OWNER TO postgres;

--
-- Name: update_product_stock(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_product_stock() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    delta INTEGER;
BEGIN
    IF TG_OP = 'INSERT' THEN
        delta := NEW.quantity;
    ELSIF TG_OP = 'UPDATE' THEN
        delta := NEW.quantity - OLD.quantity;
    ELSIF TG_OP = 'DELETE' THEN
        delta := -OLD.quantity;
    END IF;

    IF delta > 0 THEN
        IF NOT check_product_availability(NEW.product_id, delta) THEN
            RAISE EXCEPTION
                'Недостаточно товара на складе (product_id = %)',
                NEW.product_id;
        END IF;
    END IF;

    UPDATE products
    SET stock_quantity   = stock_quantity - delta,
        reserved_quantity = reserved_quantity + delta,
        updated_at        = CURRENT_TIMESTAMP
    WHERE product_id = COALESCE(NEW.product_id, OLD.product_id);

    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.update_product_stock() OWNER TO postgres;

--
-- Name: update_stock_on_order_item(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_stock_on_order_item() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Уменьшаем доступное количество и увеличиваем зарезервированное
    UPDATE products
    SET stock_quantity = stock_quantity - NEW.quantity,
        reserved_quantity = reserved_quantity + NEW.quantity,
        updated_at = CURRENT_TIMESTAMP
    WHERE product_id = NEW.product_id;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_stock_on_order_item() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    parent_category_id integer,
    name character varying(100) NOT NULL,
    slug character varying(100) NOT NULL,
    description text,
    image_url character varying(500),
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categories_category_id_seq OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50),
    billing_address jsonb,
    registration_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    last_active_date timestamp with time zone,
    account_status character varying(20) DEFAULT 'active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT customers_account_status_check CHECK (((account_status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying, 'blocked'::character varying])::text[]))),
    CONSTRAINT customers_check CHECK (((updated_at IS NULL) OR (updated_at >= created_at))),
    CONSTRAINT customers_email_check CHECK (((email)::text ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'::text))
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_customer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_customer_id_seq OWNER TO postgres;

--
-- Name: customers_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_customer_id_seq OWNED BY public.customers.customer_id;


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.deliveries (
    delivery_id integer NOT NULL,
    order_id integer NOT NULL,
    delivery_address jsonb NOT NULL,
    recipient_name character varying(255) NOT NULL,
    recipient_phone character varying(50) NOT NULL,
    delivery_method character varying(30) NOT NULL,
    delivery_cost numeric(10,2) DEFAULT 0 NOT NULL,
    status character varying(30) DEFAULT 'pending'::character varying NOT NULL,
    tracking_number character varying(100),
    carrier character varying(100),
    estimated_delivery_date date,
    actual_delivery_date timestamp with time zone,
    shipped_at timestamp with time zone,
    courier_id integer,
    courier_notes text,
    delivery_signature text,
    delivery_proof_url character varying(500),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT deliveries_delivery_cost_check CHECK ((delivery_cost >= (0)::numeric)),
    CONSTRAINT deliveries_delivery_method_check CHECK (((delivery_method)::text = ANY ((ARRAY['courier'::character varying, 'pickup'::character varying, 'post'::character varying, 'express'::character varying])::text[]))),
    CONSTRAINT deliveries_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'processing'::character varying, 'in_transit'::character varying, 'out_for_delivery'::character varying, 'delivered'::character varying, 'failed'::character varying, 'returned'::character varying])::text[])))
);


ALTER TABLE public.deliveries OWNER TO postgres;

--
-- Name: deliveries_delivery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.deliveries_delivery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.deliveries_delivery_id_seq OWNER TO postgres;

--
-- Name: deliveries_delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.deliveries_delivery_id_seq OWNED BY public.deliveries.delivery_id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role character varying(30) NOT NULL,
    department character varying(100),
    hire_date date NOT NULL,
    termination_date date,
    salary numeric(12,2),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employees_check CHECK (((termination_date IS NULL) OR (termination_date >= hire_date))),
    CONSTRAINT employees_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'manager'::character varying, 'warehouse'::character varying, 'courier'::character varying, 'support'::character varying, 'analyst'::character varying])::text[]))),
    CONSTRAINT employees_salary_check CHECK ((salary >= (0)::numeric))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: manufacturers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.manufacturers (
    manufacturer_id integer NOT NULL,
    name character varying(100) NOT NULL,
    country character varying(100),
    website character varying(255),
    description text,
    logo_url character varying(500),
    founded_year integer,
    contact_email character varying(255),
    contact_phone character varying(50),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT manufacturers_founded_year_check CHECK (((founded_year IS NULL) OR ((founded_year >= 1800) AND ((founded_year)::numeric <= EXTRACT(year FROM CURRENT_DATE)))))
);


ALTER TABLE public.manufacturers OWNER TO postgres;

--
-- Name: manufacturers_manufacturer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.manufacturers_manufacturer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.manufacturers_manufacturer_id_seq OWNER TO postgres;

--
-- Name: manufacturers_manufacturer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.manufacturers_manufacturer_id_seq OWNED BY public.manufacturers.manufacturer_id;


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_items (
    order_item_id integer NOT NULL,
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(12,2) NOT NULL,
    item_discount numeric(12,2) DEFAULT 0,
    product_name_at_time character varying(500),
    product_sku_at_time character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT order_items_check CHECK (((item_discount >= (0)::numeric) AND (item_discount <= ((quantity)::numeric * unit_price)))),
    CONSTRAINT order_items_quantity_check CHECK ((quantity > 0)),
    CONSTRAINT order_items_unit_price_check CHECK ((unit_price >= (0)::numeric))
);


ALTER TABLE public.order_items OWNER TO postgres;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_items_order_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_items_order_item_id_seq OWNER TO postgres;

--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_items_order_item_id_seq OWNED BY public.order_items.order_item_id;


--
-- Name: order_status_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_status_history (
    history_id integer NOT NULL,
    order_id integer NOT NULL,
    old_status character varying(30),
    new_status character varying(30) NOT NULL,
    changed_by_type character varying(20) NOT NULL,
    changed_by_id integer,
    changed_by_name character varying(255),
    change_reason text,
    notes text,
    ip_address inet,
    user_agent text,
    changed_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT order_status_history_changed_by_type_check CHECK (((changed_by_type)::text = ANY ((ARRAY['customer'::character varying, 'employee'::character varying, 'system'::character varying, 'payment_gateway'::character varying])::text[])))
);


ALTER TABLE public.order_status_history OWNER TO postgres;

--
-- Name: order_status_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_status_history_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_status_history_history_id_seq OWNER TO postgres;

--
-- Name: order_status_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_status_history_history_id_seq OWNED BY public.order_status_history.history_id;


--
-- Name: orders_order_number_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_number_seq
    START WITH 1000
    INCREMENT BY 1
    MINVALUE 1000
    NO MAXVALUE
    CACHE 10;


ALTER SEQUENCE public.orders_order_number_seq OWNER TO postgres;

--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id integer NOT NULL,
    order_number character varying(50) DEFAULT ((('ORD-'::text || to_char((CURRENT_DATE)::timestamp with time zone, 'YYYYMMDD'::text)) || '-'::text) || lpad((nextval('public.orders_order_number_seq'::regclass))::text, 6, '0'::text)) NOT NULL,
    customer_id integer NOT NULL,
    employee_id integer,
    status character varying(30) DEFAULT 'created'::character varying NOT NULL,
    payment_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    subtotal_amount numeric(12,2) DEFAULT 0 NOT NULL,
    discount_amount numeric(12,2) DEFAULT 0 NOT NULL,
    tax_amount numeric(12,2) DEFAULT 0 NOT NULL,
    shipping_amount numeric(12,2) DEFAULT 0 NOT NULL,
    total_amount numeric(12,2) DEFAULT 0 NOT NULL,
    payment_method character varying(30),
    payment_transaction_id character varying(100),
    coupon_code character varying(50),
    discount_percentage numeric(5,2),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    paid_at timestamp with time zone,
    completed_at timestamp with time zone,
    cancelled_at timestamp with time zone,
    customer_notes text,
    internal_notes text,
    CONSTRAINT orders_check CHECK ((discount_amount <= subtotal_amount)),
    CONSTRAINT orders_check1 CHECK ((total_amount = (((subtotal_amount - discount_amount) + tax_amount) + shipping_amount))),
    CONSTRAINT orders_check2 CHECK ((((cancelled_at IS NULL) OR (cancelled_at >= created_at)) AND ((completed_at IS NULL) OR (completed_at >= created_at)) AND ((paid_at IS NULL) OR (paid_at >= created_at)))),
    CONSTRAINT orders_discount_amount_check CHECK ((discount_amount >= (0)::numeric)),
    CONSTRAINT orders_discount_percentage_check CHECK (((discount_percentage IS NULL) OR ((discount_percentage >= (0)::numeric) AND (discount_percentage <= (100)::numeric)))),
    CONSTRAINT orders_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['card_online'::character varying, 'card_upon_receipt'::character varying, 'cash'::character varying, 'bank_transfer'::character varying, 'digital_wallet'::character varying])::text[]))),
    CONSTRAINT orders_payment_status_check CHECK (((payment_status)::text = ANY ((ARRAY['pending'::character varying, 'paid'::character varying, 'failed'::character varying, 'refunded'::character varying, 'partially_refunded'::character varying])::text[]))),
    CONSTRAINT orders_shipping_amount_check CHECK ((shipping_amount >= (0)::numeric)),
    CONSTRAINT orders_status_check CHECK (((status)::text = ANY ((ARRAY['created'::character varying, 'processing'::character varying, 'awaiting_payment'::character varying, 'paid'::character varying, 'packaging'::character varying, 'shipped'::character varying, 'delivered'::character varying, 'cancelled'::character varying, 'returned'::character varying, 'refunded'::character varying])::text[]))),
    CONSTRAINT orders_subtotal_amount_check CHECK ((subtotal_amount >= (0)::numeric)),
    CONSTRAINT orders_tax_amount_check CHECK ((tax_amount >= (0)::numeric)),
    CONSTRAINT orders_total_amount_check CHECK ((total_amount >= (0)::numeric))
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    sku character varying(50) NOT NULL,
    name character varying(500) NOT NULL,
    category_id integer NOT NULL,
    manufacturer_id integer NOT NULL,
    short_description text,
    full_description text,
    base_price numeric(12,2) NOT NULL,
    current_price numeric(12,2) NOT NULL,
    cost_price numeric(12,2),
    stock_quantity integer DEFAULT 0 NOT NULL,
    reserved_quantity integer DEFAULT 0 NOT NULL,
    min_stock_level integer DEFAULT 5,
    specifications jsonb DEFAULT '{}'::jsonb,
    main_image_url character varying(500),
    image_gallery jsonb DEFAULT '[]'::jsonb,
    weight_kg numeric(8,3),
    dimensions jsonb,
    is_active boolean DEFAULT true,
    is_featured boolean DEFAULT false,
    is_new boolean DEFAULT true,
    average_rating numeric(3,2) DEFAULT 0,
    review_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    published_at timestamp with time zone,
    CONSTRAINT products_average_rating_check CHECK (((average_rating >= (0)::numeric) AND (average_rating <= (5)::numeric))),
    CONSTRAINT products_base_price_check CHECK ((base_price >= (0)::numeric)),
    CONSTRAINT products_check CHECK (((reserved_quantity >= 0) AND (reserved_quantity <= stock_quantity))),
    CONSTRAINT products_check1 CHECK (((cost_price IS NULL) OR (current_price >= cost_price))),
    CONSTRAINT products_cost_price_check CHECK (((cost_price IS NULL) OR (cost_price >= (0)::numeric))),
    CONSTRAINT products_current_price_check CHECK ((current_price >= (0)::numeric)),
    CONSTRAINT products_min_stock_level_check CHECK ((min_stock_level >= 0)),
    CONSTRAINT products_review_count_check CHECK ((review_count >= 0)),
    CONSTRAINT products_stock_quantity_check CHECK ((stock_quantity >= 0)),
    CONSTRAINT products_weight_kg_check CHECK ((weight_kg >= (0)::numeric))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_product_id_seq OWNER TO postgres;

--
-- Name: products_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_product_id_seq OWNED BY public.products.product_id;


--
-- Name: promo_codes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promo_codes (
    promo_id integer NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    discount_type character varying(20) NOT NULL,
    discount_value numeric(10,2) NOT NULL,
    min_order_amount numeric(12,2),
    max_discount_amount numeric(12,2),
    applicable_category_ids integer[],
    applicable_product_ids integer[],
    excluded_product_ids integer[],
    customer_limit integer,
    usage_limit_per_customer integer,
    valid_from timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    valid_until timestamp with time zone,
    is_active boolean DEFAULT true,
    total_usage_count integer DEFAULT 0,
    total_discount_amount numeric(15,2) DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT percentage_limit CHECK ((((discount_type)::text <> 'percentage'::text) OR (discount_value <= (100)::numeric))),
    CONSTRAINT promo_codes_customer_limit_check CHECK ((customer_limit > 0)),
    CONSTRAINT promo_codes_discount_value_check CHECK ((discount_value >= (0)::numeric)),
    CONSTRAINT promo_codes_max_discount_amount_check CHECK ((max_discount_amount >= (0)::numeric)),
    CONSTRAINT promo_codes_min_order_amount_check CHECK ((min_order_amount >= (0)::numeric)),
    CONSTRAINT promo_codes_total_discount_amount_check CHECK ((total_discount_amount >= (0)::numeric)),
    CONSTRAINT promo_codes_total_usage_count_check CHECK ((total_usage_count >= 0)),
    CONSTRAINT promo_codes_usage_limit_per_customer_check CHECK ((usage_limit_per_customer > 0)),
    CONSTRAINT valid_dates CHECK (((valid_until IS NULL) OR (valid_until > valid_from))),
    CONSTRAINT valid_discount_type CHECK (((discount_type)::text = ANY ((ARRAY['percentage'::character varying, 'fixed_amount'::character varying, 'free_shipping'::character varying])::text[])))
);


ALTER TABLE public.promo_codes OWNER TO postgres;

--
-- Name: TABLE promo_codes; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.promo_codes IS 'Промокоды и скидочные купоны';


--
-- Name: promo_codes_promo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promo_codes_promo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promo_codes_promo_id_seq OWNER TO postgres;

--
-- Name: promo_codes_promo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promo_codes_promo_id_seq OWNED BY public.promo_codes.promo_id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reviews (
    review_id integer NOT NULL,
    product_id integer NOT NULL,
    customer_id integer NOT NULL,
    order_id integer,
    rating integer NOT NULL,
    title character varying(200),
    comment text NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying,
    moderated_by integer,
    moderation_notes text,
    moderated_at timestamp with time zone,
    is_verified_purchase boolean DEFAULT false,
    helpful_count integer DEFAULT 0,
    not_helpful_count integer DEFAULT 0,
    image_urls jsonb DEFAULT '[]'::jsonb,
    video_url character varying(500),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT reviews_helpful_count_check CHECK ((helpful_count >= 0)),
    CONSTRAINT reviews_not_helpful_count_check CHECK ((not_helpful_count >= 0)),
    CONSTRAINT reviews_rating_check CHECK (((rating >= 1) AND (rating <= 5))),
    CONSTRAINT reviews_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying, 'hidden'::character varying])::text[])))
);


ALTER TABLE public.reviews OWNER TO postgres;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reviews_review_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reviews_review_id_seq OWNER TO postgres;

--
-- Name: reviews_review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reviews_review_id_seq OWNED BY public.reviews.review_id;


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: customers customer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN customer_id SET DEFAULT nextval('public.customers_customer_id_seq'::regclass);


--
-- Name: deliveries delivery_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries ALTER COLUMN delivery_id SET DEFAULT nextval('public.deliveries_delivery_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: manufacturers manufacturer_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers ALTER COLUMN manufacturer_id SET DEFAULT nextval('public.manufacturers_manufacturer_id_seq'::regclass);


--
-- Name: order_items order_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items ALTER COLUMN order_item_id SET DEFAULT nextval('public.order_items_order_item_id_seq'::regclass);


--
-- Name: order_status_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history ALTER COLUMN history_id SET DEFAULT nextval('public.order_status_history_history_id_seq'::regclass);


--
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_product_id_seq'::regclass);


--
-- Name: promo_codes promo_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes ALTER COLUMN promo_id SET DEFAULT nextval('public.promo_codes_promo_id_seq'::regclass);


--
-- Name: reviews review_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews ALTER COLUMN review_id SET DEFAULT nextval('public.reviews_review_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, parent_category_id, name, slug, description, image_url, sort_order, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, full_name, email, phone, billing_address, registration_date, last_active_date, account_status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.deliveries (delivery_id, order_id, delivery_address, recipient_name, recipient_phone, delivery_method, delivery_cost, status, tracking_number, carrier, estimated_delivery_date, actual_delivery_date, shipped_at, courier_id, courier_notes, delivery_signature, delivery_proof_url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, username, password_hash, full_name, email, role, department, hire_date, termination_date, salary, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: manufacturers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.manufacturers (manufacturer_id, name, country, website, description, logo_url, founded_year, contact_email, contact_phone, is_active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_items (order_item_id, order_id, product_id, quantity, unit_price, item_discount, product_name_at_time, product_sku_at_time, created_at) FROM stdin;
\.


--
-- Data for Name: order_status_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_status_history (history_id, order_id, old_status, new_status, changed_by_type, changed_by_id, changed_by_name, change_reason, notes, ip_address, user_agent, changed_at) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, order_number, customer_id, employee_id, status, payment_status, subtotal_amount, discount_amount, tax_amount, shipping_amount, total_amount, payment_method, payment_transaction_id, coupon_code, discount_percentage, created_at, updated_at, paid_at, completed_at, cancelled_at, customer_notes, internal_notes) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, sku, name, category_id, manufacturer_id, short_description, full_description, base_price, current_price, cost_price, stock_quantity, reserved_quantity, min_stock_level, specifications, main_image_url, image_gallery, weight_kg, dimensions, is_active, is_featured, is_new, average_rating, review_count, created_at, updated_at, published_at) FROM stdin;
\.


--
-- Data for Name: promo_codes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promo_codes (promo_id, code, description, discount_type, discount_value, min_order_amount, max_discount_amount, applicable_category_ids, applicable_product_ids, excluded_product_ids, customer_limit, usage_limit_per_customer, valid_from, valid_until, is_active, total_usage_count, total_discount_amount, created_at, updated_at) FROM stdin;
1	WELCOME10	Приветственная скидка	percentage	10.00	\N	\N	\N	\N	\N	\N	\N	2025-12-23 12:13:27.446496+03	2026-12-31 00:00:00+03	t	0	0.00	2025-12-23 12:13:27.446496+03	2025-12-23 12:13:27.446496+03
2	SUMMER2025	Летняя распродажа	fixed_amount	5000.00	\N	\N	\N	\N	\N	\N	\N	2025-12-23 12:13:27.446496+03	2026-08-31 00:00:00+03	t	0	0.00	2025-12-23 12:13:27.446496+03	2025-12-23 12:13:27.446496+03
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reviews (review_id, product_id, customer_id, order_id, rating, title, comment, status, moderated_by, moderation_notes, moderated_at, is_verified_purchase, helpful_count, not_helpful_count, image_urls, video_url, created_at, updated_at) FROM stdin;
\.


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 1, false);


--
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 1, false);


--
-- Name: deliveries_delivery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.deliveries_delivery_id_seq', 1, false);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 1, false);


--
-- Name: manufacturers_manufacturer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.manufacturers_manufacturer_id_seq', 1, false);


--
-- Name: order_items_order_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_items_order_item_id_seq', 1, false);


--
-- Name: order_status_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_status_history_history_id_seq', 1, false);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 1, false);


--
-- Name: orders_order_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_number_seq', 1000, false);


--
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 1, false);


--
-- Name: promo_codes_promo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promo_codes_promo_id_seq', 2, true);


--
-- Name: reviews_review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reviews_review_id_seq', 1, false);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (category_id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: customers customers_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_key UNIQUE (email);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: deliveries deliveries_order_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_order_id_key UNIQUE (order_id);


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_pkey PRIMARY KEY (delivery_id);


--
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: employees employees_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_username_key UNIQUE (username);


--
-- Name: manufacturers manufacturers_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_name_key UNIQUE (name);


--
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (manufacturer_id);


--
-- Name: order_items order_items_order_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_product_id_key UNIQUE (order_id, product_id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (order_item_id);


--
-- Name: order_status_history order_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_pkey PRIMARY KEY (history_id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- Name: products products_sku_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- Name: promo_codes promo_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_code_key UNIQUE (code);


--
-- Name: promo_codes promo_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_codes
    ADD CONSTRAINT promo_codes_pkey PRIMARY KEY (promo_id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (review_id);


--
-- Name: reviews reviews_product_id_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_customer_id_key UNIQUE (product_id, customer_id);


--
-- Name: idx_customers_email_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_email_lower ON public.customers USING btree (lower((email)::text));


--
-- Name: idx_customers_registration_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_customers_registration_date ON public.customers USING btree (registration_date DESC);


--
-- Name: idx_deliveries_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliveries_status ON public.deliveries USING btree (status);


--
-- Name: idx_deliveries_tracking; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_deliveries_tracking ON public.deliveries USING btree (tracking_number) WHERE (tracking_number IS NOT NULL);


--
-- Name: idx_order_items_order; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order ON public.order_items USING btree (order_id);


--
-- Name: idx_order_items_order_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_order_product ON public.order_items USING btree (order_id, product_id);


--
-- Name: idx_order_items_product; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_order_items_product ON public.order_items USING btree (product_id);


--
-- Name: idx_orders_customer_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_customer_created_at ON public.orders USING btree (customer_id, created_at DESC);


--
-- Name: idx_orders_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_number ON public.orders USING btree (order_number);


--
-- Name: idx_orders_paid_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_paid_only ON public.orders USING btree (order_id) WHERE ((payment_status)::text = 'paid'::text);


--
-- Name: idx_orders_status_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_orders_status_created_at ON public.orders USING btree (status, created_at DESC);


--
-- Name: idx_products_active_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_active_only ON public.products USING btree (product_id) WHERE (is_active = true);


--
-- Name: idx_products_category_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_category_price ON public.products USING btree (category_id, current_price);


--
-- Name: idx_products_discounted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_discounted ON public.products USING btree (product_id) WHERE (current_price < base_price);


--
-- Name: idx_products_low_stock; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_low_stock ON public.products USING btree (product_id) WHERE (stock_quantity < min_stock_level);


--
-- Name: idx_products_manufacturer_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_manufacturer_price ON public.products USING btree (manufacturer_id, current_price);


--
-- Name: idx_products_price; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_price ON public.products USING btree (current_price);


--
-- Name: idx_promo_codes_active_dates; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promo_codes_active_dates ON public.promo_codes USING btree (valid_from, valid_until) WHERE (is_active = true);


--
-- Name: idx_promo_codes_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_promo_codes_code ON public.promo_codes USING btree (code);


--
-- Name: idx_reviews_approved_only; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_approved_only ON public.reviews USING btree (review_id) WHERE ((status)::text = 'approved'::text);


--
-- Name: idx_reviews_customer; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_customer ON public.reviews USING btree (customer_id);


--
-- Name: idx_reviews_product_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_reviews_product_rating ON public.reviews USING btree (product_id, rating DESC);


--
-- Name: idx_status_history_order_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_status_history_order_date ON public.order_status_history USING btree (order_id, changed_at DESC);


--
-- Name: orders trg_log_order_status; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_order_status AFTER UPDATE OF status ON public.orders FOR EACH ROW EXECUTE FUNCTION public.log_order_status_change();


--
-- Name: order_items trg_update_order_totals; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_order_totals AFTER INSERT OR DELETE OR UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.update_order_totals();


--
-- Name: reviews trg_update_product_rating; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_product_rating AFTER INSERT OR DELETE OR UPDATE ON public.reviews FOR EACH ROW EXECUTE FUNCTION public.update_product_rating();


--
-- Name: order_items trg_update_product_stock; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_update_product_stock AFTER INSERT OR DELETE OR UPDATE ON public.order_items FOR EACH ROW EXECUTE FUNCTION public.update_product_stock();


--
-- Name: promo_codes update_promo_codes_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_promo_codes_updated_at BEFORE UPDATE ON public.promo_codes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: categories categories_parent_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_parent_category_id_fkey FOREIGN KEY (parent_category_id) REFERENCES public.categories(category_id) ON DELETE SET NULL;


--
-- Name: deliveries deliveries_courier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_courier_id_fkey FOREIGN KEY (courier_id) REFERENCES public.employees(employee_id);


--
-- Name: deliveries deliveries_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.deliveries
    ADD CONSTRAINT deliveries_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: order_status_history order_status_history_changed_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_changed_by_id_fkey FOREIGN KEY (changed_by_id) REFERENCES public.employees(employee_id) ON DELETE SET NULL;


--
-- Name: order_status_history order_status_history_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_status_history
    ADD CONSTRAINT order_status_history_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: orders orders_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(category_id);


--
-- Name: products products_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES public.manufacturers(manufacturer_id);


--
-- Name: reviews reviews_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id) ON DELETE CASCADE;


--
-- Name: reviews reviews_moderated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_moderated_by_fkey FOREIGN KEY (moderated_by) REFERENCES public.employees(employee_id);


--
-- Name: reviews reviews_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(order_id);


--
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(product_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 4fHo6pnQx8391L0w2z5aMtDKea3wrXK78VtiHLpELX9k7VzHA3xKjOqyw2tDudh

