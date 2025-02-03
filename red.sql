--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: clinic_type_enum; Type: TYPE; Schema: public; Owner: red
--

CREATE TYPE public.clinic_type_enum AS ENUM (
    'Public',
    'Private',
    'Mixed'
);


ALTER TYPE public.clinic_type_enum OWNER TO red;

--
-- Name: identifier_type_enum; Type: TYPE; Schema: public; Owner: red
--

CREATE TYPE public.identifier_type_enum AS ENUM (
    'SUS',
    'SSN',
    'Insurance_ID',
    'Passport_Number',
    'CPF'
);


ALTER TYPE public.identifier_type_enum OWNER TO red;

--
-- Name: patient_status_enum; Type: TYPE; Schema: public; Owner: red
--

CREATE TYPE public.patient_status_enum AS ENUM (
    'active',
    'inactive',
    'deceased'
);


ALTER TYPE public.patient_status_enum OWNER TO red;

--
-- Name: professional_identifier_enum; Type: TYPE; Schema: public; Owner: red
--

CREATE TYPE public.professional_identifier_enum AS ENUM (
    'CRM',
    'State_Medical_License',
    'DEA',
    'NPI',
    'License',
    'Certification'
);


ALTER TYPE public.professional_identifier_enum OWNER TO red;

--
-- Name: status_enum; Type: TYPE; Schema: public; Owner: red
--

CREATE TYPE public.status_enum AS ENUM (
    'active',
    'inactive'
);


ALTER TYPE public.status_enum OWNER TO red;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.appointments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    schedule_id uuid NOT NULL,
    appointment_date timestamp without time zone,
    confirmed boolean DEFAULT false
);


ALTER TABLE public.appointments OWNER TO red;

--
-- Name: care_link; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.care_link (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    clinic_id uuid NOT NULL,
    doctor_id uuid NOT NULL,
    patient_id uuid NOT NULL,
    status public.status_enum DEFAULT 'active'::public.status_enum
);


ALTER TABLE public.care_link OWNER TO red;

--
-- Name: clinics; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.clinics (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name character varying(100) NOT NULL,
    address text NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(255),
    website character varying(255),
    clinic_type public.clinic_type_enum DEFAULT 'Private'::public.clinic_type_enum NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp without time zone
);


ALTER TABLE public.clinics OWNER TO red;

--
-- Name: employment_link; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.employment_link (
    id integer NOT NULL,
    clinic_id uuid NOT NULL,
    doctor_id uuid NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.employment_link OWNER TO red;

--
-- Name: employment_link_id_seq; Type: SEQUENCE; Schema: public; Owner: red
--

CREATE SEQUENCE public.employment_link_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employment_link_id_seq OWNER TO red;

--
-- Name: employment_link_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: red
--

ALTER SEQUENCE public.employment_link_id_seq OWNED BY public.employment_link.id;


--
-- Name: front_desk_users; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.front_desk_users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    is_admin boolean NOT NULL,
    clinic_id uuid NOT NULL,
    email character varying(255) NOT NULL,
    created_at timestamp without time zone,
    address text
);


ALTER TABLE public.front_desk_users OWNER TO red;

--
-- Name: healthcare_professionals; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.healthcare_professionals (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    profession character varying(50) NOT NULL,
    full_name character varying(300) NOT NULL,
    specialty character varying(100),
    email character varying(255) NOT NULL,
    phone character varying(20),
    clinic_id uuid NOT NULL
);


ALTER TABLE public.healthcare_professionals OWNER TO red;

--
-- Name: medical_records; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.medical_records (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    record_date timestamp without time zone,
    diagnosis text NOT NULL,
    anamnesis text NOT NULL,
    evolution text NOT NULL,
    pdf_file bytea,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    hash character(64) NOT NULL,
    appointment_id uuid NOT NULL
);


ALTER TABLE public.medical_records OWNER TO red;

--
-- Name: patient_identifiers; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.patient_identifiers (
    id integer NOT NULL,
    patient_id uuid NOT NULL,
    identifier_type public.identifier_type_enum NOT NULL,
    identifier_value character varying(50) NOT NULL
);


ALTER TABLE public.patient_identifiers OWNER TO red;

--
-- Name: patient_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: red
--

CREATE SEQUENCE public.patient_identifiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patient_identifiers_id_seq OWNER TO red;

--
-- Name: patient_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: red
--

ALTER SEQUENCE public.patient_identifiers_id_seq OWNED BY public.patient_identifiers.id;


