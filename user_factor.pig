register 'test.py' using jython as udf;
SET job.priority VERY_HIGH;
%DECLARE SONG_META '/practices/song-meta.gz';
%DECLARE LOGS_META '/practices/logs.gz'
%DECLARE OUTPUT_FILE '/user/fearofchou/pro4';    
songs = LOAD '$SONG_META' AS (song_id:int, artist_id:int);
logs = LOAD '$LOGS_META' AS (time_string:chararray, chararray, chararray, chararray, chararray, song_id:int, user_id:int);

MElogs = JOIN logs BY song_id, songs BY song_id; 
logs = FOREACH MElogs GENERATE user_id, artist_id, songs::song_id, time_string; 

--D = FILTER logs BY user_id == 34471554;

user_logs = GROUP logs BY user_id;
result = FOREACH user_logs GENERATE group, COUNT(logs), udf.enumerate_bag(logs);

--STORE F INTO '$OUTPUT_FILE';
--ILLUSTRATE user_logs;
--DESCRIBE user_logs;  
DUMP result;

