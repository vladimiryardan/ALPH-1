CREATE TABLE admin_users (

    UserID              INT UNSIGNED NOT NULL AUTO_INCREMENT,

    FirstName           VARCHAR(100) NOT NULL,
    LastName            VARCHAR(100) NOT NULL,

    Email               VARCHAR(255) NOT NULL,
    Username            VARCHAR(100) NOT NULL,

    PasswordHash        VARCHAR(255) NOT NULL,

    Role                ENUM(
                            'SuperAdmin',
                            'Administrator',
                            'Editor'
                        ) DEFAULT 'Administrator',

    IsActive            TINYINT(1) NOT NULL DEFAULT 1,

    LastLogin           DATETIME NULL,
    LastLoginIP         VARCHAR(45) NULL,

    FailedLoginCount    INT NOT NULL DEFAULT 0,
    LockoutUntil        DATETIME NULL,

    PasswordChanged     DATETIME NULL,

    CreatedOn           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedOn           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                        ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (UserID),

    UNIQUE KEY uq_username (Username),
    UNIQUE KEY uq_email (Email)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;