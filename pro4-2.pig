Register 'ratio.py' using jython as udf;
SET job.priority VERY_HIGH;
%DECLARE SONG_META '/practices/song-meta.gz';
%DECLARE LOGS_META '/practices/logs.gz'
%DECLARE OUTPUT_FILE '/user/fearofchou/pro4-2';    
songs = LOAD '$SONG_META' AS (song_id:int, artist_id:int);
logs = LOAD '$LOGS_META' AS (time_string:chararray, chararray, chararray, chararray, chararray, song_id:int, user_id:int);


A = JOIN logs BY song_id, songs BY song_id;
B = FILTER A BY artist_id == 6651;
--C = GROUP B;
--D = FOREACH C GENERATE COUNT(A);
--DUMP A;
--DESCRIBE D;
--DUMP X;
C = FOREACH (GROUP B BY REGEX_EXTRACT(logs::time_string, '(.*):(.*):(.*)',1)){
unique_users = DISTINCT B.logs::user_id;
GENERATE group, '6651' ,COUNT(unique_users), COUNT(B);
};

--DESCRIBE C;

D = FOREACH (GROUP B BY REGEX_EXTRACT(logs::time_string, '(.*)\\s(.*)',1)){
unique_user = DISTINCT B.logs::user_id;
GENERATE group, '6651' ,COUNT(unique_user);
};

E = JOIN C BY REGEX_EXTRACT($0, '(.*)\\s(.*)',1), D BY $0;

F = FOREACH E GENERATE $0, '6651',$2 ,$6, udf.ratio($2,$6); 
--X = FILTER Z BY logs::time_string MATCHES '2012-12-02.+';

STORE F INTO '$OUTPUT_FILE';  
--DUMP F;

