CREATE SCHEMA event_booking;

-- Roles Table
CREATE TABLE event_booking.roles (
    role_id VARCHAR(32) PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- Users Table
CREATE TABLE event_booking.users (
    user_id VARCHAR(32) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id VARCHAR(32) NOT NULL REFERENCES event_booking.roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- UserProfiles Table
CREATE TABLE event_booking.user_profiles (
    profile_id VARCHAR(32) PRIMARY KEY,
    user_id VARCHAR(32) NOT NULL REFERENCES event_booking.users(user_id),
    address TEXT,
    phone_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories Table
CREATE TABLE event_booking.categories (
    category_id VARCHAR(32) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Events Table
CREATE TABLE event_booking.events (
    event_id VARCHAR(32) PRIMARY KEY,
    organizer_id VARCHAR(32) NOT NULL REFERENCES event_booking.users(user_id),
    category_id VARCHAR(32) REFERENCES event_booking.categories(category_id),
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
CREATE TABLE event_booking.event_images (
    image_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES event_booking.events(event_id),
    image_url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sections Table
CREATE TABLE event_booking.sections (
    section_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES event_booking.events(event_id),
    section_name VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seats Table
CREATE TABLE event_booking.seats (
    seat_id VARCHAR(32) PRIMARY KEY,
    section_id VARCHAR(32) NOT NULL REFERENCES event_booking.sections(section_id),
    seat_number VARCHAR(10) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tickets Table
CREATE TABLE event_booking.tickets (
    ticket_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES event_booking.events(event_id),
    attendee_id VARCHAR(32) NOT NULL REFERENCES event_booking.users(user_id),
    seat_id VARCHAR(32) NOT NULL REFERENCES event_booking.seats(seat_id),
    quantity INT NOT NULL CHECK (quantity > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('booked', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Payments Table
CREATE TABLE event_booking.payments (
    payment_id VARCHAR(32) PRIMARY KEY,
    ticket_id VARCHAR(32) NOT NULL REFERENCES event_booking.tickets(ticket_id),
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(20) NOT NULL CHECK (payment_status IN ('success', 'failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions Table
CREATE TABLE event_booking.transactions (
    transaction_id VARCHAR(32) PRIMARY KEY,
    payment_id VARCHAR(32) NOT NULL REFERENCES event_booking.payments(payment_id),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reviews Table
CREATE TABLE event_booking.reviews (
    review_id VARCHAR(32) PRIMARY KEY,
    event_id VARCHAR(32) NOT NULL REFERENCES event_booking.events(event_id),
    user_id VARCHAR(32) NOT NULL REFERENCES event_booking.users(user_id),
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
