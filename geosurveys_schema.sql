--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2025-07-15 20:31:13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 78120)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 69884)
-- Name: point; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.point (
    pointid bigint NOT NULL,
    taskid bigint NOT NULL,
    number integer NOT NULL,
    description text NOT NULL,
    completed boolean NOT NULL
);


ALTER TABLE public.point OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 69883)
-- Name: point_pointid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.point_pointid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.point_pointid_seq OWNER TO postgres;

--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 218
-- Name: point_pointid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.point_pointid_seq OWNED BY public.point.pointid;


--
-- TOC entry 217 (class 1259 OID 69875)
-- Name: task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task (
    taskid bigint NOT NULL,
    title character varying(100) NOT NULL,
    description text,
    coordinates point,
    completed boolean NOT NULL,
    report text
);


ALTER TABLE public.task OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 69874)
-- Name: task_taskid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.task_taskid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.task_taskid_seq OWNER TO postgres;

--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 216
-- Name: task_taskid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.task_taskid_seq OWNED BY public.task.taskid;


--
-- TOC entry 223 (class 1259 OID 78111)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    userid bigint NOT NULL,
    login character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    CONSTRAINT min_login CHECK ((length((login)::text) >= 3))
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 78162)
-- Name: user_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_task (
    userid bigint NOT NULL,
    taskid bigint NOT NULL
);


ALTER TABLE public.user_task OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 78110)
-- Name: user_userid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_userid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_userid_seq OWNER TO postgres;

--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 222
-- Name: user_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_userid_seq OWNED BY public."user".userid;


--
-- TOC entry 221 (class 1259 OID 69893)
-- Name: video; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.video (
    videoid bigint NOT NULL,
    taskid bigint NOT NULL,
    title character varying(100) NOT NULL,
    url text,
    path text
);


ALTER TABLE public.video OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 69892)
-- Name: video_videoid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.video_videoid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.video_videoid_seq OWNER TO postgres;

--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 220
-- Name: video_videoid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.video_videoid_seq OWNED BY public.video.videoid;


--
-- TOC entry 4745 (class 2604 OID 69887)
-- Name: point pointid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point ALTER COLUMN pointid SET DEFAULT nextval('public.point_pointid_seq'::regclass);


--
-- TOC entry 4744 (class 2604 OID 69878)
-- Name: task taskid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task ALTER COLUMN taskid SET DEFAULT nextval('public.task_taskid_seq'::regclass);


--
-- TOC entry 4747 (class 2604 OID 78114)
-- Name: user userid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN userid SET DEFAULT nextval('public.user_userid_seq'::regclass);


--
-- TOC entry 4746 (class 2604 OID 69896)
-- Name: video videoid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.video ALTER COLUMN videoid SET DEFAULT nextval('public.video_videoid_seq'::regclass);


--
-- TOC entry 4753 (class 2606 OID 69891)
-- Name: point point_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT point_pkey PRIMARY KEY (pointid);


--
-- TOC entry 4755 (class 2606 OID 69916)
-- Name: point point_taskid_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT point_taskid_number_key UNIQUE (number, taskid);


--
-- TOC entry 4750 (class 2606 OID 69882)
-- Name: task task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task
    ADD CONSTRAINT task_pkey PRIMARY KEY (taskid);


--
-- TOC entry 4764 (class 2606 OID 78119)
-- Name: user user_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_login_key UNIQUE (login);


--
-- TOC entry 4766 (class 2606 OID 78117)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (userid);


--
-- TOC entry 4768 (class 2606 OID 78166)
-- Name: user_task user_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_task
    ADD CONSTRAINT user_task_pkey PRIMARY KEY (userid, taskid);


--
-- TOC entry 4758 (class 2606 OID 86302)
-- Name: video video_path_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT video_path_key UNIQUE (path);


--
-- TOC entry 4760 (class 2606 OID 69900)
-- Name: video video_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT video_pkey PRIMARY KEY (videoid);


--
-- TOC entry 4762 (class 2606 OID 86298)
-- Name: video video_url_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT video_url_key UNIQUE (url);


--
-- TOC entry 4751 (class 1259 OID 69906)
-- Name: fki_point_task_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_point_task_fkey ON public.point USING btree (taskid);


--
-- TOC entry 4756 (class 1259 OID 69912)
-- Name: fki_video_task_fkey; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX fki_video_task_fkey ON public.video USING btree (taskid);


--
-- TOC entry 4769 (class 2606 OID 69901)
-- Name: point point_task_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.point
    ADD CONSTRAINT point_task_fkey FOREIGN KEY (taskid) REFERENCES public.task(taskid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4771 (class 2606 OID 78172)
-- Name: user_task user_task_taskid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_task
    ADD CONSTRAINT user_task_taskid_fkey FOREIGN KEY (taskid) REFERENCES public.task(taskid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4772 (class 2606 OID 78167)
-- Name: user_task user_task_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_task
    ADD CONSTRAINT user_task_userid_fkey FOREIGN KEY (userid) REFERENCES public."user"(userid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4770 (class 2606 OID 69907)
-- Name: video video_task_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.video
    ADD CONSTRAINT video_task_fkey FOREIGN KEY (taskid) REFERENCES public.task(taskid) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2025-07-15 20:31:13

--
-- PostgreSQL database dump complete
--

