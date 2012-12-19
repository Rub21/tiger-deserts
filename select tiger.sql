
CREATE OR REPLACE FUNCTION num_nodes(the_geom geometry)
RETURNS  int
AS $$
DECLARE
	BEGIN
		RETURN( SELECT count(tiger_version.version)   
		FROM tiger_version 
		WHERE  version=1 AND ST_Within(tiger_version.geom,the_geom));
	END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION funcion() 
RETURNS TABLE (id int ,cant_points int,geom_grid geometry)
AS $$
DECLARE
	_num integer :=0;
BEGIN
	_num = (select count(*) FROM grid);
        FOR _i IN 1.._num
	LOOP   
	RETURN QUERY SELECT x.gid,num_nodes(x.geom),x.geom FROM  grid AS x  WHERE x.gid = _i;
	END LOOP;    
END;
$$ LANGUAGE plpgsql;

select id as id_grid , cant_points points_version1, geom_grid as Geometrygrid from funcion();
