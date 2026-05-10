-- ============================================================
-- SUMIS - Smart Urban Mobility Intelligence System
-- File: 01_schema.sql  |  Database: PostgreSQL
-- ============================================================

-- Drop existing tables (for fresh setup)
DROP TABLE IF EXISTS Blacklist CASCADE;
DROP TABLE IF EXISTS Payment CASCADE;
DROP TABLE IF EXISTS Fine CASCADE;
DROP TABLE IF EXISTS Violation CASCADE;
DROP TABLE IF EXISTS ViolationType CASCADE;
DROP TABLE IF EXISTS Congestion_Log CASCADE;
DROP TABLE IF EXISTS AccidentVehicle CASCADE;
DROP TABLE IF EXISTS Accident CASCADE;
DROP TABLE IF EXISTS Camera CASCADE;
DROP TABLE IF EXISTS TrafficSignal CASCADE;
DROP TABLE IF EXISTS IntersectionRoad CASCADE;
DROP TABLE IF EXISTS Intersection CASCADE;
DROP TABLE IF EXISTS Road CASCADE;
DROP TABLE IF EXISTS Vehicle CASCADE;
DROP TABLE IF EXISTS VehicleType CASCADE;
DROP TABLE IF EXISTS Zone CASCADE;
DROP TABLE IF EXISTS Owner CASCADE;
DROP TABLE IF EXISTS UserAccount CASCADE;

-- ========================
-- 1. Owner
-- ========================
CREATE TABLE Owner (
    OwnerID     SERIAL PRIMARY KEY,
    Name        VARCHAR(100) NOT NULL,
    Address     TEXT         NOT NULL,
    ContactNo   VARCHAR(15)  NOT NULL UNIQUE,
    IsActive    BOOLEAN      DEFAULT TRUE
);

-- ========================
-- 2. VehicleType
-- ========================
CREATE TABLE VehicleType (
    VehicleTypeID   SERIAL PRIMARY KEY,
    TypeName        VARCHAR(50) NOT NULL UNIQUE
);

-- ========================
-- 3. Zone
-- ========================
CREATE TABLE Zone (
    ZoneID      SERIAL PRIMARY KEY,
    ZoneName    VARCHAR(100) NOT NULL UNIQUE
);

-- ========================
-- 4. Vehicle
-- ========================
CREATE TABLE Vehicle (
    VehicleID       SERIAL PRIMARY KEY,
    RegistrationNo  VARCHAR(20) NOT NULL UNIQUE,
    Model           VARCHAR(100) NOT NULL,
    Year            INT CHECK (Year >= 1980),
    OwnerID         INT REFERENCES Owner(OwnerID),
    VehicleTypeID   INT REFERENCES VehicleType(VehicleTypeID),
    ZoneID          INT REFERENCES Zone(ZoneID),
    IsActive        BOOLEAN DEFAULT TRUE
);

-- ========================
-- 5. Road
-- ========================
CREATE TABLE Road (
    RoadID      SERIAL PRIMARY KEY,
    RoadName    VARCHAR(100) NOT NULL,
    Length      NUMERIC(5,2) NOT NULL,
    ZoneID      INT REFERENCES Zone(ZoneID),
    IsActive    BOOLEAN DEFAULT TRUE
);

-- ========================
-- 6. Intersection
-- ========================
CREATE TABLE Intersection (
    IntersectionID      SERIAL PRIMARY KEY,
    IntersectionName    VARCHAR(100) NOT NULL,
    IsActive            BOOLEAN DEFAULT TRUE
);

-- ========================
-- 7. IntersectionRoad  (Junction table - M:N)
-- ========================
CREATE TABLE IntersectionRoad (
    IntersectionID  INT REFERENCES Intersection(IntersectionID),
    RoadID          INT REFERENCES Road(RoadID),
    PRIMARY KEY (IntersectionID, RoadID)
);

-- ========================
-- 8. TrafficSignal
-- ========================
CREATE TABLE TrafficSignal (
    SignalID                SERIAL PRIMARY KEY,
    IntersectionID          INT REFERENCES Intersection(IntersectionID),
    Status                  VARCHAR(20) CHECK (Status IN ('Active','Non_Active')),
    LastMaintenanceDate     DATE
);

