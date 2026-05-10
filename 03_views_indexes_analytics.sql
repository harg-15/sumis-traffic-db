-- ============================================================
-- SUMIS - Views, Indexes & Analytics Queries
-- File: 03_views_indexes_analytics.sql
-- ============================================================

-- ============================================================
-- INDEXES for Performance Optimization
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_violation_vehicle   ON Violation(VehicleID);
CREATE INDEX IF NOT EXISTS idx_violation_camera    ON Violation(CameraID);
CREATE INDEX IF NOT EXISTS idx_violation_type      ON Violation(ViolationTypeID);
CREATE INDEX IF NOT EXISTS idx_violation_datetime  ON Violation(DateTime);

CREATE INDEX IF NOT EXISTS idx_fine_status         ON Fine(Status);
CREATE INDEX IF NOT EXISTS idx_fine_duedate        ON Fine(DueDate);

CREATE INDEX IF NOT EXISTS idx_payment_date        ON Payment(PaymentDate);
CREATE INDEX IF NOT EXISTS idx_congestion_road     ON Congestion_Log(RoadID);
CREATE INDEX IF NOT EXISTS idx_congestion_time     ON Congestion_Log(Timestamp);

CREATE INDEX IF NOT EXISTS idx_vehicle_owner       ON Vehicle(OwnerID);
CREATE INDEX IF NOT EXISTS idx_vehicle_zone        ON Vehicle(ZoneID);
CREATE INDEX IF NOT EXISTS idx_accident_time       ON Accident(DateTime);


-- ============================================================
-- VIEW 1: Active Violations with Owner Info
-- ============================================================
CREATE OR REPLACE VIEW vw_active_violations AS
SELECT
    v.ViolationID,
    v.DateTime,
    veh.RegistrationNo,
    o.Name          AS OwnerName,
    o.ContactNo,
    vt.Description  AS ViolationType,
    vt.BaseFineAmount,
    f.Status        AS FineStatus,
    f.DueDate
FROM Violation v
JOIN Vehicle veh       ON v.VehicleID = veh.VehicleID
JOIN Owner o           ON veh.OwnerID = o.OwnerID
JOIN ViolationType vt  ON v.ViolationTypeID = vt.ViolationTypeID
LEFT JOIN Fine f       ON v.ViolationID = f.ViolationID
WHERE veh.IsActive = TRUE AND o.IsActive = TRUE;


-- ============================================================
-- VIEW 2: Unpaid Fines Summary
-- ============================================================
CREATE OR REPLACE VIEW vw_unpaid_fines AS
SELECT
    f.FineID,
    veh.RegistrationNo,
    o.Name          AS OwnerName,
    o.ContactNo,
    vt.Description  AS ViolationType,
    f.Amount,
    f.DueDate,
    CURRENT_DATE - f.DueDate AS DaysOverdue
FROM Fine f
JOIN Violation v       ON f.ViolationID = v.ViolationID
JOIN Vehicle veh       ON v.VehicleID = veh.VehicleID
JOIN Owner o           ON veh.OwnerID = o.OwnerID
JOIN ViolationType vt  ON v.ViolationTypeID = vt.ViolationTypeID
WHERE f.Status = 'Unpaid'
ORDER BY f.DueDate ASC;


-- ============================================================
-- VIEW 3: Zone-wise Violation Count
-- ============================================================
CREATE OR REPLACE VIEW vw_zone_violations AS
SELECT
    z.ZoneName,
    COUNT(v.ViolationID) AS TotalViolations,
    SUM(f.Amount)        AS TotalFinesGenerated
FROM Zone z
LEFT JOIN Vehicle veh  ON veh.ZoneID = z.ZoneID
LEFT JOIN Violation v  ON v.VehicleID = veh.VehicleID
LEFT JOIN Fine f       ON f.ViolationID = v.ViolationID
GROUP BY z.ZoneName
ORDER BY TotalViolations DESC;


