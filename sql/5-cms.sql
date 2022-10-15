-- blogs
CREATE TABLE blogs (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    link TEXT NOT NULL UNIQUE,
    img_url TEXT,
    description TEXT,
    content TEXT,
    category TEXT,
    additional_details JSON DEFAULT '{}',
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
