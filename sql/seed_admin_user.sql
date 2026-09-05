-- Seed Admin User for Testing
-- Username: admin
-- Password: admin123
-- This is for development testing only

INSERT INTO admin_users (
    FirstName,
    LastName,
    Email,
    Username,
    PasswordHash,
    Role,
    IsActive
) VALUES (
    'Vladimir',
    'Admin',
    'admin@atticladderph.com',
    'admin',
    'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3',
    'SuperAdmin',
    1
);
