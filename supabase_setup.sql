-- DepEd SDO Accounting Digital Logbook — Supabase Schema
-- Run this in your Supabase SQL Editor

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL UNIQUE,
  password TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'Staff',
  unit TEXT NOT NULL DEFAULT '',
  unit_full_name TEXT NOT NULL DEFAULT ''
);

-- Logbook entries
CREATE TABLE IF NOT EXISTS logbook_entries (
  id SERIAL PRIMARY KEY,
  department TEXT NOT NULL,
  date_time_received TIMESTAMPTZ NOT NULL,
  received_by TEXT NOT NULL DEFAULT '',
  unit_owner TEXT NOT NULL DEFAULT '',
  created_by TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Document items
CREATE TABLE IF NOT EXISTS document_items (
  id SERIAL PRIMARY KEY,
  logbook_entry_id INTEGER NOT NULL REFERENCES logbook_entries(id) ON DELETE CASCADE,
  document_type TEXT NOT NULL,
  doc_code TEXT DEFAULT '',
  particulars TEXT NOT NULL,
  remarks TEXT DEFAULT ''
);

-- Audit logs
CREATE TABLE IF NOT EXISTS audit_logs (
  id SERIAL PRIMARY KEY,
  action TEXT NOT NULL,
  details TEXT NOT NULL DEFAULT '',
  performed_by TEXT NOT NULL DEFAULT '',
  unit TEXT NOT NULL DEFAULT '',
  timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Seed default accounts
INSERT INTO users (username, password, role, unit, unit_full_name) VALUES
  ('admin',        'admin123',        'Admin', 'ADMIN',       'Administrator'),
  ('AccountingUnit','Accounting2026', 'Staff', 'ACCOUNTING',  'Accounting Unit'),
  ('sdo',          'sdo123',          'Staff', 'SDO',         'Schools Division Office'),
  ('asds',         'asds123',         'Staff', 'ASDS',        'Assistant Schools Division Superintendent'),
  ('records',      'records123',      'Staff', 'RECORDS',     'Records Section'),
  ('hr',           'hr123',           'Staff', 'HR',          'Human Resource Section'),
  ('lr',           'lr123',           'Staff', 'LR',          'Learning Resources Section'),
  ('sgod',         'sgod123',         'Staff', 'SGOD',        'School Governance and Operations Division'),
  ('cid',          'cid123',          'Staff', 'CID',         'Curriculum and Instruction Division'),
  ('budget',       'budget123',       'Staff', 'BUDGET',      'Budget Section'),
  ('bac',          'bac123',          'Staff', 'BAC',         'Bids and Awards Committee'),
  ('cash',         'cash123',         'Staff', 'CASH',        'Cash Section'),
  ('admin_unit',   'admin_unit123',   'Staff', 'ADMIN_UNIT',  'Administrative Division'),
  ('sds',          'sds123',          'Staff', 'SDS',         'Schools Division Superintendent'),
  ('supply',       'supply123',       'Staff', 'SUPPLY',      'Supply and Property Unit'),
  ('legal',        'legal123',        'Staff', 'LEGAL',       'Legal Unit')
ON CONFLICT (username) DO NOTHING;

-- Enable Row Level Security (optional but recommended)
-- For simplicity, we use anon key with service-level policies
-- Allow all operations via anon key (app handles auth logic itself)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE logbook_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE document_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all_users" ON users FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_entries" ON logbook_entries FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_docs" ON document_items FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all_audit" ON audit_logs FOR ALL USING (true) WITH CHECK (true);
