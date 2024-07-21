CREATE SCHEMA eventopia;

-- Enum Creation
CREATE TYPE eventopia.ticket_status AS ENUM ('BOOKED', 'CANCELLED');
CREATE TYPE eventopia.booking_status AS ENUM ('PENDING', 'CONFIRMED', 'CANCELLED');
CREATE TYPE eventopia.transaction_status AS ENUM ('SUCCESS', 'FAILURE');

-- Roles Table
CREATE TABLE eventopia.roles (
    role_id VARCHAR(32) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Users Table
CREATE TABLE eventopia.users (
    user_id VARCHAR(32) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id VARCHAR(32) NOT NULL REFERENCES eventopia.roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- UserProfiles Table
CREATE TABLE eventopia.user_profiles (
    profile_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL REFERENCES eventopia.users(user_id),
    city VARCHAR(128),
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE eventopia.categories (
    category_id VARCHAR(32) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Events Table
CREATE TABLE eventopia.events (
    event_id VARCHAR(32) PRIMARY KEY,
    organizer_id VARCHAR(32) NOT NULL REFERENCES eventopia.users(user_id),
    category_id VARCHAR(32) REFERENCES eventopia.categories(category_id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    location VARCHAR(255) NOT NULL,
    starting_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- EventImages Table
CREATE TABLE eventopia.event_images (
    image_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES eventopia.events(event_id),
    image_url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sections Table
CREATE TABLE eventopia.sections (
    section_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES eventopia.events(event_id),
    section_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seats Table
CREATE TABLE eventopia.seats (
    seat_id VARCHAR(32) PRIMARY KEY,
    section_id VARCHAR(32) NOT NULL REFERENCES eventopia.sections(section_id),
    seat_number VARCHAR(10) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bookings Table
CREATE TABLE eventopia.bookings (
    booking_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) REFERENCES eventopia.users(user_id),
    total_amount DECIMAL(10, 2) NOT NULL,
    booking_status eventopia.booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tickets Table
CREATE TABLE eventopia.tickets (
    ticket_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES eventopia.events(event_id),
    attendee_id VARCHAR(32) NOT NULL REFERENCES eventopia.users(user_id),
    seat_id VARCHAR(32) NOT NULL REFERENCES eventopia.seats(seat_id),
    booking_id VARCHAR(32) NOT NULL REFERENCES eventopia.bookings(booking_id),
    ticket_status eventopia.ticket_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments Table
CREATE TABLE eventopia.payments (
    payment_id VARCHAR(32) PRIMARY KEY,
    ticket_id VARCHAR(32) NOT NULL REFERENCES eventopia.tickets(ticket_id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_status eventopia.transaction_status NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Table
CREATE TABLE eventopia.reviews (
    review_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES eventopia.events(event_id),
    user_id VARCHAR(32) NOT NULL REFERENCES eventopia.users(user_id),
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
