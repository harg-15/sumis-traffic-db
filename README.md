# SUMIS — Smart Urban Mobility Intelligence System
### Traffic Enforcement and Analytics Database Platform

---

## OVERVIEW

SUMIS is a centralized relational database platform that models the entire lifecycle of traffic-related data in a metropolitan environment. It covers traffic infrastructure, violation enforcement, fine collection, accident logging, congestion monitoring, and analytical reporting.

Built on **PostgreSQL** with a **Java (JDBC)** console application, the system demonstrates normalized relational schema design (BCNF), database automation via triggers and stored procedures, role-based access control, performance indexing, and advanced analytics (risk scoring, anomaly detection, congestion trends).

---

## PROJECT STRUCTURE

```
SUMIS/
├── 01_schema.sql                  ← Table definitions (DDL) — 18 tables
├── 02_triggers_procedures.sql     ← 3 triggers & 3 stored procedures
├── 03_views_indexes_analytics.sql ← 7 views + indexes
├── 04_seed_data.sql               ← Complete sample data
├── AdminMenu.java                 ← Admin operations
├── AnalystMenu.java               ← Analytics & reports
├── AuthManager.java               ← Login + role detection
├── DBConnection.java              ← DB connection singleton
├── FinanceMenu.java               ← Finance operations
├── Main.java                      ← Entry point
├── OfficerMenu.java               ← Officer operations
└── README.md                      ← This file
```

---

## STEP 1: PostgreSQL Setup

```sql
psql -U postgres
CREATE DATABASE sumis_db;
\c sumis_db
```

---

## STEP 2: Run SQL Scripts (in order!)

```sql
\i '/path/to/SUMIS/01_schema.sql'
\i '/path/to/SUMIS/02_triggers_procedures.sql'
\i '/path/to/SUMIS/03_views_indexes_analytics.sql'
\i '/path/to/SUMIS/04_seed_data.sql'
```

### Verify Setup
```sql
SELECT 'Owner'           AS tbl, COUNT(*) FROM Owner          UNION ALL
SELECT 'Vehicle',               COUNT(*) FROM Vehicle         UNION ALL
SELECT 'Violation',             COUNT(*) FROM Violation       UNION ALL
SELECT 'Fine',                  COUNT(*) FROM Fine            UNION ALL
SELECT 'Payment',               COUNT(*) FROM Payment         UNION ALL
SELECT 'Blacklist',             COUNT(*) FROM Blacklist       UNION ALL
SELECT 'Accident',              COUNT(*) FROM Accident        UNION ALL
SELECT 'AccidentVehicle',       COUNT(*) FROM AccidentVehicle UNION ALL
SELECT 'Congestion_Log',        COUNT(*) FROM Congestion_Log;
```

### Expected Record Counts
| Table           | Count |
|-----------------|-------|
| Owner           | 50    |
| Vehicle         | 50    |
| Road            | 15    |
| Intersection    | 15    |
| TrafficSignal   | 15    |
| Camera          | 15    |
| ViolationType   | 5     |
| Violation       | 50    |
| Fine            | 50    |
| Payment         | 23    |
| Blacklist       | 1+    |
| Accident        | 30    |
| AccidentVehicle | 13    |
| Congestion_Log  | 38    |
| UserAccount     | 4     |

---

## STEP 3: Configure Database Credentials

Set environment variables before running (recommended):

```bash
export SUMIS_DB_USER=postgres
export SUMIS_DB_PASSWORD=your_password
```

Or edit `DBConnection.java` directly and replace the fallback empty string with your password. The URL defaults to `localhost:5432/sumis_db`.

---

## STEP 4: Compile & Run

```cmd
cd /path/to/SUMIS
mkdir out
javac -cp ".:postgresql-42.7.9.jar" *.java -d out
java  -cp "out:postgresql-42.7.9.jar" sumis.Main
```

> On Windows, replace `:` with `;` in the classpath.

---

## STEP 5: Login Credentials

| Username  | Password    | Role    |
|-----------|-------------|---------|
| admin     | admin123    | Admin   |
| officer1  | officer123  | Officer |
| finance1  | finance123  | Finance |
| analyst1  | analyst123  | Analyst |

> **Note:** Passwords are stored as SHA-256 hashes in the database. The seed file stores hashed values. `AuthManager.java` hashes input on login automatically.

---

## DATABASE SCHEMA — 18 TABLES

### Infrastructure Layer

| Table            | Key Columns | Notes |
|------------------|-------------|-------|
| Zone             | ZoneID, ZoneName | 10 zones seeded |
| Road             | RoadID, RoadName, Length, ZoneID | IsActive — soft delete |
| Intersection     | IntersectionID, IntersectionName | IsActive — soft delete |
| IntersectionRoad | IntersectionID, RoadID | M:N junction, composite PK |
| TrafficSignal    | SignalID, IntersectionID, Status (Active/Non_Active), LastMaintenanceDate | |
| Camera           | CameraID, RoadID OR IntersectionID, InstallationDate, Status | CHECK: must belong to exactly one of road or intersection; IsActive |

