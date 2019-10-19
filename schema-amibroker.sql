--
-- PostgreSQL database dump
--

-- Dumped from database version 10.4
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: f_upd_freq_trx(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_upd_freq_trx() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE stock_trx_idx
    SET freq_trx = new.freq_trx
    WHERE 
    dt_trx = new.dt_trx
    and id_ticker = new.id_ticker;
    RETURN new;
END;
$$;


ALTER FUNCTION public.f_upd_freq_trx() OWNER TO postgres;

--
-- Name: f_upd_nbsa_prc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_upd_nbsa_prc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE stock_trx_idx
    SET nbsa_buy_prc = new.nbsa_buy_prc, nbsa_sell_prc = new.nbsa_sell_prc, nbsa_prc = new.nbsa_buy_prc - new.nbsa_sell_prc
    WHERE 
    dt_trx = new.dt_trx
    AND id_ticker = new.id_ticker;
    RETURN new;
END;
$$;


ALTER FUNCTION public.f_upd_nbsa_prc() OWNER TO postgres;

--
-- Name: f_upd_open_prc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.f_upd_open_prc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE stock_trx_idx
    SET open_prc = new.open_prc
    WHERE 
    dt_trx = new.dt_trx
    and id_ticker = new.id_ticker;
    RETURN new;
END;
$$;


ALTER FUNCTION public.f_upd_open_prc() OWNER TO postgres;

--
-- Name: sp_bajul_old(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_bajul_old(dt1 date, dt2 date) RETURNS void
    LANGUAGE sql
    AS $$
     TRUNCATE table BAJUL;
		INSERT into BAJUL (DT_TRX, ROW_NUMBER) SELECT dt_trx, row_number() OVER (ORDER BY dt_trx DESC) AS row_number
		FROM stock_trx_idx
		WHERE
		dt_trx <= dt1 AND dt_trx >= dt2
		GROUP BY 1
		ORDER BY 1 DESC
		LIMIT 200;
$$;


ALTER FUNCTION public.sp_bajul_old(dt1 date, dt2 date) OWNER TO postgres;

--
-- Name: sp_bajul_tr(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_bajul_tr() RETURNS void
    LANGUAGE sql
    AS $$
     TRUNCATE table BAJUL;
		INSERT into BAJUL (DT_TRX, ROW_NUMBER) SELECT dt_trx, row_number() OVER (ORDER BY dt_trx DESC) AS row_number
		FROM stock_trx_idx
		GROUP BY 1
		ORDER BY 1 DESC
		LIMIT 250;
$$;


ALTER FUNCTION public.sp_bajul_tr() OWNER TO postgres;

--
-- Name: sp_refresh_mv_tr(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_refresh_mv_tr() RETURNS void
    LANGUAGE sql
    AS $$
	REFRESH MATERIALIZED VIEW mv_stock_vol_melduk;
	REFRESH MATERIALIZED VIEW mv_stock_vol_amount;
	
	REFRESH MATERIALIZED VIEW mv_stock_go_down;
	REFRESH MATERIALIZED VIEW mv_stock_go_down1;
	REFRESH MATERIALIZED VIEW mv_stock_go_down2;
	REFRESH MATERIALIZED VIEW mv_stock_go_down3;
	
	REFRESH MATERIALIZED VIEW mv_stock_go_up;
	REFRESH MATERIALIZED VIEW mv_stock_go_up1;
	REFRESH MATERIALIZED VIEW mv_stock_go_up2;
	REFRESH MATERIALIZED VIEW mv_stock_go_up3;
$$;


ALTER FUNCTION public.sp_refresh_mv_tr() OWNER TO postgres;

--
-- Name: sp_stock_master_forbidden(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_stock_master_forbidden() RETURNS void
    LANGUAGE sql
    AS $$     
		DELETE FROM stock_trx_idx WHERE ID_TICKER IN (SELECT ID_TICKER FROM stock_master_forbidden);
$$;


ALTER FUNCTION public.sp_stock_master_forbidden() OWNER TO postgres;

--
-- Name: stocktrx_delete_master(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stocktrx_delete_master() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

DECLARE

    r stock_trx_idx%rowtype;

BEGIN

    DELETE FROM ONLY stock_trx_idx where id_ticker = new.id_ticker AND dt_trx = new.dt_trx returning * into r;

    RETURN r;

end;

$$;


ALTER FUNCTION public.stocktrx_delete_master() OWNER TO postgres;

--
-- Name: stocktrx_insert_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.stocktrx_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE r stock_trx_idx%rowtype;

BEGIN

IF (NEW.dt_trx >= '1993-01-01' AND NEW.dt_trx <= '1993-12-31' ) THEN

    INSERT INTO stock_trx_1993 VALUES (NEW.*) RETURNING * INTO r;
	
ELSEIF (NEW.dt_trx >= '1994-01-01' AND NEW.dt_trx <= '1994-12-31' ) THEN

    INSERT INTO stock_trx_1994 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '1995-01-01' AND NEW.dt_trx <= '1995-12-31' ) THEN

    INSERT INTO stock_trx_1995 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '1996-01-01' AND NEW.dt_trx <= '1996-12-31' ) THEN

    INSERT INTO stock_trx_1996 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '1997-01-01' AND NEW.dt_trx <= '1997-12-31' ) THEN

    INSERT INTO stock_trx_1997 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '1998-01-01' AND NEW.dt_trx <= '1998-12-31' ) THEN

    INSERT INTO stock_trx_1998 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '1999-01-01' AND NEW.dt_trx <= '1999-12-31' ) THEN

    INSERT INTO stock_trx_1999 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2000-01-01' AND NEW.dt_trx <= '2000-12-31' ) THEN

    INSERT INTO stock_trx_2000 VALUES (NEW.*) RETURNING * INTO r;	
	
ELSEIF (NEW.dt_trx >= '2001-01-01' AND NEW.dt_trx <= '2001-12-31' ) THEN

    INSERT INTO stock_trx_2001 VALUES (NEW.*) RETURNING * INTO r;	
	
ELSEIF (NEW.dt_trx >= '2002-01-01' AND NEW.dt_trx <= '2002-12-31' ) THEN

    INSERT INTO stock_trx_2002 VALUES (NEW.*) RETURNING * INTO r;	
	
ELSEIF (NEW.dt_trx >= '2003-01-01' AND NEW.dt_trx <= '2003-12-31' ) THEN

    INSERT INTO stock_trx_2003 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2004-01-01' AND NEW.dt_trx <= '2004-12-31' ) THEN

    INSERT INTO stock_trx_2004 VALUES (NEW.*) RETURNING * INTO r;		
	
ELSEIF (NEW.dt_trx >= '2005-01-01' AND NEW.dt_trx <= '2005-12-31' ) THEN

    INSERT INTO stock_trx_2005 VALUES (NEW.*) RETURNING * INTO r;	
	
ELSEIF (NEW.dt_trx >= '2006-01-01' AND NEW.dt_trx <= '2006-12-31' ) THEN

    INSERT INTO stock_trx_2006 VALUES (NEW.*) RETURNING * INTO r;	
	
ELSEIF (NEW.dt_trx >= '2007-01-01' AND NEW.dt_trx <= '2007-12-31' ) THEN

    INSERT INTO stock_trx_2007 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2008-01-01' AND NEW.dt_trx <= '2008-12-31' ) THEN

    INSERT INTO stock_trx_2008 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2009-01-01' AND NEW.dt_trx <= '2009-12-31' ) THEN

    INSERT INTO stock_trx_2009 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2010-01-01' AND NEW.dt_trx <= '2010-12-31' ) THEN

    INSERT INTO stock_trx_2010 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2011-01-01' AND NEW.dt_trx <= '2011-12-31' ) THEN

    INSERT INTO stock_trx_2011 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2012-01-01' AND NEW.dt_trx <= '2012-12-31' ) THEN

    INSERT INTO stock_trx_2012 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2013-01-01' AND NEW.dt_trx <= '2013-12-31' ) THEN

    INSERT INTO stock_trx_2013 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2014-01-01' AND NEW.dt_trx <= '2014-12-31' ) THEN

    INSERT INTO stock_trx_2014 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2015-01-01' AND NEW.dt_trx <= '2015-12-31' ) THEN

    INSERT INTO stock_trx_2015 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2016-01-01' AND NEW.dt_trx <= '2016-12-31' ) THEN

    INSERT INTO stock_trx_2016 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2017-01-01' AND NEW.dt_trx <= '2017-12-31' ) THEN

    INSERT INTO stock_trx_2017 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2018-01-01' AND NEW.dt_trx <= '2018-12-31' ) THEN

    INSERT INTO stock_trx_2018 VALUES (NEW.*) RETURNING * INTO r;
	
ELSEIF (NEW.dt_trx >= '2019-01-01' AND NEW.dt_trx <= '2019-12-31' ) THEN

    INSERT INTO stock_trx_2019 VALUES (NEW.*) RETURNING * INTO r;

ELSEIF (NEW.dt_trx >= '2020-01-01' AND NEW.dt_trx <= '2020-12-31' ) THEN

    INSERT INTO stock_trx_2020 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2021-01-01' AND NEW.dt_trx <= '2021-12-31' ) THEN

    INSERT INTO stock_trx_2021 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2022-01-01' AND NEW.dt_trx <= '2022-12-31' ) THEN

    INSERT INTO stock_trx_2022 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2023-01-01' AND NEW.dt_trx <= '2023-12-31' ) THEN

    INSERT INTO stock_trx_2023 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2024-01-01' AND NEW.dt_trx <= '2024-12-31' ) THEN

    INSERT INTO stock_trx_2024 VALUES (NEW.*) RETURNING * INTO r;	

ELSEIF (NEW.dt_trx >= '2025-01-01' AND NEW.dt_trx <= '2025-12-31' ) THEN

    INSERT INTO stock_trx_2025 VALUES (NEW.*) RETURNING * INTO r;
	
ELSE

    RAISE EXCEPTION 'Date out of range.  Fix the measurement_insert_trigger() function!';

END IF;    

    RETURN r;

END;

$$;


ALTER FUNCTION public.stocktrx_insert_trigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: bajul; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bajul (
    dt_trx date,
    row_number bigint
);


ALTER TABLE public.bajul OWNER TO postgres;

--
-- Name: stock_trx_idx; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_idx (
    id_ticker character varying(8) NOT NULL,
    dt_trx date NOT NULL,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric
);


ALTER TABLE public.stock_trx_idx OWNER TO postgres;

--
-- Name: mv_stock_go_down; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_down AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc < c.close_prc) AND (c.close_prc < d.close_prc) AND (d.close_prc < e.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2))
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_down OWNER TO postgres;

