CREATE OR REPLACE FUNCTION num_node_by_version(the_geom geometry, vers int)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT count(tiger_version.version)   
		FROM tiger_version 
		WHERE  version=vers AND ST_Within(tiger_version.geom,the_geom));
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION num_node__total(the_geom geometry)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT count(tiger_version.version)   
		FROM tiger_version 
		WHERE ST_Within(tiger_version.geom,the_geom));
	END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION max_version(the_geom geometry)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT max(version) FROM tiger_version WHERE ST_Within(tiger_version.geom,the_geom));
	END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION min_version(the_geom geometry)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT min(version) FROM tiger_version WHERE ST_Within(tiger_version.geom,the_geom));
	END;
$$ LANGUAGE plpgsql;





CREATE TABLE tiger_grid( --table tiger_grid2
id_grid INT,
amo_vt BIGINT,
amo_v1 INT,
amo_v2 INT,
perc_v1 INT,
perc_v2 INT,
average_v FLOAT,
geom GEOMETRY
)



CREATE INDEX id_grid_tiger_grid_index ON tiger_grid(id_grid);


CREATE OR REPLACE FUNCTION fill_data() 
RETURNS INT
AS $$
DECLARE
	_num integer :=0;
	_geom geometry;
	_array_version integer ARRAY;
	_min_version int=0;
	_max_version int=0;
	_amo_v1 float;
	_amo_v2 float;
        _amo_vt float;
        _perc_v1 float;
        _perc_v2 float;
        _sum_before_avr float;
        _average_v float;        
BEGIN

	
	_num = (select count(*) FROM grid);--grid
	
        FOR _i IN 1.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid AS x  WHERE x.gid = _i);--grid
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				RAISE  NOTICE '----------------------------------';
				RAISE  NOTICE '====================================================ID GRID =%', _i;
				RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
				RAISE  NOTICE 'MAX_VERSION= %', _max_version;
				RAISE  NOTICE 'MIN_VERSION= %', _min_version;
				_amo_v1=0;				
				_amo_v2=0;
				_perc_v2=0;
				_perc_v1=0;
				_sum_before_avr=0;
				_average_v =0;
							
				FOR _j IN _min_version.._max_version
					LOOP 
						_array_version[_j]=num_node_by_version(_geom,_j);
						RAISE  NOTICE '===Version  = %',_j;
						RAISE  NOTICE 'Amount= %',_array_version[_j];
						
						/* For percentage of version 1 and version 2*/
						IF (_j=1) THEN
							_amo_v1=_array_version[_j];
							_perc_v1=(_amo_v1*100)/_amo_vt;
												
								    
						END IF;

						IF (_j=2) THEN
							
							_amo_v2=_array_version[_j];
							_perc_v2=(_amo_v2*100)/_amo_vt;	
																    
						END IF;
						
						/* For average*/											
						_sum_before_avr= _sum_before_avr + _array_version[_j]*_j;										
						
				        END LOOP;									

			       _average_v=_sum_before_avr/_amo_vt;

				RAISE  NOTICE 'AVERAGE= %',_average_v;
				RAISE  NOTICE 'AMOUNT VERSION=1 : %',_amo_v1;
				RAISE  NOTICE 'AMOUNT VERSION=2 : %',_amo_v2;
				RAISE  NOTICE 'PERCENTAGE VERSION=1 : %',_perc_v1;
				RAISE  NOTICE 'PERCENTAGE VERSION=2 : %',_perc_v2;
						
				 INSERT INTO tiger_grid(id_grid, 
						amo_vt, 
						amo_v1, 
						amo_v2,
						perc_v1,
						perc_v2,
						average_v,						 
						geom)
				VALUES (_i,
					_amo_vt,
					_amo_v1,
					_amo_v2,
					_perc_v1,
					_perc_v2,
					_average_v,
					_geom);
					

			END IF;	  
		END LOOP;
		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;

select fill_data();