### Actor Layer

| Table       | Key Columns | Notes |
|-------------|-------------|-------|
| Owner       | OwnerID, Name, Address, ContactNo | IsActive — soft delete |
| VehicleType | VehicleTypeID, TypeName | Private / Commercial / Emergency |
| Vehicle     | VehicleID, RegistrationNo, Model, Year, OwnerID, VehicleTypeID, ZoneID | IsActive — soft delete |

### Event Layer

| Table           | Key Columns | Notes |
|-----------------|-------------|-------|
| ViolationType   | ViolationTypeID, Description, BaseFineAmount | 5 types seeded |
| Violation       | ViolationID, VehicleID, CameraID, ViolationTypeID, DateTime | INSERT fires trg_auto_create_fine + trg_auto_blacklist |
| Accident        | AccidentID, IntersectionID, RoadID, DateTime, SeverityLevel (Low/Medium/High) | CHECK: RoadID or IntersectionID must be non-null; 30 accidents seeded |
| AccidentVehicle | AccidentID, VehicleID, DamageLevel (Minor/Moderate/Severe/Total) | M:N junction — composite PK; 13 mappings seeded |
| Congestion_Log  | LogID, RoadID, Timestamp, VehicleCount, CongestionLevel (Low/Medium/High) | 38 logs seeded |

### Enforcement Layer

| Table     | Key Columns | Notes |
|-----------|-------------|-------|
| Fine      | FineID, ViolationID (UNIQUE FK), Amount, DueDate, Status (Paid/Unpaid) | 1:1 with Violation — auto-created by trigger |
| Payment   | PaymentID, FineID, PaymentDate, Mode, AmountPaid | INSERT fires trg_update_fine_on_payment |
| Blacklist | BlacklistID, VehicleID, StartDate, Reason | Auto-inserted when vehicle violations >= 5 |

### Governance Layer

| Table       | Key Columns | Notes |
|-------------|-------------|-------|
| UserAccount | UserID, Username, Password, Role (Admin/Officer/Finance/Analyst) | 4 accounts seeded |

---

## FEATURES BY ROLE

### Admin
| Option | Description |
|--------|-------------|
| 1 | Add Zone |
| 2 | Add Road |
| 3 | Add Intersection |
| 4 | Soft-Delete Vehicle (sets IsActive = FALSE) |
| 5 | View All Users |
| 6 | Add User Account |
| 7 | Rename Username |
| 8 | Delete User Account |
| 9 | Run All Analytics (delegates to AnalystMenu) |
| 10 | Run Custom SQL (SELECT, INSERT, UPDATE, DELETE) |

### Officer
| Option | Description |
|--------|-------------|
| 1 | Insert New Violation — Fine auto-created by trigger |
| 2 | View Vehicle History by Registration No |
| 3 | Check Blacklist |
| 4 | View All Active Violations (last 20) |

### Finance
| Option | Description |
|--------|-------------|
| 1 | View Unpaid Fines with days overdue |
| 2 | Record Payment — Fine auto-marked Paid by trigger |
| 3 | Monthly Revenue Report (enter year + month) |
| 4 | Escalate Overdue Fines (+10% via stored procedure) |

### Analyst
| Option | Description |
|--------|-------------|
| 1 | Zone-wise Violation Report |
| 2 | Accident Hotspots (High/Medium/Low breakdown) |
| 3 | Vehicle Risk Scores |
| 4 | Congestion Trends (last 7 days) |
| 5 | Anomaly Detection (vehicles with 2x above-average violations) |

---

## TRIGGERS

| Trigger | Fires When | Action |
|---------|-----------|--------|
| trg_auto_create_fine | After INSERT on Violation | Creates Fine — amount from ViolationType.BaseFineAmount, DueDate = today + 30 days, Status = 'Unpaid' |
| trg_update_fine_on_payment | After INSERT on Payment | Sets Fine.Status = 'Paid' for the corresponding FineID |
| trg_auto_blacklist | After INSERT on Violation | If vehicle total violations >= 5 and not already blacklisted, inserts into Blacklist |

---

## STORED PROCEDURES

| Procedure | Parameters | Action |
|-----------|------------|--------|
| sp_escalate_overdue_fines() | none | Multiplies Amount × 1.10 for all Unpaid fines where DueDate < today |
| sp_monthly_revenue(year, month) | INT, INT | Reports total payment count and revenue for the given month |
| sp_vehicle_risk_profile(vehicle_id) | INT | Reports violations, unpaid fines, and risk score for a vehicle |

