/* Create the Users Table */
CREATE DATABASE IF NOT EXISTS `badgerst_DiscordAPI`;
USE `badgerst_DiscordAPI`;

CREATE TABLE IF NOT EXISTS `Users` (
    `UID` INTEGER(63) AUTO_INCREMENT PRIMARY KEY,
    `lastPlayerName` VARCHAR(127) COLLATE utf8mb4_bin NOT NULL,
    `steam` VARCHAR(63) COLLATE utf8mb4_bin NOT NULL,
    `gameLicense` VARCHAR(63) COLLATE utf8mb4_bin NOT NULL,
    `discord` VARCHAR(63) COLLATE utf8mb4_bin NOT NULL
);

CREATE TABLE IF NOT EXISTS `AccessKeys` (
    `AID` INTEGER(63) AUTO_INCREMENT PRIMARY KEY,
    `key` VARCHAR(254) COLLATE utf8mb4_bin NOT NULL,
    `lastPlayerName` VARCHAR(127) COLLATE utf8mb4_bin NOT NULL,
    `steam` VARCHAR(63) COLLATE utf8mb4_bin NOT NULL,
    `gameLicense` VARCHAR(63) COLLATE utf8mb4_bin NOT NULL,
    `timeExpires` INTEGER(127) NOT NULL,
    `expired` BIT(1) NOT NULL
);