--
-- Name: mv_stock_go_down2; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_down2 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc < c.close_prc))
  ORDER BY (round((((a.close_prc - c.close_prc) / c.close_prc) * (100)::numeric), 2))
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_down2 OWNER TO postgres;

--
-- Name: mv_stock_go_down3; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_down3 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc < c.close_prc) AND (c.close_prc < d.close_prc))
  ORDER BY (round((((a.close_prc - d.close_prc) / d.close_prc) * (100)::numeric), 2))
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_down3 OWNER TO postgres;

--
-- Name: mv_stock_go_down1; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_down1 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (NOT ((a.id_ticker)::text IN ( SELECT mv_stock_go_down2.id_ticker
           FROM public.mv_stock_go_down2))) AND (NOT ((a.id_ticker)::text IN ( SELECT mv_stock_go_down3.id_ticker
           FROM public.mv_stock_go_down3))) AND (NOT ((a.id_ticker)::text IN ( SELECT mv_stock_go_down.id_ticker
           FROM public.mv_stock_go_down))))
  ORDER BY (round((((a.close_prc - b.close_prc) / a.close_prc) * (100)::numeric), 2))
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_down1 OWNER TO postgres;

--
-- Name: mv_stock_go_up; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_up AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc > c.close_prc) AND (c.close_prc > d.close_prc) AND (d.close_prc > e.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_up OWNER TO postgres;

--
-- Name: stock_go_up; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_up AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc > c.close_prc) AND (c.close_prc > d.close_prc) AND (d.close_prc > e.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_go_up OWNER TO postgres;

--
-- Name: stock_go_up2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_up2 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc > c.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_go_up2 OWNER TO postgres;

--
-- Name: stock_go_up3; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_up3 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc > c.close_prc) AND (c.close_prc > d.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_go_up3 OWNER TO postgres;

--
-- Name: mv_stock_go_up1; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_up1 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_up2.id_ticker
           FROM public.stock_go_up2))) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_up3.id_ticker
           FROM public.stock_go_up3))) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_up.id_ticker
           FROM public.stock_go_up))))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_up1 OWNER TO postgres;

--
-- Name: mv_stock_go_up2; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_up2 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc > c.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_up2 OWNER TO postgres;

--
-- Name: mv_stock_go_up3; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_go_up3 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc > c.close_prc) AND (c.close_prc > d.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC
  WITH NO DATA;


ALTER TABLE public.mv_stock_go_up3 OWNER TO postgres;

--
-- Name: stock_master; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_master (
    id_ticker character varying(7) NOT NULL,
    nm_ticker character varying(60) NOT NULL
);


ALTER TABLE public.stock_master OWNER TO postgres;

--
-- Name: mv_stock_vol_amount; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_vol_amount AS
 SELECT a.dt_trx,
    a.id_ticker,
    a.ma1,
    b.ma2,
    round((((a.ma1 - b.ma2) / b.ma2) * (100)::numeric), 2) AS up_p,
    a.volume_trx AS vol_trx,
    a.amt1 AS last_amt,
    b.amt2,
    c.amt3,
    d.amt4,
    e.amt5,
    round((((((a.amt1 + b.amt2) + c.amt3) + d.amt4) + e.amt5) / (5)::numeric)) AS avg_amt_5day
   FROM ((((( SELECT a_1.id_ticker,
            b_1.nm_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.close_prc AS ma1,
            a_1.value_prc AS amt1,
            a_1.volume_trx
           FROM (public.stock_trx_idx a_1
             JOIN public.stock_master b_1 ON (((a_1.id_ticker)::text = (b_1.id_ticker)::text)))
          WHERE (a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1)))) a
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma2,
            stock_trx_idx.value_prc AS amt2
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2)))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.value_prc AS amt3
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3)))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.value_prc AS amt4
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4)))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.value_prc AS amt5
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5)))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
  WHERE ((a.amt1 > (50000)::numeric) AND (a.amt1 > b.amt2) AND (b.amt2 > c.amt3) AND (a.amt1 >= ((b.amt2 + c.amt3) + d.amt4)))
  ORDER BY a.amt1 DESC
  WITH NO DATA;