-- ========================
-- 9. Camera
-- ========================
CREATE TABLE Camera (
    CameraID            SERIAL PRIMARY KEY,
    RoadID              INT REFERENCES Road(RoadID),
    IntersectionID      INT REFERENCES Intersection(IntersectionID),
    InstallationDate    DATE NOT NULL,
    Status              VARCHAR(20) NOT NULL,
    IsActive            BOOLEAN DEFAULT TRUE,
    CONSTRAINT chk_camera_location CHECK (
        (RoadID IS NOT NULL AND IntersectionID IS NULL) OR
        (RoadID IS NULL AND IntersectionID IS NOT NULL)
    )
);

-- ========================
-- 10. ViolationType
-- ========================
CREATE TABLE ViolationType (
    ViolationTypeID     SERIAL PRIMARY KEY,
    Description         VARCHAR(100) NOT NULL,
    BaseFineAmount      NUMERIC(8,2) NOT NULL
);

-- ========================
-- 11. Violation
-- ========================
CREATE TABLE Violation (
    ViolationID         SERIAL PRIMARY KEY,
    VehicleID           INT REFERENCES Vehicle(VehicleID),
    CameraID            INT REFERENCES Camera(CameraID),
    ViolationTypeID     INT REFERENCES ViolationType(ViolationTypeID),
    DateTime            TIMESTAMP NOT NULL DEFAULT NOW()
);

-- ========================
-- 12. Fine
-- ========================
CREATE TABLE Fine (
    FineID          SERIAL PRIMARY KEY,
    ViolationID     INT UNIQUE REFERENCES Violation(ViolationID),
    Amount          NUMERIC(8,2) NOT NULL,
    DueDate         DATE NOT NULL,
    Status          VARCHAR(20) CHECK (Status IN ('Paid','Unpaid')) DEFAULT 'Unpaid'
);

-- ========================
-- 13. Payment
-- ========================
CREATE TABLE Payment (
    PaymentID       SERIAL PRIMARY KEY,
    FineID          INT REFERENCES Fine(FineID),
    PaymentDate     DATE NOT NULL DEFAULT CURRENT_DATE,
    Mode            VARCHAR(20),
    AmountPaid      NUMERIC(8,2) NOT NULL
);

-- ========================
-- 14. Blacklist
-- ========================
CREATE TABLE Blacklist (
    BlacklistID     SERIAL PRIMARY KEY,
    VehicleID       INT REFERENCES Vehicle(VehicleID),
    StartDate       DATE NOT NULL DEFAULT CURRENT_DATE,
    Reason          TEXT NOT NULL
);

-- ========================
-- 15. Accident
-- ========================
CREATE TABLE Accident (
    AccidentID      SERIAL PRIMARY KEY,
    IntersectionID  INT REFERENCES Intersection(IntersectionID),
    RoadID          INT REFERENCES Road(RoadID),
    DateTime        TIMESTAMP NOT NULL DEFAULT NOW(),
    SeverityLevel   VARCHAR(20) CHECK (SeverityLevel IN ('Low','Medium','High')),
    CONSTRAINT chk_accident_location CHECK (
        RoadID IS NOT NULL OR IntersectionID IS NOT NULL
    )
);

-- ========================
-- 16. AccidentVehicle  (Junction table - links Accidents to Vehicles)
-- ========================
CREATE TABLE AccidentVehicle (
    AccidentID   INT REFERENCES Accident(AccidentID),
    VehicleID    INT REFERENCES Vehicle(VehicleID),
    DamageLevel  VARCHAR(20) CHECK (DamageLevel IN ('Minor','Moderate','Severe','Total')),
    PRIMARY KEY (AccidentID, VehicleID)
);

-- ========================
-- 17. Congestion_Log
-- ========================
CREATE TABLE Congestion_Log (
    LogID           SERIAL PRIMARY KEY,
    RoadID          INT REFERENCES Road(RoadID),
    Timestamp       TIMESTAMP NOT NULL DEFAULT NOW(),
    VehicleCount    INT NOT NULL,
    CongestionLevel VARCHAR(20) CHECK (CongestionLevel IN ('Low','Medium','High'))
);

-- ========================
-- 18. UserAccount
-- ========================
CREATE TABLE UserAccount (
    UserID      SERIAL PRIMARY KEY,
    Username    VARCHAR(50) UNIQUE NOT NULL,
    Password    VARCHAR(100) NOT NULL,
    Role        VARCHAR(20) CHECK (Role IN ('Admin','Officer','Finance','Analyst'))
);

SELECT 'Schema created successfully.' AS status;