--
-- Name: patients; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.patients (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    date_of_birth date NOT NULL,
    gender character varying(10) NOT NULL,
    address text NOT NULL,
    zip character varying(20) NOT NULL,
    phone character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    status public.patient_status_enum DEFAULT 'active'::public.patient_status_enum NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.patients OWNER TO red;

--
-- Name: professional_identifiers; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.professional_identifiers (
    id integer NOT NULL,
    professional_id uuid NOT NULL,
    identifier_type public.professional_identifier_enum NOT NULL,
    identifier_value character varying(50) NOT NULL
);


ALTER TABLE public.professional_identifiers OWNER TO red;

--
-- Name: professional_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: red
--

CREATE SEQUENCE public.professional_identifiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.professional_identifiers_id_seq OWNER TO red;

--
-- Name: professional_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: red
--

ALTER SEQUENCE public.professional_identifiers_id_seq OWNED BY public.professional_identifiers.id;


--
-- Name: schedule_dates; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.schedule_dates (
    id integer NOT NULL,
    schedule_id uuid NOT NULL,
    schedule_date date NOT NULL,
    break_start time without time zone,
    break_end time without time zone,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL
);


ALTER TABLE public.schedule_dates OWNER TO red;

--
-- Name: schedule_dates_id_seq; Type: SEQUENCE; Schema: public; Owner: red
--

CREATE SEQUENCE public.schedule_dates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.schedule_dates_id_seq OWNER TO red;

--
-- Name: schedule_dates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: red
--

ALTER SEQUENCE public.schedule_dates_id_seq OWNED BY public.schedule_dates.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.schedules (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    doctor_id uuid NOT NULL,
    clinic_id uuid NOT NULL,
    available_from time without time zone NOT NULL,
    available_to time without time zone NOT NULL,
    appointment_interval integer NOT NULL
);


ALTER TABLE public.schedules OWNER TO red;

--
-- Name: test_table; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.test_table (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.test_table OWNER TO red;

--
-- Name: test_table_id_seq; Type: SEQUENCE; Schema: public; Owner: red
--

CREATE SEQUENCE public.test_table_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.test_table_id_seq OWNER TO red;

--
-- Name: test_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: red
--

ALTER SEQUENCE public.test_table_id_seq OWNED BY public.test_table.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: red
--

CREATE TABLE public.users (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(20),
    password_hash character varying(255) NOT NULL,
    status public.status_enum DEFAULT 'active'::public.status_enum NOT NULL,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    healthcare_professional_id uuid,
    front_desk_user_id uuid,
    roles jsonb NOT NULL,
    recovery_token character varying(255)
);


ALTER TABLE public.users OWNER TO red;

--
-- Name: employment_link id; Type: DEFAULT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.employment_link ALTER COLUMN id SET DEFAULT nextval('public.employment_link_id_seq'::regclass);


--
-- Name: patient_identifiers id; Type: DEFAULT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.patient_identifiers ALTER COLUMN id SET DEFAULT nextval('public.patient_identifiers_id_seq'::regclass);


--
-- Name: professional_identifiers id; Type: DEFAULT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.professional_identifiers ALTER COLUMN id SET DEFAULT nextval('public.professional_identifiers_id_seq'::regclass);


--
-- Name: schedule_dates id; Type: DEFAULT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.schedule_dates ALTER COLUMN id SET DEFAULT nextval('public.schedule_dates_id_seq'::regclass);


--
-- Name: test_table id; Type: DEFAULT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.test_table ALTER COLUMN id SET DEFAULT nextval('public.test_table_id_seq'::regclass);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.appointments (id, schedule_id, appointment_date, confirmed) FROM stdin;
\.


--
-- Data for Name: care_link; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.care_link (id, clinic_id, doctor_id, patient_id, status) FROM stdin;
\.


--
-- Data for Name: clinics; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.clinics (id, name, address, phone, email, website, clinic_type, user_id, created_at) FROM stdin;
203b721b-43f2-4e8d-9cab-5425f084e14a	Clinic A	123 Main St	123-456-7890	\N	\N	Private	85830e45-667f-45e0-ba16-4dd11a645581	2025-02-01 14:29:04.932703
858bed4f-d0f9-4cf5-8823-2530445baa7f	ClinicasdfA	123 Main St	123-456-7890	\N	\N	Private	85830e45-667f-45e0-ba16-4dd11a645581	2025-02-01 14:29:35.486631
36789d4a-0ffd-46eb-8632-92e413ea6338	ClinicasdfA	123 Main St	123-456-7890	\N	\N	Private	85830e45-667f-45e0-ba16-4dd11a645581	2025-02-01 14:29:38.02836
\.


--
-- Data for Name: employment_link; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.employment_link (id, clinic_id, doctor_id, created_at) FROM stdin;
\.


--
-- Data for Name: front_desk_users; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.front_desk_users (id, is_admin, clinic_id, email, created_at, address) FROM stdin;
\.


--
-- Data for Name: healthcare_professionals; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.healthcare_professionals (id, profession, full_name, specialty, email, phone, clinic_id) FROM stdin;
\.


--
-- Data for Name: medical_records; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.medical_records (id, record_date, diagnosis, anamnesis, evolution, pdf_file, created_at, hash, appointment_id) FROM stdin;
\.


--
-- Data for Name: patient_identifiers; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.patient_identifiers (id, patient_id, identifier_type, identifier_value) FROM stdin;
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.patients (id, first_name, last_name, date_of_birth, gender, address, zip, phone, email, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: professional_identifiers; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.professional_identifiers (id, professional_id, identifier_type, identifier_value) FROM stdin;
\.


--
-- Data for Name: schedule_dates; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.schedule_dates (id, schedule_id, schedule_date, break_start, break_end, start_time, end_time) FROM stdin;
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.schedules (id, doctor_id, clinic_id, available_from, available_to, appointment_interval) FROM stdin;
\.


--
-- Data for Name: test_table; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.test_table (id, name) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: red
--

COPY public.users (id, username, name, email, phone, password_hash, status, last_login, created_at, updated_at, healthcare_professional_id, front_desk_user_id, roles, recovery_token) FROM stdin;
85830e45-667f-45e0-ba16-4dd11a645581	new	New Usadsfsdfsdfer	new_sd3a2dadsasdffsf4asdfsasdfsdfdfusas2dfer@example.com	1234sdf5346789	$argon2id$v=19$m=19456,t=2,p=1$t0ropkekZbE/1RcbztMnew$Ey1HoIxa8Idmg2/v1HHDSRb1E4jLuj3lXbfB5faun4I	active	\N	2025-02-01 12:56:30.442714	2025-02-01 12:56:30.443966	\N	\N	["user", "admin"]	\N
b4b01f96-1282-4504-909c-081a7226273b	ne5w	New Usadsfsdfsdfer	new_sd3a2dadsa5sdffsf4asdfsasdfsdfdfusas2dfer@example.com	1234sdf5346789	$argon2id$v=19$m=19456,t=2,p=1$HGE/v1BeXDani1c6CckPhw$A/cHgYp344vd5vzTPFb9+EZ8e8z3wAmlwVnj06BciGY	active	\N	2025-02-01 13:56:12.031603	2025-02-01 13:56:12.032303	\N	\N	["user"]	\N
0cca9cd0-fd1a-49db-85c4-02d07785d7ae	nedf5w	New Usadsfsdfsdfer	new_sd3a2dadsa5sdffsf4asdfsasdfsdfdfusas2dferexample.com	1234sdf5346789	$argon2id$v=19$m=19456,t=2,p=1$MU/fEbFiA4+9Lo5tN8ojRw$857g5CQiNpBwp9PVzj/3XwH4QLmljMo0dl1eaJqLaiQ	active	\N	2025-02-01 19:07:04.050762	2025-02-01 19:07:04.051149	\N	\N	["user"]	\N
d1931921-e65d-418c-ac9c-154e9d926f05	neddf5w	New Usadsfsdfsdfer	new_sd3a2dadsa5sdffsf4asdfsasdfsdfdfu@sas2dferexample.com	1234sdf5346789	$argon2id$v=19$m=19456,t=2,p=1$+T1H4kDKS7UaPynR9/MpUg$+lf/jdeOLqqs7096BSwTUDdbMUOnh7ReZdfWROf7dxM	active	\N	2025-02-02 23:26:26.532434	2025-02-02 23:26:26.532767	\N	\N	["user"]	\N
cb55cf30-21f6-4671-a377-bbfaf95cd624	up	New Usadsfsdfsdfer	new@new.com	1234sdf5346789	$argon2id$v=19$m=19456,t=2,p=1$vSBh023xUZgd0+6R4912MA$scPkJV2x0KO5z64orpVcR1Q/xGom1C2UgZ0XvlLcYhs	active	\N	2025-02-02 23:33:27.22376	2025-02-02 23:33:27.224457	\N	\N	["user"]	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJjYjU1Y2YzMC0yMWY2LTQ2NzEtYTM3Ny1iYmZhZjk1Y2Q2MjQiLCJleHAiOjE3Mzg1NDM3MzcsImVtYWlsIjoibmV3QG5ldy5jb20iLCJjbGluaWNzX2lkIjpbXSwicm9sZXMiOltdfQ.x-CtyGsczFUx2w3lxg1TdmSW_iI2XsDTLj5UaBGk3XI
\.


--
-- Name: employment_link_id_seq; Type: SEQUENCE SET; Schema: public; Owner: red
--

SELECT pg_catalog.setval('public.employment_link_id_seq', 1, false);


--
-- Name: patient_identifiers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: red
--

SELECT pg_catalog.setval('public.patient_identifiers_id_seq', 1, false);


--
-- Name: professional_identifiers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: red
--

SELECT pg_catalog.setval('public.professional_identifiers_id_seq', 1, false);


--
-- Name: schedule_dates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: red
--

SELECT pg_catalog.setval('public.schedule_dates_id_seq', 1, false);


--
-- Name: test_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: red
--

SELECT pg_catalog.setval('public.test_table_id_seq', 1, false);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: care_link care_link_clinic_id_doctor_id_patient_id_key; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.care_link
    ADD CONSTRAINT care_link_clinic_id_doctor_id_patient_id_key UNIQUE (clinic_id, doctor_id, patient_id);


--
-- Name: care_link care_link_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.care_link
    ADD CONSTRAINT care_link_pkey PRIMARY KEY (id);


--
-- Name: clinics clinics_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.clinics
    ADD CONSTRAINT clinics_pkey PRIMARY KEY (id);


--
-- Name: employment_link employment_link_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.employment_link
    ADD CONSTRAINT employment_link_pkey PRIMARY KEY (id);


--
-- Name: front_desk_users front_desk_users_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.front_desk_users
    ADD CONSTRAINT front_desk_users_pkey PRIMARY KEY (id);


--
-- Name: healthcare_professionals healthcare_professionals_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.healthcare_professionals
    ADD CONSTRAINT healthcare_professionals_pkey PRIMARY KEY (id);


--
-- Name: medical_records medical_records_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_pkey PRIMARY KEY (id);


--
-- Name: patient_identifiers patient_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.patient_identifiers
    ADD CONSTRAINT patient_identifiers_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: professional_identifiers professional_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.professional_identifiers
    ADD CONSTRAINT professional_identifiers_pkey PRIMARY KEY (id);


--
-- Name: schedule_dates schedule_dates_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.schedule_dates
    ADD CONSTRAINT schedule_dates_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: test_table test_table_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.test_table
    ADD CONSTRAINT test_table_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_front_desk_user_id_key; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_front_desk_user_id_key UNIQUE (front_desk_user_id);


--
-- Name: users users_healthcare_professional_id_key; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_healthcare_professional_id_key UNIQUE (healthcare_professional_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: red
--

CREATE UNIQUE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: appointments appointments_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.schedules(id);


--
-- Name: care_link care_link_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.care_link
    ADD CONSTRAINT care_link_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinics(id) ON DELETE CASCADE;


--
-- Name: care_link care_link_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.care_link
    ADD CONSTRAINT care_link_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.healthcare_professionals(id) ON DELETE CASCADE;


--
-- Name: care_link care_link_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.care_link
    ADD CONSTRAINT care_link_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: clinics clinics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.clinics
    ADD CONSTRAINT clinics_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: employment_link employment_link_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.employment_link
    ADD CONSTRAINT employment_link_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinics(id) ON DELETE CASCADE;


--
-- Name: employment_link employment_link_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.employment_link
    ADD CONSTRAINT employment_link_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.healthcare_professionals(id) ON DELETE CASCADE;


--
-- Name: front_desk_users front_desk_users_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.front_desk_users
    ADD CONSTRAINT front_desk_users_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinics(id);


--
-- Name: healthcare_professionals healthcare_professionals_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.healthcare_professionals
    ADD CONSTRAINT healthcare_professionals_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinics(id) ON DELETE CASCADE;


--
-- Name: medical_records medical_records_appointment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.medical_records
    ADD CONSTRAINT medical_records_appointment_id_fkey FOREIGN KEY (appointment_id) REFERENCES public.appointments(id) ON DELETE CASCADE;


--
-- Name: patient_identifiers patient_identifiers_patient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.patient_identifiers
    ADD CONSTRAINT patient_identifiers_patient_id_fkey FOREIGN KEY (patient_id) REFERENCES public.patients(id) ON DELETE CASCADE;


--
-- Name: professional_identifiers professional_identifiers_professional_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.professional_identifiers
    ADD CONSTRAINT professional_identifiers_professional_id_fkey FOREIGN KEY (professional_id) REFERENCES public.healthcare_professionals(id) ON DELETE CASCADE;


--
-- Name: schedule_dates schedule_dates_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.schedule_dates
    ADD CONSTRAINT schedule_dates_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.schedules(id) ON DELETE CASCADE;


--
-- Name: schedules schedules_clinic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_clinic_id_fkey FOREIGN KEY (clinic_id) REFERENCES public.clinics(id);


--
-- Name: schedules schedules_doctor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: red
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_doctor_id_fkey FOREIGN KEY (doctor_id) REFERENCES public.healthcare_professionals(id);


--
-- PostgreSQL database dump complete
--