ALTER TABLE public.mv_stock_vol_amount OWNER TO postgres;

--
-- Name: mv_stock_vol_melduk; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.mv_stock_vol_melduk AS
 SELECT a.dt_trx,
    a.id_ticker,
    a.ma1,
    b.ma2,
    round((((a.ma1 - b.ma2) / b.ma2) * (100)::numeric), 2) AS up_p,
    a.value_prc AS vol_prc,
    a.vol1 AS last_vol,
    b.vol2,
    c.vol3,
    d.vol4,
    e.vol5,
    round((((((a.vol1 + b.vol2) + c.vol3) + d.vol4) + e.vol5) / (5)::numeric)) AS avg_vol_5day
   FROM ((((( SELECT a_1.id_ticker,
            b_1.nm_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.close_prc AS ma1,
            a_1.volume_trx AS vol1,
            a_1.value_prc
           FROM (public.stock_trx_idx a_1
             JOIN public.stock_master b_1 ON (((a_1.id_ticker)::text = (b_1.id_ticker)::text)))
          WHERE (a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1)))) a
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma2,
            stock_trx_idx.volume_trx AS vol2
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2)))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.volume_trx AS vol3
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3)))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.volume_trx AS vol4
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4)))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.volume_trx AS vol5
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5)))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
  WHERE ((a.vol1 > (50000)::numeric) AND (a.ma1 > b.ma2) AND (a.vol1 > b.vol2) AND (a.vol1 > c.vol3) AND (a.vol1 >= ((b.vol2 + c.vol3) + d.vol4)))
  ORDER BY a.vol1 DESC
  WITH NO DATA;


ALTER TABLE public.mv_stock_vol_melduk OWNER TO postgres;

--
-- Name: row_bajul; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.row_bajul (
    dt_trx date,
    row_number bigint
);


ALTER TABLE public.row_bajul OWNER TO postgres;

--
-- Name: stock_cross_5_10; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_cross_5_10 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > e.close_prc) AND (e.close_prc > f.close_prc))
  ORDER BY a.value_prc DESC;


ALTER TABLE public.stock_cross_5_10 OWNER TO postgres;

--
-- Name: stock_go_down; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_down AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc < c.close_prc) AND (c.close_prc < d.close_prc) AND (d.close_prc < e.close_prc))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2));


ALTER TABLE public.stock_go_down OWNER TO postgres;

--
-- Name: stock_go_down2; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_down2 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc < c.close_prc))
  ORDER BY (round((((a.close_prc - c.close_prc) / c.close_prc) * (100)::numeric), 2));


ALTER TABLE public.stock_go_down2 OWNER TO postgres;

--
-- Name: stock_go_down3; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_down3 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc < c.close_prc) AND (c.close_prc < d.close_prc))
  ORDER BY (round((((a.close_prc - d.close_prc) / d.close_prc) * (100)::numeric), 2));


ALTER TABLE public.stock_go_down3 OWNER TO postgres;

--
-- Name: stock_go_down1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_down1 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS down_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_down2.id_ticker
           FROM public.stock_go_down2))) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_down3.id_ticker
           FROM public.stock_go_down3))) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_down.id_ticker
           FROM public.stock_go_down))))
  ORDER BY (round((((a.close_prc - b.close_prc) / a.close_prc) * (100)::numeric), 2));


ALTER TABLE public.stock_go_down1 OWNER TO postgres;

--
-- Name: stock_go_down_200; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_down_200 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma50,
    h.close_prc AS ma100,
    i.close_prc AS ma150,
    j.close_prc AS ma200,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - j.close_prc) / j.close_prc) * (100)::numeric), 2) AS down_p
   FROM (((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 150))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 200))) AND (a_1.volume_trx > (10000)::numeric))) j ON (((a.id_ticker)::text = (j.id_ticker)::text)))
  WHERE (a.close_prc < j.close_prc)
  ORDER BY (round((((a.close_prc - j.close_prc) / j.close_prc) * (100)::numeric), 2));


ALTER TABLE public.stock_go_down_200 OWNER TO postgres;

