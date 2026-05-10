-- ============================================================
-- SUMIS - Triggers & Stored Procedures
-- File: 02_triggers_procedures.sql
-- ============================================================

-- ============================================================
-- TRIGGER 1: Auto-generate Fine when Violation is inserted
-- ============================================================
CREATE OR REPLACE FUNCTION fn_auto_create_fine()
RETURNS TRIGGER AS $$
DECLARE
    v_base_amount NUMERIC(8,2);
BEGIN
    -- Get base fine amount from ViolationType
    SELECT BaseFineAmount INTO v_base_amount
    FROM ViolationType
    WHERE ViolationTypeID = NEW.ViolationTypeID;

    -- Insert corresponding Fine record
    INSERT INTO Fine (ViolationID, Amount, DueDate, Status)
    VALUES (
        NEW.ViolationID,
        v_base_amount,
        CURRENT_DATE + INTERVAL '30 days',
        'Unpaid'
    );

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_create_fine ON Violation;
CREATE TRIGGER trg_auto_create_fine
    AFTER INSERT ON Violation
    FOR EACH ROW
    EXECUTE FUNCTION fn_auto_create_fine();

-- ============================================================
-- TRIGGER 2: Mark Fine as Paid when Payment is inserted
-- ============================================================
CREATE OR REPLACE FUNCTION fn_update_fine_on_payment()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Fine
    SET Status = 'Paid'
    WHERE FineID = NEW.FineID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_update_fine_on_payment ON Payment;
CREATE TRIGGER trg_update_fine_on_payment
    AFTER INSERT ON Payment
    FOR EACH ROW
    EXECUTE FUNCTION fn_update_fine_on_payment();

-- ============================================================
-- TRIGGER 3: Auto-blacklist vehicle if violations >= 5
-- ============================================================
CREATE OR REPLACE FUNCTION fn_auto_blacklist()
RETURNS TRIGGER AS $$
DECLARE
    v_count INT;
    already_blacklisted INT;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM Violation
    WHERE VehicleID = NEW.VehicleID;

    IF v_count >= 5 THEN
        SELECT COUNT(*) INTO already_blacklisted
        FROM Blacklist
        WHERE VehicleID = NEW.VehicleID;

        IF already_blacklisted = 0 THEN
            INSERT INTO Blacklist (VehicleID, StartDate, Reason)
            VALUES (
                NEW.VehicleID,
                CURRENT_DATE,
                'Auto-blacklisted: exceeded 5 violations'
            );
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auto_blacklist ON Violation;
CREATE TRIGGER trg_auto_blacklist
    AFTER INSERT ON Violation
    FOR EACH ROW
    EXECUTE FUNCTION fn_auto_blacklist();

-- ============================================================
-- STORED PROCEDURE 1: Escalate Overdue Fines (10% penalty)
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_escalate_overdue_fines()
LANGUAGE plpgsql AS $$
DECLARE
    rows_updated INT;
BEGIN
    UPDATE Fine
    SET Amount = ROUND(Amount * 1.10, 2)
    WHERE Status = 'Unpaid'
      AND DueDate < CURRENT_DATE;

    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    RAISE NOTICE 'Escalated % overdue fine(s) by 10%%.', rows_updated;
END;
$$;

-- ============================================================
-- STORED PROCEDURE 2: Monthly Revenue Report
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_monthly_revenue(IN p_year INT, IN p_month INT)
LANGUAGE plpgsql AS $$
DECLARE
    r RECORD;
BEGIN
    RAISE NOTICE '--- Monthly Revenue Report: %/% ---', p_month, p_year;

    FOR r IN
        SELECT
            TO_CHAR(p.PaymentDate, 'YYYY-MM') AS Month,
            COUNT(p.PaymentID)                 AS TotalPayments,
            SUM(p.AmountPaid)                  AS TotalRevenue
        FROM Payment p
        WHERE EXTRACT(YEAR FROM p.PaymentDate) = p_year
          AND EXTRACT(MONTH FROM p.PaymentDate) = p_month
        GROUP BY TO_CHAR(p.PaymentDate, 'YYYY-MM')
    LOOP
        RAISE NOTICE 'Month: % | Payments: % | Revenue: %',
            r.Month, r.TotalPayments, r.TotalRevenue;
    END LOOP;
END;
$$;

-- ============================================================
-- STORED PROCEDURE 3: Get Vehicle Risk Profile
-- ============================================================
CREATE OR REPLACE PROCEDURE sp_vehicle_risk_profile(IN p_vehicle_id INT)
LANGUAGE plpgsql AS $$
DECLARE
    v_violations    INT;
    v_accidents     INT;
    v_unpaid        INT;
    v_risk_score    INT;
BEGIN
    SELECT COUNT(*) INTO v_violations
    FROM Violation WHERE VehicleID = p_vehicle_id;

    SELECT COUNT(*) INTO v_accidents
    FROM AccidentVehicle WHERE VehicleID = p_vehicle_id;

    SELECT COUNT(*) INTO v_unpaid
    FROM Fine f JOIN Violation v ON f.ViolationID = v.ViolationID
    WHERE v.VehicleID = p_vehicle_id AND f.Status = 'Unpaid';

    -- RiskScore = 2*Violations + 3*Accidents + 1*Unpaid Fines
    v_risk_score := (2 * v_violations) + (3 * v_accidents) + (1 * v_unpaid);

    RAISE NOTICE '--- Risk Profile for VehicleID: % ---', p_vehicle_id;
    RAISE NOTICE 'Violations: % | Accidents: % | Unpaid Fines: % | Risk Score: %',
        v_violations, v_accidents, v_unpaid, v_risk_score;
END;
$$;

SELECT 'Triggers and procedures created successfully.' AS status;