-- ============================================================
-- VIEW 4: Accident Hotspots
-- ============================================================
CREATE OR REPLACE VIEW vw_accident_hotspots AS
SELECT
    i.IntersectionName,
    COUNT(a.AccidentID)                             AS TotalAccidents,
    COUNT(CASE WHEN a.SeverityLevel='High' THEN 1 END)   AS HighSeverity,
    COUNT(CASE WHEN a.SeverityLevel='Medium' THEN 1 END) AS MediumSeverity,
    COUNT(CASE WHEN a.SeverityLevel='Low' THEN 1 END)    AS LowSeverity
FROM Intersection i
LEFT JOIN Accident a ON a.IntersectionID = i.IntersectionID
GROUP BY i.IntersectionName
ORDER BY TotalAccidents DESC;


-- ============================================================
-- VIEW 5: Vehicle Risk Scores
-- ============================================================
CREATE OR REPLACE VIEW vw_vehicle_risk_scores AS
SELECT
    veh.RegistrationNo,
    o.Name AS OwnerName,
    COUNT(DISTINCT v.ViolationID)                       AS TotalViolations,
    COUNT(DISTINCT CASE WHEN f.Status='Unpaid' THEN f.FineID END) AS UnpaidFines,
    -- RiskScore = 2*Violations + 1*UnpaidFines (fast version; full formula with accidents in sp_vehicle_risk_profile)
    (2 * COUNT(DISTINCT v.ViolationID)) +
    (1 * COUNT(DISTINCT CASE WHEN f.Status='Unpaid' THEN f.FineID END)) AS RiskScore
FROM Vehicle veh
JOIN Owner o ON veh.OwnerID = o.OwnerID
LEFT JOIN Violation v ON v.VehicleID = veh.VehicleID
LEFT JOIN Fine f ON f.ViolationID = v.ViolationID
WHERE veh.IsActive = TRUE
GROUP BY veh.RegistrationNo, o.Name
ORDER BY RiskScore DESC;


-- ============================================================
-- VIEW 6: Congestion Trend (last 7 days)
-- ============================================================
CREATE OR REPLACE VIEW vw_congestion_trend AS
SELECT
    r.RoadName,
    DATE(cl.Timestamp)              AS LogDate,
    AVG(cl.VehicleCount)::INT       AS AvgVehicleCount,
    MAX(cl.VehicleCount)            AS PeakVehicleCount,
    MODE() WITHIN GROUP (ORDER BY cl.CongestionLevel) AS TypicalCongestion
FROM Congestion_Log cl
JOIN Road r ON cl.RoadID = r.RoadID
WHERE cl.Timestamp >= NOW() - INTERVAL '7 days'
GROUP BY r.RoadName, DATE(cl.Timestamp)
ORDER BY r.RoadName, LogDate;


-- ============================================================
-- ANALYTICS QUERY: Anomaly Detection
-- Vehicles whose violation rate is > 2x the overall average
-- ============================================================
CREATE OR REPLACE VIEW vw_anomaly_vehicles AS
WITH vehicle_counts AS (
    SELECT
        veh.VehicleID,
        veh.RegistrationNo,
        o.Name AS OwnerName,
        COUNT(v.ViolationID) AS ViolationCount
    FROM Vehicle veh
    JOIN Owner o ON veh.OwnerID = o.OwnerID
    LEFT JOIN Violation v ON v.VehicleID = veh.VehicleID
    WHERE veh.IsActive = TRUE
    GROUP BY veh.VehicleID, veh.RegistrationNo, o.Name
),
overall_avg AS (
    SELECT AVG(ViolationCount) AS AvgViolations FROM vehicle_counts
)
SELECT
    vc.RegistrationNo,
    vc.OwnerName,
    vc.ViolationCount,
    ROUND(oa.AvgViolations, 2) AS SystemAverage,
    ROUND(vc.ViolationCount / NULLIF(oa.AvgViolations, 0), 2) AS RatioToAvg
FROM vehicle_counts vc, overall_avg oa
WHERE vc.ViolationCount > 2 * oa.AvgViolations
ORDER BY RatioToAvg DESC;


SELECT 'Views, indexes, and analytics created successfully.' AS status;