--
-- Name: stock_go_fast_trade; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_fast_trade AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - b.close_prc) / b.close_prc) * (100)::numeric), 2) AS up_p
   FROM (((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.open_prc > a_1.close_prc) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (a.volume_trx >= b.volume_trx))
  ORDER BY (round((((a.close_prc - b.close_prc) / b.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_go_fast_trade OWNER TO postgres;

--
-- Name: stock_go_swing; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_swing AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma5,
    c.close_prc AS ma10,
    d.close_prc AS ma20,
    e.close_prc AS ma30,
    f.close_prc AS ma40,
    g.close_prc AS ma50,
    h.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - b.close_prc) / b.close_prc) * (100)::numeric), 2) AS up_p
   FROM (((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 30))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 40))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
  WHERE (a.close_prc > b.close_prc)
  ORDER BY (round((((a.close_prc - b.close_prc) / b.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_go_swing OWNER TO postgres;

--
-- Name: stock_go_up1; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_up1 AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    e.close_prc AS ma5,
    f.close_prc AS ma10,
    g.close_prc AS ma20,
    h.close_prc AS ma50,
    i.close_prc AS ma100,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 50))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 100))) AND (a_1.volume_trx > (10000)::numeric))) i ON (((a.id_ticker)::text = (i.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_up2.id_ticker
           FROM public.stock_go_up2))) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_up3.id_ticker
           FROM public.stock_go_up3))) AND (NOT ((a.id_ticker)::text IN ( SELECT stock_go_up.id_ticker
           FROM public.stock_go_up))))
  ORDER BY (round((((a.close_prc - e.close_prc) / e.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_go_up1 OWNER TO postgres;

--
-- Name: stock_go_up_max; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_go_up_max AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    a.volume_trx AS vol_trx1,
    a.value_prc AS vol_prc1,
    b.volume_trx AS vol_trx2,
    b.value_prc AS vol_prc2,
    round((((a.close_prc - b.close_prc) / b.close_prc) * (100)::numeric), 2) AS up_p,
    round((((a.volume_trx - b.volume_trx) / b.volume_trx) * (100)::numeric), 2) AS up_vol,
    round((((a.value_prc - b.value_prc) / b.value_prc) * (100)::numeric), 2) AS up_prc
   FROM (( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.close_prc > a_1.open_prc) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (round((((a.volume_trx - b.volume_trx) / b.volume_trx) * (100)::numeric), 2) > 0.1) AND (round((((a.value_prc - b.value_prc) / b.value_prc) * (100)::numeric), 2) > 0.1))
  ORDER BY (round((((a.close_prc - b.close_prc) / b.close_prc) * (100)::numeric), 2)), (round((((a.volume_trx - b.volume_trx) / b.volume_trx) * (100)::numeric), 2)), (round((((a.value_prc - b.value_prc) / b.value_prc) * (100)::numeric), 2));


ALTER TABLE public.stock_go_up_max OWNER TO postgres;

--
-- Name: stock_info_res_sup; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_info_res_sup AS
 SELECT a_1.id_ticker,
    b_1.nm_ticker,
    a_1.dt_trx,
    a_1.close_prc AS ma1,
    a_1.volume_trx AS last_trx_vol,
    a_1.value_prc AS last_trx_prc,
    ((round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) * (2)::numeric) - a_1.low_prc) AS r1,
    (round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) + (a_1.high_prc - a_1.low_prc)) AS r2,
    round((a_1.high_prc + ((2)::numeric * (a_1.high_prc - (((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric))))) AS r3,
    round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) AS pivot_entry,
    ((round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) * (2)::numeric) - a_1.high_prc) AS s1,
    (round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) - (a_1.high_prc - a_1.low_prc)) AS s2,
    round((a_1.low_prc - ((2)::numeric * (a_1.high_prc - (((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric))))) AS s3
   FROM (public.stock_trx_idx a_1
     JOIN public.stock_master b_1 ON (((a_1.id_ticker)::text = (b_1.id_ticker)::text)))
  WHERE (a_1.dt_trx = ( SELECT max(bajul.dt_trx) AS max
           FROM public.bajul));


ALTER TABLE public.stock_info_res_sup OWNER TO postgres;

--
-- Name: stock_issi; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_issi (
    id_ticker character varying(8) NOT NULL,
    issi character varying(1),
    lq45 character varying(1),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.stock_issi OWNER TO postgres;

--
-- Name: stock_master_forbidden; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_master_forbidden (
    id_ticker character varying(7) NOT NULL,
    nm_ticker character varying(60) NOT NULL
);


ALTER TABLE public.stock_master_forbidden OWNER TO postgres;

--
-- Name: stock_master_issi; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_master_issi AS
 SELECT a.id_ticker,
    a.nm_ticker,
    b.issi,
    b.lq45
   FROM (public.stock_master a
     LEFT JOIN public.stock_issi b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
  ORDER BY a.id_ticker;


ALTER TABLE public.stock_master_issi OWNER TO postgres;

--
-- Name: stock_mudun; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_mudun AS
 SELECT concat(a.id_ticker, ' | ', btrim((a.nm_ticker)::text)) AS stock_name,
    a.dt_trx,
    a.ma1,
    a.s1,
    a.s2,
    a.s3,
    a.pivot_entry,
    a.r1,
    a.r2,
    a.r3,
    b.ma2,
    c.ma3,
    d.ma4,
    e.ma5,
    f.ma10,
    g.ma20,
    a.vol
   FROM ((((((( SELECT a_1.id_ticker,
            b_1.nm_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.close_prc AS ma1,
            a_1.volume_trx AS vol,
            ((round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) * (2)::numeric) - a_1.high_prc) AS s1,
            (round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) - (a_1.high_prc - a_1.low_prc)) AS s2,
            round((a_1.low_prc - ((2)::numeric * (a_1.high_prc - (((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric))))) AS s3,
            round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) AS pivot_entry,
            ((round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) * (2)::numeric) - a_1.low_prc) AS r1,
            (round((((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric)) + (a_1.high_prc - a_1.low_prc)) AS r2,
            round((a_1.high_prc + ((2)::numeric * (a_1.high_prc - (((a_1.high_prc + a_1.low_prc) + a_1.close_prc) / (3)::numeric))))) AS r3
           FROM (public.stock_trx_idx a_1
             JOIN public.stock_master b_1 ON (((a_1.id_ticker)::text = (b_1.id_ticker)::text)))
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.close_prc <= a_1.open_prc))) a
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma2
           FROM public.stock_trx_idx
          WHERE ((stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (stock_trx_idx.close_prc <= stock_trx_idx.open_prc))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3
           FROM public.stock_trx_idx
          WHERE ((stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (stock_trx_idx.close_prc <= stock_trx_idx.open_prc))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma4
           FROM public.stock_trx_idx
          WHERE ((stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (stock_trx_idx.close_prc <= stock_trx_idx.open_prc))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma5
           FROM public.stock_trx_idx
          WHERE ((stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (stock_trx_idx.close_prc <= stock_trx_idx.open_prc))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma10
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10)))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma20
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20)))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
  WHERE ((a.ma1 < b.ma2) AND (b.ma2 < c.ma3) AND (c.ma3 < d.ma4) AND (d.ma4 < e.ma5));


ALTER TABLE public.stock_mudun OWNER TO postgres;

--
-- Name: stock_reversal_down; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_reversal_down AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    f.close_prc AS ma5,
    g.close_prc AS ma10,
    h.close_prc AS ma20,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - f.close_prc) / f.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
  WHERE ((a.close_prc < b.close_prc) AND (b.close_prc > c.close_prc) AND (c.close_prc > d.close_prc) AND (d.close_prc > f.close_prc))
  ORDER BY (round((((a.close_prc - f.close_prc) / f.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_reversal_down OWNER TO postgres;

--
-- Name: stock_reversal_up; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_reversal_up AS
 SELECT a.id_ticker,
    a.dt_trx,
    a.close_prc AS ma1,
    b.close_prc AS ma2,
    c.close_prc AS ma3,
    d.close_prc AS ma4,
    f.close_prc AS ma5,
    g.close_prc AS ma10,
    h.close_prc AS ma20,
    a.volume_trx AS vol_trx,
    a.value_prc AS vol_prc,
    round((((a.close_prc - f.close_prc) / f.close_prc) * (100)::numeric), 2) AS up_p
   FROM ((((((( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1))) AND (a_1.volume_trx > (10000)::numeric))) a
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2))) AND (a_1.volume_trx > (10000)::numeric))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3))) AND (a_1.volume_trx > (10000)::numeric))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4))) AND (a_1.volume_trx > (10000)::numeric))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5))) AND (a_1.volume_trx > (10000)::numeric))) f ON (((a.id_ticker)::text = (f.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 10))) AND (a_1.volume_trx > (10000)::numeric))) g ON (((a.id_ticker)::text = (g.id_ticker)::text)))
     JOIN ( SELECT a_1.id_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.high_prc,
            a_1.low_prc,
            a_1.close_prc,
            a_1.volume_trx,
            a_1.value_prc
           FROM public.stock_trx_idx a_1
          WHERE ((a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 20))) AND (a_1.volume_trx > (10000)::numeric))) h ON (((a.id_ticker)::text = (h.id_ticker)::text)))
  WHERE ((a.close_prc > b.close_prc) AND (b.close_prc < c.close_prc) AND (c.close_prc < d.close_prc) AND (d.close_prc < f.close_prc))
  ORDER BY (round((((a.close_prc - f.close_prc) / f.close_prc) * (100)::numeric), 2)) DESC;


ALTER TABLE public.stock_reversal_up OWNER TO postgres;

--
-- Name: v_start_end_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_start_end_month AS
 SELECT to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'YYYY-MM'::text) AS mth_year,
    to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'YYYY'::text) AS trx_year,
    to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'Month'::text) AS trx_mth,
    min(stock_trx_idx.dt_trx) AS dt_min,
    max(stock_trx_idx.dt_trx) AS dt_max
   FROM public.stock_trx_idx
  WHERE ((to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'YYYY-MM'::text) >= '2001-01'::text) AND (to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'YYYY-MM'::text) <= '2020-12-31'::text))
  GROUP BY (to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'YYYY-MM'::text)), (to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'YYYY'::text)), (to_char((stock_trx_idx.dt_trx)::timestamp with time zone, 'Month'::text));


