SET job.priority VERY_HIGH;
%DECLARE SONG_META '/practices/song-meta.gz';
%DECLARE LOGS_META '/practices/logs.gz'
%DECLARE OUTPUT_FILE '/user/fearofchou/pro3';    
songs = LOAD '$SONG_META' AS (song_id:int, artist_id:int);
logs = LOAD '$LOGS_META' AS (time_string:chararray, chararray, chararray, chararray, chararray, song_id:int, user_id:int);


Y = JOIN logs BY song_id, songs BY song_id;
Z = FILTER Y BY songs::artist_id == 6651;
X = FOREACH (GROUP Z BY REGEX_EXTRACT(logs::time_string, '(.*)\\s(.*)',1)){
unique_users = DISTINCT Z.logs::user_id;
GENERATE group, '6651' ,COUNT(unique_users), COUNT(Z);
};

--X = FILTER Z BY logs::time_string MATCHES '2012-12-02.+';

STORE X INTO '$OUTPUT_FILE';  
--DUMP X;

