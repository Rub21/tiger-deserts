 
Create OR REPLACE FUNCTION num_node_by_version(the_geom geometry, vers int)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT count(tiger_version.version)   
		FROM tiger_version 
		WHERE  version=vers AND st_dwithin(tiger_version.geom,the_geom,0));
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION num_node__total(the_geom geometry)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT count(tiger_version.version)   
		FROM tiger_version 
		WHERE st_dwithin(tiger_version.geom,the_geom,0));
	END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION max_version(the_geom geometry)
RETURNS  int
AS $$
DECLARE
_max_version int ;
	BEGIN
		_max_version=(SELECT max(version) FROM tiger_version WHERE st_dwithin(tiger_version.geom,the_geom,0));


		IF (_max_version IS NULL) THEN
		
		_max_version=0;												
								    
		END IF;
		
		RETURN _max_version;
		
	END;
$$ LANGUAGE plpgsql;

select max_version(geom)from gridv where gid=25846;
  
CREATE OR REPLACE FUNCTION min_version(the_geom geometry)
RETURNS  int
AS $$
DECLARE
	_min_version int;
	
	BEGIN
		RETURN( SELECT min(version) FROM tiger_version WHERE st_dwithin(tiger_version.geom,the_geom,0));
		
		IF (_min_version IS NULL) THEN
		
		_min_version=0;												
								    
		END IF;
		
		RETURN _min_version;
		
	END;
$$ LANGUAGE plpgsql;


CREATE TABLE tiger_grid_v001( 
id_grid INT,
amo_vt BIGINT,
amo_v1 INT,
amo_v2 INT,
perc_v1 INT,
perc_v2 INT,
average_v FLOAT,
geom GEOMETRY
)


CREATE INDEX id_grid_tiger_grid_v001_index ON tiger_grid(id_grid);
/* ************************************************************************* -A- *******************************************************/


CREATE OR REPLACE FUNCTION fill_data_v001_A(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);

			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN

					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;

/* ************************************************************************* -B- *******************************************************/

CREATE OR REPLACE FUNCTION fill_data_v001_B(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN
					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;

/* ************************************************************************* -C- *******************************************************/

CREATE OR REPLACE FUNCTION fill_data_v001_C(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN
					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;

/* ************************************************************************* -D- *******************************************************/

CREATE OR REPLACE FUNCTION fill_data_v001_D(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN
					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************* -E- *******************************************************/


CREATE OR REPLACE FUNCTION fill_data_v001_E(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN
					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************* -F- *******************************************************/


CREATE OR REPLACE FUNCTION fill_data_v001_F(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN
					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;


/* ************************************************************************* -G- *******************************************************/

CREATE OR REPLACE FUNCTION fill_data_v001_G(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN
					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;

/* ************************************************************************* -H- *******************************************************/

CREATE OR REPLACE FUNCTION fill_data_v001_H(inicio int, fin int) 
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
	
	_num = fin;
	
        FOR _i IN inicio.._num

		LOOP 
			_geom=(SELECT x.geom FROM  grid_around_v001 AS x  WHERE x.gid =_i);--grid

			_amo_v1=0;				
			_amo_v2=0;
			_perc_v2=0;
			_perc_v1=0;
			_sum_before_avr=0;
			_average_v =0;
			
			_max_version=max_version(_geom);
			
			--find  all version
			IF (_max_version>0) THEN
				
				_min_version=min_version(_geom);
			        _amo_vt = num_node__total(_geom);
			
				IF (_min_version<=_max_version AND _amo_vt!= 1 ) THEN

					
					RAISE  NOTICE '====================================================ID GRID =%', _i;
					RAISE  NOTICE 'TOTAL WAYS= %', _amo_vt;
					RAISE  NOTICE 'MAX_VERSION= %', _max_version;
					RAISE  NOTICE 'MIN_VERSION= %', _min_version;
					
								
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
							
				 INSERT INTO tiger_grid_v001(id_grid, 
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
			ELSE
			RAISE  NOTICE 'IS NOT INSERTED THIS ID= %', _i;		

			END IF;			
			  
		END LOOP;		
	       RETURN _num;
END;
$$ LANGUAGE plpgsql;




/* Example */

select count(*) from grid_around_v001;

select fill_data_v001_A(1, 13561);
select fill_data_v001_B(13562, 27122); 
select fill_data_v001_C(27123, 40683);
select fill_data_v001_D(40684, 54244);
select fill_data_v001_E(54245, 67805);
select fill_data_v001_F(67806, 81366);
select fill_data_v001_G(81367, 94927);
select fill_data_v001_H(94928, 108488);










