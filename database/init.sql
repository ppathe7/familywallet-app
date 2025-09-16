-- FamilyWallet Database Initialization Script

-- Create databases
CREATE DATABASE familywallet;
CREATE DATABASE familywallet_dev;

-- Create users
CREATE USER familywallet WITH PASSWORD 'familywallet';
CREATE USER familywallet_dev WITH PASSWORD 'familywallet_dev';

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE familywallet TO familywallet;
GRANT ALL PRIVILEGES ON DATABASE familywallet_dev TO familywallet_dev;

-- Connect to main database
\c familywallet;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create families table
CREATE TABLE families (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    family_id UUID REFERENCES families(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create categories table
CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    color VARCHAR(7),
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create expenses table
CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    category_id UUID REFERENCES categories(id),
    description TEXT,
    store_name VARCHAR(255),
    receipt_image_url VARCHAR(500),
    location_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create portfolio_assets table
CREATE TABLE portfolio_assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    symbol VARCHAR(20) NOT NULL,
    asset_type VARCHAR(50) NOT NULL,
    quantity DECIMAL(15,8) NOT NULL,
    purchase_price DECIMAL(15,8) NOT NULL,
    purchase_date DATE NOT NULL,
    current_price DECIMAL(15,8) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create goals table
CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    family_id UUID REFERENCES families(id),
    goal_name VARCHAR(255) NOT NULL,
    target_amount DECIMAL(15,2) NOT NULL,
    current_amount DECIMAL(15,2) DEFAULT 0,
    deadline DATE,
    monthly_contribution DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create budgets table
CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    family_id UUID REFERENCES families(id),
    category_id UUID REFERENCES categories(id),
    monthly_amount DECIMAL(10,2) NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, category_id, year, month)
);

-- Create indexes
CREATE INDEX idx_expenses_user_id ON expenses(user_id);
CREATE INDEX idx_expenses_created_at ON expenses(created_at);
CREATE INDEX idx_expenses_category_id ON expenses(category_id);
CREATE INDEX idx_portfolio_assets_user_id ON portfolio_assets(user_id);
CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_goals_family_id ON goals(family_id);
CREATE INDEX idx_budgets_user_id ON budgets(user_id);
CREATE INDEX idx_budgets_family_id ON budgets(family_id);

-- Insert default categories
INSERT INTO categories (name, color, icon) VALUES
('食費', '#FF6B6B', 'restaurant'),
('交通費', '#4ECDC4', 'directions-car'),
('娯楽', '#45B7D1', 'movie'),
('医療費', '#96CEB4', 'local-hospital'),
('光熱費', '#FFEAA7', 'flash-on'),
('通信費', '#DDA0DD', 'phone'),
('衣類', '#98D8C8', 'checkroom'),
('その他', '#F7DC6F', 'more-horiz');

-- Connect to dev database and create same structure
\c familywallet_dev;

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Copy structure from main database (simplified for dev)
CREATE TABLE families (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    family_id UUID REFERENCES families(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    color VARCHAR(7),
    icon VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE expenses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    category_id UUID REFERENCES categories(id),
    description TEXT,
    store_name VARCHAR(255),
    receipt_image_url VARCHAR(500),
    location_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE portfolio_assets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    symbol VARCHAR(20) NOT NULL,
    asset_type VARCHAR(50) NOT NULL,
    quantity DECIMAL(15,8) NOT NULL,
    purchase_price DECIMAL(15,8) NOT NULL,
    purchase_date DATE NOT NULL,
    current_price DECIMAL(15,8) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE goals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    family_id UUID REFERENCES families(id),
    goal_name VARCHAR(255) NOT NULL,
    target_amount DECIMAL(15,2) NOT NULL,
    current_amount DECIMAL(15,2) DEFAULT 0,
    deadline DATE,
    monthly_contribution DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE budgets (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    family_id UUID REFERENCES families(id),
    category_id UUID REFERENCES categories(id),
    monthly_amount DECIMAL(10,2) NOT NULL,
    year INTEGER NOT NULL,
    month INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, category_id, year, month)
);

-- Insert default categories for dev
INSERT INTO categories (name, color, icon) VALUES
('食費', '#FF6B6B', 'restaurant'),
('交通費', '#4ECDC4', 'directions-car'),
('娯楽', '#45B7D1', 'movie'),
('医療費', '#96CEB4', 'local-hospital'),
('光熱費', '#FFEAA7', 'flash-on'),
('通信費', '#DDA0DD', 'phone'),
('衣類', '#98D8C8', 'checkroom'),
('その他', '#F7DC6F', 'more-horiz');