ALTER TABLE public.v_start_end_month OWNER TO postgres;

--
-- Name: v_prc_max; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_prc_max AS
 SELECT a.id_ticker,
    a.close_prc AS prc_max,
    b.mth_year,
    b.trx_year,
    b.trx_mth,
    b.dt_max
   FROM (public.stock_trx_idx a
     JOIN public.v_start_end_month b ON ((a.dt_trx = b.dt_max)));


ALTER TABLE public.v_prc_max OWNER TO postgres;

--
-- Name: v_prc_min; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_prc_min AS
 SELECT a.id_ticker,
    a.close_prc AS prc_min,
    b.mth_year,
    b.trx_year,
    b.trx_mth,
    b.dt_min
   FROM (public.stock_trx_idx a
     JOIN public.v_start_end_month b ON ((a.dt_trx = b.dt_min)));


ALTER TABLE public.v_prc_min OWNER TO postgres;

--
-- Name: stock_session; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_session AS
 SELECT a.id_ticker,
    a.trx_year,
    a.trx_mth,
    a.prc_min,
    a.dt_min,
    b.prc_max,
    b.dt_max,
    round((((b.prc_max - a.prc_min) / a.prc_min) * (100)::numeric), 2) AS up_p
   FROM (( SELECT v_prc_min.id_ticker,
            v_prc_min.trx_year,
            v_prc_min.trx_mth,
            v_prc_min.prc_min,
            v_prc_min.dt_min
           FROM public.v_prc_min) a
     JOIN ( SELECT v_prc_max.id_ticker,
            v_prc_max.trx_year,
            v_prc_max.trx_mth,
            v_prc_max.prc_max,
            v_prc_max.dt_max
           FROM public.v_prc_max) b ON ((((a.id_ticker)::text = (b.id_ticker)::text) AND (a.trx_year = b.trx_year) AND (a.trx_mth = b.trx_mth))))
  ORDER BY a.trx_year, a.dt_min;


ALTER TABLE public.stock_session OWNER TO postgres;

