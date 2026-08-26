-- SQL Migration / DDL for email_log table
-- Engine: MySQL / MariaDB (InnoDB, utf8mb4)

CREATE TABLE IF NOT EXISTS email_log (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sender          VARCHAR(255) NOT NULL,
    recipient       VARCHAR(255) NOT NULL,
    subject         VARCHAR(500) NOT NULL,
    status          ENUM('pending', 'sent', 'failed', 'bounced') NOT NULL DEFAULT 'pending',
    sent_at         DATETIME NULL,
    
    -- Additional best-practice columns for auditing & debugging
    body            TEXT NULL,
    error_message   TEXT NULL,
    message_id      VARCHAR(255) NULL,
    ip_address      VARCHAR(45) NULL,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (id),

    -- Indexes for common query patterns and maintenance
    INDEX idx_recipient (recipient),
    INDEX idx_status (status),
    INDEX idx_sent_at (sent_at),
    INDEX idx_created_at (created_at),
    INDEX idx_status_created (status, created_at)

) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;