```sql
CALL sp_escalate_overdue_fines();
CALL sp_monthly_revenue(2026, 1);
CALL sp_vehicle_risk_profile(1);
```

---

## VIEWS

| View | Description |
|------|-------------|
| vw_active_violations | Violations with owner, vehicle, type, fine status — filters IsActive = TRUE |
| vw_unpaid_fines | Unpaid fines with owner info, amount, due date, days overdue |
| vw_zone_violations | Total violations and total fines per zone |
| vw_accident_hotspots | Accident count per intersection broken into High/Medium/Low severity |
| vw_vehicle_risk_scores | RiskScore per active vehicle, ordered descending |
| vw_congestion_trend | Avg and peak vehicle count per road over last 7 days |
| vw_anomaly_vehicles | Vehicles whose violation count > 2x the system average |

```sql
SELECT * FROM vw_active_violations;
SELECT * FROM vw_unpaid_fines;
SELECT * FROM vw_zone_violations;
SELECT * FROM vw_accident_hotspots;
SELECT * FROM vw_vehicle_risk_scores;
SELECT * FROM vw_congestion_trend;
SELECT * FROM vw_anomaly_vehicles;
```

---

## RISK SCORE FORMULA

**View layer** (`vw_vehicle_risk_scores`):
```
RiskScore = (2 × Total Violations) + (1 × Unpaid Fines)
```
Note: Accidents are tracked via `AccidentVehicle` but not joined in the view for performance. Use the stored procedure for the full score.

**Stored procedure** (`sp_vehicle_risk_profile`) — full formula:
```
RiskScore = (2 × Violations) + (3 × Accidents) + (1 × Unpaid Fines)
```
Accidents are counted from `AccidentVehicle` where `VehicleID` matches.

---

## SOFT DELETE STRATEGY

Tables with `IsActive BOOLEAN DEFAULT TRUE`: **Owner, Vehicle, Road, Intersection, Camera**

```sql
-- Never:
DELETE FROM Vehicle WHERE VehicleID = 1;

-- Always:
UPDATE Vehicle SET IsActive = FALSE WHERE VehicleID = 1;
```

All views and active queries filter `IsActive = TRUE`. Deactivated records are excluded from operations but remain in the database, preserving referential integrity and enforcement history.

---

## ROLE-BASED ACCESS CONTROL

`AuthManager.java` validates credentials against `UserAccount` and returns the Role. `Main.java` routes to the matching menu — all other menus are unreachable.

| Role    | Access |
|---------|--------|
| Admin   | Infrastructure management, user management, all analytics |
| Officer | Insert violations, view vehicle history, check blacklist |
| Finance | Record payments, view fines, revenue reports, escalate fines |
| Analyst | Read-only access to all 7 analytics views — no transactional writes |

---

## PERFORMANCE INDEXES

```sql
-- Violation lookups
idx_violation_vehicle, idx_violation_camera, idx_violation_type, idx_violation_datetime

-- Fine & payment queries
idx_fine_status, idx_fine_duedate, idx_payment_date

-- Congestion analysis
idx_congestion_road, idx_congestion_time

-- Vehicle & accident
idx_vehicle_owner, idx_vehicle_zone, idx_accident_time
```

```sql
EXPLAIN ANALYZE SELECT * FROM Violation WHERE VehicleID = 1;
EXPLAIN ANALYZE SELECT * FROM Fine WHERE Status = 'Unpaid' AND DueDate < CURRENT_DATE;
```

---

## QUICK TEST QUERIES

```sql
-- Verify triggers: insert a violation and check fine was auto-created
SELECT * FROM Fine ORDER BY FineID DESC LIMIT 1;

-- Check blacklisted vehicles
SELECT * FROM Blacklist;

-- Run all analytics views
SELECT * FROM vw_active_violations;
SELECT * FROM vw_unpaid_fines;
SELECT * FROM vw_zone_violations;
SELECT * FROM vw_accident_hotspots;
SELECT * FROM vw_vehicle_risk_scores;
SELECT * FROM vw_congestion_trend;
SELECT * FROM vw_anomaly_vehicles;

-- Verify index usage
EXPLAIN ANALYZE SELECT * FROM Violation WHERE VehicleID = 1;
EXPLAIN ANALYZE SELECT * FROM Fine WHERE Status = 'Unpaid' AND DueDate < CURRENT_DATE;
```

---

## TECHNOLOGY STACK

| Layer       | Technology |
|-------------|------------|
| Database    | PostgreSQL |
| Application | Java with JDBC — console-based menu system |
| Driver      | postgresql-42.7.9.jar |
| Package     | `sumis` (all .java files) |

---

## TEAM

- Harshit Goyal
- Darsh Valand

---

*SUMIS — Traffic Enforcement and Analytics Database Platform*
