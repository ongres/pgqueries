-- Simple Random Generator

CREATE TABLE randTableII AS
SELECT 
d.datein as datein,
i.anumber as anumber,
('{Gandalf,Dumbledore,Theodore,Clarkson,Crawley,Fernandez,Aquamenti,Cicerus,Tiffany,Polka,Beer,Glasses,Cigar}'::text[])[round(random()*12+1)] as arandomtext
FROM generate_series(now() - '5 month'::interval, now(), '1 day'::interval) as d(datein),
     generate_series(1,1000) i(anumber);
     
INSERT INTO randTableII 
SELECT 
d.datein as datein,
i.anumber as anumber,
('{Gandalf,Dumbledore,Theodore,Clarkson,Crawley,Fernandez,Aquamenti,Cicerus,Tiffany,Polka,Beer,Glasses,Cigar}'::text[])[round(random()*12+1)] as arandomtext
FROM generate_series(now() - '5 month'::interval, now(), '1 day'::interval) as d(datein),
     generate_series(1,1000) i(anumber);