--
-- Name: stock_trx_1993; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1993 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1993_dt_trx_check CHECK (((dt_trx >= '1993-01-01'::date) AND (dt_trx <= '1993-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1993 OWNER TO postgres;

--
-- Name: stock_trx_1993_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1993_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1993_seq OWNER TO postgres;

--
-- Name: stock_trx_1994; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1994 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1994_dt_trx_check CHECK (((dt_trx >= '1994-01-01'::date) AND (dt_trx <= '1994-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1994 OWNER TO postgres;

--
-- Name: stock_trx_1994_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1994_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1994_seq OWNER TO postgres;

--
-- Name: stock_trx_1995; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1995 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1995_dt_trx_check CHECK (((dt_trx >= '1995-01-01'::date) AND (dt_trx <= '1995-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1995 OWNER TO postgres;

--
-- Name: stock_trx_1995_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1995_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1995_seq OWNER TO postgres;

--
-- Name: stock_trx_1996; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1996 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1996_dt_trx_check CHECK (((dt_trx >= '1996-01-01'::date) AND (dt_trx <= '1996-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1996 OWNER TO postgres;

--
-- Name: stock_trx_1996_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1996_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1996_seq OWNER TO postgres;

--
-- Name: stock_trx_1997; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1997 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1997_dt_trx_check CHECK (((dt_trx >= '1997-01-01'::date) AND (dt_trx <= '1997-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1997 OWNER TO postgres;

--
-- Name: stock_trx_1997_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1997_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1997_seq OWNER TO postgres;

--
-- Name: stock_trx_1998; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1998 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1998_dt_trx_check CHECK (((dt_trx >= '1998-01-01'::date) AND (dt_trx <= '1998-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1998 OWNER TO postgres;

--
-- Name: stock_trx_1998_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1998_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1998_seq OWNER TO postgres;

--
-- Name: stock_trx_1999; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_1999 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_1999_dt_trx_check CHECK (((dt_trx >= '1999-01-01'::date) AND (dt_trx <= '1999-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_1999 OWNER TO postgres;

--
-- Name: stock_trx_1999_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_1999_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_1999_seq OWNER TO postgres;

--
-- Name: stock_trx_2000; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2000 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2000_dt_trx_check CHECK (((dt_trx >= '2000-01-01'::date) AND (dt_trx <= '2000-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2000 OWNER TO postgres;

--
-- Name: stock_trx_2000_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2000_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2000_seq OWNER TO postgres;

--
-- Name: stock_trx_2001; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2001 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2001_dt_trx_check CHECK (((dt_trx >= '2001-01-01'::date) AND (dt_trx <= '2001-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2001 OWNER TO postgres;

--
-- Name: stock_trx_2001_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2001_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2001_seq OWNER TO postgres;

--
-- Name: stock_trx_2002; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2002 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2002_dt_trx_check CHECK (((dt_trx >= '2002-01-01'::date) AND (dt_trx <= '2002-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2002 OWNER TO postgres;

--
-- Name: stock_trx_2002_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2002_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2002_seq OWNER TO postgres;

--
-- Name: stock_trx_2003; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2003 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2003_dt_trx_check CHECK (((dt_trx >= '2003-01-01'::date) AND (dt_trx <= '2003-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2003 OWNER TO postgres;

--
-- Name: stock_trx_2003_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2003_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2003_seq OWNER TO postgres;

--
-- Name: stock_trx_2004; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2004 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2004_dt_trx_check CHECK (((dt_trx >= '2004-01-01'::date) AND (dt_trx <= '2004-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2004 OWNER TO postgres;

--
-- Name: stock_trx_2004_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2004_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2004_seq OWNER TO postgres;

--
-- Name: stock_trx_2005; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2005 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2005_dt_trx_check CHECK (((dt_trx >= '2005-01-01'::date) AND (dt_trx <= '2005-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2005 OWNER TO postgres;

--
-- Name: stock_trx_2005_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2005_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2005_seq OWNER TO postgres;

--
-- Name: stock_trx_2006; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2006 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2006_dt_trx_check CHECK (((dt_trx >= '2006-01-01'::date) AND (dt_trx <= '2006-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2006 OWNER TO postgres;

--
-- Name: stock_trx_2006_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2006_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2006_seq OWNER TO postgres;

--
-- Name: stock_trx_2007; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2007 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2007_dt_trx_check CHECK (((dt_trx >= '2007-01-01'::date) AND (dt_trx <= '2007-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2007 OWNER TO postgres;

--
-- Name: stock_trx_2007_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2007_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2007_seq OWNER TO postgres;

--
-- Name: stock_trx_2008; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2008 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2008_dt_trx_check CHECK (((dt_trx >= '2008-01-01'::date) AND (dt_trx <= '2008-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2008 OWNER TO postgres;

--
-- Name: stock_trx_2008_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2008_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2008_seq OWNER TO postgres;

--
-- Name: stock_trx_2009; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2009 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2009_dt_trx_check CHECK (((dt_trx >= '2009-01-01'::date) AND (dt_trx <= '2009-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2009 OWNER TO postgres;

--
-- Name: stock_trx_2009_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2009_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2009_seq OWNER TO postgres;

--
-- Name: stock_trx_2010; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2010 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2010_dt_trx_check CHECK (((dt_trx >= '2010-01-01'::date) AND (dt_trx <= '2010-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2010 OWNER TO postgres;

--
-- Name: stock_trx_2010_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2010_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2010_seq OWNER TO postgres;

--
-- Name: stock_trx_2011; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2011 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2011_dt_trx_check CHECK (((dt_trx >= '2011-01-01'::date) AND (dt_trx <= '2011-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2011 OWNER TO postgres;

--
-- Name: stock_trx_2011_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2011_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2011_seq OWNER TO postgres;

--
-- Name: stock_trx_2012; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2012 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2012_dt_trx_check CHECK (((dt_trx >= '2012-01-01'::date) AND (dt_trx <= '2012-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2012 OWNER TO postgres;

--
-- Name: stock_trx_2012_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2012_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2012_seq OWNER TO postgres;

--
-- Name: stock_trx_2013; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2013 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2013_dt_trx_check CHECK (((dt_trx >= '2013-01-01'::date) AND (dt_trx <= '2013-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2013 OWNER TO postgres;

--
-- Name: stock_trx_2013_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2013_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2013_seq OWNER TO postgres;

--
-- Name: stock_trx_2014; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2014 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2014_dt_trx_check CHECK (((dt_trx >= '2014-01-01'::date) AND (dt_trx <= '2014-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2014 OWNER TO postgres;

--
-- Name: stock_trx_2014_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2014_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2014_seq OWNER TO postgres;

--
-- Name: stock_trx_2015; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2015 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2015_dt_trx_check CHECK (((dt_trx >= '2015-01-01'::date) AND (dt_trx <= '2015-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2015 OWNER TO postgres;

--
-- Name: stock_trx_2015_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2015_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2015_seq OWNER TO postgres;

--
-- Name: stock_trx_2016; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2016 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2016_dt_trx_check CHECK (((dt_trx >= '2016-01-01'::date) AND (dt_trx <= '2016-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2016 OWNER TO postgres;

--
-- Name: stock_trx_2016_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2016_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2016_seq OWNER TO postgres;

--
-- Name: stock_trx_2017; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2017 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2017_dt_trx_check CHECK (((dt_trx >= '2017-01-01'::date) AND (dt_trx <= '2017-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2017 OWNER TO postgres;

--
-- Name: stock_trx_2017_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2017_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2017_seq OWNER TO postgres;

--
-- Name: stock_trx_2018; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2018 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2018_dt_trx_check CHECK (((dt_trx >= '2018-01-01'::date) AND (dt_trx <= '2018-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2018 OWNER TO postgres;

--
-- Name: stock_trx_2018_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2018_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2018_seq OWNER TO postgres;

--
-- Name: stock_trx_2019; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2019 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2019_dt_trx_check CHECK (((dt_trx >= '2019-01-01'::date) AND (dt_trx <= '2019-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2019 OWNER TO postgres;

--
-- Name: stock_trx_2019_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2019_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2019_seq OWNER TO postgres;

--
-- Name: stock_trx_2020; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2020 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2020_dt_trx_check CHECK (((dt_trx >= '2020-01-01'::date) AND (dt_trx <= '2020-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2020 OWNER TO postgres;

--
-- Name: stock_trx_2020_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2020_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2020_seq OWNER TO postgres;

--
-- Name: stock_trx_2021; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2021 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2021_dt_trx_check CHECK (((dt_trx >= '2021-01-01'::date) AND (dt_trx <= '2021-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2021 OWNER TO postgres;

--
-- Name: stock_trx_2021_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2021_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2021_seq OWNER TO postgres;

--
-- Name: stock_trx_2022; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2022 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2022_dt_trx_check CHECK (((dt_trx >= '2022-01-01'::date) AND (dt_trx <= '2022-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2022 OWNER TO postgres;

--
-- Name: stock_trx_2022_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2022_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2022_seq OWNER TO postgres;

--
-- Name: stock_trx_2023; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2023 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2023_dt_trx_check CHECK (((dt_trx >= '2023-01-01'::date) AND (dt_trx <= '2023-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2023 OWNER TO postgres;

--
-- Name: stock_trx_2023_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2023_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2023_seq OWNER TO postgres;

--
-- Name: stock_trx_2024; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2024 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2024_dt_trx_check CHECK (((dt_trx >= '2024-01-01'::date) AND (dt_trx <= '2024-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2024 OWNER TO postgres;

--
-- Name: stock_trx_2024_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2024_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2024_seq OWNER TO postgres;

--
-- Name: stock_trx_2025; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_2025 (
    id_ticker character varying(8),
    dt_trx date,
    open_prc numeric,
    high_prc numeric,
    low_prc numeric,
    close_prc numeric,
    volume_trx numeric,
    value_prc numeric,
    freq_trx numeric,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric,
    nbsa_prc numeric,
    CONSTRAINT stock_trx_2025_dt_trx_check CHECK (((dt_trx >= '2025-01-01'::date) AND (dt_trx <= '2025-12-31'::date)))
)
INHERITS (public.stock_trx_idx);


ALTER TABLE public.stock_trx_2025 OWNER TO postgres;

--
-- Name: stock_trx_2025_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stock_trx_2025_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stock_trx_2025_seq OWNER TO postgres;

--
-- Name: stock_trx_freq; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_freq (
    id_ticker character varying(8) NOT NULL,
    dt_trx date NOT NULL,
    freq_trx numeric
);


ALTER TABLE public.stock_trx_freq OWNER TO postgres;

--
-- Name: stock_trx_nbsa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_nbsa (
    id_ticker character varying(8) NOT NULL,
    dt_trx date NOT NULL,
    nbsa_buy_prc numeric,
    nbsa_sell_prc numeric
);


ALTER TABLE public.stock_trx_nbsa OWNER TO postgres;

--
-- Name: stock_trx_open; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock_trx_open (
    id_ticker character varying(8) NOT NULL,
    dt_trx date NOT NULL,
    open_prc numeric
);


ALTER TABLE public.stock_trx_open OWNER TO postgres;

--
-- Name: stock_vol_amount; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_vol_amount AS
 SELECT a.dt_trx,
    a.id_ticker,
    a.ma1,
    b.ma2,
    round((((a.ma1 - b.ma2) / b.ma2) * (100)::numeric), 2) AS up_p,
    a.volume_trx AS vol_trx,
    a.amt1 AS last_amt,
    b.amt2,
    c.amt3,
    d.amt4,
    e.amt5,
    round((((((a.amt1 + b.amt2) + c.amt3) + d.amt4) + e.amt5) / (5)::numeric)) AS avg_amt_5day
   FROM ((((( SELECT a_1.id_ticker,
            b_1.nm_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.close_prc AS ma1,
            a_1.value_prc AS amt1,
            a_1.volume_trx
           FROM (public.stock_trx_idx a_1
             JOIN public.stock_master b_1 ON (((a_1.id_ticker)::text = (b_1.id_ticker)::text)))
          WHERE (a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1)))) a
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma2,
            stock_trx_idx.value_prc AS amt2
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2)))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.value_prc AS amt3
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3)))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.value_prc AS amt4
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4)))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.value_prc AS amt5
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5)))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
  WHERE ((a.amt1 > (50000)::numeric) AND (a.amt1 > b.amt2) AND (b.amt2 > c.amt3) AND (a.amt1 >= ((b.amt2 + c.amt3) + d.amt4)))
  ORDER BY a.amt1 DESC;


ALTER TABLE public.stock_vol_amount OWNER TO postgres;

--
-- Name: stock_vol_melduk; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.stock_vol_melduk AS
 SELECT a.dt_trx,
    a.id_ticker,
    a.ma1,
    b.ma2,
    round((((a.ma1 - b.ma2) / b.ma2) * (100)::numeric), 2) AS up_p,
    a.value_prc AS vol_prc,
    a.vol1 AS last_vol,
    b.vol2,
    c.vol3,
    d.vol4,
    e.vol5,
    round((((((a.vol1 + b.vol2) + c.vol3) + d.vol4) + e.vol5) / (5)::numeric)) AS avg_vol_5day
   FROM ((((( SELECT a_1.id_ticker,
            b_1.nm_ticker,
            a_1.dt_trx,
            a_1.open_prc,
            a_1.close_prc AS ma1,
            a_1.volume_trx AS vol1,
            a_1.value_prc
           FROM (public.stock_trx_idx a_1
             JOIN public.stock_master b_1 ON (((a_1.id_ticker)::text = (b_1.id_ticker)::text)))
          WHERE (a_1.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 1)))) a
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma2,
            stock_trx_idx.volume_trx AS vol2
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 2)))) b ON (((a.id_ticker)::text = (b.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.volume_trx AS vol3
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 3)))) c ON (((a.id_ticker)::text = (c.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.volume_trx AS vol4
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 4)))) d ON (((a.id_ticker)::text = (d.id_ticker)::text)))
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.dt_trx,
            stock_trx_idx.open_prc,
            stock_trx_idx.close_prc AS ma3,
            stock_trx_idx.volume_trx AS vol5
           FROM public.stock_trx_idx
          WHERE (stock_trx_idx.dt_trx = ( SELECT bajul.dt_trx
                   FROM public.bajul
                  WHERE (bajul.row_number = 5)))) e ON (((a.id_ticker)::text = (e.id_ticker)::text)))
  WHERE ((a.vol1 > (50000)::numeric) AND (a.ma1 > b.ma2) AND (a.vol1 > b.vol2) AND (a.vol1 > c.vol3) AND (a.vol1 >= ((b.vol2 + c.vol3) + d.vol4)))
  ORDER BY a.vol1 DESC;


ALTER TABLE public.stock_vol_melduk OWNER TO postgres;

--
-- Name: v_max_stock_prc_yearly; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_max_stock_prc_yearly AS
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2010-01-01'::date) AND (stock_trx_idx.dt_trx <= '2010-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2011-01-01'::date) AND (stock_trx_idx.dt_trx <= '2011-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2012-01-01'::date) AND (stock_trx_idx.dt_trx <= '2012-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2013-01-01'::date) AND (stock_trx_idx.dt_trx <= '2013-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2014-01-01'::date) AND (stock_trx_idx.dt_trx <= '2014-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2015-01-01'::date) AND (stock_trx_idx.dt_trx <= '2015-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2016-01-01'::date) AND (stock_trx_idx.dt_trx <= '2016-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2017-01-01'::date) AND (stock_trx_idx.dt_trx <= '2017-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2018-01-01'::date) AND (stock_trx_idx.dt_trx <= '2018-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2019-01-01'::date) AND (stock_trx_idx.dt_trx <= '2019-12-31'::date))
UNION ALL
 SELECT max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2020-01-01'::date) AND (stock_trx_idx.dt_trx <= '2020-12-31'::date));


ALTER TABLE public.v_max_stock_prc_yearly OWNER TO postgres;

--
-- Name: v_max_stock_prc_yearly_a; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_max_stock_prc_yearly_a AS
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2010-01-01'::date) AND (stock_trx_idx.dt_trx <= '2010-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2011-01-01'::date) AND (stock_trx_idx.dt_trx <= '2011-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2012-01-01'::date) AND (stock_trx_idx.dt_trx <= '2012-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2013-01-01'::date) AND (stock_trx_idx.dt_trx <= '2013-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2014-01-01'::date) AND (stock_trx_idx.dt_trx <= '2014-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2015-01-01'::date) AND (stock_trx_idx.dt_trx <= '2015-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2016-01-01'::date) AND (stock_trx_idx.dt_trx <= '2016-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2017-01-01'::date) AND (stock_trx_idx.dt_trx <= '2017-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2018-01-01'::date) AND (stock_trx_idx.dt_trx <= '2018-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2019-01-01'::date) AND (stock_trx_idx.dt_trx <= '2019-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    max(stock_trx_idx.dt_trx) AS max_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2020-01-01'::date) AND (stock_trx_idx.dt_trx <= '2020-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc;


ALTER TABLE public.v_max_stock_prc_yearly_a OWNER TO postgres;

--
-- Name: v_min_stock_prc_yearly; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_min_stock_prc_yearly AS
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2010-01-01'::date) AND (stock_trx_idx.dt_trx <= '2010-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2011-01-01'::date) AND (stock_trx_idx.dt_trx <= '2011-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2012-01-01'::date) AND (stock_trx_idx.dt_trx <= '2012-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2013-01-01'::date) AND (stock_trx_idx.dt_trx <= '2013-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2014-01-01'::date) AND (stock_trx_idx.dt_trx <= '2014-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2015-01-01'::date) AND (stock_trx_idx.dt_trx <= '2015-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2016-01-01'::date) AND (stock_trx_idx.dt_trx <= '2016-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2017-01-01'::date) AND (stock_trx_idx.dt_trx <= '2017-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2018-01-01'::date) AND (stock_trx_idx.dt_trx <= '2018-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2019-01-01'::date) AND (stock_trx_idx.dt_trx <= '2019-12-31'::date))
UNION ALL
 SELECT min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2020-01-01'::date) AND (stock_trx_idx.dt_trx <= '2020-12-31'::date));


ALTER TABLE public.v_min_stock_prc_yearly OWNER TO postgres;

--
-- Name: v_min_stock_prc_yearly_a; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_min_stock_prc_yearly_a AS
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2010-01-01'::date) AND (stock_trx_idx.dt_trx <= '2010-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2011-01-01'::date) AND (stock_trx_idx.dt_trx <= '2011-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2012-01-01'::date) AND (stock_trx_idx.dt_trx <= '2012-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2013-01-01'::date) AND (stock_trx_idx.dt_trx <= '2013-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2014-01-01'::date) AND (stock_trx_idx.dt_trx <= '2014-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2015-01-01'::date) AND (stock_trx_idx.dt_trx <= '2015-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2016-01-01'::date) AND (stock_trx_idx.dt_trx <= '2016-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2017-01-01'::date) AND (stock_trx_idx.dt_trx <= '2017-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2018-01-01'::date) AND (stock_trx_idx.dt_trx <= '2018-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2019-01-01'::date) AND (stock_trx_idx.dt_trx <= '2019-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc
UNION ALL
 SELECT stock_trx_idx.id_ticker,
    stock_trx_idx.close_prc,
    min(stock_trx_idx.dt_trx) AS min_dt
   FROM public.stock_trx_idx
  WHERE ((stock_trx_idx.dt_trx >= '2020-01-01'::date) AND (stock_trx_idx.dt_trx <= '2020-12-31'::date))
  GROUP BY stock_trx_idx.id_ticker, stock_trx_idx.close_prc;


ALTER TABLE public.v_min_stock_prc_yearly_a OWNER TO postgres;

--
-- Name: v_stock_prc_min_max; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_stock_prc_min_max AS
 SELECT a.id_ticker,
    a.dt_trx AS min_dt,
    a.close_prc AS min_prc,
    a.dt_trx AS max_dt,
    b.close_prc AS max_prc,
    round((((b.close_prc - a.close_prc) / a.close_prc) * (100)::numeric), 2) AS up_p
   FROM (( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.close_prc,
            stock_trx_idx.dt_trx
           FROM public.stock_trx_idx) a
     JOIN ( SELECT stock_trx_idx.id_ticker,
            stock_trx_idx.close_prc,
            stock_trx_idx.dt_trx
           FROM public.stock_trx_idx) b ON (((a.id_ticker)::text = (b.id_ticker)::text)));


ALTER TABLE public.v_stock_prc_min_max OWNER TO postgres;

--
-- Name: v_stock_ready_amibroker; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_stock_ready_amibroker AS
 SELECT stock_trx_idx.dt_trx,
    count(stock_trx_idx.id_ticker) AS total_ticker
   FROM public.stock_trx_idx
  GROUP BY stock_trx_idx.dt_trx
  ORDER BY stock_trx_idx.dt_trx DESC;


ALTER TABLE public.v_stock_ready_amibroker OWNER TO postgres;

--
-- Name: v_summary_nbsa; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_summary_nbsa AS
 SELECT stock_trx_idx.dt_trx,
    sum(stock_trx_idx.nbsa_buy_prc) AS buy,
    sum(stock_trx_idx.nbsa_sell_prc) AS sell,
    sum(stock_trx_idx.nbsa_prc) AS total_nbsa
   FROM public.stock_trx_idx
  GROUP BY stock_trx_idx.dt_trx
  ORDER BY stock_trx_idx.dt_trx DESC;


ALTER TABLE public.v_summary_nbsa OWNER TO postgres;

--
-- Name: stock_master_forbidden stock_master_forbidden_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_master_forbidden
    ADD CONSTRAINT stock_master_forbidden_pkey PRIMARY KEY (id_ticker);


--
-- Name: stock_trx_1993 stock_trx_1993_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1993
    ADD CONSTRAINT stock_trx_1993_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_1994 stock_trx_1994_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1994
    ADD CONSTRAINT stock_trx_1994_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_1995 stock_trx_1995_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1995
    ADD CONSTRAINT stock_trx_1995_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_1996 stock_trx_1996_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1996
    ADD CONSTRAINT stock_trx_1996_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_1997 stock_trx_1997_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1997
    ADD CONSTRAINT stock_trx_1997_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_1998 stock_trx_1998_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1998
    ADD CONSTRAINT stock_trx_1998_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_1999 stock_trx_1999_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_1999
    ADD CONSTRAINT stock_trx_1999_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2000 stock_trx_2000_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2000
    ADD CONSTRAINT stock_trx_2000_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2001 stock_trx_2001_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2001
    ADD CONSTRAINT stock_trx_2001_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2002 stock_trx_2002_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2002
    ADD CONSTRAINT stock_trx_2002_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2003 stock_trx_2003_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2003
    ADD CONSTRAINT stock_trx_2003_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2004 stock_trx_2004_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2004
    ADD CONSTRAINT stock_trx_2004_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2005 stock_trx_2005_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2005
    ADD CONSTRAINT stock_trx_2005_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2006 stock_trx_2006_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2006
    ADD CONSTRAINT stock_trx_2006_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2007 stock_trx_2007_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2007
    ADD CONSTRAINT stock_trx_2007_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2008 stock_trx_2008_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2008
    ADD CONSTRAINT stock_trx_2008_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2009 stock_trx_2009_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2009
    ADD CONSTRAINT stock_trx_2009_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2010 stock_trx_2010_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2010
    ADD CONSTRAINT stock_trx_2010_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2011 stock_trx_2011_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2011
    ADD CONSTRAINT stock_trx_2011_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2012 stock_trx_2012_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2012
    ADD CONSTRAINT stock_trx_2012_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2013 stock_trx_2013_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2013
    ADD CONSTRAINT stock_trx_2013_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2014 stock_trx_2014_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2014
    ADD CONSTRAINT stock_trx_2014_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2015 stock_trx_2015_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2015
    ADD CONSTRAINT stock_trx_2015_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2016 stock_trx_2016_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2016
    ADD CONSTRAINT stock_trx_2016_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2017 stock_trx_2017_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2017
    ADD CONSTRAINT stock_trx_2017_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2018 stock_trx_2018_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2018
    ADD CONSTRAINT stock_trx_2018_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2019 stock_trx_2019_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2019
    ADD CONSTRAINT stock_trx_2019_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2020 stock_trx_2020_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2020
    ADD CONSTRAINT stock_trx_2020_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2021 stock_trx_2021_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2021
    ADD CONSTRAINT stock_trx_2021_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2022 stock_trx_2022_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2022
    ADD CONSTRAINT stock_trx_2022_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2023 stock_trx_2023_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2023
    ADD CONSTRAINT stock_trx_2023_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2024 stock_trx_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2024
    ADD CONSTRAINT stock_trx_2024_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_2025 stock_trx_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_2025
    ADD CONSTRAINT stock_trx_2025_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_freq stock_trx_freq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_freq
    ADD CONSTRAINT stock_trx_freq_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_idx stock_trx_idx_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_idx
    ADD CONSTRAINT stock_trx_idx_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_nbsa stock_trx_nbsa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_nbsa
    ADD CONSTRAINT stock_trx_nbsa_pkey PRIMARY KEY (id_ticker);


--
-- Name: stock_trx_open stock_trx_open_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock_trx_open
    ADD CONSTRAINT stock_trx_open_pkey PRIMARY KEY (id_ticker, dt_trx);


--
-- Name: stock_trx_idx after_insert_stock_trx_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER after_insert_stock_trx_trigger AFTER INSERT ON public.stock_trx_idx FOR EACH ROW EXECUTE PROCEDURE public.stocktrx_delete_master();


--
-- Name: stock_trx_idx insert_stocktrx_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER insert_stocktrx_trigger BEFORE INSERT ON public.stock_trx_idx FOR EACH ROW EXECUTE PROCEDURE public.stocktrx_insert_trigger();


--
-- Name: stock_trx_open trig_copy; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trig_copy AFTER INSERT ON public.stock_trx_open FOR EACH ROW EXECUTE PROCEDURE public.f_upd_open_prc();


--
-- Name: stock_trx_freq trig_freq; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trig_freq AFTER INSERT ON public.stock_trx_freq FOR EACH ROW EXECUTE PROCEDURE public.f_upd_freq_trx();


--
-- Name: stock_trx_nbsa trig_nbsa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trig_nbsa AFTER INSERT ON public.stock_trx_nbsa FOR EACH ROW EXECUTE PROCEDURE public.f_upd_nbsa_prc();


--
-- PostgreSQL database dump complete
--

